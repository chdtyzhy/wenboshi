//
//  WBSetBaseCell.h
//  WenBoshi
//
//  Created by 张勇 on 15/11/28.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSetBaseModel.h"



@interface WBSetBaseCell : UITableViewCell


@property (nonatomic, strong) WBSetBaseModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
