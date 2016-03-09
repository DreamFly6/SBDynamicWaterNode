//
//  SettingsView.h
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicWaterNode.h"

@class GameScene;

@protocol SettingsViewDelegate;

@interface SettingsView : UIView
@property (nonatomic, weak) id<SettingsViewDelegate> delegate;

@property (nonatomic, weak) GameScene *gameScene;
@property (nonatomic, weak) DynamicWaterNode *waterNode;
+(id)instanceFromNib;

@end

@protocol SettingsViewDelegate <NSObject>
-(void)settingsViewShouldClose:(SettingsView*)settingsView;
-(void)settingsViewWantsRestoreDefaultValues:(SettingsView*)settingsView;
@end
