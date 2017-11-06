//
//  STOrderSettlementHeadView.h
//  sosoYY
//
//  Created by soso-mac on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STOrderSettlementHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *namePhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *adrassLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalLab;
@property (weak, nonatomic) IBOutlet UILabel *postageLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *numPirceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UITextView *orderRemarkTextView;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectLab;
@property (weak, nonatomic) IBOutlet UILabel *yuLine;
@property (weak, nonatomic) IBOutlet UILabel *youLine;
@property (weak, nonatomic) IBOutlet UILabel *dingLine;






@property (copy, nonatomic) void(^OrderSettlementHeadViewBlock)(NSString *num,NSString *payBalance);//余额开关

@property (copy, nonatomic) void(^OrderCouponsNumBlock)(void);//优惠券选择

@property (copy, nonatomic) void(^OrderchangeAdrassBlock)(void);//地址改变

@property (copy, nonatomic) void(^OrderRemarkTextViewBlock)(NSString *text);//修改备注



-(void)setOrderSettlementHeadView:(STPaymentDetailsEntity *)entity;

-(void)setOrderCouponsMoney:(NSString *)money count:(NSString *)count;

-(void)setOrderchangeAdrass:(NSArray *)adrass;
@end
