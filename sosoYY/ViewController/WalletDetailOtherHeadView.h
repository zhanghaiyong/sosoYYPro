//
//  WalletDetailOtherHeadView.h
//  sosoYY
//
//  Created by zhy on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletDetailOtherHeadView : UIView

/*****************SectionOther**************************************/
@property (weak,nonatomic)IBOutlet UIButton *OrderCode;
@property (weak,nonatomic)IBOutlet NSLayoutConstraint *ViewH1;
@property (weak,nonatomic)IBOutlet NSLayoutConstraint *ViewH2;

@property (nonatomic,copy)void(^jumpToOrderDetailBlock)(void);

@end
