//
//  NSMutableArray+XTExtension.m
//  BlackRose
//
//  Created by Qing Xiubin on 14-2-16.
//  Copyright (c) 2014年 BR. All rights reserved.
//

#import "NSMutableArray+XTExtension.h"

@implementation NSMutableArray (XTExtension)

- (NSMutableArray *)pushHead:(NSObject *)obj{
	if (obj) {
		[self insertObject:obj atIndex:0];
	}
	return self;
}
- (NSMutableArray *)popHead{
	if ([self count]>0) {
		[self removeObjectAtIndex:0];
	}
    return self;
}

- (NSMutableArray *)pushHeads:(NSArray *)all{
	if ([all count]>0){
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self insertObjects:all atIndexes:indexSet];
	}
	return self;
}
- (NSMutableArray *)popHeads:(NSUInteger)n{
	if ([self count]>n) {
        NSRange range = NSMakeRange(0, n);
        [self removeObjectsInRange:range];
	} else {
        [self removeAllObjects];
    }
    return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj{
	if (obj) {
		[self addObject:obj];
	}
    return self;
}
- (NSMutableArray *)popTail{
	if ([self count]>0){
		[self removeObjectAtIndex:[self count]-1];
	}
    return self;
}

- (NSMutableArray *)pushTails:(NSArray *)all{
	if ([all count]) {
		[self addObjectsFromArray:all];
	}
    return self;
}
- (NSMutableArray *)popTails:(NSUInteger)n{
	if ([self count]>n) {
        NSRange range = NSMakeRange(n, [self count]-n);
        [self removeObjectsInRange:range];
	} else {
        [self removeAllObjects];
    }
    return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n{
	if ([self count]>n) {
		NSRange range = NSMakeRange(n, [self count]-n);
		[self removeObjectsInRange:range];
	}
    return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n{
	if ([self count]>n){
		NSRange range = NSMakeRange(0, [self count]-n);
		[self removeObjectsInRange:range];
	}
    return self;
}

- (void)moveObjectAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2{
    id object = [self objectAtIndex:index1];
    if (object) {
        [self removeObjectAtIndex:index1];
        [self insertObject:object atIndex:index2];
    }
}

@end
