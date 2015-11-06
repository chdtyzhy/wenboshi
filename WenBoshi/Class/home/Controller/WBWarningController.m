//
//  WBWarningController.m
//  WenBoshi
//
//  Created by apple on 14/12/14.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "WBWarningController.h"



@interface WBWarningController ()
@property (weak, nonatomic) IBOutlet UISwitch *warnSwitch;
@property (weak, nonatomic) IBOutlet UISlider *wenduSlider;
- (IBAction)silderValueChanged:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UILabel *wenduLabel;

@end

@implementation WBWarningController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WBWarningController" owner:self options:nil] lastObject];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showBackButtonWithTitle:@"返回"];
    [self showRightButtonWithTitle:@"确定"];

    [self.wenduSlider setMinimumValue:-20];
    self.wenduSlider.maximumValue = 300;
    [self.wenduSlider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateNormal];
    [self.wenduSlider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateHighlighted];
    self.title = @"警报设置";
}

- (void) backBarButtonPressed:(id)sender
{
    [self backToPrePage];
}

- (void)rightBarButtonPressed:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.warnSwitch.on forKey:kWarnSwitchState];
    [defaults setFloat:self.wenduSlider.value forKey:kWarnTemp];
    [defaults synchronize];
    [self backBarButtonPressed:nil];
}


- (IBAction)silderValueChanged:(UISlider *)sender {
    self.wenduLabel.text = [NSString stringWithFormat:@"%.1f°",sender.value];
}


- (IBAction)switchClick:(UISwitch *)sender {
    
    if (sender.on) {
        self.wenduSlider.enabled = YES;
    }else
    {
        self.wenduSlider.enabled = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    // 初始化状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.warnSwitch.on = [defaults boolForKey:kWarnSwitchState];
    self.wenduSlider.value = [defaults floatForKey:kWarnTemp];
    [self silderValueChanged:self.wenduSlider];
    [self switchClick:self.warnSwitch];
    
}

@end
