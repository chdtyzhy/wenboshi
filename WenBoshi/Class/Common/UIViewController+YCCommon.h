//
//  UIViewController+YCCommon.h
//  iWeidao
//
//  Created by yongche on 13-11-8.
//  Copyright (c) 2013年 Weidao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (YCCommon)

@property (nonatomic,strong) UIImageView * homeShotImageV;


- (void)showProgressHUD;

- (void)hideProgressHUD;

- (void)showToastMessage:(NSString *)message;

- (void)showBackButton;

- (void)showBackButtonWithImage:(NSString *)imagestr;

-(void)showBackButtonWithTitle:(NSString *)title imageStr:(NSString *)imageStr;

- (void)showBackButtonWithTitle:(NSString *)title;


- (void)hideBackButton;

- (void)showDownButton;

- (void)addSegmentButtonInNav:(NSArray *)titleArray;

- (void)addRoundSegmentButton:(NSArray *)titleArray;


- (void)backBarButtonPressed:(id)sender;

- (void)showRightButtonWithTitle:(NSString *)title;

- (void)hideRightButton;

- (void)showRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color;

- (void)showRightButtonWithImage:(UIImage *)image andHigImage:(UIImage *)higImage;

- (void)showRightButtonWithBackgroundImage:(UIImage *)image andTitle:(NSString *)title;

- (UIButton *)getRightButtonFromRightBarButtonItem;


-(void)showrightButtonWithStatus:(BOOL)isShow;

- (void)changeRightBarButtonItemTextColor:(UIColor *)color;


- (void)rightBarButtonPressed:(id)sender;

- (void)backToPrePage;
@end








