//
//  orderproductlistModel.m
//  sosoYY
//
//  Created by zhy on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "orderproductlistModel.h"

@implementation orderproductlistModel

//实现这个方法，就会自动吧数组中的字典转化成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"orderproductlist":[ProduceDetailListModel class]};
}


@end
