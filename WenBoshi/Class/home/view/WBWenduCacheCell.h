//
//  WBWenduCacheCell.h
//  WenBoshi
//
//  Created by 马浩然 on 15/4/1.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBGroupTemp;
@interface WBWenduCacheCell : UITableViewCell

@property (nonatomic ,strong) WBGroupTemp *temp;

+(WBWenduCacheCell *)cellWithTableView:(UITableView *)tableView;

@end
