//
//  STShopCartSearchUndoView.m
//  sosoYY
//
//  Created by soso-mac on 2017/8/10.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STShopCartSearchUndoView.h"

@implementation STShopCartSearchUndoView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
           self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        [self setSubAddView];
    }
    return self;
}
-(void)setSubAddView{
    
    _undoMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-100, 40)];
    _undoMsg.textColor = [UIColor whiteColor];
    _undoMsg.font = [UIFont systemFontOfSize:13];
    [self addSubview:_undoMsg];
    
    UIButton *undoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-110, 0, 100, 40)];
    [undoBtn setTitle:@" 撤销" forState:UIControlStateNormal];
    undoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [undoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [undoBtn setImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [undoBtn addTarget:self action:@selector(undoClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:undoBtn];

}
-(void)undoClick{
    if (_undoBlock) {
        _undoBlock();
    }
}
@end
