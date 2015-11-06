//
//  WBNavigationController.m
//  WenBoshi
//
//  Created by 马浩然 on 15/1/29.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBNavigationController.h"
@interface WBNavigationController ()

@end

@implementation WBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:RGB(94, 91, 86)];
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    muDict[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [bar setTitleTextAttributes:muDict];
    [bar setTintColor:[UIColor whiteColor]];
}

@end
