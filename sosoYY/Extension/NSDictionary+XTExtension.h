//
//  NSDictionary+XTExtension.h
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

@interface NSDictionary (XTJson)

//字典转化成NSData
- (NSData *)JSONData;
//转化成NSString
- (NSString *)JSONString;

@end