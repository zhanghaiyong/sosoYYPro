//
//  STWisdomToLeftView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/29.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomToLeftView.h"


//设备型号
#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

//系统版本
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_5    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0

//物理屏幕尺寸
#define IH_DEVICE_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define IH_DEVICE_WIDTH     [[UIScreen mainScreen] bounds].size.width


//自定义的NSLog
#ifdef DEBUG
#define XSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define YYLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define XSLog(FORMAT, ...) nil;
#define YYLog(FORMAT, ...) nil;
#endif

@implementation STWisdomToLeftView

-(void)setWisdomToLeftView{
    if (IS_IPHONE_5) {
        _bgImgeV.image = [UIImage imageNamed:@"slidingToLeft_5"];
    }else if (IS_IPHONE_6){
       _bgImgeV.image = [UIImage imageNamed:@"slidingToLeft_6"];
    }else if (IS_IPHONE_6_PLUS){
      _bgImgeV.image = [UIImage imageNamed:@"slidingToLeft_6"];
    }else{
      _bgImgeV.image = [UIImage imageNamed:@"slidingToLeft_5"];
    }
}
- (IBAction)hiddenBtn:(id)sender {
    if (_WisdomToLeftViewBlock) {
        _WisdomToLeftViewBlock();
    }
}

@end
