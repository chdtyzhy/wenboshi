//
//  UIViewController+WB.m
//  WenBoshi
//
//  Created by 马浩然 on 15/3/26.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "UIViewController+WB.h"

@implementation UIViewController (WB)
- (void)showBackButton
{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void)backBarButtonPressed:(id)sender
{
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
@end
