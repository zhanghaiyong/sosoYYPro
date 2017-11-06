//
//  STShopHomeFiltrateView.m
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopHomeFiltrateView.h"

#define kSTListBtntag 1000

#define kSreenHeight [UIScreen mainScreen].bounds.size.height
#define kSreenWidth [UIScreen mainScreen].bounds.size.width

@interface STShopHomeFiltrateView ()
@property(strong,nonatomic)NSArray *labelAry;
@end

@implementation STShopHomeFiltrateView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setSubBtn:(NSArray *)labelAry{
    _labelAry = labelAry;
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        Btn.tag = kSTListBtntag + i;
        Btn.backgroundColor = [UIColor whiteColor];
        Btn.frame = CGRectMake(0+kSreenWidth/_labelAry.count * i, 0, kSreenWidth/_labelAry.count, 40);
        [Btn setTintColor:[UIColor fromHexValue:0x555555 alpha:1]];
        [Btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [Btn setTitle: [_labelAry objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:Btn];

        if (i==0) {
            [Btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
        }
    }
    UIView *underLine = [UIView new];
    underLine.frame = CGRectMake(0, 39.5, kSreenWidth, .5);
    underLine.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:underLine];
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, 0, kSreenWidth, .5);
    line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:line];
}
#pragma mark --btn - mothed
-(void)selectBtn:(UIButton *)btn{
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *Btn = [self viewWithTag:kSTListBtntag + i];
        [Btn setTintColor:[UIColor fromHexValue:0x555555 alpha:1]];
    }
    [btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
    
    if (_FiltrateBlock) {
        _FiltrateBlock(btn.tag - kSTListBtntag);
    }
}


@end
