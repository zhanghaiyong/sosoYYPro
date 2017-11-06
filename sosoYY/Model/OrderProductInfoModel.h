//
//  OrderProductInfoModel.h
//  sosoYY
//
//  Created by zhy on 16/11/30.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProductInfoModel : NSObject
@property (nonatomic,strong)NSString *Name;
@property (nonatomic,strong)NSString *ShopPrice;
@property (nonatomic,strong)NSString *DiscountPrice;
@property (nonatomic,strong)NSString *BuyCount;
@property (nonatomic,strong)NSString *DrugsBase_Specification;
@property (nonatomic,strong)NSString *DrugsBase_Manufacturer;
@property (nonatomic,strong)NSString *DrugsBase_ApprovalNumber;
@property (nonatomic,strong)NSString *SmallImageUrl;
@property (nonatomic,strong)NSString *SellType;
@property (nonatomic,strong)NSString *Goods_Pcs;
@property (nonatomic,strong)NSString *Goods_Pcs_Small;
@property (nonatomic,strong)NSString *Goods_Unit;

@end
