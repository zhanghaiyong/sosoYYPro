//
//  ShareManagerCtrl.m
//  sosoYY
//
//  Created by zhy on 16/12/8.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "ShareManagerCtrl.h"

@implementation ShareManagerCtrl

+ (AFHTTPSessionManager *)shareManager {

    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"api.m.sosoyy" ofType:@"cer"];
        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
        // 客户端是否信任非法证书
        manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        [manager.securityPolicy setValidatesDomainName:NO];
        //将json中是null的key-value去掉
//        AFJSONResponseSerializer *response = (AFJSONResponseSerializer *)manager.responseSerializer;
//        response.removesKeysWithNullValues = YES;
    });
    return manager;
}

@end
