//
//  CustonAlertView.h
//  sosoYY
//
//  Created by zhy on 16/11/30.
//  Copyright © 2016年 felix. All rights reserved.
//

typedef void(^CustomAlertViewBlock)(void);

#import <UIKit/UIKit.h>

@interface CustonAlertView : UIView

@property (nonatomic,copy)CustomAlertViewBlock cusAlertViewBlock;

- (void)tapOKBtnMethod:(CustomAlertViewBlock )block;

- (instancetype)initWithFrame:(CGRect)frame withMsg:(NSString *)alertMsg;
- (void)startAnimation;
- (void)stopAnimation;
@end
