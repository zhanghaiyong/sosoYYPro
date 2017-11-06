//
//  Core.h
//  eather
//
//  Created by 青秀斌 on 14-6-12.
//  Copyright (c) 2014年 com.cdzlxt.iw. All rights reserved.
//

#ifndef iWeather_Core_h
#define iWeather_Core_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "NSDate+XTExtension.h"
#import "NSString+XTExtension.h"
#import "UIColor+XTExtension.h"
#import "HYSystem.h"




#define CORE_VERSION     0.1.1
#define CORE_BUILD       1




#undef	BLOCK_OBJ
#if __has_feature(objc_arc_weak)
#define	BLOCK_OBJ(object)           __block __weak typeof(object) __##object = object;
#elif __has_feature(objc_arc)
#define	BLOCK_OBJ(object)           __block __unsafe_unretained typeof(object) __##object = object;
#else
#define	BLOCK_OBJ(object)           __block typeof(object) __##object = object;
#endif

#undef	BLOCK_IF
#define BLOCK_IF(block)             if(block)block

#undef	SEL_EXSIT
#define SEL_EXSIT(objc, method)     objc && [objc respondsToSelector:@selector(method)]

#undef	DEALLOC_PRINT
#define DEALLOC_PRINT               DDLogInfo(@"TestDealloc--->%@",[self class]);


#endif
