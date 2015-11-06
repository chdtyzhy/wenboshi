//
//  WBGroupTemp.h
//  WenBoshi
//
//  Created by 马浩然 on 15/4/1.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBGroupTemp : NSObject

@property (nonatomic ,copy) NSString *start_time;
@property (nonatomic ,copy) NSString *end_time;
@property (nonatomic ,assign) CGFloat max_temp;
@property (nonatomic ,assign) CGFloat min_temp;
@property (nonatomic ,assign) CGFloat start_temp;
@property (nonatomic ,assign) CGFloat end_temp;
@property (nonatomic ,strong) NSArray *tempAry;
@property (nonatomic ,assign) int tempID;
@end
