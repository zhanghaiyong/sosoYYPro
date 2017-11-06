//
//  ListModel.h
//  sosoYY
//
//  Created by zhy on 16/11/29.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreCartListModel.h"
@interface ListModel : NSObject<MJKeyValue>

@property (nonatomic,strong)NSString *TotalCount;
@property (nonatomic,strong)NSString *ProductAmount;
@property (nonatomic,strong)NSString *FullCut;
@property (nonatomic,strong)NSString *OrderAmount;
@property (nonatomic,strong)NSArray *StoreCartList;

@end
