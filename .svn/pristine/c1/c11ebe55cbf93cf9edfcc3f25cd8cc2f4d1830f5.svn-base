//
//  XTSystem.h
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>



#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

//判断设备版本
#define IOS8_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
#define IOS7_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
#define IOS6_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_5_1)
#define IOS5_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_4_3)
#define IOS4_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iPhoneOS_3_2)
#define IOS3_OR_LATER	(NSFoundationVersionNumber > NSFoundationVersionNumber_iPhoneOS_2_2)

#else

#define IOS6_OR_LATER	(NO)
#define IOS5_OR_LATER	(NO)
#define IOS4_OR_LATER	(NO)
#define IOS3_OR_LATER	(NO)

#endif

@interface HYSystem : NSObject

//设备名称和版本号
+ (NSString *)osVersion;
//app版本号
+ (NSString *)appVersion;
//构建型号
+ (NSString *)appBuild;
//app名称
+ (NSString *)appName;
//app的identifier
+ (NSString *)appIdentifier;
//设备类型
+ (NSString *)deviceModel;
//设备UUID
+ (NSString *)deviceUUID;
//手机厂商名称
+ (NSString *)carrierName;
//IMEI
+ (NSString *) imei;

//状态栏高度
+ (CGFloat)statuBarHeight;
//导航栏高度
+ (CGFloat)navBarHeight;

//是否越狱
+ (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);
+ (NSString *)jailBreaker	NS_AVAILABLE_IOS(4_0);

//是否是iphone设备
+ (BOOL)isDevicePhone;
//是否是pad设备
+ (BOOL)isDevicePad;

+ (BOOL)isPhone35;
+ (BOOL)isPhoneRetina35;
+ (BOOL)isPhoneRetina4;
+ (BOOL)isPhoneRetina6;
+ (BOOL)isPhoneRetina6Plus;
+ (BOOL)isPad;
+ (BOOL)isPadRetina;
//是否是屏幕大小
+ (BOOL)isScreenSize:(CGSize)size;

//获得设备型号
+ (NSString *)getCurrentDeviceModel;

@end
