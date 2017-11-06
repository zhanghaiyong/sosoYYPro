//
//  AppDelegate+statistics.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "AppDelegate+statistics.h"

@implementation AppDelegate (statistics)

-(void)setStatistics {
    
    [MobClick setLogEnabled:NO];
    UMConfigInstance.appKey = kUMAppKey;
    UMConfigInstance.secret = @"secretstringaldfkals";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}
@end
