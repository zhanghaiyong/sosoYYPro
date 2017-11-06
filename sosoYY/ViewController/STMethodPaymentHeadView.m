//
//  STMethodPaymentHeadView.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STMethodPaymentHeadView.h"

@implementation STMethodPaymentHeadView

-(void)setMethodPayment:(id)dataResult{
    
    _serialNumberLab.text = dataResult[@"MasterOsnList"];
    
    _moneyNumerLab.text = [NSString stringWithFormat:@"¥%.2f",[dataResult[@"WaitPayMoney"] floatValue]];
    
    _lineLab.frame = CGRectMake(0, 59, kScreenWidth, .5);
}

@end
