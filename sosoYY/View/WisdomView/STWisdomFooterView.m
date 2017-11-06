//
//  STWisdomFooterView.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomFooterView.h"

@interface STWisdomFooterView (){
    UILabel *allLab;
}

@end

@implementation STWisdomFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _gouBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _gouBtn.backgroundColor = [UIColor clearColor];
        _gouBtn.layer.masksToBounds = YES;
        _gouBtn.layer.cornerRadius = 10.0f;
        _gouBtn.frame = CGRectMake(10, 5, kScreenWidth - 20, 40);
        [_gouBtn setTintColor:[UIColor whiteColor]];
        [_gouBtn addTarget:self action:@selector(gouSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_gouBtn setTitle:@"生成采购方案" forState:UIControlStateNormal];
        [self addSubview:_gouBtn];
        
        
        allLab = [UILabel new];
        allLab.textColor = RGB(85, 85, 85);
        allLab.frame = CGRectMake(40, 0, 40, 50);
        allLab.text = @"全选";
        allLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:allLab];
        
        _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allSelectBtn.frame = CGRectMake(0,0, 40, 50);
        [_allSelectBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [self addSubview:_allSelectBtn];
        
        
        _numLab = [UILabel new];
        _numLab.textColor = [UIColor fromHexValue:0x333333 alpha:1];
        _numLab.frame = CGRectMake(10, 0, 100, 50);
        _numLab.text = @"共3个商品";
        _numLab.font = [UIFont systemFontOfSize:14];
//        [self addSubview:_numLab];
 
        _iphoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _iphoneBtn.backgroundColor = [UIColor clearColor];
        _iphoneBtn.frame = CGRectMake(kScreenWidth - 120, 0, 120, 50);
        [_iphoneBtn setTintColor:[UIColor fromHexValue:0xffffff alpha:1]];
        [_iphoneBtn addTarget:self action:@selector(iphoneSelecte:) forControlEvents:UIControlEventTouchUpInside];
        [_iphoneBtn setTitle:@"发送(0)" forState:UIControlStateNormal];
        [_iphoneBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
       [_iphoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [self addSubview:_iphoneBtn];
        
        _line = [UILabel new];
        _line.frame = CGRectMake(0, 0, kScreenWidth, .5);
        _line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
        [self addSubview:_line];
    }
    return self;
}
-(void)setSTWisdomFooterView:(NSInteger)type index:(NSString *)index{
    _type = type;
    if (type == 0) {
        _numLab.hidden = YES;
        _iphoneBtn.hidden = YES;
        _allSelectBtn.hidden = YES;
        allLab.hidden = YES;
        _gouBtn.hidden = NO;
        [_gouBtn setTitle:@"生成采购方案(0)" forState:UIControlStateNormal];
    }else if(type == 2){
        _numLab.hidden = NO;
        _iphoneBtn.hidden = NO;
        _allSelectBtn.hidden = NO;
        allLab.hidden = NO;
        _gouBtn.hidden = YES;
        _numLab.text = [NSString stringWithFormat:@"共%@个商品",index];
        [_iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%@)",index]forState:UIControlStateNormal];
    }else if (type == 1) {
        _numLab.hidden = YES;
        _iphoneBtn.hidden = YES;
        _allSelectBtn.hidden = YES;
        allLab.hidden = YES;
        _gouBtn.hidden = NO;
        [_gouBtn setTitle:@"全部加入计划" forState:UIControlStateNormal];
    }
}
- (void)gouSelected:(id)sender {
    if (_STWisdomBlock) {
        _STWisdomBlock(_type);
    }
}

- (void)iphoneSelecte:(id)sender {
    if (_STWisdomBlock) {
        _STWisdomBlock(_type);
    }
}
-(void)allSelect:(id)sender{
    if (_STWisdomselectAllBlock) {
        _STWisdomselectAllBlock();
    }
}

@end
