//
//  SettingsSliderCell.h
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsCellInfo.h"

@interface SettingsSliderCell : UITableViewCell

@property (nonatomic, strong) NSString *title;

-(void)setupWithInfo:(SettingsCellSliderInfo*)info;

@end
