//
//  NSObject+PGPerformSelectorOnMainThreadWithThreeObjects.m
//  PlayWhat
//
//  Created by 谢  on 13-5-30.
//  Copyright (c) 2013年 fljt. All rights reserved.
//

#import "NSObject+PGPerformSelectorOnMainThreadWithThreeObjects.h"

@implementation NSObject (PGPerformSelectorOnMainThreadWithThreeObjects)

- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2  waitUntilDone:(BOOL)wait
{
    [self performSelectorOnMainThread:selector withObject:arg1 withObject:arg2 withObject:nil waitUntilDone:wait];
}

- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2  withObject:(id)arg3 waitUntilDone:(BOOL)wait;
{
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig) return;
    
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&arg1 atIndex:2];
    if (arg2!=nil) {
        [invo setArgument:&arg2 atIndex:3];
    }
    if (arg3!=nil) {
        [invo setArgument:&arg3 atIndex:4];
    }
    [invo retainArguments];
    [invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
}
@end
