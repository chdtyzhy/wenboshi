//
//  CBManger.h
//  蓝牙测试
//
//  Created by 张勇 on 14/12/7.
//  Copyright (c) 2014年 com.baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
//设备断开通知
static  NSString * const CBMangerDidConnetedNoti = @"CBMangerDidConnetedNoti";

//蓝牙状态
typedef enum : NSUInteger {
    kCBStateOpen,
    kCBStateClose,
    kCBStateUnkown,
} CBState;
@class CBManager;

@protocol  CBMangerDelegate<NSObject>
@optional
//判断蓝牙是否打开
-(void)CBMangerDelegateWithManger:(CBManager*)manger andState:(CBState)states;
//获取蓝牙设备名称和信号强度
-(void)CBMangerDelegateWithManger:(CBManager *)manger andDeviceName:(NSString*)name andRSSI:(NSNumber*)rssi andUUID:(NSString*)uid;
//获取设备传送回来的温度数据
-(void)CBManagerDelegateWithManger:(CBManager*)manger andTemperature:(NSString*)temp andBat:(NSString*)V;


@end



@interface CBManager : NSObject

//代理方法
@property (nonatomic,weak)id<CBMangerDelegate>delegate;

/***
 * 是否正在采集
 */
@property (nonatomic, assign,readonly) BOOL isCaputering;

@property (nonatomic,assign,readonly) CGFloat distance;
/**
 * 是否连接
 */
@property (nonatomic, assign, readonly) BOOL isConnected;
//单利
+(instancetype)shareManager;

//扫描
-(void)startScanWithSucces:(void(^)(NSString*DeviceValue))Succes andFail:(void(^)(NSString*errorStr,NSString *localValue))failure;
//连接
-(void)connectDevice;
//断开
-(void)disConnectDevice;
//开始采集
-(void)startCaputerWithSucces:(void(^)(NSString*DeviceValue))Succes andFail:(void(^)(NSString*errorStr,NSString *localValue))failure;
//停止采集
-(void)stopCaputerWithSucces:(void(^)(NSString*DeviceValue))Succes andFail:(void(^)(NSString*errorStr,NSString *localValue))failure;
//读取温度校准值
-(void)readCalibrationValueWithSucces:(void(^)(NSString*DeviceValue))Succes andFail:(void(^)(NSString*errorStr,NSString *localValue))failure;
//读取版本号
-(void)readVerWithSuccess:(void(^)(NSString *DeviceValue))success andFail:(void(^)(NSString*errorStr,NSString *localValue))failure;
//发送温度校准值
-(void)setCalibbrationValue:(NSString*)value andSucces:(void(^)(NSString*DeviceValue))success andFail:(void(^)(NSString*errorStr,NSString *localValue))failure;
// 发送“Set_Addr:xxxx-Temp”,进行设置地址(蓝牙地址),返回“OK”,重新开机生效。
//查询蓝牙时为该设置地址,设置范围:0000-9999,默认”0000-Temp”
-(void)setAddr:(unsigned int)addr andSucces:(void(^)(NSString *DeviceValue))success andFail:(void(^)(NSString*errorStr,NSString *localValue))failure;

@end
