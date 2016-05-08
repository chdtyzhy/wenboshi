//
//  WBaseTableViewCell.m
//  WenBoshi
//
//  Created by 张勇 on 16/4/17.
//  Copyright © 2016年 luoshuisheng. All rights reserved.
//

#import "WBaseTableViewCell.h"

@interface WBaseTableViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;

//
@property (nonatomic, weak)  UITableView  *tableView;

@end

@implementation WBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView andID:(NSString *)ID andIndexPath:(NSIndexPath *)indexPath
{
    WBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.tableView = tableView;
        cell.indexPath = indexPath;
    }
    return cell;
}

- (BOOL)isFirstRow
{
    if (self.indexPath) {
        if (self.indexPath.row == 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isLastRow
{
    NSInteger  row = [_tableView numberOfRowsInSection:self.indexPath.section];
    if (row-1 == self.indexPath.row) {
        return YES;
    }
    return NO;
}

@end
