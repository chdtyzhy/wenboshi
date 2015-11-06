//
//  WBCacheTool.h
//  WenBoshi
//
//  Created by 马浩然 on 15/3/30.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBTemperature;

@interface WBCacheTool : NSObject

/** 缓存温度*/
+(void)addTemperature:(WBTemperature *)temp;

/** 混存一组温度数据*/
+(void)addtemperatures:(NSArray *)tempAry;

/** 获取一组数组里面的数据*/
+(NSArray *)getTemperature:(int)tempID;

/** 获取一组数据的最大温度*/
+(CGFloat)getMaxTemp:(int)tempID;

/** 获取一组数据的最小温度*/
+(CGFloat)getMinTemp:(int)tempID;

/** 总共记录的数组数*/
+(NSArray*)temperatureCounts;

/** 删除一条温度*/
+(void)deleteTemp:(int)tempID;

+(void)deleteAllTemp;

@end
