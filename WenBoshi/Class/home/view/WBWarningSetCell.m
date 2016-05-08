//
//  WBWarningSetCell.m
//  WenBoshi
//
//  Created by 张勇 on 15/11/21.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import "WBWarningSetCell.h"
#import "WBWarningDataCenter.h"


@interface  WarnTempView: UIView

@property (nonatomic,  strong, nonnull) UISlider *slider;

@property (nonatomic,  strong, nonnull) UIImageView *iconView;

@property (nonatomic,  strong, nonnull) UIImageView *bgView;

@property (nonatomic,  strong, nonnull) UILabel *numLable;

@property (nonatomic, assign) CGFloat  tempValue;

@property (nonatomic, assign) cellType  type;

@end


@implementation WarnTempView

-(void)setTempValue:(CGFloat)tempValue
{
    _tempValue = tempValue;
    self.slider.value = tempValue;
    [self silderValueChanged:self.slider];
}

-(UISlider *)slider
{
    if (_slider == nil) {
        _slider = [[UISlider alloc]init];
        [_slider setMinimumValue:-20];
        _slider.maximumValue = 300;
        [_slider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateHighlighted];
        _slider.minimumTrackTintColor = [UIColor redColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        [_slider addTarget:self action:@selector(silderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
-(instancetype)init
{
    if (self = [super init]) {
         self.bgView = [[UIImageView alloc]init];
         self.bgView.userInteractionEnabled = YES;
         self.bgView.image = [UIImage  imageNamed:@"进度条-底"];
        [self addSubview:self.bgView];
    
        [self addSubview:self.slider];
        
        self.iconView  = [[UIImageView alloc]init];
         UIImage *image= [UIImage imageNamed:@"红背景"];
        self.iconView.image = image;
        
        [self addSubview:self.iconView];
     
        self.numLable = [[UILabel alloc] init];
        self.numLable.font = [UIFont systemFontOfSize:10];
        self.numLable.textColor = [UIColor whiteColor];
        self.numLable.textAlignment = NSTextAlignmentCenter;
        [self.iconView addSubview:self.numLable];
    }
    return self;
}

- (void)silderValueChanged:(UISlider *)sender {
    _tempValue = sender.value;
    self.numLable.text = [NSString stringWithFormat:@"%.1f°",sender.value];
    if (_type == kCellTypeHight) {
        [[WBWarningDataCenter shareDataCenter] setHightTemp:[self.numLable.text floatValue]];
    }
    if (_type == kCellTypeLow) {
        [[WBWarningDataCenter shareDataCenter] setLowTemp:[self.numLable.text floatValue]];
    }
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat sliderX = 0;
    CGFloat sliderY = self.frame.size.height - 15;
    CGFloat sliderW = self.frame.size.width;
    CGFloat sliderH = 20;
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    self.bgView.frame = CGRectMake(sliderX, sliderY+5, sliderW, 10);
    
    CGFloat iconX = 15;
    CGFloat iconY = -3;
    CGFloat iconW = 41;
    CGFloat iconH = 21;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat numLableX = 0;
    CGFloat numLableY = 3;
    CGFloat numLableW = iconW;
    CGFloat numLableH = 11;
    self.numLable.frame = CGRectMake(numLableX, numLableY, numLableW, numLableH);
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@interface WBWarningSetCell ()

@property (nonatomic, strong) UILabel  *nameLale;

@property (nonatomic, strong) UISwitch *swicthBtn;

@property (nonatomic, strong) WarnTempView *warnTempView;

@property (nonatomic, weak) UIImageView *diver;

@end

@implementation WBWarningSetCell


- (UISwitch *)swicthBtn
{
    if (_swicthBtn == nil) {
        _swicthBtn = [[UISwitch alloc] init];
    }
    return _swicthBtn;
}



-(UILabel *)nameLale
{
    if (_nameLale == nil) {
        _nameLale = [[UILabel alloc]init];
        _nameLale.font = [UIFont systemFontOfSize:15];
        _nameLale.backgroundColor = [UIColor clearColor];
    }
    return _nameLale;
}

- (WarnTempView *)warnTempView
{
    if (_warnTempView == nil) {
        _warnTempView = [[WarnTempView alloc]init];
    }
    return _warnTempView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        if (self.nameLale) {
            [self.contentView addSubview:self.nameLale];
        }
        if (self.warnTempView) {
            [self.contentView addSubview:self.warnTempView];
        }
        if (self.swicthBtn) {
            [self.contentView addSubview:self.swicthBtn];
        }
        UIImageView *diver = [[UIImageView alloc]init];
        diver.image = [UIImage imageNamed:@"分割线"];
        self.diver = diver;
        [self.contentView addSubview:self.diver];
     }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
   return self;
}

-(void)setType:(cellType)type
{
    
         _type = type;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (_type == kCellTypeSwitch) {
        self.nameLale.text = @"开启警报";
        self.swicthBtn.hidden = NO;
        self.warnTempView.hidden = YES;
        self.swicthBtn.on = NO;
        if ([defaults boolForKey:kWarnSwitchState]) {
            self.swicthBtn.on = [defaults boolForKey:kWarnSwitchState];
        }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveSwitchStatus) name:SAVESWITCHSTATUS object:nil];
    }else if(_type == kCellTypeHight){
        self.nameLale.text = @"高温设置";
        self.swicthBtn.hidden = YES;
        self.warnTempView.type = type;
        self.warnTempView.hidden = NO;
        self.warnTempView.tempValue = [defaults floatForKey:kWarnHightTemp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveHightTempData) name:SaveHighTemperature object:nil];
    }else{
        self.nameLale.text = @"低温设置";
        self.swicthBtn.hidden = YES;
        self.warnTempView.hidden = NO;
        self.warnTempView.type = type;
        self.warnTempView.tempValue = [defaults floatForKey:kWarnLowTemp];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLowTempData) name:SaveLowTemperature object:nil];
    }
    
}

