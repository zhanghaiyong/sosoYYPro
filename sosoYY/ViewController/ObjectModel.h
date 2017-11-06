//
//  ObjectModel.h
//  sosoYY
//
//  Created by zhy on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectModel : NSObject<MJKeyValue>

@property (nonatomic,assign)double couponmoney; //优惠券金额
@property (nonatomic,strong)NSString *balance;    //当前余额
@property (nonatomic,strong)NSString *paysn;      //交易单号
@property (nonatomic,strong)NSString *payfriendname;//支付方式
@property (nonatomic,strong)NSString *create_time;   //交易时间
@property (nonatomic,assign)double ordermoney;     //订单总金额
@property (nonatomic,assign)double surplusmoney;   //实际支付金额
@property (nonatomic,strong)NSString *type;     //收支类型
@property (nonatomic,strong)NSString *osn;     //订单编号
@property (nonatomic,assign)double paybalancemoney; //钱包支付

@property (nonatomic,strong)NSString *oid; //
@property (nonatomic,assign)double income_money; //

@end
