//
//  STOrderDetailsOutboundScetion0HeadView.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STOrderDetailsHeadView.h"

@implementation STOrderDetailsHeadView

-(void)setOrderDetails:(NSString *)storename{
    _storenameLab.text = storename;
    
    _lineLab.frame = CGRectMake(0, 39, kScreenWidth, .5);
}
- (IBAction)setDetails:(UIButton *)sender {
    
    if (_OrderDetailsBlock) {
        _OrderDetailsBlock();
    }
}

@end
