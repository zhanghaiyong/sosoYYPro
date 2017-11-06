//
//  AppDelegate+share.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "AppDelegate+share.h"

@implementation AppDelegate (share)

- (void)setUMSocialApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    
    [UMessage setLogEnabled:NO];
    
    //微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechatAppID appSecret:kWechatAppSecret redirectURL:nil];
    //QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppID appSecret:kQQAppKey redirectURL:nil];
    //新浪
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSinaAppID  appSecret:kSinaAppSecret redirectURL:nil];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    FxLog(@"options = %@",options);
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"处理结果%@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"success",@"code", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UPPay_Code object:nil userInfo:dic];
            }else {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"cancel",@"code", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UPPay_Code object:nil userInfo:dic];
            }
        }];
    }else if ([url.host isEqualToString:@"platformapi"]) {
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic2 = %@",resultDic);
        }];
    }
    
    //微信回掉
    if ([[options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    [[UPPaymentControl defaultControl]handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        if (code.length > 0) {
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:code,@"code", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:UPPay_Code object:nil userInfo:dic];
            
        }
        
        FxLog(@"SZFsdf = %@",code);
    }];

    
    return result;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"处理结果%@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"success",@"code", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UPPay_Code object:nil userInfo:dic];
            }else {
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"cancel",@"code", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UPPay_Code object:nil userInfo:dic];
            }
        }];
    }else if ([url.host isEqualToString:@"platformapi"]) {
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic2 = %@",resultDic);
        }];
    }
    
    return result;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


#pragma mark 微信回调方法

- (void)onResp:(BaseResp *)resp {
    
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                FxLog(@"支付成功: %d",resp.errCode);
                wxPayResult = @"success";
                break;
            }
            case WXErrCodeUserCancel:
            {
                
                wxPayResult = @"cancel";
                break;
            }
            default:
            {
                
                wxPayResult = @"faile";
                break;
            }
        }
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:wxPayResult,@"code", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPPay_Code object:nil userInfo:dic];
    }
}



@end
