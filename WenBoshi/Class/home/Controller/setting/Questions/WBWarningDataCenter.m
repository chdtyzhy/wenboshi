//
//  WBWarningDataCenter.m
//  WenBoshi
//
//  Created by 张勇 on 16/4/17.
//  Copyright © 2016年 luoshuisheng. All rights reserved.
//

#import "WBWarningDataCenter.h"

@interface WBWarningDataCenter()


@end

@implementation WBWarningDataCenter
+(instancetype)shareDataCenter
{
    static  WBWarningDataCenter *temp=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        temp=[[self alloc] init];
    });
    return temp;
}

@end
