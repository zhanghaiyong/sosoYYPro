//
//  STPaymentDetailsBtnView.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STPaymentDetailsBtnView.h"


@interface STPaymentDetailsBtnView ()


@end

@implementation STPaymentDetailsBtnView

-(instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubBtn:type];
    }
    return self;
}

-(void)setSubBtn:(NSInteger)type{
    
    _numLab = [UILabel new];
    _numLab.textColor = [UIColor fromHexValue:0xea5413];
    _numLab.frame = CGRectMake(10, 0, kScreenWidth - 130, 50);
    _numLab.text = @"实付总额:¥0";
    _numLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:_numLab];
    

        _finisgdeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _finisgdeBtn.frame = CGRectMake(kScreenWidth - 120, 0, 120, 50);
        [_finisgdeBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (type == 1) {
      [_finisgdeBtn setTitle: @"立即支付"forState:UIControlStateNormal];
    }else{
       [_finisgdeBtn setTitle: @"提交订单"forState:UIControlStateNormal];
    }
    
        _finisgdeBtn.backgroundColor = [UIColor fromHexValue:0xea5413];
        [_finisgdeBtn setTitleColor:RGB(225, 225, 225) forState:UIControlStateNormal];
        [self addSubview:_finisgdeBtn];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, 0, kScreenWidth, .5);
    line.backgroundColor = [UIColor fromHexValue:0xe5e5e5];
    [self addSubview:line];
}
#pragma mark --btn - mothed
-(void)selectBtn:(UIButton *)btn{
    if (_PaymentDetailsBtnBlock != nil) {
        _PaymentDetailsBtnBlock();
    }
}

-(void)setPaymentDetails:(NSString *)num{
   _numLab.text = [NSString stringWithFormat:@"实付总额:¥%.2f",num.floatValue];
}
@end
