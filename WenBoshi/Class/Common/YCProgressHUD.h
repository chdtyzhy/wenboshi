//
//  YCProgressHUD.h
//  YCProgressHUD
//
//  Created by gongliang on 13-11-20.
//  Copyright (c) 2013年 yongche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCProgressHUD : UIView

/**
 *  显示loading View
 *
 *  @param view
 */
+ (void)showHUDAddedTo:(UIView *)view;

/**
 *  隐藏loading View
 *
 *  @param view 
 */
+ (void)hideHUDForView:(UIView *)view;

@end
