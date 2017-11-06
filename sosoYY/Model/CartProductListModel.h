//
//  CartProductListModel.h
//  sosoYY
//
//  Created by zhy on 16/11/30.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderProductInfoModel.h"
@interface CartProductListModel : NSObject

@property (nonatomic,assign)BOOL IsSelected;
@property (nonatomic,strong)OrderProductInfoModel *OrderProductInfo;

@end
