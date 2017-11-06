//
//  UIViewController+share.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/5.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "UIViewController+share.h"

@implementation UIViewController (share)

-(void)setShare {
    [UMSocialUIManager addCustomPlatformWithoutFilted:(UMSocialPlatformType)1002
                                     withPlatformIcon:[UIImage imageNamed:@"copy"]
                                     withPlatformName:@"复制"];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Sms),
                                               @(UMSocialPlatformType_UserDefine_Begin + 2),
                                               ]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}
-(void)setShareTwo{
    
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:(UMSocialPlatformType)1002
                                     withPlatformIcon:[UIImage imageNamed:@"copy"]
                                     withPlatformName:@"复制"];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Sms),
                                               @(UMSocialPlatformType_UserDefine_Begin + 2),
                                               ]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

-(void)setShareThree {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               ]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

-(void)wisdomRefreshing{
    
}
-(void)failBlockwisdomRefreshing{
    
}
@end
