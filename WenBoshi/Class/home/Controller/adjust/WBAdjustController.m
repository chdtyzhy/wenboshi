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

@property (nonatomic, weak) UIImageView *bgView;  //背景
@property (nonatomic ,strong) UILabel *nameLable;
@property (strong, nonatomic)  UISlider *slider;
@property (strong, nonatomic)  UILabel *changeLabel;
- (void)slideClick:(id)sender;
@property (nonatomic ,assign) CGFloat changeValue;
@property (nonatomic ,assign) CGFloat deviceChangeValue;
@property (strong, nonatomic)  UIButton *zeroBtn;
- (void)zeroBtnClick:(id)sender;
@end

@implementation WBAdjustController

- (UISlider *)slider
{
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateHighlighted];
        _slider.minimumValue = -9.9;
        _slider.maximumValue = 9.9;
        [_slider setMinimumTrackTintColor:[UIColor redColor]];
        [_slider setMaximumTrackTintColor:[UIColor darkTextColor]];
        [_slider addTarget:self action:@selector(slideClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

-(UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.font = [UIFont systemFontOfSize:15];
        _nameLable.text = @"偏差调整";
        _nameLable.textColor = [UIColor blackColor];
        _nameLable.backgroundColor = [UIColor clearColor];
    }
    return _nameLable;
}

-(UILabel *)changeLabel
{
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = [UIFont systemFontOfSize:10];
        _changeLabel.text = @"正在读取...";
        _changeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changeLabel;
}

- (UIButton *)zeroBtn
{
    if (_zeroBtn == nil) {
        _zeroBtn = [[UIButton alloc]init];
        _zeroBtn.backgroundColor = [UIColor redColor];
        _zeroBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_zeroBtn setTitle:@"归零" forState:UIControlStateNormal];
        _zeroBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _zeroBtn.layer.masksToBounds = YES;
        _zeroBtn.layer.cornerRadius = 2;
        [_zeroBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zeroBtn addTarget:self action:@selector(zeroBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zeroBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showBackButtonWithTitle:@"返回"];
    [self showRightButtonWithTitle:@"确定"];
    self.title = @"偏差调整";
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.bgView = bgView;
    bgView.userInteractionEnabled = YES;
    self.bgView.image = [UIImage imageNamed:@"首页背景"];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.nameLable];
    self.nameLable.frame = CGRectMake(20, 100, 100, 30);
    [self.bgView addSubview:self.slider];
    self.slider.frame = CGRectMake(MainScreenWith - 120, 100, 100, 30);
    
    UILabel *showLable = [[UILabel alloc]init];
    showLable.font = [UIFont systemFontOfSize:10];
    showLable.text = @"调整偏差数值";
    showLable.textColor = RGB(34, 82, 25);
    showLable.frame = CGRectMake(20, CGRectGetMaxY(self.nameLable.frame)+5, 100, 20);
    [self.bgView addSubview:showLable];
    
    [self.bgView addSubview:self.changeLabel];
    self.changeLabel.frame = CGRectMake(self.slider.frame.origin.x, showLable.frame.origin.y, 100, 20);
    
    [self.bgView addSubview:self.zeroBtn];
    self.zeroBtn.frame = CGRectMake(20, MainScreenHeight - 60, MainScreenWith - 40, 40);
 
    
    self.manger = [CBManager shareManager];
    __weak typeof(self)weakSelf = self;
    [self.manger readCalibrationValueWithSucces:^(NSString *DeviceValue) {
        __strong typeof(weakSelf) sself = weakSelf;
        sself.changeLabel.text = [sself getValue:DeviceValue];
        sself.slider.value = [sself getValueFloat:DeviceValue];
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

- (void)slideClick:(id)sender {
    self.changeLabel.text =  [NSString stringWithFormat:@"%.1f",self.slider.value];
    self.changeValue = self.slider.value;
}
- (void)zeroBtnClick:(id)sender {
    self.slider.value = 0;
    self.changeValue = 0;
    self.changeLabel.text = @"0";
    [self rightBarButtonPressed:nil];
}
@end
