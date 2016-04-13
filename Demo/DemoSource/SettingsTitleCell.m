//
//  SettingsTitleCell.m
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SettingsTitleCell.h"

@interface SettingsTitleCell ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@end

@implementation SettingsTitleCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setTitle:(NSString*)title{
    self.label.text = title;
}

@end
