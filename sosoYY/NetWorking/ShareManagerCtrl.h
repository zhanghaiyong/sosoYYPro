//
//  ShareManagerCtrl.h
//  sosoYY
//
//  Created by zhy on 16/12/8.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface ShareManagerCtrl : AFHTTPSessionManager

+ (AFHTTPSessionManager *)shareManager;

@end
