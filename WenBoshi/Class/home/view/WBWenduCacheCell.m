//
//  WBWenduCacheCell.m
//  WenBoshi
//
//  Created by 马浩然 on 15/4/1.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBWenduCacheCell.h"
#import "WBGroupTemp.h"

@interface WBWenduCacheCell ()

@property (nonatomic ,strong) UILabel *tiemLabel;
@property (nonatomic ,strong) UILabel *durationLabel;
@property (nonatomic ,strong) UILabel *startTempLabel;
@property (nonatomic ,strong) UILabel *endTempLabel;
@property (nonatomic ,strong) UILabel *maxTempLabel;

@end

@implementation WBWenduCacheCell

+(WBWenduCacheCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    WBWenduCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WBWenduCacheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.maxTempLabel = [[UILabel alloc] init];
        self.maxTempLabel.font = [UIFont boldSystemFontOfSize:20];
        self.maxTempLabel.textColor = [UIColor orangeColor];
        self.maxTempLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.maxTempLabel];
        
        self.endTempLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.endTempLabel];
        self.endTempLabel.textColor = RGB(30, 30, 30);
        self.endTempLabel.textAlignment = NSTextAlignmentLeft;
        self.endTempLabel.font = [UIFont systemFontOfSize:15];
        
        self.startTempLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.startTempLabel];
        self.startTempLabel.textColor = RGB(30, 30, 30);
        self.startTempLabel.textAlignment = NSTextAlignmentLeft;
        self.startTempLabel.font = [UIFont systemFontOfSize:15];

        self.tiemLabel = [[UILabel alloc] init];
        self.tiemLabel.textColor = RGB(30, 30, 30);
        self.tiemLabel.font = [UIFont systemFontOfSize:15];
        self.tiemLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.tiemLabel];
        
        self.durationLabel = [[UILabel alloc] init];
        self.durationLabel.textAlignment = NSTextAlignmentRight;
        self.durationLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.durationLabel];
        
    }
    return self;
}

-(void)setTemp:(WBGroupTemp *)temp
{
    _temp = temp;
    //1.时间 label
    CGFloat dayX = 15;
    CGFloat dayY = 10;
    self.tiemLabel.text = [temp.start_time substringWithRange: NSMakeRange(5, 5)];
    CGSize daySize = KSizeFont(self.tiemLabel.text, self.tiemLabel.font);
    self.tiemLabel.frame = CGRectMake(dayX, dayY, daySize.width, daySize.height);
    
    //2.持续时间
    NSDateFormatter *fromatter = [[NSDateFormatter alloc] init];
    fromatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate = [fromatter dateFromString:temp.start_time];
    NSDate *endDate = [fromatter dateFromString:temp.end_time];
    NSTimeInterval timeInterVal = [endDate timeIntervalSinceDate:startDate];
    if (timeInterVal < 60) {
        self.durationLabel.text = [NSString stringWithFormat:@"持续%d秒",(int)timeInterVal];
    }else{
        self.durationLabel.text = [NSString stringWithFormat:@"持续%d分钟",(int)timeInterVal/60];
    }
    CGSize durationSize = KSizeFont(self.durationLabel.text, self.durationLabel.font);
    CGFloat durationX = self.frame.size.width - 15 - durationSize.width;
    self.durationLabel.frame = CGRectMake(durationX, dayY, durationSize.width, durationSize.height);
    
    //3.最大温度
    CGFloat maxTempY = daySize.height + dayY + 10;
    CGFloat maxTempW = self.frame.size.width - 2*dayX;
    CGFloat maxTempH = KHeightFont(20);
    self.maxTempLabel.frame = CGRectMake(dayX, maxTempY, maxTempW, maxTempH);
    self.maxTempLabel.text = [NSString stringWithFormat:@"最大：%.1f%@",temp.max_temp,Wendu];
    
    //4.开始温度
    CGFloat startY = maxTempH + maxTempY + 10;
    CGFloat startW = self.frame.size.width - 2*dayX;
    CGFloat startH = KHeightFont(15);
    self.endTempLabel.frame = CGRectMake(dayX, startY, startW, startH);
    self.endTempLabel.text = [NSString stringWithFormat:@"开始温度：%.1f%@",temp.start_temp,Wendu];
    
    //5.结束温度
    CGFloat endY = startY + startH + 10;
    CGFloat endW = startW;
    CGFloat endH = startH;
    self.startTempLabel.frame = CGRectMake(dayX, endY, endW, endH);
    self.startTempLabel.text = [NSString stringWithFormat:@"结束温度：%.1f%@",temp.end_temp,Wendu];

}


@end
