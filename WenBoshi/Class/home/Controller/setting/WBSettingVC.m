//
//  WBSettingVC.m
//  WenBoshi
//
//  Created by 马浩然 on 15/3/26.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBSettingVC.h"
#import "WBSetBaseModel.h"
#import "WBSetSwitchModel.h"
#import "DelegateViewController.h"
#import "WBSetQuestionVC.h"
#import "WBSetFeckVC.h"
#import "WBSetGroup.h"

@interface WBSettingVC ()


@end

@implementation WBSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showBackButtonWithTitle:@"返回"];
    
    WBSetBaseModel *firstModel = [WBSetBaseModel modelWithTitle:@"常见问题" andDesVC:[WBSetQuestionVC class]];
    WBSetBaseModel *secondModel = [WBSetBaseModel modelWithTitle:@"意见反馈" andDesVC:[WBSetFeckVC class]];
    WBSetBaseModel *threeModel = [WBSetBaseModel modelWithTitle:@"用户协议" andDesVC:[DelegateViewController class]];
    WBSetGroup *group = [WBSetGroup  group];
    group.items = @[firstModel,secondModel,threeModel];
    self.groups = @[group];

}

-(void)backBarButtonPressed:(id)sender
{
    [self backToPrePage];
}
- (void)UserProtoal:(id)sender {
     DelegateViewController *avc=[[DelegateViewController alloc]initWithNibName:nil bundle:nil];
    avc.title = @"用户协议";
    [self.navigationController pushViewController:avc animated:YES];
}
@end
