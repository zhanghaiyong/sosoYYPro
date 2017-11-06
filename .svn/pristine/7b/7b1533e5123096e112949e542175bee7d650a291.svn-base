//
//  AppDelegate+message.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "AppDelegate+message.h"

@implementation AppDelegate (message)


- (void)setUMessageApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [UMessage startWithAppkey:kUMAppKey launchOptions:launchOptions httpsEnable:YES ];
    [UMessage registerForRemoteNotifications];
    [UMessage setLogEnabled:NO];
    [UMessage setChannel:@"App Store"];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                }];
            } else {
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        //iOS8 - iOS10
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[Uitils getUserDefaultsForKey:@"cookie"]];
    if (cookies) {
        FxLog(@"有cookie");
        
        for (NSHTTPCookie *https in cookies) {
            
            if ([https.value containsString:@"uid"]) {
                
                NSArray *array = [https.value componentsSeparatedByString:@"&"];
                
                NSString *uidStr = array[0];
                uidStr=[uidStr stringByReplacingOccurrencesOfString:@"uid=" withString:@""];
                
                if ([uidStr integerValue] > 0) {
                    
                    [KSMNetworkRequest postRequest:requestUpdatePush params:@{@"uid":uidStr} success:^(id responseObj) {
                        
                        FxLog(@"sfdsdg = %@",responseObj);
                        
                    } failure:^(NSError *error) {
                        FxLog(@"sfdsdg = %@",error.localizedDescription);
                    }];
                }
            }
        }
        
    }else{
        FxLog(@"无cookie");
    }

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"token = %@",deviceToken);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0) {

    FxLog(@"error = %@",error.description);
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if (self.showAlert) {
        
         [STCommon setMassge:userInfo];
        
        self.showAlert = NO;
        
    }else {
    
        self.alert = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"您接收到新的消息，是否查看？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        //审计划
        if ([userInfo.allKeys containsObject:@"flag"]) {
            
            if ([[userInfo objectForKey:@"flag"] integerValue] == 2) {
                
                self.alert.tag = 200;
                [self.alert show];
            }
            
        }else {
            
            self.alert.tag = 100;
            [self.alert show];
        }
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else if (alertView.tag == 100) {
         if (buttonIndex == 1) {
             NSDictionary *dic = @{@"type":@"order"}; //订单
             [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_Notification object:self userInfo:dic];
         }
     
    }else{
        if (buttonIndex == 1) {
            NSDictionary *dic = @{@"type":@"plan"};  //审计划
            [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_Notification object:self userInfo:dic];
        }
    }
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    self.alert = [[UIAlertView alloc]initWithTitle:@"新消息" message:@"您接收到新的消息，是否查看？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    //审计划
    if ([userInfo.allKeys containsObject:@"flag"]) {
        
        if ([[userInfo objectForKey:@"flag"] integerValue] == 2) {
            self.alert.tag = 200;
            [self.alert show];
        }

    }else {
    
        self.alert.tag = 100;
        [self.alert show];
    }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}


//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{

    
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    [STCommon setMassge:userInfo];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[Uitils getUserDefaultsForKey:@"cookie"]];
    if (cookies) {
        FxLog(@"有cookie");
        
        for (NSHTTPCookie *https in cookies) {
            
            if ([https.value containsString:@"uid"]) {
                
                NSArray *array = [https.value componentsSeparatedByString:@"&"];
                
                NSString *uidStr = array[0];
                uidStr=[uidStr stringByReplacingOccurrencesOfString:@"uid=" withString:@""];
                
                if ([uidStr integerValue] > 0) {
                    
                    [KSMNetworkRequest postRequest:requestUpdatePush params:@{@"uid":uidStr} success:^(id responseObj) {
                        
                        FxLog(@"sfdsdg = %@",responseObj);
                        
                    } failure:^(NSError *error) {
                        FxLog(@"sfdsdg = %@",error.localizedDescription);
                    }];
                }
            }
        }
        
    }else{
        FxLog(@"无cookie");
    }
}


@end
