//
//  ZHProgressHUD.m
//  House
//
//  Created by coffee on 15/9/15.
//  Copyright (c) 2015年 cylkj. All rights reserved.
//

#import "ZHProgressHUD.h"

@implementation ZHProgressHUD

+ (void)load {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.8]];
}

+ (void)showAddedTo:(UIView *)view {
    [SVProgressHUD showWithStatus:@"加载中"];
}

+ (void)showAddedTo:(UIView *)view text:(NSString *)text {
    [SVProgressHUD showWithStatus:text];
}

+ (void)hideAddedFrom:(UIView *)view {
   [SVProgressHUD dismiss];
}

+ (void)showCompletedAddedTo:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay {
    [SVProgressHUD showSuccessWithStatus:text];
    [SVProgressHUD dismissWithDelay:delay];
}

+ (void)showAddedTo:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay {
    [SVProgressHUD showWithStatus:text];
    [SVProgressHUD dismissWithDelay:delay];
}

#pragma mark - new methods

+ (void)show {
    [SVProgressHUD showWithStatus:@"加载中"];
}

+ (void)showWithMaskType:(SVProgressHUDMaskType)type {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"加载中"];
}

+ (void)showWithtext:(NSString *)text {
    [SVProgressHUD showWithStatus:text];
}

+ (void)showWithtext:(NSString *)text dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD showWithStatus:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showSuccessWithText:(NSString *)text dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD showSuccessWithStatus:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showErrorWithText:(NSString *)text dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD showErrorWithStatus:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showInfoWithText:(NSString *)text dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD showInfoWithStatus:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showSuccessWithText:(NSString *)text {
    [SVProgressHUD showSuccessWithStatus:text];
}

+ (void)showErrorWithText:(NSString *)text {
   [SVProgressHUD showErrorWithStatus:text];
}

+ (void)showInfoWithText:(NSString *)text {
    [SVProgressHUD showInfoWithStatus:text];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD dismissWithDelay:delay];
}

+ (void)setStatus:(NSString *)text {
    [SVProgressHUD setStatus:text];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay complete:(void(^)())block {
	
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        block();
    });
    
}








@end








