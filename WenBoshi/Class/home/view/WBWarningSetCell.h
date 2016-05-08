//
//  WBWarningSetCell.h
//  WenBoshi
//
//  Created by 张勇 on 15/11/21.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBaseTableViewCell.h"

static NSString *const SaveHighTemperature = @"SaveHighTemperature";
static NSString *const SaveLowTemperature = @"SaveLowTemperature";
static NSString *const SAVESWITCHSTATUS = @"SAVESWITCHSTATUS";

typedef enum : NSUInteger {
    kCellTypeSwitch = 0,
    kCellTypeHight,
    kCellTypeLow
} cellType;

@interface WBWarningSetCell : WBaseTableViewCell

@property (nonatomic, assign) cellType  type;

@end
