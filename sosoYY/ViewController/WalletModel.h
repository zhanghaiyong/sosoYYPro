//
//  WalletModel.h
//  sosoYY
//
//  Created by zhy on 2017/5/25.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject

@property (nonatomic,strong)NSString *Row;
//余额
@property (nonatomic,strong)NSString *balance;
//业务类型
@property (nonatomic,strong)NSString *business_type;
//创建时间
@property (nonatomic,strong)NSString *creat_time;
@property (nonatomic,strong)NSString *expenditure_money;
//支出
@property (nonatomic,strong)NSString *from_uid;
//收入
@property (nonatomic,strong)NSString *income_money;
//订单号
@property (nonatomic,strong)NSString *oid;

@property (nonatomic,strong)NSString *uid;
//操作方式
@property (nonatomic,strong)NSString *payfriendname;
//操作方式
@property (nonatomic,strong)NSString *id;

@end
