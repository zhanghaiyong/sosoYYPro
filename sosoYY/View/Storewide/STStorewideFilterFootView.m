//
//  STStorewideFilterFootView.m
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideFilterFootView.h"

@implementation STStorewideFilterFootView
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}
-(void)setAddBtn{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Btn.frame = CGRectMake(20 , self.frame.size.height - 40, self.frame.size.width - 40, 30);
    Btn.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
    [Btn setTintColor:[UIColor whiteColor]];
    Btn.layer.cornerRadius = 5.0f;
    Btn.layer.masksToBounds = YES;
    [Btn setTitle:@"确 定" forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(finishedSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:Btn];
}
-(void)finishedSelected{
    if (_delegate && [_delegate respondsToSelector:@selector(g_setStorewideFilterFinished)]) {
        [_delegate g_setStorewideFilterFinished];
    }
}

@end
