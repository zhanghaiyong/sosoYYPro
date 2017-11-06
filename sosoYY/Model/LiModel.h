//
//  LiModel.h
//  sosoYY
//
//  Created by zhy on 17/1/18.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchasetAddPricePromotionsModel.h"
#import "purchasetSpecialPricePromotionsModel.h"
@interface LiModel : NSObject<MJKeyValue,NSMutableCopying,NSCopying>

//商品是否选中
@property (nonatomic,strong)NSString *isSelect;

//加价购商品是否选中
//@property (nonatomic,assign)BOOL isCheckedExchangeGood;

@property (nonatomic,assign)BOOL isBadGood;

@property (nonatomic,strong)NSString *id;
/// 会员编号
@property (nonatomic,strong)NSString *userid;
/// erp编号
@property (nonatomic,strong)NSString *psn;
 /// 平台件装编号
@property (nonatomic,strong)NSString *Goods_Package_ID;
/// 首字母
@property (nonatomic,strong)NSString *PreChar;
/// 生产厂家
@property (nonatomic,strong)NSString *DrugsBase_Manufacturer;
 /// 商品名
@property (nonatomic,strong)NSString *DrugsBase_ProName;
/// 通用名
@property (nonatomic,strong)NSString *DrugsBase_DrugName;
/// 销售单位
@property (nonatomic,strong)NSString *Goods_Unit;
/// 剂型
@property (nonatomic,strong)NSString *DrugsBase_Specification;
/// 产品库存
@property (nonatomic,strong)NSString *stock;
/// 最近采购日期
@property (nonatomic,strong)NSString *LastTime;
/// 字符时间
@property (nonatomic,strong)NSString *LastTimeString;
 /// 历史采购价格
@property (nonatomic,strong)NSString *HistoryPrice;
///月销售量
@property (nonatomic,strong)NSString *SalesVolume;
/// 能购买到的最低的价格
@property (nonatomic,strong)NSString *minPrice;
/// 能买到的最高价格
@property (nonatomic,strong)NSString *maxPrice;
 /// 采购优先级
@property (nonatomic,strong)NSString *priority;
/// 商品条码
@property (nonatomic,strong)NSString *Barcode;
/// 购买数量
@property (nonatomic,strong)NSString *buyCount;
/// 店铺编号
@property (nonatomic,strong)NSString *store_Id;
/// 店铺名称
@property (nonatomic,strong)NSString *store_Name;
/// 最小购买数量
@property (nonatomic,strong)NSString *minBuy;
/// 商品效期
@property (nonatomic,strong)NSString *sxrq;

@property (nonatomic,strong)NSString *IsJxq;

@property (nonatomic,strong)NSString *myStock;

// 商品编号
@property (nonatomic,strong)NSString *pid;
@property (nonatomic,strong)NSString *Price;
//销售方式 1,不限制，2中包装，3件装
@property (nonatomic,strong)NSString *sellType;
//件装
@property (nonatomic,strong)NSString *Product_Pcs;
//中包装
@property (nonatomic,strong)NSString *Product_Pcs_Small;
/// 快捷购买数量
@property (nonatomic,strong)NSArray  *buyNumList;

// 品种来源 0 默认来源客户erp 1 凑单商品 2 搜索添加
@property (nonatomic,strong)NSString *source;

//如果选中了加价，则存储加价购的规则id,没有则存零
@property (nonatomic,strong)NSString *pmid;

//是否是特价商品 0不是，1 是
@property (nonatomic,strong)NSString *PricePromotionsTypes;

//是否是加价购 0 否 1 是
@property (nonatomic,strong)NSString *PromotionTypes;

//促销信息(加价购)
@property (nonatomic,strong)NSArray *purchasetAddPricePromotionsList;

//促销信息(特价)
@property (nonatomic,strong)purchasetSpecialPricePromotionsModel *purchasetSpecialPricePromotions;

@property (nonatomic,assign)CGFloat cellHeight;



@end