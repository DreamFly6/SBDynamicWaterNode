//
//  SettingsCellInfo.m
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SettingsCellInfo.h"

@implementation SettingsCellInfo
+(SettingsCellInfo*)cellInfoWithTitle:(NSString*)title{
    SettingsCellInfo *info = [[SettingsCellInfo alloc ]init];
    info.title = title;
    return info;
}

@end

@implementation SettingsCellSliderInfo
@end

