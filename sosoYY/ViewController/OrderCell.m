//
//  OrderCell.m
//  sosoYY
//
//  Created by zhy on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (IBAction)jumpToDetClick:(id)sender {
    if (_jumpToDetailBlock) {
        _jumpToDetailBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//取消订单
- (IBAction)cancleAction:(UIButton *)sender {

//    OrderCell *cell = (OrderCell *)[[sender superview] superview];
//    
//    if ([self.delegate respondsToSelector:@selector(cancelPayMethod:button:)]) {
//        [self.delegate cancelPayMethod:cell button:sender];
//    }
    
    if (_cancelBlock) {
        _cancelBlock(sender);
    }
    
}

//立即支付
- (IBAction)nowPayAction:(id)sender {
    
//    OrderCell *cell = (OrderCell *)[[sender superview] superview];
//    
//    if ([self.delegate respondsToSelector:@selector(nowPayMethod:)]) {
//        [self.delegate nowPayMethod:cell];
//    }
    
    
    if (_nowPayBlock) {
        _nowPayBlock();
    }
}
- (IBAction)checkWalletDet:(UIButton *)sender {
    
    if (_checkWalletDetBlock) {
        _checkWalletDetBlock();
    }
}

@end
