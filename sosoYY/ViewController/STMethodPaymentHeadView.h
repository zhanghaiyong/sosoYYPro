//
//  STMethodPaymentHeadView.h
//  sosoYY
//
//  Created by soso-mac on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMethodPaymentHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumerLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
-(void)setMethodPayment:(id)dataResult;
@end
