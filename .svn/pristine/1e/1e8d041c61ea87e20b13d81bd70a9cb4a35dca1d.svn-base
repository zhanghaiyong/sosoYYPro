//
//  BottomToolView.m
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "BottomToolView.h"

@implementation BottomToolView

//全选
- (IBAction)selectAllAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.selected == YES) {
        
        self.allSelectButton.selected = NO;
        
    }else {
        
        self.allSelectButton.selected = YES;
    }
    
    self.selectAllBlock(self.allSelectButton.selected);
}

- (void)selectAllMethod:(selectAllBlock)block {

    _selectAllBlock = block;
}

//去结算
- (IBAction)balanceAction:(id)sender {
    
    self.toBalanceBlock();
}

- (void)toBalanceMethod:(goBalanceblock)block {

    _toBalanceBlock = block;
}

@end
