//
//  DynamicWaterNode.m
//  DynamicWater
//
//  Created by Steve Barnegren on 07/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "DynamicWaterNode.h"

//**********************************************
#pragma mark - ***** WaterJoint *****
//**********************************************

@interface WaterJoint : NSObject

@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat speed;
@property (nonatomic) CGFloat damping;
@property (nonatomic) CGFloat tension;
@end

@implementation WaterJoint

-(instancetype)init{
    
    if (self = [super init]) {
        self.position = CGPointZero;
        self.speed = 0; // <-- change to velocity
        self.damping = 0.04 * 60;
        self.tension = 0.03 * 60;
    }
        return self;
}

-(void)setYPosition:(float)yPos{
    self.position = CGPointMake(self.position.x, yPos);
}

- (void)update:(NSTimeInterval)dt {
    NSTimeInterval invDt = 1.0-dt;
    
    CGFloat y = self.position.y;
    CGFloat acceleration = (-self.tension * y) - (self.speed * (self.damping));

    self.position = CGPointMake(self.position.x, self.position.y + (self.speed));
    self.speed += acceleration * dt;
}

@end

//**********************************************
#pragma mark - ***** DynamicWaterNode *****
//**********************************************

@interface DynamicWaterNode ()
@property (nonatomic, strong) NSArray<WaterJoint*> *joints;
@property (nonatomic, strong) SKShapeNode *shapeNode;
@property float surfaceHeight;
@property float width;
@property float spread;

@property CGPathRef path;

@end


@implementation DynamicWaterNode

#pragma mark - Setup

-(instancetype)initWithWidth:(float)width numJoints:(NSInteger)numJoints surfaceHeight:(float)surfaceHeight{
    
    self = [super init];
    if (!self) { return nil; }
    
    // Init Properties
    self.surfaceHeight = surfaceHeight;
    self.width = width;
    
    // Shape Node
    self.shapeNode = [[SKShapeNode alloc]init];
    self.shapeNode.fillColor = [UIColor blueColor];
    [self addChild:self.shapeNode];
    
    // Create joints
    NSMutableArray *mutableJoints = [[NSMutableArray alloc]initWithCapacity:numJoints];
    for (NSInteger i = 0; i < numJoints; i++) {
        WaterJoint *joint = [[WaterJoint alloc]init];
        CGPoint position;
        position.x = -(width/2) + ((width/numJoints) * i);
        position.y = 0;
        joint.position = position;
        [mutableJoints addObject:joint];
    }
    self.joints = [NSArray arrayWithArray:mutableJoints];
    
    
    [self performSelector:@selector(doSplash) withObject:nil afterDelay:5];
   
    return self;
}

-(void)doSplash{
    NSLog(@"SPLASH!");
    [self splash:CGPointMake(100, 100) speed:0];
}

- (void)splash:(CGPoint)location speed:(CGFloat)speed {
    
    NSInteger closestJointIndex = 0;
    CGFloat shortestDistance = CGFLOAT_MAX;
    WaterJoint *closestJoint;
    
    for (WaterJoint *joint in self.joints) {
    
        CGFloat distance = fabs(joint.position.x - location.x);
        if (distance < shortestDistance) {
            shortestDistance = distance;
            closestJoint = joint;
        }
    }
    
    closestJoint.speed = -100;
}


#pragma mark - Update

-(void)update:(CFTimeInterval)dt{
    
    self.spread = 0.15 * 60;
    
    for (WaterJoint *joint in self.joints) {
        [joint update:dt];
    }
    
    float leftDeltas[self.joints.count];
    float rightDeltas[self.joints.count];
    
    for (NSInteger pass = 0; pass < 1; pass++) {
        
        for (NSInteger i = 0; i < self.joints.count; i++) {
            
            WaterJoint *currentJoint = self.joints[i];
            
            if (i > 0) {
                WaterJoint *previousJoint = self.joints[i-1];
                leftDeltas[i] = self.spread * (currentJoint.position.y - previousJoint.position.y);
                previousJoint.speed += leftDeltas[i] * dt;
            }
            if (i < self.joints.count-1) {
                WaterJoint *nextJoint = self.joints[i+1];
                rightDeltas[i] = self.spread * (currentJoint.position.y - nextJoint.position.y);
                nextJoint.speed += rightDeltas[i] * dt;
            }
        }
        
        for (NSInteger i = 0; i < self.joints.count; i++) {
            
            if (i > 0) {
                WaterJoint *previousJoint = self.joints[i-1];
                [previousJoint setYPosition:previousJoint.position.y + leftDeltas[i] * dt];
            }
            if (i < self.joints.count - 1) {
                WaterJoint *nextJoint = self.joints[i+1];
                [nextJoint setYPosition:nextJoint.position.y + rightDeltas[i] * dt];
            }
            
        }
        
        
    }
    
    
    
    // Render
    [self render];
}

-(void)render{
    
    CGPathRelease(self.path);
    self.path = [self newPathFromJoints:self.joints];
    
    [self.shapeNode setPath:self.path];
}

- (CGPathRef)newPathFromJoints:(NSArray*)joints {
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    NSInteger index = 0;
    for (WaterJoint *joint in self.joints) {
        
        if (index == 0) {
            CGPathMoveToPoint(path,
                              nil,
                              joint.position.x,
                              joint.position.y + self.surfaceHeight);
        }
        else{
            CGPathAddLineToPoint(path,
                                 nil,
                                 joint.position.x,
                                 joint.position.y + self.surfaceHeight);
        }
        
        index++;
    }
    
    // Bottom Right
    CGPathAddLineToPoint(path,
                         nil,
                         self.width/2,
                         0);
    
    // Bottom Left
    CGPathAddLineToPoint(path,
                         nil,
                         -self.width/2,
                         0);
    
    CGPathCloseSubpath(path);

    
    return path;
}


@end
