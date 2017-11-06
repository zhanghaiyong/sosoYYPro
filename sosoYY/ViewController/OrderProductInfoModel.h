//
//  CartProduceListModel.h
//  sosoYY
//
//  Created by zhy on 2017/6/15.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddPriceBuyModel.h"
#import "SpecialPriceModel.h"
#import "AddProductModel.h"
@interface OrderProductInfoModel : NSObject

@property (nonatomic,strong)NSString *jjgStatus;

@property (nonatomic,strong)NSString *BagCount;
@property (nonatomic,strong)NSString *BuyCount;
@property (nonatomic,strong)NSString *CostPrice;
@property (nonatomic,strong)NSString *ShopPrice;
@property (nonatomic,strong)NSString *DiscountPrice;
@property (nonatomic,strong)NSString *DrugsBase_ApprovalNumber;
@property (nonatomic,strong)NSString *DrugsBase_Manufacturer;
@property (nonatomic,strong)NSString *DrugsBase_ProName;
@property (nonatomic,strong)NSString *DrugsBase_Specification;
@property (nonatomic,strong)NSString *Goods_Package_ID;
@property (nonatomic,strong)NSString *Goods_Pcs;
@property (nonatomic,strong)NSString *Goods_Pcs_Small;
@property (nonatomic,strong)NSString *Goods_Unit;
@property (nonatomic,strong)NSString *IsSelect;
@property (nonatomic,strong)NSString *MarketPrice;
@property (nonatomic,strong)NSString *MinBuyNum;
@property (nonatomic,strong)NSString *Name;
@property (nonatomic,strong)NSString *Oid;
@property (nonatomic,strong)NSString *Pid;
@property (nonatomic,strong)NSString *Product_Pcs;
@property (nonatomic,strong)NSString *Product_Pcs_Small;
@property (nonatomic,strong)NSString *RecordId;
@property (nonatomic,strong)NSString *SellType;
@property (nonatomic,strong)NSString *SmallImageUrl;
@property (nonatomic,strong)NSString *StoreId;
@property (nonatomic,strong)NSString *Type;
@property (nonatomic,strong)NSString *addpricebuycoast;
@property (nonatomic,strong)NSString *addpricebuyid;
@property (nonatomic,strong)AddPriceBuyModel *addpricebuymodel;
@property (nonatomic,strong)NSString *addpricebuynum;
@property (nonatomic,strong)NSString *addpricebuypernum;
@property (nonatomic,strong)AddProductModel *addproduct;
@property (nonatomic,strong)NSString *orderproductstate;
@property (nonatomic,strong)NSString *pmid;
@property (nonatomic,strong)SpecialPriceModel *specialpricemodel;
@property (nonatomic,strong)NSString *stock;


@end
