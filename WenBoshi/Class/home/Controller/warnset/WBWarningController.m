//
//  WBWarningController.m
//  WenBoshi
//
//  Created by apple on 14/12/14.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "WBWarningController.h"
#import "WBWarningSetCell.h"
#import "CBManager.h"
#import "WBWarningDataCenter.h"

@interface WBWarningController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation WBWarningController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButtonWithTitle:@"返回"];
    [self showRightButtonWithTitle:@"确定"];
    self.title = @"警报设置";
    //背景view
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"首页背景"];
    [self.view addSubview:bgView];
    
    UITableView  *contenTableView = [[UITableView alloc]initWithFrame:CGRectMake((MainScreenWith - 293)/2, 18+64, 293, 147) style:UITableViewStylePlain];
    UIImageView *contentTableBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"警报背景"]];
    contenTableView.backgroundView = contentTableBgView;
    contenTableView.backgroundColor = [UIColor clearColor];
    contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:contenTableView];
    contenTableView.delegate = self;
    contenTableView.dataSource = self;
    contenTableView.scrollEnabled = NO;
}

- (void) backBarButtonPressed:(id)sender
{
    [self backToPrePage];
}

- (void)rightBarButtonPressed:(id)sender
{
    CGFloat margin = 2;
    WBWarningDataCenter *dataCenter = [WBWarningDataCenter shareDataCenter];
    CGFloat hightValue = dataCenter.hightTemp;
    CGFloat lowValue = dataCenter.lowTemp;
    if (lowValue + margin > hightValue) {
        UIAlertView *alertView = [[UIAlertView  alloc] initWithTitle:@"设置无效" message:@"高温值和低温值之差不能低于2℃\n是否重新设置" delegate:self cancelButtonTitle:@"不,谢谢" otherButtonTitles:@"重新设置",nil];
        [alertView show];
    }else{
    //设置高温  && 低温
    CBManager *mager = [CBManager shareManager];
    __weak typeof(mager) weakmanger = mager;
    __weak typeof(self) wself = self;
    [mager setHighTemperatureValue:hightValue andSucces:^(NSString *value) {
        [weakmanger setLowTemperautreValue:lowValue andSucces:^(NSString *value) {
            [wself hideProgressHUD];
            [wself  showToastMessage:@"设置成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:SaveHighTemperature object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:SaveLowTemperature object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:SAVESWITCHSTATUS object:nil];
            [wself backBarButtonPressed:nil];
        } andFailed:^(NSString *error, NSString *localValue) {
            [wself hideProgressHUD];
            [wself  showToastMessage:@"设置失败"];
            [wself backBarButtonPressed:nil];
        }];
    } andFailed:^(NSString *error, NSString *localValue) {
//        [wself  showToastMessage:@"设置失败"];
//        [wself backBarButtonPressed:nil];
    }];
    }
}      

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CBManager *mager = [CBManager shareManager];
    [mager Read_AlarmAndSuccess:^(NSString *value) {
        NSArray *array = [value componentsSeparatedByString:@","];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setFloat:[[array lastObject] floatValue] forKey:kWarnLowTemp];
             [defaults setFloat:[[array firstObject] floatValue] forKey:kWarnHightTemp];
             [defaults synchronize];
        
    } andFialed:^(NSString *error, NSString *localValue) {
        
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self backToPrePage];
    }
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"WBWarningSetCell";
    WBWarningSetCell *cell = [WBWarningSetCell cellWithTableView:tableView andID:ID andIndexPath:indexPath];
    cell.type = indexPath.row;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}
@end
