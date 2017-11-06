//
//  STListShopBtnView.m
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STListShopBtnView.h"

#define kSTListBtntag 1000
#define kSreenHeight [UIScreen mainScreen].bounds.size.height
#define kSreenWidth [UIScreen mainScreen].bounds.size.width


@interface STListShopBtnView ()
@property(strong,nonatomic)NSArray *labelAry;
@property(strong,nonatomic)NSString *typeStr;
@end


@implementation STListShopBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self setSubBtn];
    }
    return self;
}
-(void)setSubBtn {
    
    //@[@"综合",@"热卖",@"最新",@"免邮"];
    _labelAry = @[@"综合",@"最新",@"免邮",@"白条支付"];
    
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        Btn.backgroundColor = [UIColor whiteColor];
        Btn.tag = kSTListBtntag + i;
        Btn.frame = CGRectMake(0+kSreenWidth/_labelAry.count * i, 0, kSreenWidth/_labelAry.count, 30);
        [Btn setTintColor:[UIColor fromHexValue:0x555555 alpha:1]];
        [Btn addTarget:self action:@selector(selectShopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [Btn setTitle: [_labelAry objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:Btn];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(Btn.frame.size.width-0.5, 0, 0.5, 30);
        lineView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
        [Btn addSubview:lineView];
        if (i==0) {
           [Btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
        }
    }
    
    UIView *underLine = [UIView new];
    underLine.frame = CGRectMake(0, 29.5, kSreenWidth, .5);
    underLine.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:underLine];
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, 0, kSreenWidth, .5);
    underLine.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:line];
}
#pragma btn - mothed
-(void)selectShopBtn:(UIButton *)btn{
    for (int i = 0; i < _labelAry.count; i++) {
        
        UIButton *Btn = [self viewWithTag:kSTListBtntag + i];
       [Btn setTintColor:[UIColor fromHexValue:0x555555 alpha:1]];
    }
    [btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
    
    
    if (_delegate && [ _delegate respondsToSelector:@selector(g_setSelectShopBtnTag:)]) {
        [_delegate g_setSelectShopBtnTag:btn.tag - kSTListBtntag];
    }
}


@end
