//
//  StoreCartListModel.h
//  sosoYY
//
//  Created by zhy on 16/11/29.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreInfoModel.h"
@interface StoreCartListModel : NSObject<MJKeyValue>

@property (nonatomic,strong)NSString *fullCut;
@property (nonatomic,strong)NSString *productAmount;
@property (nonatomic,strong)NSString *OrderAmount;
@property (nonatomic,strong)NSArray  *CartProductList;
@property (nonatomic,strong)StoreInfoModel  *StoreInfo;
@end
