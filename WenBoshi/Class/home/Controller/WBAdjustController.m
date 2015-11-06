//
//  WBAdjustController.m
//  WenBoshi
//
//  Created by apple on 14/12/14.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "WBAdjustController.h"
#import "CBManager.h"

@interface WBAdjustController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
- (IBAction)slideClick:(id)sender;
@property (nonatomic ,assign) CGFloat changeValue;
@property (nonatomic ,assign) CGFloat deviceChangeValue;
@property (weak, nonatomic) IBOutlet UIButton *zeroBtn;
- (IBAction)zeroBtnClick:(id)sender;
@end

@implementation WBAdjustController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WBAdujustController" owner:self options:nil] lastObject];
    }
    return self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButtonWithTitle:@"返回"];
    [self showRightButtonWithTitle:@"确定"];
    self.title = @"偏差调整";
    
    [self.slider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateHighlighted];
    self.slider.minimumValue = -9.9;
    self.slider.maximumValue = 9.9;
    
    self.manger = [CBManager shareManager];
    __weak typeof(self)weakSelf = self;
    [self.manger readCalibrationValueWithSucces:^(NSString *DeviceValue) {
        weakSelf.changeLabel.text = [weakSelf getValue:DeviceValue];
        self.slider.value = [weakSelf getValueFloat:DeviceValue];
    } andFail:^(NSString *errorStr, NSString *localValue) {
        
    }];

}

-(CGFloat)getValueFloat:(NSString *)value
{
    NSString *code = [value substringToIndex:1];
    
    if ([code isEqualToString:@"+"] || [code isEqualToString:@"-"]) {
        return [[value substringFromIndex:1] floatValue];
    }else{
        return 0;
    }
}

-(NSString *)getValue:(NSString *)value
{
    NSString *code = [value substringToIndex:1];

    if ([code isEqualToString:@"+"]) {
        return [value substringFromIndex:1];
    }else{
        return value;
    }
}

-(NSString *)setValue:(CGFloat)floatValue
{
    if (self.changeValue > 0 || self.changeValue == 0) {
        return [NSString stringWithFormat:@"+%.1f",self.changeValue];
    }else{
        return [NSString stringWithFormat:@"%.1f",self.changeValue];
    }
}

-(void)rightBarButtonPressed:(id)sender
{
        [self setValue:self.changeValue];
        __weak typeof(self)weakSelf = self;
        [self.manger setCalibbrationValue:[self setValue:self.changeValue] andSucces:^(NSString *DeviceValue) {
            
            [weakSelf  dismissViewControllerAnimated:YES completion:nil];
        } andFail:^(NSString *errorStr, NSString *localValue) {
            [weakSelf showToastMessage:errorStr];
        }];
        
}

-(void)backBarButtonPressed:(id)sender
{
    [self backToPrePage];
}

- (IBAction)slideClick:(id)sender {
    self.changeLabel.text =  [NSString stringWithFormat:@"%.1f",self.slider.value];
    self.changeValue = self.slider.value;
}
- (IBAction)zeroBtnClick:(id)sender {
    self.slider.value = 0;
    self.changeValue = 0;
    self.changeLabel.text = @"0";
    [self rightBarButtonPressed:nil];
}
@end
