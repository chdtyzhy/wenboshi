//
//  WBWarningController.m
//  WenBoshi
//
//  Created by apple on 14/12/14.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "WBWarningController.h"
#import "WBWarningSetCell.h"

@interface WBWarningController ()<UITableViewDataSource,UITableViewDelegate>

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
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVEWARNDATA object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SAVESWITCHSTATUS object:nil];
    [self backBarButtonPressed:nil];
}



#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBWarningSetCell *cell = [WBWarningSetCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.type = kCellTypeSwitch;
    }else{
        cell.type = kCellTypeSlider;
    }
       return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}
@end
