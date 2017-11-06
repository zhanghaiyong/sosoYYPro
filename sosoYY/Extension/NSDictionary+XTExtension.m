//
//  NSDictionary+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSDictionary+XTExtension.h"

@implementation NSDictionary (XTJson)

- (NSData *)JSONData{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSLog(@"JSON序列化出错--->error:存在非法数据类型");return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        NSLog(@"JSON序列化出错--->error:%@",error);
    }
    return jsonData;
}
- (NSString *)JSONString{
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

@end
