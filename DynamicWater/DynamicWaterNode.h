//
//  DynamicWaterNode.h
//  DynamicWater
//
//  Created by Steve Barnegren on 07/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DynamicWaterNode : SKNode

-(instancetype)initWithWidth:(float)width numJoints:(NSInteger)numJoints surfaceHeight:(float)surfaceHeight;


-(void)update:(CFTimeInterval)dt;

-(void)render;

@end
