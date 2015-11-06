//
//  WBTemperature.m
//  WenBoshi
//
//  Created by 马浩然 on 15/3/30.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBTemperature.h"
#import "MJExtension.h"
@implementation WBTemperature

-( void )encodeWithCoder:(NSCoder * )encoder
{
    [ encoder encodeObject :self.create_time forKey:@"create_time"];
    [ encoder encodeInteger:self.tempID forKey:@"tempID"];
    [ encoder encodeFloat:self.temp forKey:@"temp"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init ] ){
        //读取文件的内容
        self.create_time = [ decoder decodeObjectForKey:@"create_time"];
        self.tempID = [decoder decodeIntegerForKey:@"tempID"];
        self.temp = [decoder decodeFloatForKey:@"temp"];
    }
    return self;
}


@end
