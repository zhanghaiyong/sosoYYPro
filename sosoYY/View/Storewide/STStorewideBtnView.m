//
//  STStorewideBtnView.m
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideBtnView.h"
#define kSTListBtntag 1000
#define kSTListImgtag 10000

#define kSreenHeight [UIScreen mainScreen].bounds.size.height
#define kSreenWidth [UIScreen mainScreen].bounds.size.width


@interface STStorewideBtnView (){
    NSInteger typeTag;
    BOOL isSeleceted;
    NSInteger oldtag;
}
@property(strong,nonatomic)NSArray *labelAry;
@end

@implementation STStorewideBtnView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        oldtag = kSTListBtntag;
        isSeleceted = YES;
        [self setSubBtn];
    }
    return self;
}
-(void)setSubBtn{
    _labelAry = @[@"综合",@"价格  ",@"毛利率 ",@"  筛选"];
    
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        Btn.tag = kSTListBtntag + i;
        Btn.backgroundColor = [UIColor whiteColor];
        Btn.frame = CGRectMake(0+kSreenWidth/_labelAry.count * i, 0, kSreenWidth/_labelAry.count, 30);
        [Btn setTintColor:[UIColor fromHexValue:0x555555 alpha:1]];
        [Btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [Btn setTitle: [_labelAry objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:Btn];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(Btn.frame.size.width-0.5, 0, 0.5, 30);
        lineView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
        [Btn addSubview:lineView];
        if (i==0) {
            [Btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
        }
        if (i==0) {
            [Btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
        }
        if (i == 1|| i == 2) {
            UIImageView *imgV = [UIImageView new];
            imgV.tag = kSTListImgtag + i;
            imgV.hidden = YES;
            imgV.frame = CGRectMake(Btn.frame.size.width - 15, (Btn.frame.size.height - 11)/2, 8, 11);
            imgV.image = [UIImage imageNamed:@"down"];
            [Btn addSubview:imgV];
        }
        if (i == 3) {
            UIImageView *imgV = [UIImageView new];
            imgV.frame = CGRectMake(13, (Btn.frame.size.height - 11)/2, 6, 11);
            imgV.image = [UIImage imageNamed:@"left"];
            [Btn addSubview:imgV];
        }
        
        if (i == 0) {
            UIImageView *imgV = [UIImageView new];
            imgV.frame = CGRectMake(Btn.frame.size.width - 18, (Btn.frame.size.height - 6)/2, 11, 6);
            imgV.image = [UIImage imageNamed:@"list"];
            [Btn addSubview:imgV];
        }
    }
    
    UIView *underLine = [UIView new];
    underLine.frame = CGRectMake(0, 29.5, kSreenWidth, .5);
    underLine.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:underLine];
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, 0, kSreenWidth, .5);
    line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:line];
}
#pragma mark --btn - mothed
-(void)selectBtn:(UIButton *)btn{
    if (btn.tag != kSTListBtntag + 3) {
        oldtag = btn.tag;
    }
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *Btn = [self viewWithTag:kSTListBtntag + i];
        UIImageView *imgv = [self viewWithTag:kSTListImgtag + i];
        [Btn setTintColor:[UIColor fromHexValue:0x555555 alpha:1]];
        imgv.hidden = YES;
        if (oldtag == kSTListBtntag + i) {
            [Btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
            imgv.hidden = NO;
        }
    }
    if (btn.tag != kSTListBtntag + 3) {
        [btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
    }
    if (btn.tag == kSTListBtntag + 3) {
        if (isSeleceted) {
            isSeleceted = NO;
        }else{
            isSeleceted = YES;
        }
    }
    
    UIImageView *imgv = [self viewWithTag:kSTListImgtag + btn.tag - kSTListBtntag];
    imgv.hidden = NO;
    if (typeTag == btn.tag) {
        if (isSeleceted) {
            imgv.image = [UIImage imageNamed:@"down"];
            isSeleceted = NO;
        }else{
            imgv.image = [UIImage imageNamed:@"up"];
            isSeleceted = YES;
        }
    }else{
        if (isSeleceted) {
            imgv.image = [UIImage imageNamed:@"up"];
        }else{
            imgv.image = [UIImage imageNamed:@"down"];
        }
    }
    
    if (_delegate && [ _delegate respondsToSelector:@selector(g_setStorewideSelectBtnTag:andSelected:)]) {
        [_delegate g_setStorewideSelectBtnTag:btn.tag - kSTListBtntag andSelected:isSeleceted];
    }
    typeTag = btn.tag;
    
    if (btn.tag == kSTListBtntag) {
        isSeleceted = YES;
    }
}
-(void)setsynthesizeBtnTitle:(NSString *)text{
    UIButton *Btn = [self viewWithTag:kSTListBtntag];
    [Btn setTitle:text forState:UIControlStateNormal];
}
@end
