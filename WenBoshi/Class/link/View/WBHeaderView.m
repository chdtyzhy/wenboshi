//
//  WBHeaderView.m
//  WenBoshi
//
//  Created by apple on 14/12/20.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "WBHeaderView.h"


@implementation WBHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn = leftBtn;
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchDown];
        [leftBtn setImage:[UIImage imageNamed:@"滑出"] forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        titleLabel.textColor =  RGB(88, 72, 59);
        titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:titleLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftBtn.frame = CGRectMake(18, 33, 24, 22);
    
    CGFloat titleW = 80;
    CGFloat titleY = 33;
    CGFloat titleH = 22;
    CGFloat titleX = (self.frame.size.width - titleW)/2;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
}

-(void)leftBtnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftBarBtnClick" object:nil];
}

@end
