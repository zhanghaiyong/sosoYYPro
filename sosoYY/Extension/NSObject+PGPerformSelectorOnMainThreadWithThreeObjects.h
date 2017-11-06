//
//  NSObject+PGPerformSelectorOnMainThreadWithThreeObjects.h
//  PlayWhat
//
//  Created by 谢  on 13-5-30.
//  Copyright (c) 2013年 fljt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PGPerformSelectorOnMainThreadWithThreeObjects)

//可带多个参数
- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2  waitUntilDone:(BOOL)wait;
- (void) performSelectorOnMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2  withObject:(id)arg3 waitUntilDone:(BOOL)wait;
@end
