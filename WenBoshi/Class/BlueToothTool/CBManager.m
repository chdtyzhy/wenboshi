
//
//  CBManger.m
//  蓝牙测试
//
//  Created by 张勇 on 14/12/7.
//  Copyright (c) 2014年 com.baidu. All rights reserved.
//

#import "CBManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define plistPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CBMangerData.plist"] 


/**
 *   命令
 *
 */
static NSString  * const  OK = @"OK";

static NSString  * const  SendOFF = @"Set_Send:OFF";

static NSString  * const  SendON  = @"Set_Send:ON";

static NSString  * const  ReadVER = @"Read_VER";

static NSString  * const  ReadAdjust = @"Read_Adjust";

static NSString  * const  AdjustKey = @"Adjust";

static NSString  * const  VERKey   = @"VER";

static NSString  * const  SetAdjust = @"Set_Adjust:";

   static NSString* const strOC = @"oC";

static NSString  * const  Set_Addr = @"Set_Addr:";

static NSString  * const  Set_AlarmHi = @"Set_AlarmHi:";  //高温设置

static NSString  * const  Set_AlarmLo = @"Set_AlarmLo:";  //低温设置

static NSString  * const  Read_Alarm  = @"Read_Alarm";    //读取警报值

static NSString  * const  AlarmLo     = @"AlarmLo:";

static NSString  * const  AlarmHi     = @"AlarmHi:";

static NSString  * const  TEMP = @"-Temp";
//:xxxx-Temp

static NSString  * const  errorStr = @"请先停止温度采集";

static NSString  * const  errorValueInvaild = @"设置值无效";

static NSString  * const  timeOut =  @"响应超时,请稍后重新连接";
/**********************/
static int   const num = 4;
/****
 *  定时间隔
 **/
static CGFloat timeInterval = 2.0;
static int   const MaxNum = 5;
/****************/

typedef void(^success)(NSString*DeviceValue);
typedef void(^failure)(NSString*errorStr,NSString *localValue);

@interface CBManager()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager  *manager;

@property (nonatomic, strong)CBPeripheral      *peripheral;

@property (nonatomic, strong)CBCharacteristic  *FAF1Characteristic;

@property (nonatomic, assign) int  oldRSSI;

@property (nonatomic, assign) CGFloat oldDistance;

@property (nonatomic, copy) NSMutableString *tempStr;

@property (nonatomic, strong) NSTimer *timer;

//@property (nonatomic, copy) completion completion;

@property (nonatomic, copy) success   success;

@property (nonatomic, copy) failure   failure;

@property (nonatomic, assign) int TotalNum;

/**
 * 发送命令
 */
@property (nonatomic, copy) NSString *sendStr;



@end

@implementation CBManager

-(NSMutableString*)tempStr
{
    if (_tempStr==nil) {
        _tempStr = [NSMutableString string];
    }
    return _tempStr;
}

+(instancetype)shareManager
{
    static  CBManager *temp=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      temp=[[self alloc] init];
      [temp createPlist];
    });
    return temp;
}

-(void)setTimer:(NSTimer *)timer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = timer;
}
-(void)createPlist
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(0),AdjustKey,@"Ver-1.1",VERKey, nil];
    [dic writeToFile:plistPath atomically:YES];
}
/**
 开始扫描
 */
