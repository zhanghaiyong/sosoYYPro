//
//  NSArray+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSArray+XTExtension.h"

@implementation NSArray (XTExtension)
//获取前面几个元素组成数组
- (NSArray *)head:(NSUInteger)count{
	if ([self count]<count){
		return [NSArray arrayWithArray:self];
	}
    return [self subarrayWithRange:NSMakeRange(0, count)];
}

//获取后面几个元素组成数组
- (NSArray *)tail:(NSUInteger)count{
    if ([self count]<count) {
		return [NSArray arrayWithArray:self];
    }
    return [self subarrayWithRange:NSMakeRange([self count]-count, count)];
}

@end


@implementation NSArray (XTJson)

//将数组转换成NSData
- (NSData *)JSONData{
    if (![NSJSONSerialization isValidJSONObject:self]) {
        NSLog(@"JSON序列化出错--->error:存在非法数据类型");return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        NSLog(@"JSON序列化出错--->error:%@",error); return nil;
    }
    return jsonData;
}

//将数组转换成NSString
- (NSString *)JSONString{
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

@end