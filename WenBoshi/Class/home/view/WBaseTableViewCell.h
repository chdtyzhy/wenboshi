//
//  WBaseTableViewCell.h
//  WenBoshi
//
//  Created by 张勇 on 16/4/17.
//  Copyright © 2016年 luoshuisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBaseTableViewCell : UITableViewCell


- (BOOL)isFirstRow;

- (BOOL)isLastRow;

+(instancetype)cellWithTableView:(UITableView *)tableView andID:(NSString *)ID andIndexPath:(NSIndexPath *)indexPath;


@end
