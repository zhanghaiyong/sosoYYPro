//
//  AnimationView.h
//  sosoYY
//
//  Created by zhy on 2017/7/12.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

@property (nonatomic,copy)void (^foldAnimationBlock)(BOOL openAnimation);

@property (nonatomic,copy)void (^searchScanBlock)(NSInteger row);

@end
