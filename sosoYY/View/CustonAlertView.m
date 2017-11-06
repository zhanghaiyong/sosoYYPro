//
//  CustonAlertView.m
//  sosoYY
//
//  Created by zhy on 16/11/30.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "CustonAlertView.h"

@implementation CustonAlertView
{
    UIView *whiteView;
    NSString *alert;
}
- (instancetype)initWithFrame:(CGRect)frame withMsg:(NSString *)alertMsg
{
    self = [super initWithFrame:frame];
    if (self) {
        alert = alertMsg;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self setUp];
    }
    return self;
}

- (void)setUp {

    whiteView = [[UIView alloc]initWithFrame:CGRectMake(self.width/2 - (self.width-20)/2, -self.height/2.5, self.width-20, self.height/2.5)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    whiteView.clipsToBounds = YES;
    [self addSubview:whiteView];
    
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(whiteView.width/2 - (whiteView.width-40)/2, 30, whiteView.width-40, whiteView.height-100)];
    textV.font = [UIFont boldSystemFontOfSize:25];
    textV.backgroundColor = [UIColor clearColor];
    textV.editable = NO;
    textV.text = alert;
    textV.showsVerticalScrollIndicator = NO;
    textV.showsHorizontalScrollIndicator = NO;
    textV.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:textV];
    
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(whiteView.width/2-40, textV.bottom+10, 80, 44)];
    sender.backgroundColor = HEX_RGBA(0x93d4f5, 1);
    [sender setTitle:@"OK" forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    sender.layer.cornerRadius = 4;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(OKAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sender];
}

- (void)startAnimation {

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        whiteView.frame = CGRectMake(self.width/2 - (self.width-20)/2, self.height/2-self.height/5, self.width-20, self.height/2.5);
        
    } completion:nil];
}


- (void)OKAction {

    self.cusAlertViewBlock();
}

- (void)tapOKBtnMethod:(CustomAlertViewBlock )block {

    _cusAlertViewBlock = block;
}

@end
