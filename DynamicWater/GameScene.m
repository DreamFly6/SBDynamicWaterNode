//
//  GameScene.m
//  DynamicWater
//
//  Created by Steve Barnegren on 07/03/2016.
//  Copyright (c) 2016 Steve Barnegren. All rights reserved.
//

#import "GameScene.h"
#import "DynamicWaterNode.h"

#define kFixedTimeStep (1.0f/500)

@interface GameScene ()
@property (nonatomic, strong) SKSpriteNode *skySprite;
@property (nonatomic, strong) DynamicWaterNode *waterNode;

@property CFTimeInterval lastFrameTime;
@property BOOL hasReferenceFrameTime;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {

    // Sky
    self.skySprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"sky"]];
    self.skySprite.xScale = self.size.width/self.skySprite.texture.size.width;
    self.skySprite.yScale = self.size.height/self.skySprite.texture.size.height;
    self.skySprite.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.skySprite.zPosition = 0;
    [self addChild:self.skySprite];

    // Water
    self.waterNode = [[DynamicWaterNode alloc]initWithWidth:self.size.width numJoints:100 surfaceHeight:200];
    self.waterNode.position = CGPointMake(self.size.width/2, 0);
    self.waterNode.zPosition = 1;
    [self addChild:self.waterNode];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  }


#pragma mark - Update

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (!self.hasReferenceFrameTime) {
        self.lastFrameTime = currentTime;
        self.hasReferenceFrameTime = YES;
        return;
    }
    
    CFTimeInterval dt = currentTime - self.lastFrameTime;
    
    // Fixed Update
    CFTimeInterval accumilator = 0;
    accumilator += dt;
    
    while (accumilator >= kFixedTimeStep) {
        [self fixedUpdate:kFixedTimeStep];
        accumilator -= kFixedTimeStep;
    }
    [self fixedUpdate:accumilator];
    
    // Late Update
    [self lateUpdate:dt];
    
    self.lastFrameTime = currentTime;
    
}

-(void)fixedUpdate:(CFTimeInterval)dt{
    [self.waterNode update:dt];
    //[self.waterNode render];


}

-(void)lateUpdate:(CFTimeInterval)dt{
}

@end