#pragma mark ----- 设置高温 && 低温 && 开关状态
- (void)saveSwitchStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setBool:self.swicthBtn.on forKey:kWarnSwitchState];
    [defaults synchronize];
}

- (void)saveHightTempData
{
    if (!self.warnTempView.hidden && self.type != kCellTypeSwitch) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:self.warnTempView.tempValue forKey:kWarnHightTemp];
        [defaults synchronize];
    }
}

- (void)saveLowTempData
{
  if (!self.warnTempView.hidden && self.type != kCellTypeSwitch) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.warnTempView.tempValue forKey:kWarnLowTemp];
    [defaults synchronize];
   }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat nameLableX = 10;
    CGFloat nameLableY = 15;
    CGFloat nameLableW = 200;
    CGFloat nameLableH = 16;
    self.nameLale.frame = CGRectMake(nameLableX, nameLableY, nameLableW, nameLableH);
    if (!self.swicthBtn.hidden) {
        CGFloat switchX = self.contentView.frame.size.width - 70;
        CGFloat switchY = 8;
        CGFloat switchW = 50;
        CGFloat switchH = 25;
        self.swicthBtn.frame = CGRectMake(switchX, switchY, switchW, switchH);
    }else{
        self.swicthBtn.frame = CGRectZero;
    }
    if (!self.warnTempView.hidden) {
        CGFloat  warnTempViewX = self.contentView.frame.size.width - 100;
        CGFloat  warnTempViewY = 2;
        CGFloat  warnTempViewW = 86;
        CGFloat  warnTempViewH = 30;
        self.warnTempView.frame = CGRectMake(warnTempViewX, warnTempViewY, warnTempViewW, warnTempViewH);
    }else{
        self.warnTempView.frame = CGRectZero;
    }
    
    if ([self isLastRow]) {
        self.diver.frame = CGRectZero;
    }else{
       self.diver.frame = CGRectMake(10, self.contentView.frame.size.height - 5, self.contentView.frame.size.width-20, 5);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
