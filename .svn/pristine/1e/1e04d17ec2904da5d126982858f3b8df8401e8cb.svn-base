//
//  STWisdomProcurementHeadView.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomBtnView.h"

#define STWisdomBtn 1000
#define kSTListImgtag 10000

@interface STWisdomBtnView (){
    NSInteger oldtag;
}
@property(strong,nonatomic)NSArray *labelAry;

@end

@implementation STWisdomBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWisdomSubBtn:@[@"紧急程度",@"字母排序",@"筛选  "]];
    }
    return self;
}
-(void)setWisdomSubBtn:(NSArray *)labelAry{
    _labelAry = labelAry;
    _isSeleceted = YES;
    oldtag = STWisdomBtn;
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectBtn.tag = STWisdomBtn + i;
        selectBtn.backgroundColor = [UIColor whiteColor];
        selectBtn.frame = CGRectMake(kScreenWidth/_labelAry.count * i, 0, kScreenWidth/_labelAry.count, 40);
        [selectBtn setTitleColor:RGB(85, 85, 85)forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setTitle: [_labelAry objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:selectBtn];
        
        if (i==0) {
            [selectBtn setTitleColor:[UIColor fromHexValue:0xea5413 alpha:1] forState:UIControlStateNormal];
        }
        
        if (i == 2) {
           UIImageView *imgV = [UIImageView new];
            imgV.tag = kSTListImgtag + i;
            imgV.frame = CGRectMake(selectBtn.frame.size.width/2 + 20, (selectBtn.frame.size.height - 6)/2, 11, 6);
            imgV.image = [UIImage imageNamed:@"list"];
            [selectBtn addSubview:imgV];
        }
    }
    UIView *underLine = [UIView new];
    underLine.frame = CGRectMake(0, 39.5, kScreenWidth, .5);
    underLine.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:underLine];
    
}
#pragma mark --btn - mothed
-(void)selectBtn:(UIButton *)btn{
    
    if (btn.tag != STWisdomBtn + 2) {
        oldtag = btn.tag;
    }
    
    for (int i = 0; i < _labelAry.count; i++) {
        UIButton *Btn = [self viewWithTag:STWisdomBtn + i];
        
        [Btn setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
        
        if (oldtag == STWisdomBtn + i) {
            [Btn setTitleColor:[UIColor fromHexValue:0xea5413 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    
    if (btn.tag != STWisdomBtn + 2) {
        [btn setTitleColor:[UIColor fromHexValue:0xea5413 alpha:1] forState:UIControlStateNormal];
    }
    
    if (btn.tag == STWisdomBtn + 2) {
        
       UIImageView *imgv = [self viewWithTag:kSTListImgtag + btn.tag - STWisdomBtn];
        
        if (_isSeleceted) {
             imgv.image = [UIImage imageNamed:@"uplist"];
            _isSeleceted = NO;
        }else{
              imgv.image = [UIImage imageNamed:@"list"];
            _isSeleceted = YES;
        }
    }
    
    if (_WisdomBtnBlock) {
        _WisdomBtnBlock(btn.tag - STWisdomBtn);
    }
}
-(void)selectFilterBtn:(NSString *)title{
   
    UIButton *Btn = [self viewWithTag:STWisdomBtn + 2];
    
    [Btn setTitle: title forState:UIControlStateNormal];
    
    UIImageView *imgv = [self viewWithTag:kSTListImgtag + 2];
    
    imgv.image = [UIImage imageNamed:@"list"];
    
    _isSeleceted = YES;
}

@end
