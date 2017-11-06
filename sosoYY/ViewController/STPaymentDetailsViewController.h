//
//  STPaymentDetailsViewController.h
//  sosoYY
//
//  Created by soso-mac on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface STPaymentDetailsViewController : UIViewController
@property(strong,nonatomic)NSString *orderId;
@property(assign,nonatomic)NSInteger isZhui;//0:不是智慧采购,1:是智慧采购
@property(assign,nonatomic)NSInteger orderType;//1:下单代付款款详情,2:订单结算详情.

@end
