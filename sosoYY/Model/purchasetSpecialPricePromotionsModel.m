//
//  purchasetSpecialPricePromotionsModel.m
//  sosoYY
//
//  Created by zhy on 17/3/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "purchasetSpecialPricePromotionsModel.h"

@implementation purchasetSpecialPricePromotionsModel
-(id)copyWithZone:(NSZone *)zone {

    purchasetSpecialPricePromotionsModel *model = [[[self class] allocWithZone:zone] init];
    
    //特价规则说明
    model.name = self.name;
    
    // 品种特价
    model.speprice = self.speprice;
    
    // 品种原价
    model.shopprice = self.shopprice;
    
    // 特价限制类型：0-不限，1-每人限购，2-每人每天限购
    model.limittype = self.limittype;
    
    // 限购数量
    model.limitnumber = self.limitnumber;
    
    // 当天能买了多少
    model.TodayNumber = self.TodayNumber;
    
    // 共计买了多少
    model.TotalNumber = self.TotalNumber;
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    
    purchasetSpecialPricePromotionsModel *model = [[[self class] allocWithZone:zone] init];
    
    //特价规则说明
    model.name = self.name;
    
    // 品种特价
    model.speprice = self.speprice;
    
    // 品种原价
    model.shopprice = self.shopprice;
    
    // 特价限制类型：0-不限，1-每人限购，2-每人每天限购
    model.limittype = self.limittype;
    
    // 限购数量
    model.limitnumber = self.limitnumber;
    
    // 当天能买了多少
    model.TodayNumber = self.TodayNumber;
    
    // 共计买了多少
    model.TotalNumber = self.TotalNumber;
    return model;
}
@end
