//
//  NSObject+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSObject+XTExtension.h"
#import "NSString+XTExtension.h"
#import "NSDate+XTExtension.h"
#import <objc/runtime.h>


@implementation NSObject (XTAccociated)


//关联对象
- (id)object{
	return [self associatedObjectForKey:"AssociatedObject"];
}

- (void)setObject:(id)object{
	[self setAssociatedObject:object forkey:"AssociatedObject"];
}

- (id)associatedObjectForKey:(const char *)key{
	return objc_getAssociatedObject(self, key);
}
- (void)setAssociatedObject:(id)object forkey:(const char *)key{
	objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedBlockForKey:(const char *)key{
	return objc_getAssociatedObject(self, key);
}
- (void)setAssociatedBlock:(id)object forkey:(const char *)key{
	objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation NSObject (XTConversion)

- (NSData *)toData{
    if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSAssert(NO, @"该类型（%@）不能转换为NSData类型",[self class]);
    return nil;
}

- (NSDate *)toDate{
    if ( [self isKindOfClass:[NSDate class]] ){
		return (NSDate *)self;
	}
    
    if ([self isKindOfClass:[NSNumber class]]){
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)self doubleValue]];
	}
    
    if ([self isKindOfClass:[NSString class]]){
		return [(NSString *)self dateWithFormate:@"yyyy-MM-dd HH:mm:ss"];
	}
    
    NSAssert(NO, @"该类型（%@）不能转换为NSDate类型",[self class]);
    return nil;
}

- (NSDate *)toDate1{
    if ( [self isKindOfClass:[NSDate class]] ){
        return (NSDate *)self;
    }
    
    if ([self isKindOfClass:[NSNumber class]]){
        return [NSDate dateWithTimeIntervalSince1970:([(NSNumber *)self doubleValue])];
    }
    
    if ([self isKindOfClass:[NSString class]]){
        return [(NSString *)self dateWithFormate:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSAssert(NO, @"该类型（%@）不能转换为NSDate类型",[self class]);
    return nil;
}

- (NSNumber *)toNumber{
	if ([self isKindOfClass:[NSNumber class]]){
		return (NSNumber *)self;
	}
    
    if ([self isKindOfClass:[NSDate class]]){
		return [NSNumber numberWithDouble:[(NSDate *)self timeIntervalSince1970]];
	}
    
    if ([self isKindOfClass:[NSString class]]){
		return [NSNumber numberWithDouble:[(NSString *)self doubleValue]];
	}
    
    NSAssert(NO, @"该类型（%@）不能转换为NSNumber类型",[self class]);
	return nil;
}

- (NSString *)toString{
	if ([self isKindOfClass:[NSString class]]){
		return (NSString *)self;
	}
    
    if ([self isKindOfClass:[NSData class]]){
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
	}
    
    if ([self isKindOfClass:[NSNumber class]]){
		return [(NSNumber *)self stringValue];
	}
    
    if ([self isKindOfClass:[NSDate class]]){
		return [(NSDate *)self stringWithFormate:@"yyyy-MM-dd HH:mm:ss"];
	}
    
    return self.description;
}

- (NSString *)toIntegerString{
    
    if ([self isKindOfClass:[NSString class]]){
        return (NSString *)self;
    }
    
    if ([self isKindOfClass:[NSData class]]){
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    
    if ([self isKindOfClass:[NSNumber class]]){
        return [@([(NSNumber *)self integerValue]) stringValue];
    }
    
    if ([self isKindOfClass:[NSDate class]]){
        return [(NSDate *)self stringWithFormate:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return self.description;
}

@end


@implementation NSObject (XTTimer)

- (void)stopTimer{
    NSTimer *timer = objc_getAssociatedObject(self, "timerKey");
    if (timer) {
        [timer invalidate];
    }
    
    objc_setAssociatedObject(self, "timerKey", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "timesKey", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "timerActionBlockKey", nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, "timerCompleteBlockKey", nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)startTimerDuration:(NSTimeInterval)duration times:(NSInteger)times
                    action:(TimerActionBlock)actionBlock
                  complete:(TimerCompleteBlock)completeBlock{
    [self stopTimer];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:duration
                                             target:self
                                           selector:@selector(timerRepeatAction:)
                                           userInfo:nil
                                            repeats:YES];
    NSNumber *timers = [NSNumber numberWithUnsignedInteger:times];
    
	objc_setAssociatedObject(self, "timerKey", timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, "timesKey", timers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, "timerActionBlockKey", actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	objc_setAssociatedObject(self, "timerCompleteBlockKey", completeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerRepeatAction:(NSTimer *)timer{
    NSNumber *timesNumber = objc_getAssociatedObject(self, "timesKey");
    NSUInteger timers = [timesNumber unsignedIntegerValue];
    
    timers--;
    if (timers>0) {
        timesNumber = [NSNumber numberWithUnsignedInteger:timers];
        objc_setAssociatedObject(self, "timesKey", timesNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        TimerActionBlock actionBlock = objc_getAssociatedObject(self, "timerActionBlockKey");
        if (actionBlock) {
            actionBlock(timers);
        }
    } else {
        
        TimerCompleteBlock completeBlock = objc_getAssociatedObject(self, "timerCompleteBlockKey");
        if (completeBlock) {
            completeBlock();
        }
        [self stopTimer];
    }
}

@end


@implementation NSObject (XTNotification)

- (void)registerNotification:(NSString *)name object:(id)object selector:(SEL)selector{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:object];
}
- (void)removeNotification:(NSString *)name{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}
- (void)removeAllNotifications{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString *)name{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}
- (void)postNotification:(NSString *)name object:(NSObject *)object{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

@end


@implementation NSObject (XTKeyboard)

- (void)observeKeyboard{
    NSNotificationCenter *keyboardNoti = [NSNotificationCenter defaultCenter];
    [keyboardNoti addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [keyboardNoti addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardDidShowNotification object:nil];
    [keyboardNoti addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [keyboardNoti addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)unObserveKeyboard{
    NSNotificationCenter *keyboardNoti = [NSNotificationCenter defaultCenter];
	[keyboardNoti removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[keyboardNoti removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[keyboardNoti removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[keyboardNoti removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

//处理键盘通知
- (void)handleKeyboardNotification:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    //    CGRect beginFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        [self keyboardWillShow:endFrame duration:duration curve:curve];
    }else if ([notification.name isEqualToString:UIKeyboardDidShowNotification]) {
        [self keyboardDidShow:endFrame duration:duration curve:curve];
    }else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        [self keyboardWillHide:endFrame duration:duration curve:curve];
    }else if ([notification.name isEqualToString:UIKeyboardDidHideNotification]) {
        [self keyboardDidHide:endFrame duration:duration curve:curve];
    }
}

- (void)keyboardWillShow:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve{
}
- (void)keyboardDidShow:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve{
}
- (void)keyboardWillHide:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve{
}
- (void)keyboardDidHide:(CGRect)frame duration:(NSTimeInterval)duration curve:(NSUInteger)curve{
}

@end
