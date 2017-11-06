//
//  MixturePayGoodsModel.h
//  sosoYY
//
//  Created by zhy on 2017/8/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixturePayGoodsModel : NSObject
//加价购描述
@property (nonatomic,strong)NSString *AddPriceDes;
//是否加价购：1-是
@property (nonatomic,strong)NSString *AddPriceTag;
//购买数量
@property (nonatomic,strong)NSString *BuyCount;
//特价
@property (nonatomic,strong)NSString *DiscountPrice;
//规格
@property (nonatomic,strong)NSString *DrugsBase_Specification;
//商品名称
@property (nonatomic,strong)NSString *ProductName;
//原价
@property (nonatomic,strong)NSString *ShopPrice;
//是否特价：1-是
@property (nonatomic,strong)NSString *SpelPriceTag;

@end
