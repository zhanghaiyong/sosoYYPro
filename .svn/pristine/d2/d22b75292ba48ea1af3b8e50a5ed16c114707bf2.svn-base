//
//  STWisdomHeadererView.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/20.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomHeadererView.h"

#define STTopWisdomBtn 1000
#define STTopWisdomLab 10000

@interface STWisdomHeadererView ()
@property(strong,nonatomic)NSArray *labelAry;
@end


@implementation STWisdomHeadererView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWisdomSubBtn:@[@"智慧采购",@"人工采购"]];
    }
    return self;
}
-(void)setWisdomSubBtn:(NSArray *)labelAry{
    _labelAry = labelAry;
    
    UIView *bgView = [UIView  new];
    bgView.frame = CGRectMake(10, 5, kScreenWidth - 20, 30);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.0f;
    bgView.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
    bgView.layer.borderWidth = 1.0f;
    [self addSubview:bgView];
    
    CGFloat width = bgView.frame.size.width;
    CGFloat height = bgView.frame.size.height;
    
    for (int i = 0; i < [_labelAry count]; i++) {
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        switch (i) {
            case 0:
                Btn.tag = STTopWisdomBtn + 0;
                break;
            case 1:
                Btn.tag = STTopWisdomBtn + 2;
                break;
                
            default:
                break;
        }
        Btn.backgroundColor = [UIColor whiteColor];
        Btn.frame = CGRectMake(width/[_labelAry count] * i, 0, width/[_labelAry count], height);
        [Btn setTintColor:RGB(51, 51, 51)];
        [Btn addTarget:self action:@selector(selectTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [Btn setTitle:[NSString stringWithFormat:@"%@(0)", _labelAry[i]] forState:UIControlStateNormal];
//        [Btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        [bgView addSubview:Btn];
        if (i==0) {
            [Btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
        }
     
        if (i < 2) {
            UILabel *lineLab = [UILabel new];
            lineLab.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
            lineLab.frame = CGRectMake(Btn.frame.size.width - 1, 0, 1, 30);
            [Btn addSubview:lineLab];
        }
    }
  
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, 39.5, kScreenWidth, .5);
    line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:line];
}
#pragma mark --btn - mothed

-(void)setNumStr:(NSString *)numStr type:(NSInteger)type{
    if (type == 0) {
        UIButton *btn = [self viewWithTag:STTopWisdomBtn + 0];
        [btn setTitle:[NSString stringWithFormat:@"智慧采购(%@)",numStr] forState:UIControlStateNormal];
    }else if (type == 1){
        UIButton *btn = [self viewWithTag:STTopWisdomBtn + 1];
        [btn setTitle:[NSString stringWithFormat:@"暂不采购(%@)",numStr] forState:UIControlStateNormal];
    }else if (type == 2){
        UIButton *btn = [self viewWithTag:STTopWisdomBtn + 2];
        [btn setTitle:[NSString stringWithFormat:@"人工采购(%@)",numStr] forState:UIControlStateNormal];
    }
}
-(void)selectTopBtn:(UIButton *)btn{
    for (int i = 0; i < [_labelAry count]; i++) {
        UIButton *Btn = nil;
        switch (i) {
            case 0:
                Btn = [self viewWithTag:STTopWisdomBtn + 0];
                break;
            case 1:
                Btn = [self viewWithTag:STTopWisdomBtn + 2];
                break;
            default:
                break;
        }

        [Btn setTintColor:RGB(51, 51, 51)];
    }
    
    [btn setTintColor:[UIColor fromHexValue:0xea5413 alpha:1]];
    
    if (_WisdomTopBtnBlock) {
        _WisdomTopBtnBlock(btn.tag - STTopWisdomBtn);
    }
}

@end
