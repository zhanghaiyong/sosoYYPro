//
//  ZHProgressHUD.h
//  House
//
//  Created by coffee on 15/9/15.
//  Copyright (c) 2015年 cylkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@class UIView;

@interface ZHProgressHUD : NSObject

+ (void)showAddedTo:(UIView *)view DEPRECATED_MSG_ATTRIBUTE("use show");
+ (void)showAddedTo:(UIView *)view text:(NSString *)text DEPRECATED_MSG_ATTRIBUTE("use showWithtext:");
+ (void)showAddedTo:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay DEPRECATED_MSG_ATTRIBUTE("Use showWithtext:afterDelay:");
+ (void)hideAddedFrom:(UIView *)view DEPRECATED_MSG_ATTRIBUTE("");
+ (void)showCompletedAddedTo:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay DEPRECATED_MSG_ATTRIBUTE("");

#pragma mark - show methods
+ (void)show;
+ (void)showWithMaskType:(SVProgressHUDMaskType)type;
+ (void)showWithtext:(NSString *)text;
+ (void)showWithtext:(NSString *)text dismissWithDelay:(NSTimeInterval)delay;
+ (void)showSuccessWithText:(NSString *)text dismissWithDelay:(NSTimeInterval)delay;
+ (void)showErrorWithText:(NSString *)text dismissWithDelay:(NSTimeInterval)delay;
+ (void)showInfoWithText:(NSString *)text dismissWithDelay:(NSTimeInterval)delay;

+ (void)showSuccessWithText:(NSString *)text;
+ (void)showErrorWithText:(NSString *)text;
+ (void)showInfoWithText:(NSString *)text;

+ (void)setStatus:(NSString *)text;

#pragma mark - dismiss methods
+ (void)dismiss;
+ (void)dismissWithDelay:(NSTimeInterval)delay;
+ (void)dismissWithDelay:(NSTimeInterval)delay complete:(void(^)())block;

@end
