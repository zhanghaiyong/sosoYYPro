//
//  BottomToolView.h
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//


typedef void(^goBalanceblock)(void);
typedef void(^selectAllBlock)(BOOL select);
#import <UIKit/UIKit.h>

@interface BottomToolView : UIView

@property (weak, nonatomic) IBOutlet UILabel *totalCash;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *allSelectLabel;
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBalanceButton;

@property (nonatomic,copy)goBalanceblock toBalanceBlock;
@property (nonatomic,copy)selectAllBlock selectAllBlock;

- (void)toBalanceMethod:(goBalanceblock)block;
- (void)selectAllMethod:(selectAllBlock)block;
@end
