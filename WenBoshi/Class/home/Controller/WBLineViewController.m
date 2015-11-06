//
//  WBLineViewController.m
//  WenBoshi
//
//  Created by 马浩然 on 15/4/10.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBLineViewController.h"
#import "JBLineChartView.h"
#import "JBChartHeaderView.h"
#import "JBLineChartFooterView.h"
#import "JBChartInformationView.h"
#import "WBTemperature.h"


CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
//NSInteger const kJBLineChartViewControllerNumChartPoints = 27;
NSInteger const kJBLineChartViewControllerMaxPointValue = 300;

// Strings
NSString * const kJBLineChartViewControllerNavButtonViewKey = @"view";


@interface WBLineViewController ()<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic ,strong) JBLineChartView *lineChartView;
@property (nonatomic ,strong) JBChartInformationView *informationView;
@property (nonatomic ,strong) NSMutableArray *chartData;
@property (nonatomic ,assign) NSInteger kJBLineChartViewControllerNumChartPoints;
@end

@implementation WBLineViewController

-(void)setGroupTemp:(WBGroupTemp *)groupTemp
{
    _groupTemp = groupTemp;
    
    for (WBTemperature *temp in groupTemp.tempAry) {
        [self.chartData addObject:@(temp.temp)];
    }
   self.kJBLineChartViewControllerNumChartPoints = self.groupTemp.tempAry.count;
}

-(NSMutableArray *)chartData
{
    if (!_chartData) {
        _chartData = [NSMutableArray array];
    }
    return _chartData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHex(0xb7e3e4);
    
    self.lineChartView = [[JBLineChartView alloc] initWithFrame:CGRectMake(kJBNumericDefaultPadding, kJBNumericDefaultPadding + 64, self.view.bounds.size.width - (kJBNumericDefaultPadding * 2), kJBLineChartViewControllerChartHeight)];
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;
    self.lineChartView.backgroundColor = UIColorFromHex(0xb7e3e4);

    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBNumericDefaultPadding * 2), kJBLineChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = @"温度表";
    headerView.titleLabel.textColor = kJBColorLineChartHeader;
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.text = @"4月5号";
    headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChartView.headerView = headerView;
    
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(kJBNumericDefaultPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBNumericDefaultPadding * 2), kJBLineChartViewControllerChartFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.leftLabel.text = [[self.groupTemp.tempAry[0] create_time] substringFromIndex:11];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[[self.groupTemp.tempAry lastObject] create_time] substringFromIndex:11];
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = self.kJBLineChartViewControllerNumChartPoints;
    self.lineChartView.footerView = footerView;

    [self.view addSubview:self.lineChartView];
    
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame)) layout:JBChartInformationViewLayoutVertical];
    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    [self.informationView setTitleTextColor:kJBColorLineChartHeader];
    [self.informationView setTextShadowColor:nil];
    [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
    [self.view addSubview:self.informationView];
    
    [self.lineChartView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.lineChartView setState:JBChartViewStateExpanded animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineChartView setState:JBChartViewStateCollapsed];
}

#pragma mark - JBLineChartViewDelegate

- (NSInteger)lineChartView:(JBLineChartView *)lineChartView heightForIndex:(NSInteger)index
{
    return [[self.chartData objectAtIndex:index] intValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectChartAtIndex:(NSInteger)index
{
    NSNumber *valueNumber = [self.chartData objectAtIndex:index];
    WBTemperature *temp =  self.groupTemp.tempAry[index];
    [self.informationView setValueText:[NSString stringWithFormat:@"%d", [valueNumber intValue]] unitText:kJBStringLabelMm];
    NSString *time = [temp.create_time substringFromIndex:11];
    [self.informationView setTitleText:time];
    [self.informationView setHidden:NO animated:YES];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didUnselectChartAtIndex:(NSInteger)index
{
    [self.informationView setHidden:YES animated:YES];
}

#pragma mark - JBLineChartViewDataSource

- (NSInteger)numberOfPointsInLineChartView:(JBLineChartView *)lineChartView
{
    return [self.chartData count];
}

- (UIColor *)lineColorForLineChartView:(JBLineChartView *)lineChartView
{
    return kJBColorLineChartLineColor;
}

- (UIColor *)selectionColorForLineChartView:(JBLineChartView *)lineChartView
{
    return [UIColor whiteColor];
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBLineChartViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    
    CGAffineTransform transform = self.lineChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform = transform;
    
    [self.lineChartView setState:self.lineChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

@end
