//
//  WBWarningImageView.m
//  WenBoshi
//
//  Created by 马浩然 on 15/1/20.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBWarningImageView.h"

@interface WBWarningImageView ()

@property (nonatomic ,weak) UIImageView *iconImagView;
@property (nonatomic ,weak) UILabel *titleLabel;

@end


@implementation WBWarningImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        self.iconImagView = iconImageView;
        iconImageView.image = [UIImage imageNamed:@"警报"];
        [self addSubview:iconImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel = titleLabel;
        titleLabel.text = @"警报温度.";
        
        UILabel *numberLable = [[UILabel alloc] init];
        self.numberLabel = numberLable;
        numberLable.font = titleLabel.font;
        numberLable.textColor = titleLabel.textColor;
        [self addSubview:numberLable];
    
        }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat iconX = 15;
    CGFloat iconY = 8;
    CGFloat iconW = 9;
    CGFloat iconH = 17;
    self.iconImagView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    CGFloat titleX = iconX + iconW + 5;
    CGFloat titleY = iconY+2;
    CGSize titleSize = KSizeFont(self.titleLabel.text, self.titleLabel.font);
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    
    CGFloat numberX = titleX + titleSize.width + 5;
    CGFloat numberY = titleY;
    CGFloat numberW = 40;
    self.numberLabel.frame = CGRectMake(numberX, numberY, numberW, titleSize.height);
}

@end
