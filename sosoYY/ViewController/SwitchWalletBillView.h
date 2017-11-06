//
//  SwitchWalletBillView.h
//  sosoYY
//
//  Created by zhy on 2017/5/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchWalletBillView : UIView<UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)array;

@property (nonatomic,copy)void(^switchTableBlock)(NSInteger indexRow);
@property (nonatomic,copy)void(^removeMaskBlock)(void);

@end
