//
//  MyScene.m
//  MotionManagerDemo
//
//  Created by STEFAN JOSTEN on 12.07.14.
//  Copyright (c) 2014 MotionManagerDemo. All rights reserved.
//

#import "MyScene.h"
#import "MotionManagerSingleton.h"
#import <GLKit/GLKit.h>

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        sprite.size=CGSizeMake(20, 20);
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

// private properties
NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;

-(void)update:(CFTimeInterval)currentTime {
    // Needed for smooth scrolling. It's not guaranteed, that the update method is not called in fixed intervals:
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    GLKVector3 motionVector = [MotionManagerSingleton getMotionVectorWithLowPass];
    SKSpriteNode *sprite;
    for (int i=0; i<self.children.count;i++) {
        sprite=[self.children objectAtIndex:i];
        sprite.position = CGPointMake(sprite.position.x + _dt * motionVector.x*100, sprite.position.y);
    }
    
}

@end
