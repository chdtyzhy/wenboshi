//
//  AppDelegate.h
//  WenBoshi
//
//  Created by luoshuisheng on 14/12/7.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) CBManager *manger;

+(AppDelegate *)shareDelegate;

@end

