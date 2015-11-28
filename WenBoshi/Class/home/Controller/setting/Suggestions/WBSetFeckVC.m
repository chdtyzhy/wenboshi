//
//  WBSetFeckVC.m
//  WenBoshi
//
//  Created by 张勇 on 15/11/28.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import "WBSetFeckVC.h"
#import "UIViewController+YCCommon.h"

@interface WBSetFeckVC ()

@property (nonatomic, weak) UITextView *contentField;

@end

@implementation WBSetFeckVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    [self showRightButtonWithTitle:@"提交"];
    
    UITextView *contentField = [[UITextView alloc]init];
    self.contentField = contentField;
    [self.view addSubview:contentField];
    contentField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentField.layer.borderWidth = 1;
    self.contentField.frame =CGRectMake(0, 64, MainScreenWith, 150);
   //如果视图中加载了UIScrollview ，则添加到UIScrllview 上的视图会默认遵循UIScrollview的规则，即顶部有44高度的Header. 这样就会导致添加上的UITextView,UITextField等同样会有这种效果，导致光标位置不在顶部，而是靠下。 需要设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.contentField becomeFirstResponder];
    
}

-(void)rightBarButtonPressed:(id)sender
{
    if (self.contentField.text.length) {
        [self.contentField resignFirstResponder];
        [self showToastMessage:@"谢谢您的反馈..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

    }else{
        [self showToastMessage:@"请您写点东西吧..."];
    }
}




@end
