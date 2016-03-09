//
//  SettingsView.m
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SettingsView.h"

@interface SettingsView()

@property (nonatomic, weak) IBOutlet UILabel *surfaceHeightLabel;
@property (nonatomic, weak) IBOutlet UILabel *tensionLabel;
@property (nonatomic, weak) IBOutlet UILabel *dampingLabel;
@property (nonatomic, weak) IBOutlet UILabel *spreadLabel;
@property (nonatomic, weak) IBOutlet UILabel *splashSizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *splashForceLabel;

@property (nonatomic, weak) IBOutlet UISlider *surfaceHeightSlider;
@property (nonatomic, weak) IBOutlet UISlider *tensionSlider;
@property (nonatomic, weak) IBOutlet UISlider *dampingSlider;
@property (nonatomic, weak) IBOutlet UISlider *spreadSlider;
@property (nonatomic, weak) IBOutlet UISlider *splashSizeSlider;
@property (nonatomic, weak) IBOutlet UISlider *splashForceSlider;

@end

@implementation SettingsView

+(id)instanceFromNib{
    
    id result = nil;
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner:self options: nil];
    for (id anObject in elements)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            break;
        }
    }
    NSAssert1(result, @"Failed to load %@ from nib", NSStringFromClass(self));
    
    return result;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    
}

-(IBAction)closeButtonPressed:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(settingsViewShouldClose:)]) {
        [self.delegate settingsViewShouldClose:self];
    }
}

@end
