//
//  UIViewController+YCCommon.m
//  iWeidao
//
//  Created by yongche on 13-11-8.
//  Copyright (c) 2013年 Weidao. All rights reserved.
//

#import "UIViewController+YCCommon.h"
#import "YCProgressHUD.h"



@implementation UIViewController (YCCommon)

- (void)showProgressHUD
{
    [self hideProgressHUD];
    [YCProgressHUD showHUDAddedTo:self.view];
}
- (void)hideProgressHUD
{
    [YCProgressHUD hideHUDForView:self.view];
}

- (void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}

- (void)showBackButton
{
    UIImage *image = [UIImage imageNamed:@"common_back"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,44, 44)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void)showBackButtonWithTitle:(NSString *)title imageStr:(NSString *)imageStr
{
    UIImage *image = [UIImage imageNamed:imageStr];
    UIButton *button = [self createButtonWithTitle:@""];
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0) ;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
    
}

- (void)showBackButtonWithImage:(NSString *)imagestr
{
    UIImage *image = [UIImage imageNamed:imagestr];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)showBackButtonWithTitle:(NSString *)title
{
    UIButton *button = [self createButtonWithTitle:title];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;

}

- (void)hideBackButton
{
    UIButton *button = [self createButtonWithTitle:@""];
    button.enabled = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(backBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;
}


- (void)showDownButton{
    UIImage *image = [UIImage imageNamed:@"back"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  image.size.width,
                                                                  image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(downButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItem;

}
- (void)backToPrePage//返回上一级
{
    if ([self.navigationController.viewControllers count] >1)
    {
        [self.navigationController  popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }
}

- (void)downButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showRightButtonWithTitle:(NSString *)title
{
    UIButton *button = [self createButtonWithTitle:title];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)hideRightButton
{
    UIButton *button = [self createButtonWithTitle:@""];
    button.enabled = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)showRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)color
{
    UIButton *button = [self createButtonWithTitle:title titleColor:color];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}


- (void)showRightButtonWithImage:(UIImage *)image andHigImage:(UIImage *)higImage
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 44-image.size.width, 0, 0);
    [button setImage:image forState:UIControlStateNormal];
    if (!higImage) {
        [button setImage:image forState:UIControlStateHighlighted];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)showRightButtonWithBackgroundImage:(UIImage *)image andTitle:(NSString *)title
{
    UIButton *button = [self createButtonWithTitle:title];
    CGRect frame = button.frame;
    frame.size.width += 25;
    button.frame = frame;
    image = [image stretchableImageWithLeftCapWidth:2 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(rightBarButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (UIButton *)getRightButtonFromRightBarButtonItem{
    UIButton *rightButton = (id)self.navigationItem.rightBarButtonItem.customView;
    if ([rightButton isKindOfClass:[UIButton class]]) {
        return rightButton;
    }
    return nil;
}

-(void)showrightButtonWithStatus:(BOOL)isShow
{
    UIButton *btn = self.navigationController.navigationBar.subviews[2];
    btn.hidden= !isShow;
}


- (void)changeRightBarButtonItemTextColor:(UIColor *)color{
    UIButton *rightButton = [self getRightButtonFromRightBarButtonItem];
    [rightButton setTitleColor:color forState:UIControlStateNormal];
}


- (void)rightBarButtonPressed:(id)sender 
{
    
}

- (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)color
{
    UIButton *btn =[self createButtonWithTitle:title];
    [btn setTitleColor:color forState:UIControlStateNormal];
    return btn;
}


- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    CGSize size = [title sizeWithFont:button.titleLabel.font];
    button.frame = CGRectMake(0, 0, size.width + 20, 44);
    return button;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alert.delegate =self;
    [alert show];
    
}


@end



