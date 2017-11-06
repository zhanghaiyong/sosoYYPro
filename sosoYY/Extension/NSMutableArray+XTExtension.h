//
//  NSMutableArray+XTExtension.h
//  BlackRose
//
//  Created by Qing Xiubin on 14-2-16.
//  Copyright (c) 2014年 BR. All rights reserved.
//

@interface NSMutableArray (XTExtension)

//向前插入
- (NSMutableArray *)pushHead:(NSObject *)obj;
//移除前面的元素
- (NSMutableArray *)popHead;

//将数组插入前面
- (NSMutableArray *)pushHeads:(NSArray *)all;

//移除前n个元素
- (NSMutableArray *)popHeads:(NSUInteger)n;

//向后插入
- (NSMutableArray *)pushTail:(NSObject *)obj;
//移除后面的元素
- (NSMutableArray *)popTail;

//将数组插入后面
- (NSMutableArray *)pushTails:(NSArray *)all;
//移除后面n个元素
- (NSMutableArray *)popTails:(NSUInteger)n;

//保留n前面的元素
- (NSMutableArray *)keepHead:(NSUInteger)n;
//保留n后面的元素
- (NSMutableArray *)keepTail:(NSUInteger)n;

//移除指定位置的元素
- (void)moveObjectAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2;

@end
