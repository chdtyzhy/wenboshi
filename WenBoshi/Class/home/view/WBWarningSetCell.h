//
//  WBWarningSetCell.h
//  WenBoshi
//
//  Created by 张勇 on 15/11/21.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const SAVEWARNDATA = @"SAVEWARNDATA";
static NSString *const SAVESWITCHSTATUS = @"SAVESWITCHSTATUS";

typedef enum : NSUInteger {
    kCellTypeSwitch,
    kCellTypeSlider,
} cellType;

@interface WBWarningSetCell : UITableViewCell

@property (nonatomic, assign) cellType  type;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
