//
//  SettingsView.m
//  DynamicWater
//
//  Created by Steve Barnegren on 09/03/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

#import "SettingsView.h"
#import "SettingsSliderCell.h"
#import "SettingsCellInfo.h"
#import "GameScene.h"

#define kCellHeight 45

@interface SettingsView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (nonatomic, strong) NSArray *cellInfos;
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
    [self createCellInfos];
    
    // Container View
    self.containerView.layer.cornerRadius = 15;
    self.containerView.clipsToBounds = YES;
    
    // TableView
    self.tableViewHeightConstraint.constant = kCellHeight * self.cellInfos.count;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"SettingsSliderCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([SettingsSliderCell class])];
    [self.tableView reloadData];
    
    
}

-(void)createCellInfos{
    
    NSMutableArray *cellInfos = [[NSMutableArray alloc]init];
    
    __weak __typeof__(self) weakSelf = self;
    
    // Surface Height
    {
        SettingsCellSliderInfo *info = [[SettingsCellSliderInfo alloc]init];
        info.title = @"Surface Height";
        info.startValue = 150;
        info.endValue = 500;
        info.showValueReadout = YES;
        [info setGetCurrentValue:^float{
            return weakSelf.waterNode.surfaceHeight;
        }];
        [info setUpdateCallback:^void(float newValue) {
            weakSelf.waterNode.surfaceHeight = newValue;
        }];
        [cellInfos addObject:info];
    }
    
    // Tension
    {
        SettingsCellSliderInfo *info = [[SettingsCellSliderInfo alloc]init];
        info.title = @"Tension";
        info.startValue = 0.05;
        info.endValue = 15;
        info.showValueReadout = YES;
        [info setGetCurrentValue:^float{
            return weakSelf.waterNode.tension;
        }];
        [info setUpdateCallback:^void(float newValue) {
            weakSelf.waterNode.tension = newValue;
        }];
        [cellInfos addObject:info];
    }
    
    // Damping
    {
        SettingsCellSliderInfo *info = [[SettingsCellSliderInfo alloc]init];
        info.title = @"Damping";
        info.startValue = 0.15;
        info.endValue = 15;
        info.showValueReadout = YES;
        [info setGetCurrentValue:^float{
            return weakSelf.waterNode.damping;
        }];
        [info setUpdateCallback:^void(float newValue) {
            weakSelf.waterNode.damping = newValue;
        }];
        [cellInfos addObject:info];
    }
    
    // Spread
    {
        
        SettingsCellSliderInfo *info = [[SettingsCellSliderInfo alloc]init];
        info.title = @"Spread";
        info.startValue = 3;
        info.endValue = 100;
        info.showValueReadout = YES;
        [info setGetCurrentValue:^float{
            return weakSelf.waterNode.spread;
        }];
        [info setUpdateCallback:^void(float newValue) {
            weakSelf.waterNode.spread = newValue;
        }];
        [cellInfos addObject:info];
    }
    
    // Splash Force Multiplier
    {
        
        SettingsCellSliderInfo *info = [[SettingsCellSliderInfo alloc]init];
        info.title = @"Splash Force";
        info.startValue = 0.02;
        info.endValue = 2.5;
        info.showValueReadout = NO;
        [info setGetCurrentValue:^float{
            return weakSelf.gameScene.splashForceMultiplier;
        }];
        [info setUpdateCallback:^void(float newValue) {
            weakSelf.gameScene.splashForceMultiplier = newValue;
        }];
        [cellInfos addObject:info];
    }
    
    // Splash Width
    {
        
        SettingsCellSliderInfo *info = [[SettingsCellSliderInfo alloc]init];
        info.title = @"Splash Width";
        info.startValue = 0;
        info.endValue = 200;
        info.showValueReadout = YES;
        [info setGetCurrentValue:^float{
            return weakSelf.gameScene.splashWidth;
        }];
        [info setUpdateCallback:^void(float newValue) {
            weakSelf.gameScene.splashWidth = newValue;
        }];
        [cellInfos addObject:info];
    }
    
    self.cellInfos = [NSArray arrayWithArray:cellInfos];
}

#pragma mark - Actions

-(IBAction)restoreDefaultsButtonPressed:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(settingsViewWantsRestoreDefaultValues:)]) {
        [self.delegate settingsViewWantsRestoreDefaultValues:self];
    }
    [self.tableView reloadData];
}

-(IBAction)closeButtonPressed:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(settingsViewShouldClose:)]) {
        [self.delegate settingsViewShouldClose:self];
    }
}

#pragma mark - UITableView Datasource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SettingsSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingsSliderCell class])];
    [cell setupWithInfo:self.cellInfos[indexPath.row]];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

@end
