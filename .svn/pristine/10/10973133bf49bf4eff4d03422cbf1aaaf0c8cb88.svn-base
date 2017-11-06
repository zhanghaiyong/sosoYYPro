//
//  STWisdomAddListTabBarView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomAddListTabBarView.h"

@implementation STWisdomAddListTabBarView

-(void)setWisdomAddListTabBarView:(STStorewideEntity *)entity{
    _lineLab.frame = CGRectMake(0, 0, kScreenWidth, .5);
    
    NSString *Total_Amount = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[entity.Total_Amount floatValue]]];
    _totalLab.text = [NSString stringWithFormat:@"商品金额总计:¥%@元",Total_Amount];
    
    NSString *lowestFreeShippingAmount = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[entity.lowestFreeShippingAmount floatValue]]];

    NSString *D_Amount = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[entity.D_Amount floatValue]]];
    
    if ([D_Amount intValue] > 0) {
      _balanceLab.text = [NSString stringWithFormat:@"还差:%@元达到店铺发货金额",D_Amount];
    }else{
        if ([Total_Amount floatValue] >= [lowestFreeShippingAmount floatValue]) {
          _balanceLab.text = [NSString stringWithFormat:@"已达店铺免邮金额"];
        }else{
        NSString *balance =[STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[lowestFreeShippingAmount floatValue] - [Total_Amount floatValue]]];
          _balanceLab.text = [NSString stringWithFormat:@"还差:%@元达到店铺包邮金额",balance];
        }
    }
}
- (IBAction)selectBack:(UIButton *)sender {
    if (_wisdomAddListTabBarViewBlock) {
        _wisdomAddListTabBarViewBlock();
    }
}

@end
