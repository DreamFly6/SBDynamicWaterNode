//
//  DynamicWaterNode.m
//  DynamicWater
//
//  Created by Steve Barnegren on 07/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "DynamicWaterNode.h"

//**********************************************
#pragma mark - ***** Droplet *****
//**********************************************

@interface Droplet : SKSpriteNode
@property CGPoint velocity;


@end

@implementation Droplet

+(instancetype)droplet{
    Droplet *droplet = [[Droplet alloc]initWithImageNamed:@"metaparticle"];
    droplet.velocity = CGPointZero;
    return droplet;
}

@end

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
    
    CGFloat y = self.position.y;
    CGFloat acceleration = (-self.tension * y) - (self.speed * self.damping);

    self.position = CGPointMake(self.position.x, self.position.y + (self.speed * 60 * dt));
    self.speed += acceleration * dt;
}

@end

//**********************************************
#pragma mark - ***** DynamicWaterNode *****
//**********************************************

@interface DynamicWaterNode ()
@property (nonatomic, strong) NSArray<WaterJoint*> *joints;
@property (nonatomic, strong) SKShapeNode *shapeNode;
@property float width;
@property float spread;

@property CGPathRef path;

@property (nonatomic, strong) NSMutableArray *droplets;

@property (nonatomic, strong) SKEffectNode *dropletsNode;

@end


@implementation DynamicWaterNode

#pragma mark - Setup

-(instancetype)initWithWidth:(float)width numJoints:(NSInteger)numJoints surfaceHeight:(float)surfaceHeight fillColour:(UIColor*)fillColour{
    
    self = [super init];
    if (!self) { return nil; }
    
    // Init Properties
    self.surfaceHeight = surfaceHeight;
    self.width = width;
    self.droplets = [[NSMutableArray alloc]init];
    
    // Shape Node
    self.shapeNode = [[SKShapeNode alloc]init];
    self.shapeNode.fillColor = fillColour;
    self.shapeNode.zPosition = 2;
    [self addChild:self.shapeNode];
    
    // Droplets Node (SKEffectNode)
    
    self.dropletsNode = [[SKEffectNode alloc]init];
    self.dropletsNode.position = CGPointZero;
    self.dropletsNode.zPosition = 1;
    self.dropletsNode.shouldRasterize = NO;
    self.dropletsNode.shouldEnableEffects = YES;
    self.dropletsNode.shader = [SKShader shaderWithFileNamed:@"Droplets.fsh"];
    self.dropletsNode.hidden = NO;
    [self addChild:self.dropletsNode];
    

    // Droplets Node (SKnode)
//    self.dropletsNode = [SKNode node];
//    self.dropletsNode.position = CGPointZero;
//    self.dropletsNode.zPosition = 999;
//    [self addChild:self.dropletsNode];
    
    
    // Create joints
    NSMutableArray *mutableJoints = [[NSMutableArray alloc]initWithCapacity:numJoints];
    for (NSInteger i = 0; i < numJoints; i++) {
        WaterJoint *joint = [[WaterJoint alloc]init];
        CGPoint position;
        position.x = -(width/2) + ((width/(numJoints-1)) * i);
        position.y = 0;
        joint.position = position;
        [mutableJoints addObject:joint];
    }
    self.joints = [NSArray arrayWithArray:mutableJoints];
    
    // Initial render
    [self render];
    
    
    
   
    return self;
}


#pragma mark - Splash

-(void)splashAtX:(float)xLocation force:(CGFloat)force{
    [self splashAtX:xLocation force:force width:0];
}

-(void)splashAtX:(float)xLocation force:(CGFloat)force width:(float)width{

    xLocation -= self.width/2;
    
    CGFloat shortestDistance = CGFLOAT_MAX;
    WaterJoint *closestJoint;
    
    for (WaterJoint *joint in self.joints) {
    
        CGFloat distance = fabs(joint.position.x - xLocation);
        if (distance < shortestDistance) {
            shortestDistance = distance;
            closestJoint = joint;
        }
    }
    
    closestJoint.speed = -force;
    
    for (WaterJoint *joint in self.joints) {
        CGFloat distance = fabs(joint.position.x - closestJoint.position.x);
        if (distance < width) {
            joint.speed = distance / width * -force;
        }
    }
    
    
    // Add droplets
    for (NSInteger i = 0; i < 50; i++) {
        const float maxVelY = 500;
        const float minVelY = 200;
        const float maxVelX = -350;
        const float minVelX = 350;
        
        float velY = minVelY + (maxVelY - minVelY) * [self randomFloatBetween0and1];
        float velX = minVelX + (maxVelX - minVelX) * [self randomFloatBetween0and1];
        
        [self addDropletAt:CGPointMake(xLocation, self.surfaceHeight)
                  velocity:CGPointMake(velX, velY)];
    }
    
}

-(float)randomFloatBetween0and1{
    return (float)rand() / RAND_MAX;
}

#pragma mark - Droplets

-(void)addDropletAt:(CGPoint)position velocity:(CGPoint)velocity{
    
    Droplet *droplet = [Droplet droplet];
    droplet.velocity = velocity;
    droplet.position = position;
    droplet.zPosition = 1;
    droplet.blendMode = SKBlendModeAlpha;
    droplet.color = [UIColor blueColor];
    droplet.colorBlendFactor = 1;
    droplet.xScale = droplet.yScale = 3;
    //droplet.color = [UIColor blueColor];
    [self.dropletsNode addChild:droplet];
    [self.droplets addObject:droplet];
}

-(void)removeDroplet:(Droplet*)droplet{
    
    [droplet removeFromParent];
    [self.droplets removeObject:droplet];
}


#pragma mark - Update

-(void)update:(CFTimeInterval)dt{
    [self updateJoints:dt];
    [self updateDroplets:dt];
}

-(void)updateJoints:(CFTimeInterval)dt{
    
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
}

-(void)updateDroplets:(CFTimeInterval)dt{
    
    const float gravity = -1200;
    
    NSMutableArray *dropletsToRemove = [[NSMutableArray alloc]init];
    
    for (Droplet *droplet in self.droplets) {
        
        // Apply Gravity
        droplet.velocity = CGPointMake(droplet.velocity.x,
                                       droplet.velocity.y + gravity * dt);
        
        droplet.position = CGPointMake(droplet.position.x + droplet.velocity.x * dt,
                                       droplet.position.y + droplet.velocity.y * dt);
        
        // Remove if below surface
        if (droplet.position.y + droplet.texture.size.height/2 + 30 < self.surfaceHeight) {
            [dropletsToRemove addObject:droplet];
        }
    }
    
    for (Droplet *droplet in dropletsToRemove) {
        [self removeDroplet:droplet];
    }
    
}

#pragma mark - Render

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
