//
//  WBSettingVC.m
//  WenBoshi
//
//  Created by 马浩然 on 15/3/26.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBSettingVC.h"
#import "DelegateViewController.h"

@interface WBSettingVC ()


@end

@implementation WBSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButtonWithTitle:@"返回"];
}

-(void)backBarButtonPressed:(id)sender
{
    [self backToPrePage];
}
- (IBAction)UserProtoal:(id)sender {
 
    DelegateViewController *avc=[[DelegateViewController alloc]initWithNibName:nil bundle:nil];
    avc.title = @"用户协议";
    [self.navigationController pushViewController:avc animated:YES];
    
}
@end
