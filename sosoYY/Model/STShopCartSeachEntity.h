//
//  STShopCartSeachEntity.h
//  sosoYY
//
//  Created by soso-mac on 2017/8/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STShopCartSeachEntity : NSObject
// 序列编号
@property(strong,nonatomic)NSString *memberID;
/// <summary>
/// 会员编号
/// </summary>
@property(strong,nonatomic)NSString *userid;
/// <summary>
/// erp编号
/// </summary>
@property(strong,nonatomic)NSString *psn;
/// <summary>
/// 平台件装编号
/// </summary>
@property(strong,nonatomic)NSString *Goods_Package_ID;
/// <summary>
/// 首字母
/// </summary>
@property(strong,nonatomic)NSString *PreChar;
/// <summary>
/// 生产厂家
/// </summary>
@property(strong,nonatomic)NSString *DrugsBase_Manufacturer;
/// <summary>
/// 商品名
/// </summary>
@property(strong,nonatomic)NSString *DrugsBase_ProName;
/// <summary>
/// 通用名
/// </summary>
@property(strong,nonatomic)NSString *DrugsBase_DrugName;
/// <summary>
/// 剂型
/// </summary>
@property(strong,nonatomic)NSString *DrugsBase_Formulation;
/// <summary>
/// 销售单位
/// </summary>
@property(strong,nonatomic)NSString *Goods_Unit;
/// <summary>
/// 规格
/// </summary>
@property(strong,nonatomic)NSString *DrugsBase_Specification;
/// <summary>
/// 批文
/// </summary>
@property(strong,nonatomic)NSString *DrugsBase_ApprovalNumber;
/// <summary>
/// 产品库存
/// </summary>
@property(strong,nonatomic)NSString *stock;
/// <summary>
/// 最近采购日期
/// </summary>
@property(strong,nonatomic)NSString *LastTime;
/// <summary>
/// 字符时间
/// </summary>
@property(strong,nonatomic)NSString *LastTimeString;
/// <summary>
/// 历史采购价格
/// </summary>
@property(strong,nonatomic)NSString *HistoryPrice;

/// <summary>
/// 月销售量
/// </summary>
@property(strong,nonatomic)NSString *SalesVolume;

/// <summary>
/// 能购买到的最低的价格
/// </summary>
@property(strong,nonatomic)NSString *minPrice;
/// <summary>
/// 能买到的最高价格
/// </summary>
@property(strong,nonatomic)NSString *maxPrice;

/// <summary>
/// 采购优先级
/// </summary>
@property(strong,nonatomic)NSString *priority;

/// <summary>
/// 快捷购买数量
/// </summary>
@property(strong,nonatomic)NSArray *buyNumList;

/// <summary>
/// 商品条码
/// </summary>
@property(strong,nonatomic)NSString *Barcode;

/// <summary>
/// 购买数量
/// </summary>
@property(strong,nonatomic)NSString *buyCount;

/// <summary>
/// 供应商名称
/// </summary>
@property(strong,nonatomic)NSString *supplierName;

/// <summary>
/// 客户erp中的库存数量
/// </summary>
@property(strong,nonatomic)NSString *myStock;

/// <summary>
/// 是否标品
/// </summary>
@property(strong,nonatomic)NSString *IsStandard;

/// <summary>
/// 店铺编号
/// </summary>
@property(strong,nonatomic)NSString *store_Id;
/// <summary>
/// 店铺名称
/// </summary>
@property(strong,nonatomic)NSString *store_Name;
/// <summary>
/// 最小购买数量
/// </summary>
@property(strong,nonatomic)NSString *minBuy;
/// <summary>
/// 商品效期
/// </summary>
@property(strong,nonatomic)NSString *sxrq;
/// <summary>
/// 商品编号
/// </summary>
@property(strong,nonatomic)NSString *pid;
/// <summary>
/// 采购价格
/// </summary>
@property(strong,nonatomic)NSString *Price;
/// <summary>
/// 销售方式 销售方式 1,不限制，2中包装，3件装
/// </summary>
@property(strong,nonatomic)NSString *sellType;
/// <summary>
/// 件装
/// </summary>
@property(strong,nonatomic)NSString *Product_Pcs;
/// <summary>
/// 中包装
/// </summary>
@property(strong,nonatomic)NSString *Product_Pcs_Small;

/// <summary>
/// 品种来源 0 默认来源客户erp 1 凑单商品
/// </summary>
@property(strong,nonatomic)NSString *source;

/// <summary>
/// 如果选中了加价，则存储加价购的规则id,没有则存零
/// </summary>
@property(strong,nonatomic)NSString *pmid;

/// <summary>
/// 是否是特价商品 0不是，1 是
/// </summary>
@property(strong,nonatomic)NSString *PricePromotionsTypes;

/// <summary>
/// 是否是加价购 0 否 1 是
/// </summary>
@property(strong,nonatomic)NSString *PromotionTypes;

/// <summary>
/// 促销信息(加价购信息列表)
/// </summary>
@property(strong,nonatomic)NSArray *purchasetAddPricePromotionsList;
/// <summary>
/// 促销信息(特价)
/// </summary>
@property(strong,nonatomic)NSDictionary *purchasetSpecialPricePromotions;

/// <summary>
/// 是否近效期
/// </summary>
@property(strong,nonatomic)NSString *IsJxq;

/// <summary>
/// 智慧采购执行的特价
/// </summary>
@property(strong,nonatomic)NSString *speprice;

/// <summary>
/// 是否选中
/// </summary>
@property(strong,nonatomic)NSString *isSelect;

/// <summary>
/// 是否昨日断货
/// </summary>
@property(strong,nonatomic)NSString *YesterdayNoStock;

/// <summary>
/// 购物车中是否选中
/// </summary>
@property(strong,nonatomic)NSString *isSelectForCart;

@property(strong,nonatomic)NSString *Total_Amount;//商品合计金额

@property(strong,nonatomic)NSString *D_Amount;//还差多少元

@property(strong,nonatomic)NSString *lowestFreeShippingAmount;//免邮金额

@end
