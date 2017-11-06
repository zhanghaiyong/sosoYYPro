//
//  STWisdomProcurementEntity.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STWisdomEntity : NSObject

@property(strong,nonatomic)NSString *memberID;// 序列编号
@property(strong,nonatomic)NSString *userid;/// erp编号
@property(strong,nonatomic)NSString *psn;//平台件装编号
@property(strong,nonatomic)NSString *Goods_Package_ID;
@property(strong,nonatomic)NSString *PreChar; /// 首字母
@property(strong,nonatomic)NSString *DrugsBase_Manufacturer; /// 生产厂家
@property(strong,nonatomic)NSString *DrugsBase_ProName;  /// 商品名
@property(strong,nonatomic)NSString *DrugsBase_DrugName;  /// 通用名
@property(strong,nonatomic)NSString *DrugsBase_Formulation;  /// 剂型
@property(strong,nonatomic)NSString *Goods_Unit; /// 销售单位
@property(strong,nonatomic)NSString *DrugsBase_Specification;
@property(strong,nonatomic)NSString *DrugsBase_ApprovalNumber;
@property(strong,nonatomic)NSString *stock;
@property(strong,nonatomic)NSString *LastTime;
@property(strong,nonatomic)NSString *LastTimeString;
@property(strong,nonatomic)NSString *HistoryPrice;
@property(strong,nonatomic)NSString *SalesVolume;
@property(strong,nonatomic)NSString *minPrice;
@property(strong,nonatomic)NSString *maxPrice;
@property(strong,nonatomic)NSString *priority;
@property(strong,nonatomic)NSArray *buyNumList;
@property(strong,nonatomic)NSString *Barcode;
@property(strong,nonatomic)NSString *buyCount;
@property(strong,nonatomic)NSString *store_Id;
@property(strong,nonatomic)NSString *store_Name;
@property(strong,nonatomic)NSString *minBuy;
@property(strong,nonatomic)NSString *sxrq;
@property(strong,nonatomic)NSString *pid;
@property(strong,nonatomic)NSString *Price;
@property(strong,nonatomic)NSString *sellType;
@property(strong,nonatomic)NSString *Product_Pcs;
@property(strong,nonatomic)NSString *Product_Pcs_Small;
@property(strong,nonatomic)NSString *supplierName;
@property(strong,nonatomic)NSMutableArray *dataAryTwo;
@property(strong,nonatomic)NSString *myStock;//库存
@property(strong,nonatomic)NSString *buyNumListStr;
@property(strong,nonatomic)NSDate *mTimestamp;
//加价购方案
@property(strong,nonatomic)NSString *pmid;
@property(strong,nonatomic)NSString *speprice;
@property(strong,nonatomic)NSString *isSelect;//是否选中
@property(strong,nonatomic)NSString *YesterdayNoStock;//是否昨日断货

@end
