//
//  DelegateViewController.h
//  JobHunting
//
//  Created by 123 on 14-6-10.
//  Copyright (c) 2014年 123. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DelegateViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic ,strong) NSString *systemNotif;
@property (nonatomic ,strong) NSString *systemUrlStr;
@property (nonatomic ,strong) UIWebView *syswebView;

@end
