//
//  AppDelegate+pay.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "AppDelegate+pay.h"

@implementation AppDelegate (pay)
-(void)setPay {
    
    [WXApi registerApp:kWechatAppID withDescription:@"weixinpay 2.0"];
}


@end
