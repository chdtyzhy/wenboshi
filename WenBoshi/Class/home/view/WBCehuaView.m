//
//  WBCehuaView.m
//  WenBoshi
//
//  Created by 马浩然 on 15/1/27.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBCehuaView.h"

@interface WBCehuaView ()
@property (nonatomic ,weak) UIView *bgView;
@property (nonatomic ,weak) UIButton *zhushouBtn;
@property (nonatomic ,weak) UIButton *wenduBtn;
@property (nonatomic ,weak) UIButton *settingBtn;
@property (nonatomic ,weak) UIImageView *bgImageView;
@property (nonatomic ,strong) NSMutableArray *btnAry;

@end

@implementation WBCehuaView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIView *bgView = [[UIView alloc] init];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UIImageView *bgImageView = [[UIImageView alloc] init];
        self.bgImageView = bgImageView;
        [self.bgView addSubview:bgImageView];
        bgImageView.image = [UIImage imageNamed:@"背景"];
        
//        self.zhushouBtn = [self getbtn:@" 温博士助手" image:[UIImage imageNamed:@"温度"]];
//        self.zhushouBtn.tag = WBCehuaZhushou;
        self.wenduBtn = [self getbtn:@" 温度记录" image:[UIImage imageNamed:@"记录"]];
        self.wenduBtn.tag = WBCehuaCase;
        self.settingBtn = [self getbtn:@" 设置" image:[UIImage imageNamed:@"设置"]];
        self.settingBtn.tag = WBCehuaSetting;
    }
    return self;
}

-(UIButton *)getbtn:(NSString *)title image:(UIImage *)iconImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:iconImage forState:UIControlStateNormal];
    [btn setImage:iconImage forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:btn];
    [self.btnAry addObject:btn];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return btn;
}

-(NSMutableArray *)btnAry
{
    if (_btnAry == nil) {
        _btnAry = [NSMutableArray array];
    }
    return _btnAry;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat bgX = 0;
    CGFloat bgY = 0;
    CGFloat bgW = 198;
    CGFloat bgH = self.frame.size.height;
    self.bgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
    self.bgImageView.frame = self.bgView.frame;
    CGFloat btnX = 37;
    CGFloat btnH = 60;
    CGFloat btnW = self.bgView.frame.size.width - 37;
    CGFloat btnY = 0;
    for (int index = 0; index < 2; index ++) {
        UIButton *btn = self.btnAry[index];
        btnY = 60 + btnH *index;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    }];
}

-(void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(cehuaBtnClick:)]) {
        [self.delegate cehuaBtnClick:(int)btn.tag];
    }
}

@end