-(void)startScanWithSucces:(void (^)(NSString *))Succes andFail:(void (^)(NSString *, NSString *))failure
{
    
    self.success = Succes;
    self.failure = failure;
//    NSLog(@"正在扫描外设...");
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    double delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.manager stopScan];
        if (!_isConnected) {
            if (self.failure) {
                self.failure(@"连接失败,请检查硬件是否打开",nil);
            }
        }
       
    });
}
/**连接*/
-(void)connectDevice
{
  [self.manager connectPeripheral:_peripheral options:nil];
}
/**断开连接*/
-(void)disConnectDevice
{
    NSLog(@"断开连接－－－");
    _isConnected = NO;
    if (_peripheral == nil) return;
   [self.manager cancelPeripheralConnection:_peripheral];
    [self.timer invalidate];
    self.timer = nil;
}
/**停止采集*/
-(void)stopCaputerWithSucces:(void (^)(NSString *))Succes andFail:(void (^)(NSString *, NSString *))failure
{
    _success = Succes;
    _failure = failure;
    self.sendStr = SendOFF;
    self.TotalNum = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(setOpertionWithTimer) userInfo:nil repeats:YES];
    [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

/**开始采集*/
-(void)startCaputerWithSucces:(void (^)(NSString *))Succes andFail:(void (^)(NSString *, NSString *))failure{
    _isConnected = YES;
    self.success = Succes;
    self.failure = failure;
    self.sendStr = SendON;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (_FAF1Characteristic) {
       [_peripheral setNotifyValue:YES forCharacteristic:_FAF1Characteristic];
    }
    self.TotalNum = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(setOpertionWithTimer) userInfo:nil repeats:YES];
    [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];

}
/**读取温度校准值*/
-(void)readCalibrationValueWithSucces:(void (^)(NSString *))Succes andFail:(void (^)(NSString *, NSString *))failure
{
    _isConnected = YES;
    self.success  = Succes;
    self.failure = failure;
    if (self.isCaputering) {
        if (self.failure) {
            NSString*errorStr = @"请先停止温度采集";
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
            NSString *value = [dic objectForKey:AdjustKey];
            self.failure(errorStr,value);
        }
    }else{
        if (_FAF1Characteristic) {
             [_peripheral setNotifyValue:YES forCharacteristic:_FAF1Characteristic];
        }
    self.TotalNum = 0;
    self.sendStr = ReadAdjust;
     self.timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(setOpertionWithTimer) userInfo:nil repeats:YES];
   [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

/**读取系统的版本号*/
-(void)readVerWithSuccess:(success)success andFail:(failure)failure
{
    _success = success;
    _failure = failure;
    self.sendStr = ReadVER;
    if (_FAF1Characteristic) {
        [_peripheral setNotifyValue:YES forCharacteristic:_FAF1Characteristic];
 
    }
    self.TotalNum = 0;
       self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(setOpertionWithTimer) userInfo:nil repeats:YES];
    [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

-(void)setSuccess:(success)success
{
    if (_success) {
        _success = nil;
    }
    _success = success;
}
-(void)setFailure:(failure)failure
{
    if (_failure) {
        _failure =nil;
    }
    _failure = failure;
}
#pragma mark  设置温度校准值
-(void)setCalibbrationValue:(NSString*)value andSucces:(success)success andFail:(failure)failure
{
    //设置温度校准值之前，一定要关闭采集
    self.success = success;
    self.failure = failure;
    if (self.isCaputering) {//没有关闭采集
        if (self.failure) {
            self.failure(errorStr,nil);
        }
    }else{//关闭采集
        NSString *s =[SetAdjust stringByAppendingString:value];
        self.sendStr = [s stringByAppendingString:strOC];
        if (_FAF1Characteristic) {
           [_peripheral setNotifyValue:YES forCharacteristic:_FAF1Characteristic];
        }
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.TotalNum = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(setOpertionWithTimer) userInfo:nil repeats:YES];
        [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark 设置高温 
- (void)setHighTemperatureValue:(CGFloat)hightValue andSucces:(successTask)success andFailed:(failTask)fail;
{
    self.success = success;
    self.failure = fail;
    NSString *hightTempValue = [self formatTempData:hightValue];

    if (self.isCaputering ||! _isConnected) {//没有关闭采集
        if (self.failure) {
            self.failure(errorStr,nil);
        }
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self setAlartHiTask:hightTempValue];
}


- (void)setAlartHiTask:(NSString *)hightValue
{
    if (hightValue && [hightValue isKindOfClass:NSString.class] && hightValue.length) {
        NSString *s =[Set_AlarmHi stringByAppendingString:hightValue];
        self.sendStr = [s stringByAppendingString:strOC];
        self.TotalNum = 0;
        [self setOpertion:self.sendStr];
    }
}

#pragma mark --- 低温设置
- (void)setLowTemperautreValue:(CGFloat)lowValue andSucces:(successTask)success andFailed:(failTask)fail{

    self.success = success;
    self.failure = fail;
    NSString *hightTempValue = [self formatTempData:lowValue];
    NSLog(@"LowTemperautreValue = %@,",hightTempValue);
    if (self.isCaputering ||! _isConnected) {//没有关闭采集
        if (self.failure) {
            self.failure(errorStr,nil);
        }
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self setAlarmLoTask:hightTempValue];
}


- (void)setAlarmLoTask:(NSString *)lowValue
{
    if (lowValue && [lowValue isKindOfClass:NSString.class] && lowValue.length) {
        NSString *s =[Set_AlarmLo stringByAppendingString:lowValue];
        self.sendStr = [s stringByAppendingString:strOC];
        self.TotalNum = 0;
        [self setOpertion:self.sendStr];
    }
}

- (NSString *)formatTempData:(CGFloat)value
{
    NSString *valueStr = nil;
    if (value >=100) {
        valueStr = [NSString stringWithFormat:@"%.1f",value];
    }else if (value > 0 && value <100) {//大于 0
        valueStr = [NSString stringWithFormat:@" %.1f",value];
    }else if(value < 0){ //小于0
        valueStr = [NSString stringWithFormat:@"%.1f",value];
    }else{//等于 0
        valueStr = [NSString stringWithFormat:@"  %.1f",value];
    }
    return valueStr;
}

#pragma mark --读取警报值
- (void)Read_AlarmAndSuccess:(successTask)success andFialed:(failTask)fail;
{
    self.success = success;
    self.failure = fail;
    if (self.isCaputering) {//没有关闭采集
        if (self.failure) {
            self.failure(errorStr,nil);
        }
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.sendStr = Read_Alarm;
    self.TotalNum = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(setOpertionWithTimer) userInfo:nil repeats:YES];
    [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

#pragma mark  定时设置校准值
-(void)setOpertionWithTimer
{
    self.TotalNum++;
    if (self.TotalNum>MaxNum) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
            if (self.failure) {
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];;
                NSString *value = nil;
                if ([self.sendStr hasPrefix:ReadAdjust]) {
                     value = [dic objectForKey:AdjustKey];
                }else if ([self.sendStr hasPrefix:ReadVER]){
                      value = [dic objectForKey:VERKey];
                }
                self.failure(timeOut,value);

            }

        }
    }else{
       [self setOpertion:self.sendStr];
    }
}


//#pragma mark  拼接字符串
//-(char*)initCharIndex:(char*)index andEnd:(char*)end
//{
//    char *c = (char *) malloc(strlen(index) + strlen(end) + 1); //局部变量，用malloc申请内存
//    if (c == NULL) exit (1);
//    char *tempc = c; //把首地址存下来
//    while (*index != '\0') {
//        *c++ = *index++;
//    }
//    while ((*c++ = *end++)!= '\0');
//    return tempc;
//}
#pragma mark 发送命令
-(void)setOpertion:(NSString*)str
{
    if (![str hasPrefix:self.sendStr]) {
        return;
    }
    if (_FAF1Characteristic == nil) return;
    
    [_peripheral setNotifyValue:YES forCharacteristic:_FAF1Characteristic];
    if (str.length) {
    const char *s = [str UTF8String];
    NSData *data = [NSData dataWithBytes:s length:strlen(s)];
    if (_FAF1Characteristic && _FAF1Characteristic.properties == CBCharacteristicWriteWithResponse) {
            [_peripheral writeValue:data forCharacteristic:_FAF1Characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        [_peripheral writeValue:data forCharacteristic:_FAF1Characteristic type:CBCharacteristicWriteWithoutResponse];
      }

    }
}
#pragma mark 设置地址值
-(void)setAddr:(unsigned int)addr andSucces:(void(^)(NSString *DeviceValue))success andFail:(void(^)(NSString*errorStr,NSString *localValue))failure
{
    self.success = success;
    self.failure = failure;
    if (self.isCaputering) {//没有关闭采集
        if (self.failure) {
            self.failure(errorStr,nil);
        }
    }else{//关闭采集
        NSString *addrStr = [NSString stringWithFormat:@"%d",addr];
        NSString *s =[Set_Addr stringByAppendingString:addrStr];
        self.sendStr = [s stringByAppendingString:TEMP];
       
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.TotalNum = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(setOpertionWithTimer) userInfo:nil repeats:YES];
        [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }

}

-(instancetype)init
{
    if (self=[super init]) {
        _manager =[[CBCentralManager alloc]initWithDelegate:self queue:nil];
        _isCaputering = NO;
        _isConnected = NO;
    }
    return self;
}
#pragma mark 懒加载


#pragma mark 开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"---%ld",(long)central.state);
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"---蓝牙打开，请扫描外设");
            if ([_delegate  respondsToSelector:@selector(CBMangerDelegateWithManger:andState:)]) {
                [_delegate  CBMangerDelegateWithManger:self andState:kCBStateOpen];
            }
            
            break;
        case CBCentralManagerStatePoweredOff:
            if ([_delegate respondsToSelector:@selector(CBMangerDelegateWithManger:andState:)]) {
                [_delegate CBMangerDelegateWithManger:self andState:kCBStateClose];
            }
            break;
        default:
            if ([_delegate respondsToSelector:@selector(CBMangerDelegateWithManger:andState:)]) {
                [_delegate CBMangerDelegateWithManger:self andState:kCBStateUnkown];
            }
            break;
    }
}
#pragma mark 查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
////    CBUUID
  NSLog(@"====%@",[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, name: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.name, advertisementData]);
//  
    CBUUID *sysUID = [CBUUID UUIDWithString:@"FAF0"];
    if ([advertisementData[@"kCBAdvDataServiceUUIDs"][0] isEqual:sysUID]) {//同类型的设备
      _peripheral = peripheral;
        if([_delegate respondsToSelector:@selector(CBMangerDelegateWithManger:andDeviceName:andRSSI:andUUID:)])
        {
            self.oldRSSI=[RSSI intValue];
            self.oldDistance = pow(10, (abs(self.oldRSSI)-49)/(10*4.0));
            [_delegate CBMangerDelegateWithManger:self andDeviceName:peripheral.name andRSSI:RSSI andUUID:peripheral.identifier.UUIDString];
        }
        [self.manager stopScan];
   }
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
//     NSLog(@"====%@",[NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.UUID]);
    self.peripheral=peripheral;
    self.peripheral.delegate = self;
    //开启定时器
    if (self.timer==nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(readRSSI) userInfo:nil repeats:YES];
        [[NSRunLoop alloc] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
        _isConnected = YES;
    
    [self.peripheral discoverServices:nil];
    
//  [self updateLog:@"扫描服务"];
}
-(void)readRSSI
{
    if (self.peripheral) {
//         NSLog(@"readRSSI");
//        NSLog(@"---%@",[NSThread currentThread]);
        [self.peripheral readRSSI];
    }
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"断开了。");
    NSLog(@"%@",error);
    _isConnected = NO;
    if (self.failure) {
        self.failure(@"连接失败,请检查硬件是否打开",nil);
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer =nil;
    }
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _isConnected = NO;
//    [self.manager connectPeripheral:peripheral options:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:CBMangerDidConnetedNoti object:nil];
}

-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{

    int rssi = abs([RSSI intValue]);
    CGFloat ci = pow(10,(rssi - 49) / (10 * 4.0));
     NSLog(@"距离：%f",ci-self.oldDistance);
    _distance = ci;


}
//已发现服务     
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
      NSLog(@"发现服务.");
     int i=0;
//    for (CBService *s in peripheral.services) {
//     [self.nServices addObject:s];
//    }
    for (CBService *s in peripheral.services) {
        NSLog(@"---%@",[NSString stringWithFormat:@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID]);
        i++;
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

#pragma mark 已搜索到Characteristics，查找服务列表
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"---%@",[NSString stringWithFormat:@"发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID]);
    //遍历特征
    for (CBCharacteristic *c in service.characteristics) {
          NSLog(@"---%@",[NSString stringWithFormat:@"特征 UUID: %@ (%@), %ld",c.UUID.data,c.UUID,(unsigned long)c.properties]);
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FAF1"]]) {
            NSLog(@"可以接收到FAF1这个服务");
            _FAF1Characteristic = c;
            [_peripheral setNotifyValue:YES forCharacteristic:_FAF1Characteristic];
            break;
        }
    }
    if (self.success) {
        self.success(@"连接成功");
    }
    
}

#pragma mark 获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(!error){
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FAF1"]])
        {
            NSString *str1 = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
//            NSLog(@"接收到的数据==%@ ****** self.sendStr==%@",str1,self.sendStr);
            if ([str1 hasPrefix:SetAdjust]&&[self.sendStr hasPrefix:ReadAdjust]) {//读校验值
                [self.timer invalidate];
                 self.timer = nil;
                if (self.success) {
                    NSRange range = [str1 rangeOfString:SetAdjust];
                    NSString *value = [str1 substringWithRange:NSMakeRange(range.location+range.length, num)];
                    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:plistPath];
                    [dic setValue:value forKey:AdjustKey];
                    self.success(value);
                    return;
                }
            }
            else if ([str1 containsString:OK]&&[self.sendStr hasPrefix:SetAdjust]) {//设定校验值
                if (self.success) {
                    NSRange range = [self.sendStr rangeOfString:SetAdjust];
                    NSString *value = [self.sendStr substringWithRange:NSMakeRange(range.location+range.length, num)];
                    self.success(value);
                    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:plistPath];
                    [dic setValue:value forKey:AdjustKey];

                    [self.timer invalidate];
                    self.timer = nil;
                }
                return;
            }else if ([str1 containsString:OK] && [self.sendStr hasPrefix:Set_AlarmHi]){//设置高温
                if (self.success) {
                    NSRange range = [self.sendStr rangeOfString:Set_AlarmHi];
                    NSString *value = [self.sendStr substringWithRange:NSMakeRange(range.location+range.length, num)];
                    self.success(value);
                    [self.timer invalidate];
                    self.timer = nil;
                }
                return;
            }else if ([str1 containsString:OK] && [self.sendStr hasPrefix:Set_AlarmLo]){//设置低温
                if (self.success) {
                    NSRange range = [self.sendStr rangeOfString:Set_AlarmLo];
                    NSString *value = [self.sendStr substringWithRange:NSMakeRange(range.location+range.length, num)];
                    self.success(value);
                    [self.timer invalidate];
                    self.timer = nil;
                    self.success(value);
                }
                return;
            }else if ([self.sendStr hasPrefix:Read_Alarm]){
                str1 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];//去除空格
                if ([str1 containsString:strOC]) {
                    [self.tempStr appendString:str1];
                }
                if ([self.tempStr rangeOfString:AlarmHi].location != NSNotFound && [self.tempStr rangeOfString:AlarmLo].location != NSNotFound) {
                    NSString *value = nil;
                    NSRange rangeHi = [self.tempStr rangeOfString:AlarmHi];
                    NSString *hiValue  = nil;
                    if (self.tempStr.length >rangeHi.location + rangeHi.length + num) {
                        hiValue = [self.tempStr substringWithRange:NSMakeRange(rangeHi.location+rangeHi.length, num)];
                    }
                    
                    NSString   *lowValue  = nil;
                    NSRange    rangeLo = [self.tempStr rangeOfString:AlarmLo];
                    if (self.tempStr.length >rangeLo.location + rangeLo.length + num) {
                        lowValue = [self.tempStr substringWithRange:NSMakeRange(rangeLo.location+rangeLo.length, num)];
                    }
                    if (hiValue && lowValue) {
                        value = [NSString stringWithFormat:@"%@,%@",hiValue,lowValue];
                    }
                    if (self.success) {
                        self.success(value);
                    }
                    if(self.timer){
                        [self.timer invalidate];
                        self.timer = nil;
                    }
                    return;
                }
                return;
                
            }else if([self.sendStr hasPrefix:SendON]){//采集温度
            str1 = [str1 stringByRemovingPercentEncoding];
            str1 = [str1 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            str1 = [str1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            str1 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
            
              NSLog(@"数据-%@",str1);
            if ([self.tempStr containsString:@"Temp:"]&&[self.tempStr containsString:@"Bat"]&&[self.tempStr containsString:@"V"]&&[self.tempStr containsString:@"oC"]) {
                
                NSLog(@"self.temstr = %@",self.tempStr);
                NSRange rangeT = [self.tempStr rangeOfString:@"Temp:"];
                NSRange rangeTT = [self.tempStr rangeOfString:@"oC"];
                
                NSRange rangeB = [self.tempStr rangeOfString:@"Bat:"];
                NSRange rangeV = [self.tempStr rangeOfString:@"V"];
                if (rangeT.location+rangeT.length<rangeTT.location&&rangeB.location+rangeB.length<rangeV.location) {
                    NSRange StrRange = NSMakeRange(rangeT.location+rangeT.length, rangeTT.location-rangeT.location-rangeT.length);
                    NSRange  vRange = NSMakeRange(rangeB.location+rangeB.length, rangeV.location - rangeB.location-rangeB.length);
                    NSString  *str = [self.tempStr substringWithRange:StrRange];
                    NSString  *V = [self.tempStr substringWithRange:vRange];
                    if ([_delegate respondsToSelector:@selector(CBManagerDelegateWithManger:andTemperature:andBat:)]) {
                          if (self.timer) {
                            [self.timer invalidate];
                            self.timer = nil;
                              _isCaputering= YES;//打开采集标志
                            if (self.success) {
                                self.success(OK);
                            }
                        }
                        [_delegate CBManagerDelegateWithManger:self andTemperature:str andBat:V];
                    }

                }
                    _tempStr =[NSMutableString string];
                return;
            }
            else
            {
                if (str1) {
                    [self.tempStr appendString:str1];
                }
                return;
            }
            
            }
            else if([self.sendStr hasPrefix:SendOFF]){//关闭采集
                if([str1 containsString:OK]){
                    [self.timer invalidate];
                     self.timer = nil;
                    _isCaputering = NO;//关闭采集标志
                    if (self.success) {
                        self.success(OK);
                     }
                    return;
             }
          }
            else if([self.sendStr hasPrefix:ReadVER]){
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                [dic setValue:str1 forKey:VERKey];
                self.success(str1);
            }
            else if ([self.sendStr hasPrefix:Set_Addr]&&[str1 containsString:OK]){
                if (self.success) {
                    self.success(@"设置成功");
                }
            }
       }
    }
    else{
      NSLog(@"error = %@",error);
    }
}


//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
}
//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"error.userInfo=%@",error.userInfo);
        if (self.failure) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];;
            NSString *value = nil;
            if ([self.sendStr hasPrefix:ReadAdjust]) {
                value = [dic objectForKey:AdjustKey];
            }else if ([self.sendStr hasPrefix:ReadVER]){
                value = [dic objectForKey:VERKey];
            }
            self.failure(@"发送数据失败",value);
        }
    }else{
        NSLog(@"发送数据成功");
    }
}

- (void)clear
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    self.TotalNum = 0;
}

@end
