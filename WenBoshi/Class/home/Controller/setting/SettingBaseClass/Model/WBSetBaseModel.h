//
//  WBSetBaseModel.h
//  WenBoshi
//
//  Created by 张勇 on 15/11/28.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSetBaseModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) Class  destClass;

+(instancetype)modelWithTitle:(NSString *)title andDesVC:(Class )cls;

@end
