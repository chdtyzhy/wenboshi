//
//  WBHomeController.m
//  WenBoshi
//
//  Created by apple on 14/12/13.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "WBHomeController.h"
#import "WBWarningController.h"
#import "WBAdjustController.h"
#import "WBHeaderView.h"
#import "WBWarningImageView.h"
#import "YCHomeBtn.h"
#import "WBNavigationController.h"
#import "MJAudioTool.h"
#import "WBZhushouVC.h"
#import "WBWenduCaseVC.h"
#import "WBSettingVC.h"
#import "WBCacheTool.h"
#import "WBTemperature.h"

@interface WBHomeController () <CBMangerDelegate,WBCehuaDelegate>
@property (nonatomic ,weak) WBHeaderView *headerView;

@property (nonatomic ,weak) WBWarningImageView *warningImageView;
/** 温度label*/
@property (nonatomic ,weak) UILabel *wenduLabel;
@property (nonatomic ,weak) WBCehuaView *cehuaView;
@property (nonatomic ,weak) UILabel *timeLabel;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) long long timeInt;
@property (nonatomic ,strong) CBManager *manger;
/** 温度*/
@property (nonatomic ,assign) CGFloat temp;
/** tempID*/
@property (nonatomic ,assign) int tempID;
@end

@implementation WBHomeController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:kWarnSwitchState]) {
        self.warningImageView.hidden = NO;
        NSString *warnTemp = [NSString stringWithFormat:@"%.1f℃", [defaults floatForKey:kWarnTemp]];
        self.warningImageView.numberLabel.text = warnTemp;
    }else
    {
        self.warningImageView.hidden = YES;
    }
    
    //判断是否正在采集
    if (!self.manger.isCaputering && self.manger.isConnected) {
        [self startCaiji];
    }else  if(!self.manger.isConnected){
        [self startScan];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showTitle:@"获取信息"];
    self.manger = [AppDelegate shareDelegate].manger;
    self.manger.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftBarBtnClick) name:@"leftBarBtnClick" object:nil];
    [self createView];
}
-(void)createView
{
    //1
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.view.frame;
    imageView.image = [UIImage imageNamed:@"首页背景"];
    [self.view addSubview:imageView];
    //2
    WBHeaderView *headerView = [[WBHeaderView alloc] init];
    self.headerView = headerView;
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [self.view addSubview:headerView];
    //3
    WBWarningImageView *warningImageView = [[WBWarningImageView alloc] init];
    self.warningImageView = warningImageView;
    warningImageView.image = [UIImage imageNamed:@"警报背景"];
    warningImageView.numberLabel.text = [@"30" stringByAppendingString:Wendu];
    warningImageView.frame = CGRectMake(self.view.frame.size.width - 13 - 135, 64, 135, 40);
    [self.view addSubview:warningImageView];
    //4
    UIImageView *circleView = [[UIImageView alloc] init];
    circleView.image = [UIImage imageNamed:@"圈"];
    CGFloat circleW = 270;
    CGFloat circleH = 250;
    CGFloat circleX = (self.view.frame.size.width - circleW)/2;
    CGFloat circleY = 110;
    circleView.frame = CGRectMake(circleX, circleY, circleW, circleH);
    [self.view addSubview:circleView];
    //5
    UILabel *wenduLabel = [[UILabel alloc] init];
    self.wenduLabel = wenduLabel;
    wenduLabel.font = [UIFont systemFontOfSize:45];
    wenduLabel.textColor = RGB(118, 100, 86);
    NSString *wendustr = [@"0" stringByAppendingString:Wendu2];
    wenduLabel.text = wendustr;
    
    wenduLabel.textAlignment = NSTextAlignmentCenter;
    CGSize wenduSize = KSizeFont(wendustr, wenduLabel.font);
    CGFloat wenduY = 240;
    self.wenduLabel.frame = CGRectMake(20, wenduY, self.view.frame.size.width-20, wenduSize.height);
    [self.view addSubview:wenduLabel];
    //6
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stopBtn = stopBtn;
    [stopBtn setTitle:@"开始" forState:UIControlStateNormal];
    stopBtn.backgroundColor = RGB(208, 86, 89);
    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat stopW = 95;
    CGFloat stopH = 37;
    stopBtn.layer.cornerRadius = stopH/2;
    stopBtn.layer.masksToBounds = YES;
    stopBtn.bounds = CGRectMake(0, 0, stopW, stopH);
    stopBtn.center = CGPointMake(self.view.frame.size.width/2, CGRectGetMaxY(wenduLabel.frame) + 30);
    [stopBtn addTarget:self action:@selector(stopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    //7
    CGFloat bottomBtnMaxY = [self addbttomBtn];
    //8.
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    [self.view addSubview:timeLabel];
    timeLabel.layer.cornerRadius = 5;
    timeLabel.layer.masksToBounds = YES;
    timeLabel.backgroundColor = RGB(236, 73, 73);
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:25];
    self.timeLabel.hidden = YES;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.frame = CGRectMake((self.view.frame.size.width - 174)/2, bottomBtnMaxY + 10, 174, 39);
    //9
    WBCehuaView *cehuaView = [[WBCehuaView alloc] init];
    self.cehuaView = cehuaView;
    cehuaView.hidden = YES;
    cehuaView.alpha = 0;
    cehuaView.delegate = self;
    cehuaView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:cehuaView];
}

