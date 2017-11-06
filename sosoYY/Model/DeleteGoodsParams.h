//
//  DeleteGoodsParams.h
//  sosoYY
//
//  Created by zhy on 16/12/2.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteGoodsParams : NSObject

//商品编号
@property (nonatomic,strong)NSString *pid;
//批量删除商品的id,分割
@property (nonatomic,strong)NSString *pids;
//店铺id，如果有值，说明是删除店铺下面所有的品种
@property (nonatomic,strong)NSString *storeid;

@end
