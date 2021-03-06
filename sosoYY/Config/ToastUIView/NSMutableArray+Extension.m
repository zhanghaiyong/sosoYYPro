
//
//  NSMutableArray+Extension.m
//  my
//
//  Created by soso-mac on 2017/4/25.
//  Copyright © 2017年 soso-mac. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)
+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            //防止给ary添加nil的数据
            Method oldMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
            Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(gbh_addObject:));
            method_exchangeImplementations(oldMethod, newMethod);
            
            Method oldMethod1 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:));
            Method newMethod1 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(gbh_objectAtIndex:));
            method_exchangeImplementations(oldMethod1, newMethod1);
            
            
//            Method oldMethod2 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(removeObjectAtIndex:));
//            Method newMethod2 = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(gbh_removeObjectAtIndex:));
//            method_exchangeImplementations(oldMethod2, newMethod2);
        }
    });
}
-(void)gbh_addObject:(id)objct{
    if (objct) {
        [self gbh_addObject:objct];
    }
}
-(id)gbh_objectAtIndex:(NSInteger)index{
    if (index < self.count) {
        return [self gbh_objectAtIndex:index];
    }
     NSLog(@"越界 == %@",self);
    return nil;
   
}

-(id)gbh_removeObjectAtIndex:(NSInteger)index{
    if (index < self.count) {
        return [self gbh_removeObjectAtIndex:index];
    }
    NSLog(@"%@ 越界",self);
    return nil;
}



@end

