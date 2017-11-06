//
//  STSearchHeaderView.m
//  my
//
//  Created by soso-mac on 2016/12/7.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STSearchHeaderView.h"

@implementation STSearchHeaderView
-(void)setSearchHeaderView:(id)result{
    _imgeV.image = [UIImage imageNamed:@"探索品类的世界"];
    [_nameBtn setTitle:[NSString stringWithFormat:@"查看%@排行榜",result] forState:UIControlStateNormal];
    _lineLab.frame = CGRectMake(0, (kScreenWidth - 100) / 1.47 - 0.5, kScreenWidth - 100,.5);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)nameSelected:(UIButton *)sender {
    if (_prodRankBlock) {
        _prodRankBlock(@"0");
    }
}

@end
