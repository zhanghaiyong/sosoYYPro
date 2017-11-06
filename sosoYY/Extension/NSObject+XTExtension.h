//
//  NSObject+XTExtension.h
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//


#undef	SAFE_RELEASE
#define SAFE_RELEASE(object)            [object release];object=nil

typedef void (^TimerActionBlock)(NSUInteger times);
typedef void (^TimerCompleteBlock)(void);

@interface NSObject (XTAccociated)

- (id)object;
- (void)setObject:(id)object;

- (id)associatedObjectForKey:(const char *)key;
- (void)setAssociatedObject:(id)object forkey:(const char *)key;

- (id)associatedBlockForKey:(const char *)key;
- (void)setAssociatedBlock:(id)object forkey:(const char *)key;

@end

@interface NSObject (XTConversion)

- (NSData *)toData;
- (NSDate *)toDate;
- (NSDate *)toDate1;
- (NSNumber *)toNumber;
- (NSString *)toString;
- (NSString *)toIntegerString;
@end


@interface NSObject (XTTimer)
//停止定时器
- (void)stopTimer;
//开始一个定时器
- (void)startTimerDuration:(NSTimeInterval)duration times:(NSInteger)times
                    action:(TimerActionBlock)durationBlock
                  complete:(TimerCompleteBlock)completeBlock;

@end


@interface NSObject (XTNotification)

- (void)registerNotification:(NSString *)name object:(id)object selector:(SEL)selector;
- (void)removeNotification:(NSString *)name;
- (void)removeAllNotifications;

- (void)postNotification:(NSString *)name;
- (void)postNotification:(NSString *)name object:(NSObject *)object;

@end


@interface NSObject (XTKeyboard)

- (void)observeKeyboard;
- (void)unObserveKeyboard;

- (void)keyboardWillShow:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve;
- (void)keyboardDidShow:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve;
- (void)keyboardWillHide:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve;
- (void)keyboardDidHide:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve;

@end