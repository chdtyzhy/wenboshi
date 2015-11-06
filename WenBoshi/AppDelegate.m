//
//  AppDelegate.m
//  WenBoshi
//
//  Created by luoshuisheng on 14/12/7.
//  Copyright (c) 2014年 luoshuisheng. All rights reserved.
//

#import "AppDelegate.h"
#import "WBHomeController.h"
#import "WBLinkController.h"
#import "CBManager.h"
#import "MBProgressHUD+MJ.h"

@interface AppDelegate ()<CBMangerDelegate>
@property (nonatomic ,weak) WBHomeController *homeController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CBManager *manger = [CBManager shareManager];
    self.manger = manger;
    manger.delegate = self;
    WBHomeController *home = [[WBHomeController alloc] init];
    self.homeController = home;
    self.window.rootViewController = home;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mangerDidendConnect) name:CBMangerDidConnetedNoti object:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)mangerDidendConnect
{
    [self.window.rootViewController showToastMessage:@"设备已断开"];
    [self.homeController.stopBtn setTitle:@"开始" forState:UIControlStateNormal];
}

-(void)CBMangerDelegateWithManger:(CBManager *)manger andState:(CBState)states
{
//    WBHomeController *home = [[WBHomeController alloc] init];
//    self.homeController = home;
//    self.window.rootViewController = home;

}


+(AppDelegate *)shareDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end