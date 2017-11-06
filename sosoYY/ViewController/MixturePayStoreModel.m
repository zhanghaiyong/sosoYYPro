//
//  MixturePayModel.m
//  sosoYY
//
//  Created by zhy on 2017/8/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "MixturePayStoreModel.h"

@implementation MixturePayStoreModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"OrderProductList":[MixturePayGoodsModel class]};
}

@end
