//
//  WBLinkController.m
//  WenBoshi
//
//  Created by apple on 14/12/13.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "WBLinkController.h"
#import "WBHomeController.h"
#import "WBHeaderView.h"
#import "MBProgressHUD+MJ.h"

@interface WBLinkController ()<CBMangerDelegate>

@property (nonatomic ,weak) WBHeaderView *headerView;

@property (nonatomic ,weak) UIImageView *backImageView;

@property (nonatomic ,weak) UIButton *startBtn;

@property (nonatomic ,weak) UILabel *titleLabel;

@property (nonatomic ,weak) UILabel *stateLabel;

@property (nonatomic ,strong) CBManager *manger;
@end

@implementation WBLinkController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    self.backImageView = imageView;
    imageView.image = [UIImage imageNamed:@"首页背景"];
    imageView.frame = self.view.frame;
    [self.view addSubview:imageView];
    
    //1.headerView
    WBHeaderView *headerView  = [[WBHeaderView alloc] init];
    self.headerView = headerView;
    headerView.titleLabel.text = @"测量体温";
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
 
    //2.title
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    CGFloat titleW = 100;
    titleLabel.frame = CGRectMake((self.view.frame.size.width - titleW)/2, 64+40, titleW, 30);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"已保存本次记录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor  = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:titleLabel];
    
    //3.btn
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setImage:[UIImage imageNamed:@"开始-未点击"] forState:UIControlStateNormal];
    [startBtn setImage:[UIImage imageNamed:@"开始-点击"] forState:UIControlStateHighlighted];
    CGFloat startBtnWH = 194;
    CGFloat startBtnX = (self.view.frame.size.width - startBtnWH)/2;
    CGFloat startBtnY = CGRectGetMaxY(titleLabel.frame) + 40;
    startBtn.frame = CGRectMake(startBtnX, startBtnY, startBtnWH, startBtnWH);
    self.startBtn = startBtn;
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    //4.底部label
    UILabel *stateLabel = [[UILabel alloc] init];
    self.stateLabel = stateLabel;
    stateLabel.font = [UIFont systemFontOfSize:14];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat stateLabelX = 0;
    CGFloat stateLabelY = CGRectGetMaxY(startBtn.frame) + 24;
    CGFloat stateLabeLW = self.view.frame.size.width;
    CGFloat stateLabelH = 30;
    stateLabel.textColor = RGB(88, 72,59);
    self.stateLabel.frame = CGRectMake(stateLabelX, stateLabelY, stateLabeLW, stateLabelH);
    self.stateLabel.text = @"打开硬件设备开关，点开始";
    [self.view addSubview:stateLabel];
 
    self.manger = [AppDelegate shareDelegate].manger;
    self.manger.delegate = self;
    
}


-(void)startBtnClick
{
//    if (!self.manger.isConnected) {
    WBHomeController *homeController = [[WBHomeController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = homeController;
    
//        [MBProgressHUD showMessage:@"开始连接设备"];
//        [self.manger startScan];
//    }else{

}
//-(void)CBMangerDelegateWithManger:(CBManager *)manger andDeviceName:(NSString*)name andRSSI:(NSNumber*)rssi andUUID:(NSString*)uid
//{
//    [MBProgressHUD hideHUD];
//    [MBProgressHUD showSuccess:@"连接成功"];
//    [self.manger  connectDevice];
//}

@end
