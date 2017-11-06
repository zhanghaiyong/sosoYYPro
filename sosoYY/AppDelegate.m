//
//  AppDelegate.m
//  sosoYY
//
//  Created by zhy on 16/11/22.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarCtrl.h"
#import "FirstGuidViewController.h"
#import "AppDelegate+share.h"
#import "AppDelegate+pay.h"
#import "AppDelegate+statistics.h"
#import "AppDelegate+message.h"
#import "MyUrlCache.h"
#import <Bugly/Bugly.h>
#import "AppDelegate+location.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:233/255.0 green:84/255.0 blue:18/255.0 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"PingFang-SC-Medium" size: 18], NSFontAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    

//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    MyUrlCache *cache = [[MyUrlCache alloc] init];
    [NSURLCache setSharedURLCache:cache];
    
    [self setShowViewController];
    [self setLocationKey];
    
    //是否是同一个接口，如果不是清除cookies，要重新登录
    if (kRequestHost != nil) {
        if (![kRequestHost isEqualToString:@requestHost]) {
            [Uitils UserDefaultRemoveObjectForKey:@"cookie"];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:@requestHost forKey:@"requestHost"];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            
           [STCommon setMassge:userInfo];
        }
    }
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;
    
    /*友盟统计*/
    [self setStatistics];
   /*支付*/
    [self setPay];
    /*推送*/
    [self setUMessageApplication:application didFinishLaunchingWithOptions:launchOptions];
    /*分享*/
    [self setUMSocialApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)setShowViewController {
        
    if(!kFirstStartLoading){
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartLoading"];
        self.window.rootViewController = [FirstGuidViewController new];
    } else {
        BaseTabBarCtrl *tabBar = [[BaseTabBarCtrl alloc]init];
        self.window.rootViewController = tabBar;
        
        UIAlertView  *notificationAlert = nil;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { //iOS8以上包含iOS8
            
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
                
                notificationAlert = [[UIAlertView alloc]initWithTitle:@"打开推送通知" message:@"第一时间获取最低价活动信息!" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"继续", nil];
                notificationAlert.tag = 1001;
                [notificationAlert show];
            }
        }else{ // ios7 一下
            if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
                notificationAlert = [[UIAlertView alloc]initWithTitle:@"打开推送通知" message:@"第一时间获取最低价活动信息!" delegate:self cancelButtonTitle:@"不允许" otherButtonTitles:@"继续", nil];
                notificationAlert.tag = 1001;
                [notificationAlert show];
            }
        }
        
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.showAlert = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    self.showAlert = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [[UIApplication sharedApplication].keyWindow hideToastActivity];
//    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    
    //智慧采购人工采购
     [[NSNotificationCenter defaultCenter] postNotificationName:SHARE_Notification object:nil];
    //支付后的邀请
     [[NSNotificationCenter defaultCenter] postNotificationName:inviteShareNOtifation object:nil];
    //代支付
     [[NSNotificationCenter defaultCenter] postNotificationName:Pay_Share_Notification object:nil];

}
//内存警告时的处理
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
