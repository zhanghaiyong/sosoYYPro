//
//  LiOfOrderModel.h
//  sosoYY
//
//  Created by zhy on 2017/6/1.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiOfOrderModel : NSObject

// 0-不具备电子发票,1-灰电,2-蓝店
@property (nonatomic,assign)int fpTag;

//1是白条支付 0 不是白条支付
@property (nonatomic,assign)int blanknotepay;

//客户QQ
@property (nonatomic,strong)NSString *qq;

/// 订单总金额
@property (nonatomic,strong)NSString *surplusmoney;

/// 商品条目
@property (nonatomic,strong)NSString *productcount;

/// 下单时间
@property (nonatomic,strong)NSString *addtime;

/// 母订单id
@property (nonatomic,strong)NSString *parentid;

/// 订单编号
@property (nonatomic,strong)NSString *oid;

@property (nonatomic,strong)NSString *id;

/// 店铺名称
@property (nonatomic,strong)NSString *storename;

/// 发货差异数量
@property (nonatomic,strong)NSString *diffCount;

  /// 订单状态
@property (nonatomic,strong)NSString *orderstateInfo;

/// 冲红数量
@property (nonatomic,strong)NSString *orderproduct_hot;

/// 冲红单状态
@property (nonatomic,strong)NSString *orderstate_hot;

/// 订单来源
@property (nonatomic,strong)NSString *channelTypeInfo;

// 是否付款
@property (nonatomic,strong)NSString *isPay;
// 订单取消财务流水
@property (nonatomic,strong)NSString *transactionflow_userCancelId;
/// 订单发货差异财务流水
@property (nonatomic,strong)NSString *transactionflow_userDifflId;


@end
