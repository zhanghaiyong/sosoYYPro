//
//  XTSystem.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "HYSystem.h"
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation HYSystem




+ (NSString *)osVersion{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else
	return nil;
#endif
}

+ (NSString *)appVersion{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
#else
	return nil;
#endif
}

+ (NSString *)appName{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
#else
    return nil;
#endif
}

+ (NSString *)appBuild{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
#else
	return nil;
#endif
}

+ (NSString *)appIdentifier{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
#else
	return nil;
#endif
}

+ (NSString *)deviceModel{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [[UIDevice currentDevice] model];
#else
	return nil;
#endif
}

+ (NSString *)deviceUUID{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
//    if (IOS6_OR_LATER) {
//        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    } else {
//        
//    }
    return [NSString mechineID];
#else
	return nil; 
#endif
}



+(NSString *)carrierName {

    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    return mCarrier;
}


+ (CGFloat)statuBarHeight{
    if (IOS7_OR_LATER) {
        return 20;
    }else{
        return 0;
    }
}

+ (CGFloat)navBarHeight{
    return 44;
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static const char * __jb_app = NULL;
#endif

+ (BOOL)isJailBroken NS_AVAILABLE_IOS(4_0){
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	static const char * __jb_apps[] ={
		"/Application/Cydia.app",
		"/Application/limera1n.app",
		"/Application/greenpois0n.app",
		"/Application/blackra1n.app",
		"/Application/blacksn0w.app",
		"/Application/redsn0w.app",
		NULL
	};
    
	__jb_app = NULL;
    
	// method 1
    for ( int i = 0; __jb_apps[i]; ++i ){
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
			__jb_app = __jb_apps[i];
			return YES;
        }
    }
	
    // method 2
	if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ){
		return YES;
	}
	
//    // method 3
//    if ( 0 == system("ls") ){
//        return YES;
//    }
#endif
	
    return NO;
}

+ (NSString *)jailBreaker NS_AVAILABLE_IOS(4_0){
#if (TARGET_OS_IPHONE)
	if ( __jb_app ){
		return [NSString stringWithUTF8String:__jb_app];
	}
#endif
    
	return @"";
}

+ (BOOL)isDevicePhone{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	NSString * deviceType = [UIDevice currentDevice].model;
	
	if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 ){
		return YES;
	}
#endif
	
	return NO;
}

+ (BOOL)isDevicePad{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	NSString * deviceType = [UIDevice currentDevice].model;
	
	if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 ){
		return YES;
	}
#endif
	
	return NO;
}

+ (BOOL)isPhone35{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [HYSystem isScreenSize:CGSizeMake(320, 480)];
#else
	return NO;
#endif
}

+ (BOOL)isPhoneRetina35{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [HYSystem isScreenSize:CGSizeMake(640, 960)];
#else
	return NO;
#endif
}

+ (BOOL)isPhoneRetina4{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [HYSystem isScreenSize:CGSizeMake(640, 1136)];
#else
	return NO;
#endif
}
+ (BOOL)isPhoneRetina6{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [HYSystem isScreenSize:CGSizeMake(750, 1334)];
#else
    return NO;
#endif
}

+ (BOOL)isPhoneRetina6Plus{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [HYSystem isScreenSize:CGSizeMake(1242, 2208)];
#else
    return NO;
#endif
}

+ (BOOL)isPad{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [HYSystem isScreenSize:CGSizeMake(768, 1024)];
#else
	return NO;
#endif
}

+ (BOOL)isPadRetina{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return [HYSystem isScreenSize:CGSizeMake(1536, 2048)];
#else
	return NO;
#endif
}

+ (BOOL)isScreenSize:(CGSize)size{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ( [UIScreen instancesRespondToSelector:@selector(currentMode)] ){
		CGSize screenSize = [UIScreen mainScreen].currentMode.size;
		CGSize size2 = CGSizeMake( size.height, size.width );
        
		if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) ){
			return YES;
		}
	}
	
	return NO;
#else
	return NO;
#endif
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
