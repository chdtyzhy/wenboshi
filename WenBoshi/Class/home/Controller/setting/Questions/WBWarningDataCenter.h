//
//  WBWarningDataCenter.h
//  WenBoshi
//
//  Created by 张勇 on 16/4/17.
//  Copyright © 2016年 luoshuisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBWarningDataCenter : NSObject

//高温
@property (nonatomic, assign) CGFloat  hightTemp;

//低温
@property (nonatomic, assign) CGFloat  lowTemp;

+ (instancetype)shareDataCenter;

@end
