//
//  WBWenduCaseVC.m
//  WenBoshi
//
//  Created by 马浩然 on 15/3/26.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBWenduCaseVC.h"
#import "WBCacheTool.h"
#import "WBGroupTemp.h"
#import "WBTemperature.h"
#import "WBWenduCacheCell.h"
#import "WBLineViewController.h"

@interface WBWenduCaseVC ()

@property (nonatomic ,strong) NSMutableArray *tempAry;

@end

@implementation WBWenduCaseVC

-(NSMutableArray *)tempAry
{
    if (!_tempAry) {
        _tempAry = [NSMutableArray array];
    }
    return _tempAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButtonWithTitle:@"返回"];
    [self showRightButtonWithTitle:@"清空"];
    NSArray *array = [WBCacheTool temperatureCounts];
    for (int index = 0; index <array.count; index ++) {
        WBGroupTemp *temp = [[WBGroupTemp alloc] init];
        
        NSNumber *OCtempID =array[index];
        int tempID = [OCtempID intValue];
        temp.max_temp = [WBCacheTool getMaxTemp:tempID];
        temp.min_temp = [WBCacheTool getMinTemp:tempID];
        temp.tempAry = [WBCacheTool getTemperature:tempID];
        WBTemperature *fistTemp = temp.tempAry[0];
        WBTemperature *endTemp = [temp.tempAry lastObject];
        temp.start_time = fistTemp.create_time;
        temp.end_time = endTemp.create_time;
        temp.start_temp = fistTemp.temp;
        temp.end_temp = endTemp.temp;
        temp.tempID = tempID;
        [self.tempAry addObject:temp];
    }
    [self.tableView reloadData];
}

- (void)backBarButtonPressed:(id)sender
{
    [self backToPrePage];
}

- (void)rightBarButtonPressed:(id)sender
{
    [WBCacheTool deleteAllTemp];
    [self.tempAry removeAllObjects];
    [self.tableView reloadData];
    [self showToastMessage:@"清除成功"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBWenduCacheCell *cell = [WBWenduCacheCell cellWithTableView:tableView];
    if (self.tempAry&&self.tempAry.count>indexPath.row) {
        cell.temp = self.tempAry[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1.删除数据
       
        WBGroupTemp  *groupTemp = self.tempAry[indexPath.row];
        [WBCacheTool deleteTemp:groupTemp.tempID];
         [self.tempAry removeObjectAtIndex:indexPath.row];
        //2.清理数据库
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBLineViewController *controller = [[WBLineViewController alloc] init];
    controller.groupTemp = self.tempAry[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}




@end
