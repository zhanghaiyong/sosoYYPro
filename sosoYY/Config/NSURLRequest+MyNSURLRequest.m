//
//  NSURLRequest+MyNSURLRequest.m
//  sosoYY
//
//  Created by soso-mac on 2017/2/22.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "NSURLRequest+MyNSURLRequest.h"

@implementation NSURLRequest (MyNSURLRequest)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host{
    return NO;
}
@end
