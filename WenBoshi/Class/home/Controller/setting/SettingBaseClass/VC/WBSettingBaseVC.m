//
//  WBSettingBaseVC.m
//  WenBoshi
//
//  Created by 张勇 on 15/11/28.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import "WBSettingBaseVC.h"
#import "WBSetGroup.h"
#import "WBSetBaseCell.h"
#import "WBSetBaseModel.h"

@interface WBSettingBaseVC ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) UITableView  *baseView;

@end

@implementation WBSettingBaseVC

-(NSArray *)groups
{
    if (_groups == nil) {
        _groups = [NSArray array];
    }
    return _groups;
}

-(UITableView *)baseView
{
    if (_baseView == nil) {
        UITableView *baseView = [[UITableView  alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _baseView = baseView;
        _baseView.rowHeight = 45;
        _baseView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseView.delegate = self;
        _baseView.dataSource = self;
        _baseView.scrollEnabled = NO;
        [self.view addSubview:_baseView];
    }
    return _baseView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.baseView) {
        [self.baseView reloadData];
    }

}


#pragma mark ------ tableview ----delegate  && datasource--------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WBSetGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBSetBaseCell *cell = [WBSetBaseCell cellWithTableView:tableView];
    WBSetGroup *group = self.groups[indexPath.section];
    if (group.items && group.items.count > indexPath.row) {
        WBSetBaseModel *model = group.items[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:NO];
    WBSetGroup *group = self.groups[indexPath.section];
    WBSetBaseModel *model = group.items[indexPath.row];
    if (model.destClass) {
        UIViewController *destVc = [[model.destClass alloc] init];
        destVc.title = model.title;
    [self.navigationController pushViewController:destVc animated:YES];
    }
}
@end
