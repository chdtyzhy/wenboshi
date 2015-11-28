//
//  DelegateViewController.m
//
//  Created by 123 on 14-6-10.
//  Copyright (c) 2014年 123. All rights reserved.
//

#import "WBSetQuestionVC.h"

@interface WBSetQuestionVC ()

@end

@implementation WBSetQuestionVC


-(void)BackButClickedNow:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)creatHtmlView
{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.scalesPageToFit = YES;
    webView.contentMode = UIViewContentModeScaleToFill;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"question" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
}

#pragma mark
#pragma mark-----system
-(void)backButClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatHtmlView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
