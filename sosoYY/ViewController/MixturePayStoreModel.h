//
//  MixturePayModel.h
//  sosoYY
//
//  Created by zhy on 2017/8/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixturePayGoodsModel.h"
@interface MixturePayStoreModel : NSObject<MJKeyValue>
//店铺名称
@property (nonatomic,strong)NSString *StoreName;

//小计
@property (nonatomic,strong)NSString *StoreOrderAmount;

//邮费
@property (nonatomic,strong)NSString *StoreShipFee;

//店铺包含的商品
@property (nonatomic,strong)NSArray *OrderProductList;
@end
