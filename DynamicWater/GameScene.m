//
//  GameScene.m
//  DynamicWater
//
//  Created by Steve Barnegren on 07/03/2016.
//  Copyright (c) 2016 Steve Barnegren. All rights reserved.
//

#import "GameScene.h"
#import "DynamicWaterNode.h"
#import "Rock.h"
#import "SettingsView.h"

#define kFixedTimeStep (1.0f/500)

typedef enum : NSUInteger {
    ZPositionSky,
    ZPositionRock,
    ZPositionWater,
} ZPositions;

@interface GameScene () <SettingsViewDelegate>
@property (nonatomic, strong) SettingsView *settingsView;

@property (nonatomic, strong) SKSpriteNode *skySprite;
@property (nonatomic, strong) DynamicWaterNode *waterNode;

@property CFTimeInterval lastFrameTime;
@property BOOL hasReferenceFrameTime;

@property (nonatomic, strong) Rock *rock;
@property (nonatomic, strong) NSMutableArray *rocks;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.rocks = [[NSMutableArray alloc]init];

    // Sky
    self.skySprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"sky"]];
    self.skySprite.xScale = self.size.width/self.skySprite.texture.size.width;
    self.skySprite.yScale = self.size.height/self.skySprite.texture.size.height;
    self.skySprite.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.skySprite.zPosition = ZPositionSky;
    [self addChild:self.skySprite];

    // Water
    self.waterNode = [[DynamicWaterNode alloc]initWithWidth:self.size.width numJoints:100 surfaceHeight:200 fillColour:[UIColor blueColor]];
    self.waterNode.position = CGPointMake(self.size.width/2, 0);
    self.waterNode.zPosition = ZPositionWater;
    self.waterNode.alpha = 0.7;
    [self addChild:self.waterNode];
    
    // Settings Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Settings" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(showSettingsView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:8]];
    
}

#pragma mark - Touch Handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.rock) { return; }
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    self.rock = [[Rock alloc]initWithImageNamed:@"rock"];
    self.rock.position = location;
    self.rock.zPosition = ZPositionRock;
    [self addChild:self.rock];
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.rock) {
        [self.rock removeFromParent];
        self.rock = nil;
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.rock) { return; }
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    self.rock.position = location;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.rock) { return; }
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    self.rock.position = location;
    [self.rocks addObject:self.rock];
    self.rock = nil;
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

    
    NSMutableArray *rocksToRemove = [[NSMutableArray alloc]init];
    
    const float gravity = -1200;
    for (Rock *rock in self.rocks) {
        
        // Apply Gravity
        rock.velocity = CGPointMake(rock.velocity.x,
                                    rock.velocity.y + gravity * dt);
    
        rock.position = CGPointMake(rock.position.x + rock.velocity.x * dt,
                                    rock.position.y + rock.velocity.y * dt);
        
        // Splash
        if (rock.isAboveWater && rock.position.y <= self.waterNode.surfaceHeight) {
            rock.isAboveWater = NO;
            [self.waterNode splashAtX:rock.position.x force:-rock.velocity.y* 0.125 width:20];

        }
        
        // Remove if off-screen
        if (rock.position.y < - rock.size.height/2) {
            [rocksToRemove addObject:rock];
        }
    }
    
    for (Rock *rock in rocksToRemove) {
        [self.rocks removeObject:rock];
    }
    
}

-(void)lateUpdate:(CFTimeInterval)dt{
    [self.waterNode render];
}

#pragma mark - Settings View

-(void)showSettingsView{
    if (self.settingsView) { return; }
    
    self.settingsView = [SettingsView instanceFromNib];
    self.settingsView.frame = self.view.bounds;
    self.settingsView.delegate = self;
    [self.view addSubview:self.settingsView];
    
}

-(void)settingsViewShouldClose:(SettingsView *)settingsView{
    
    if (self.settingsView) {
        [self.settingsView removeFromSuperview];
        self.settingsView = nil;
    }
    
}

@end
