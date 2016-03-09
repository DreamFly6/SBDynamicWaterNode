//
//  SettingsView.m
//  DynamicWater
//
//  Created by Steve Barnegren on 08/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

+(instancetype)instanceFromNib{
    
    id result = nil;
    NSArray* views = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options: nil];
    for (id view in views)
    {
        if ([view isKindOfClass:[self class]])
        {
            result = view;
            break;
        }
    }
    
    NSAssert1(result, @"Failed to load %@ from nib", NSStringFromClass(self));
    return result;
}



@end
