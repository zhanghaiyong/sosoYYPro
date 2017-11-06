//
//  ShopCartHead.h
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//

typedef void(^HeadSelectBlock)(BOOL select);
//删除药铺
typedef void(^DeleteStoreBlock)(void);

//进入店铺
typedef void(^IntoStoreBlock)(void);

#import <UIKit/UIKit.h>
#import "StoreInfoModel.h"
@interface ShopCartHead : UIView<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *storeName;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *lousImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lousImgW;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ShippingH;
//发货金额
@property (weak, nonatomic) IBOutlet UILabel *ShippingCount;
//包邮金额
@property (weak, nonatomic) IBOutlet UILabel *postageCount;
//包邮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PinkageH;

@property (nonatomic,strong)StoreInfoModel *StoreInfo;

@property (nonatomic,copy)HeadSelectBlock headSelectBlock;
@property (nonatomic,copy)DeleteStoreBlock  deleteStoreBlock;
@property (nonatomic,copy)IntoStoreBlock  intoStoreBlock;
- (void)headSelect:(HeadSelectBlock) block;
- (void)deleteStoreMethod:(DeleteStoreBlock)block;
- (void)intoStoreMethod:(IntoStoreBlock)block;
@end
