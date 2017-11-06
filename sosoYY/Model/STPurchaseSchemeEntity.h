//
//  STPurchaseSchemeEntity.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STPurchaseSchemeEntity : NSObject
@property(strong,nonatomic)NSString *SchemeName; /// 方案名称
@property(strong,nonatomic)NSString *EconomizeTime;  /// 节约时间
@property(strong,nonatomic)NSString *EconomizeMoney;  /// 节约金钱
@property(strong,nonatomic)NSString *SuperiorityNum;/// 多少个品种低于原采购价格
@property(strong,nonatomic)NSString *StoresCount;/// 在多少个店铺采购
@property(strong,nonatomic)NSString *Postage;/// 邮费
@property(strong,nonatomic)NSString *SurplusMoney; /// 合计
@property(strong,nonatomic)NSString *mismatching; /// 不匹配的品种数量
@property(strong,nonatomic)NSString *Count; /// 商品数

@end
