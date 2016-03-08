//
//  DynamicWaterNode.h
//  DynamicWater
//
//  Created by Steve Barnegren on 07/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DynamicWaterNode : SKNode

@property float surfaceHeight;


-(instancetype)initWithWidth:(float)width numJoints:(NSInteger)numJoints surfaceHeight:(float)surfaceHeight fillColour:(UIColor*)fillColour;


-(void)update:(CFTimeInterval)dt;

-(void)render;

-(void)splashAtX:(float)xLocation force:(CGFloat)force;
-(void)splashAtX:(float)xLocation force:(CGFloat)force width:(float)width;

@end
