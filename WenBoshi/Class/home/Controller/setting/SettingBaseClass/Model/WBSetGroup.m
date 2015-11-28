//
//  WBSetGroup.m
//  WenBoshi
//
//  Created by 张勇 on 15/11/28.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import "WBSetGroup.h"

@implementation WBSetGroup

-(NSArray*)items
{
    if (_items == nil) {
        _items = [NSArray array];
    }
    return _items;
}

+(instancetype)group
{
    return [[self alloc]init];
}

@end
