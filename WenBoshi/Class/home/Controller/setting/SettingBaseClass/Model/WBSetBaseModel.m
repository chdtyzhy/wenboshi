//
//  WBSetBaseModel.m
//  WenBoshi
//
//  Created by 张勇 on 15/11/28.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import "WBSetBaseModel.h"

@implementation WBSetBaseModel

-(instancetype)initWithTitle:(NSString *)title andDesVC:(Class )cls
{
    if (self = [super init]) {
        self.title = title;
        self.destClass = cls;
    }
    return self;
}
+(instancetype)modelWithTitle:(NSString *)title andDesVC:(Class )cls
{
    return [[self alloc]initWithTitle:title andDesVC:cls];
}
@end
