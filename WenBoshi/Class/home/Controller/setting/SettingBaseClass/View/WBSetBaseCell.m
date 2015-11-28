//
//  WBSetBaseCell.m
//  WenBoshi
//
//  Created by 张勇 on 15/11/28.
//  Copyright © 2015年 luoshuisheng. All rights reserved.
//

#import "WBSetBaseCell.h"
#import "WBSetSwitchModel.h"
@interface WBSetBaseCell()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UILabel *titleLable; //文字

@property (nonatomic, weak) UIImageView *diver;

@end

@implementation WBSetBaseCell

-(void)setModel:(WBSetBaseModel *)model
{
    _model = model;
    self.titleLable.text = model.title;
    if ([model isKindOfClass:[WBSetSwitchModel class]]) {
        
    }else{
    
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
   static NSString *ID = @"WBSetBaseCell";
    WBSetBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.font = [UIFont systemFontOfSize:13];
        self.titleLable = titleLable;
        [self.contentView addSubview:titleLable];
        UIImageView *diver = [[UIImageView alloc] init];
        diver.backgroundColor = RGB(194, 194, 194);
        self.diver = diver;
        [self.contentView addSubview:diver];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLable.frame = CGRectMake(20, 10, 100, 25);
    CGFloat lineHight = 1/[UIScreen mainScreen].scale;
    self.diver.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame)- lineHight, MainScreenWith, lineHight);
}
@end
