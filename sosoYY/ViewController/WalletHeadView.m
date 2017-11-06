//
//  WalletHeadView.m
//  sosoYY
//
//  Created by zhy on 2017/5/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "WalletHeadView.h"

@implementation WalletHeadView

- (IBAction)swiftButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [self viewWithTag:i+100];
        btn.selected = NO;
    }
    
    button.selected = YES;
    [self layoutIfNeeded];
    self.bottomLineLeft.constant = (button.tag-100)*self.width/3;
    
    if (_walletTypeBlock) {
        _walletTypeBlock(button.tag);
    }
    
}

@end
