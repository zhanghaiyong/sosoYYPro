//
//  STShopCartSearchUndoView.h
//  sosoYY
//
//  Created by soso-mac on 2017/8/10.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShopCartSearchUndoView : UIView

@property(strong,nonatomic)UILabel *undoMsg;

@property(copy,nonatomic)void(^undoBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame;
@end
