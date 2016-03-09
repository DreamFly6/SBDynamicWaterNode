//
//  SettingsCellInfo.h
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsCellInfo : NSObject
@property (nonatomic, strong) NSString *title;
@end

@interface SettingsCellSliderInfo : SettingsCellInfo
@property float startValue;
@property float endValue;
@property (nonatomic, copy) float (^getCurrentValue)();
@property (nonatomic, copy) void (^updateCallback)(float newValue);
@property BOOL showValueReadout;
@end
