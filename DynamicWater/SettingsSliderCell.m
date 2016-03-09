//
//  SettingsSliderCell.m
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SettingsSliderCell.h"

@interface SettingsSliderCell ()
@property (nonatomic, strong) SettingsCellSliderInfo *info;

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UISlider *slider;

@end

@implementation SettingsSliderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithInfo:(SettingsCellSliderInfo*)info{
    self.info = info;
    
    self.slider.minimumValue = info.startValue;
    self.slider.maximumValue = info.endValue;
    self.slider.continuous = YES;
    self.slider.value = info.getCurrentValue();
    
    [self updateLabel];
}

-(IBAction)sliderValueChanged:(UISlider*)slider{
    NSLog(@"slider value changed");
    self.info.updateCallback(slider.value);
    [self updateLabel];
}


-(void)updateLabel{
    
    NSString *text = self.info.title;
    if (self.info.showValueReadout) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"( %g)", self.slider.value]];
    }
    self.label.text = text;
}

@end
