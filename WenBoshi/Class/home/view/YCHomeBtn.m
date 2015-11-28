//
//  YCHomeBtn.m
//  WenBoshi
//
//  Created by 马浩然 on 15/1/21.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "YCHomeBtn.h"

@implementation YCHomeBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.exclusiveTouch = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:RGB(118, 100, 86) forState:UIControlStateNormal];

    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*9/13);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height * 9/13, self.frame.size.width, 20);
}


@end
