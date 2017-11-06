//
//  AppDelegate+share.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "AppDelegate.h"
//银联支付
#import "UPPaymentControl.h"
//微信SDK头文件
#import "WXApi.h"
@interface AppDelegate (share)<WXApiDelegate>
- (void)setUMSocialApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
