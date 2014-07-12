//
//  MotionManagerSingleton.h
//  MotionManagerDemo
//
//  Created by STEFAN JOSTEN on 12.07.14.
//  Copyright (c) 2014 MotionManagerDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>


@interface MotionManagerSingleton : NSObject
+(GLKVector3)getMotionVectorWithLowPass;
+(void)stop;
+(void)calibrate;
@end
