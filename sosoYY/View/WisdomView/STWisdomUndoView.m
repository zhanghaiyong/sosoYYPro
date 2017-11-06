//
//  STWisdomUndoView.m
//  sosoYY
//
//  Created by soso-mac on 2017/2/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomUndoView.h"

@implementation STWisdomUndoView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(119, 119, 119);
        self.alpha = .7f;
        
        _numLab = [UILabel new];
        _numLab.textColor = RGB(255, 255, 255);
        _numLab.frame = CGRectMake(10, 0, kScreenWidth - 100, 44);
        _numLab.font = [UIFont systemFontOfSize:14];
        _numLab.text =@"该商品已被移入未采购";
        [self addSubview:_numLab];
        
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        Btn.frame = CGRectMake(kScreenWidth - 70, 0, 70, 44);
        [Btn addTarget:self action:@selector(selectUndoBtn:) forControlEvents:UIControlEventTouchUpInside];
        [Btn setTitle: @"撤销" forState:UIControlStateNormal];
        [Btn setImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
        [Btn setTintColor:RGB(225, 225, 225)];
        [Btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [self addSubview:Btn];
    }
    return self;
}
- (void)selectUndoBtn:(UIButton *)sender {
    if (_WisdomUndoViewBlock) {
        _WisdomUndoViewBlock();
    }
}

@end
