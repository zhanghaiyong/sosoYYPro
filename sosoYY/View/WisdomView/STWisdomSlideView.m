//
//  STWisdomSlideView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomSlideView.h"


#define STWisdomBtn 1000

@interface STWisdomSlideView ()
@property(strong,nonatomic)NSArray *labelAry;
@end


@implementation STWisdomSlideView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWisdomSubBtn:@[@"淘汰品种",@"删除"]];
    }
    return self;
}

-(void)setWisdomSubBtn:(NSArray *)labelAry{
    _labelAry = labelAry;
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectBtn.tag = STWisdomBtn + i;
        selectBtn.backgroundColor = [UIColor whiteColor];
        selectBtn.frame = CGRectMake((kScreenWidth - 80) + 40 * i, 0, 40, 40);
        [selectBtn setTintColor:RGB(85, 85, 85)];
        [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setTitle: [_labelAry objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:selectBtn];

    }
}
#pragma mark --btn - mothed
-(void)selectBtn:(UIButton *)btn{
    if (_WisdomSlideViewBlock) {
        _WisdomSlideViewBlock(btn.tag - STWisdomBtn);
    }
}

@end
