//
//  MotionManagerSingleton.m
//  MotionManagerDemo
//
//  Created by STEFAN JOSTEN on 12.07.14.
//  Copyright (c) 2014 MotionManagerDemo. All rights reserved.
//

#import "MotionManagerSingleton.h"

// Damping factor
#define cLowPassFactor 0.95

@implementation MotionManagerSingleton

static CMMotionManager* _motionManager;
static CMAttitude* _referenceAttitude;
static bool bActive;

// only one instance of CMMotionManager can be used in your project.
// => Implement as Singleton which can be used in the whole application
+(CMMotionManager*)getMotionManager {
    if (_motionManager==nil) {
        _motionManager=[[CMMotionManager alloc]init];
        _motionManager.deviceMotionUpdateInterval=0.25;
        [_motionManager startDeviceMotionUpdates];
        bActive=true;
    } else if (bActive==false) {
        [_motionManager startDeviceMotionUpdates];
        bActive=true;
    }
    return _motionManager;
}

// Returns a vector with the movements
// At the first time a reference orientation is saved to ensure the motion detection works
// for multiple device positions
+(GLKVector3)getMotionVectorWithLowPass{
    // Motion
    CMAttitude *attitude = self.getMotionManager.deviceMotion.attitude;
    if (_referenceAttitude==nil) {
        // Cache Start Orientation to calibrate the device. Wait for a short time to give MotionManager enough time to initialize
        [self performSelector:@selector(calibrate) withObject:nil afterDelay:0.25];
    } else {
        // Use start orientation to calibrate
        [attitude multiplyByInverseOfAttitude:_referenceAttitude];
    }
    return [self lowPassWithVector: GLKVector3Make(attitude.yaw,attitude.roll,attitude.pitch)];
}

// Stop collecting motion data to save energy
+(void)stop {
    if (_motionManager!=nil) {
        [_motionManager stopDeviceMotionUpdates];
        _referenceAttitude=nil;
        bActive=false;
    }
}

+(void)calibrate {
    _referenceAttitude = [self.getMotionManager.deviceMotion.attitude copy];
    
}

// Damp the jitter caused by hand movement
+(GLKVector3)lowPassWithVector:(GLKVector3)vector
{
    static GLKVector3 lastVector;
    
    vector.x = vector.x * cLowPassFactor + lastVector.x * (1.0 - cLowPassFactor);
    vector.y = vector.y * cLowPassFactor + lastVector.y * (1.0 - cLowPassFactor);
    vector.z = vector.z * cLowPassFactor + lastVector.z * (1.0 - cLowPassFactor);
    
    lastVector = vector;
    return vector;
}

@end