-(CGFloat)addbttomBtn
{
    CGFloat interval = 27;
    CGFloat btnH = 65;
    CGFloat btnW = 45;
    CGFloat btnY = CGRectGetMaxY(self.stopBtn.frame) +25;
    CGFloat btnX = 0;
    CGFloat btnInterValX = (self.view.frame.size.width - btnW * 3 - interval * 2)/2;
    
    //记录温度
    YCHomeBtn *recordTempbtn = [YCHomeBtn buttonWithType:UIButtonTypeCustom];
    btnX = btnInterValX +(btnW + interval)*0;
    [recordTempbtn addTarget:self action:@selector(recordTempbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    recordTempbtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [recordTempbtn setImage:[UIImage imageNamed:@"recordTemp"] forState:UIControlStateNormal];
    [recordTempbtn setTitle:@"记录温度" forState:UIControlStateNormal];
    [self.view addSubview:recordTempbtn];
    
    //警报设置
    YCHomeBtn *warnSetBtn = [YCHomeBtn buttonWithType:UIButtonTypeCustom];
    btnX = btnInterValX +(btnW + interval)*1;
    [warnSetBtn addTarget:self action:@selector(warnSetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         warnSetBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [warnSetBtn setImage:[UIImage imageNamed:@"warnSetBtn"] forState:UIControlStateNormal];
    [warnSetBtn setTitle:@"警报设置" forState:UIControlStateNormal];
    [self.view addSubview:warnSetBtn];
    
    //偏差调整"
    YCHomeBtn *adjustSetBtn = [YCHomeBtn buttonWithType:UIButtonTypeCustom];
    btnX = btnInterValX +(btnW + interval)*2;
    [adjustSetBtn addTarget:self action:@selector(adjustSetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    adjustSetBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [adjustSetBtn setImage:[UIImage imageNamed:@"adjustSet"] forState:UIControlStateNormal];
    [adjustSetBtn setTitle:@"偏差调整" forState:UIControlStateNormal];
    [self.view addSubview:adjustSetBtn];

    return btnH + btnY;
}

-(void)startScan
{
    if (self.manger.isConnected) {
        [self startCaiji];
    }else{
        [self showToastMessage:@"连接设备中"];
        __weak typeof(self)weakSelf = self;
        [self.manger startScanWithSucces:^(NSString *isSucess) {
            [weakSelf startCaiji];
        } andFail:^(NSString *errorStr, NSString *localValue) {
            [weakSelf showToastMessage:errorStr];
        }];
    }
}
//开始采集温度
-(void)startCaiji
{
    [MBProgressHUD showMessage:@"开始采集"];
    __weak typeof(self)weakSelf = self;
    [self.manger startCaputerWithSucces:^(NSString *DeviceValue) {
        [MBProgressHUD hideHUD];
        [weakSelf.stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [weakSelf showToastMessage:@"采集成功"];
        
    } andFail:^(NSString *errorStr, NSString *localValue) {
        [MBProgressHUD hideHUD];
        [weakSelf showToastMessage:errorStr];
    }];
}

-(void)leftBarBtnClick
{
    [UIView animateWithDuration:0.5 animations:^{
        self.cehuaView.hidden = NO;
        self.cehuaView.alpha = 1;
    }];
}

// 记录温度点击事件
-(void)recordTempbtnClick:(YCHomeBtn *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"记录温度"]) {
        if (!self.manger.isCaputering) {
            [self showToastMessage:@"请先连接设备"];
            return;
        }
        [btn setTitle:@"停止记录" forState:UIControlStateNormal];
        self.timeLabel.hidden = NO;
        NSArray *array =  [WBCacheTool temperatureCounts];
        NSNumber *max = [array lastObject];
        self.tempID =  [max intValue]+ 1;
        NSTimer *showTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
        self.timer = showTimer;
        [showTimer fire];
        
    }else{// 停止记录
        [btn setTitle:@"记录温度" forState:UIControlStateNormal];
        self.tempID = 0;
        [self.timer invalidate];
        self.timeLabel.text = @"00 ：00 ：00";
        self.timeLabel.hidden = YES;
        self.timeInt = 0;
    }
}

//警报设置 点击
- (void)warnSetBtnClick:(YCHomeBtn *)btn
{
    WBWarningController *controller = [[WBWarningController alloc] init];
    WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

//偏差调整 点击
-(void)adjustSetBtnClick:(YCHomeBtn *)btn
{
    [MBProgressHUD showMessage:@"停止采集"];
    __weak typeof(self)weakSelf = self;
    [self.manger stopCaputerWithSucces:^(NSString *DeviceValue) {
        [MBProgressHUD hideHUD];
        [weakSelf.stopBtn setTitle:@"开始" forState:UIControlStateNormal];
        WBAdjustController *controller = [[WBAdjustController alloc] init];
        WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
        
    } andFail:^(NSString *errorStr, NSString *localValue) {
        [MBProgressHUD hideHUD];
        [weakSelf showToastMessage:errorStr];
    }];
}


-(void)changeTimeLabel
{
    if (!(self.timeInt % 5)) {
        NSDate *now = [NSDate date];
        NSDateFormatter *time = [[NSDateFormatter alloc] init];
        time.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *timeStr = [time stringFromDate:now];
        
        WBTemperature *temp = [[WBTemperature alloc] init];
        temp.create_time = timeStr;
        temp.tempID = self.tempID;
        temp.temp = self.temp ;
        [WBCacheTool addTemperature:temp];
    }
    self.timeInt ++;
    int h = (int)self.timeInt/3600;
    int m = self.timeInt/60%60;
    int s = self.timeInt%60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d : %02d : %02d",h,m,s];
}

/** ---stop-btn点击--*/
-(void)stopBtnClick
{
    if ([self.stopBtn.titleLabel.text isEqualToString:@"开始"]) {
        [self startScan];
    }else{
    //停止采集
        [MBProgressHUD showMessage:@"停止采集"];
        __weak typeof(self)weakSelf = self;
        [self.manger stopCaputerWithSucces:^(NSString *value) {
            [MBProgressHUD hideHUD];
            [self.stopBtn setTitle:@"开始" forState:UIControlStateNormal];
            [weakSelf showToastMessage:value];
        } andFail:^(NSString *errorStr, NSString *localValue) {
            [MBProgressHUD hideHUD];
            [weakSelf showToastMessage:errorStr];
        }];
    }
}

-(void)CBMangerDelegateWithManger:(CBManager *)manger andState:(CBState)states
{
    NSLog(@"---蓝牙状态变了---");
    if (states == kCBStateOpen) {
        [self showToastMessage:@"开始数据采集"];
        [self startCaiji];
    }else{
        [self showToastMessage:@"停止数据采集"];
        [self.manger stopCaputerWithSucces:^(NSString *value) {
            
        } andFail:^(NSString *errorStr, NSString *localValue) {
            
        }];
    }
}
-(void)CBMangerDelegateWithManger:(CBManager *)manger andDeviceName:(NSString*)name andRSSI:(NSNumber*)rssi andUUID:(NSString*)uid
{
    [self.manger  connectDevice];
}
//获取温度
-(void)CBManagerDelegateWithManger:(CBManager *)manger andTemperature:(NSString *)temp andBat:(NSString *)V
{
    self.wenduLabel.text = [temp stringByAppendingString:Wendu2];
    self.temp = [temp floatValue];
    if (!self.warningImageView.hidden) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:kWarnSwitchState]) {
            if ([temp floatValue]>[defaults floatForKey:kWarnTemp] ) {
                [MJAudioTool playSound:@"alarm.mp3" andRepeat:YES];
            }else{
                NSLog(@"停止警告");
                [MJAudioTool disposeSound:@"alarm.mp3"];
            }
        }
    }        
}
-(void)CBMangerDidContentSuccess
{
    [MBProgressHUD showTitle:@"获取数据"];
}
-(void)cehuaBtnClick:(int)tag
{
    if (tag == WBCehuaCase){
        WBWenduCaseVC *vc = [[WBWenduCaseVC alloc]init];
        WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:vc];
        vc.title = @"温度记录";
        [self presentViewController:nav animated:YES completion:nil];
    }else{
//        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        WBSettingVC *vc = [main instantiateViewControllerWithIdentifier:@"WBSettingVC"];
        WBSettingVC  *vc = [[WBSettingVC alloc]init];
        WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:vc];
        vc.title = @"设置";
        [self presentViewController:nav animated:YES completion:nil];
    }
}


@end
