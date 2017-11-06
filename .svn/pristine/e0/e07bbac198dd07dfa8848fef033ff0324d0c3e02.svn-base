//
//  WisdomModel.m
//  sosoYY
//
//  Created by zhy on 17/1/18.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "WisdomModel.h"

@implementation WisdomModel

//实现这个方法，就会自动吧数组中的字典转化成对应的模型
+ (NSDictionary *)objectClassInArray {
    
    return @{@"li":[LiModel class]};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    WisdomModel * wisdomModel = [[[self class] allocWithZone:zone] init];
    wisdomModel.store_Id = self.store_Id;
    wisdomModel.store_Name = self.store_Name;
    wisdomModel.MoneySend = self.MoneySend;
    wisdomModel.MoneyFreePostage = self.MoneyFreePostage;
    wisdomModel.Postage = self.Postage;
    wisdomModel.Surplusmoney = self.Surplusmoney;
    wisdomModel.li = self.li;
    wisdomModel.Expand = self.Expand;
    
    return wisdomModel;
}

- (id)copyWithZone:(NSZone *)zone
{
    WisdomModel * wisdomModel = [[[self class] allocWithZone:zone] init];
    wisdomModel.store_Id = self.store_Id;
    wisdomModel.store_Name = self.store_Name;
    wisdomModel.MoneySend = self.MoneySend;
    wisdomModel.MoneyFreePostage = self.MoneyFreePostage;
    wisdomModel.Postage = self.Postage;
    wisdomModel.Surplusmoney = self.Surplusmoney;
    wisdomModel.li = self.li;
    wisdomModel.Expand = self.Expand;
    
    return wisdomModel;
}


@end
