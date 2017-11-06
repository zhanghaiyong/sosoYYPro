//
//  CH_OrderCell.h
//  sosoYY
//
//  Created by zhy on 2017/5/25.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletDetailCell : UITableViewCell

/*******************订单冲红*********************/
//商品名
@property (weak, nonatomic) IBOutlet UILabel *CH_GoodName;
//公司
@property (weak, nonatomic) IBOutlet UILabel *CH_Company;
//冲红数量
@property (weak, nonatomic) IBOutlet UILabel *CH_Count;
//退款金额
@property (weak, nonatomic) IBOutlet UILabel *CH_Refund;
//冲红原因
@property (weak, nonatomic) IBOutlet UILabel *CH_Reason;
//单价
@property (weak, nonatomic) IBOutlet UILabel *CH_UnitPrice;
//总价
@property (weak, nonatomic) IBOutlet UILabel *CH_TotalPrice;


/*******************订单取消/其他原因*********************/
//商品名
@property (weak, nonatomic) IBOutlet UILabel *Cancle_GoodName;
//公司
@property (weak, nonatomic) IBOutlet UILabel *Cancle_Company;
//单价
@property (weak, nonatomic) IBOutlet UILabel *Cancle_UnitPrice;
//总价
@property (weak, nonatomic) IBOutlet UILabel *Cancle_TotalPrice;

/*******************发货差异*********************/
//商品名
@property (weak, nonatomic) IBOutlet UILabel *Dif_GoodName;
//公司
@property (weak, nonatomic) IBOutlet UILabel *Dif_Company;
//数量
@property (weak, nonatomic) IBOutlet UILabel *Dif_Count;
//未发货
@property (weak, nonatomic) IBOutlet UILabel *Dif_disSend;
//退款金额
@property (weak, nonatomic) IBOutlet UILabel *Dif_Refund;
//单价
@property (weak, nonatomic) IBOutlet UILabel *Dif_UnitPrice;
//总价
@property (weak, nonatomic) IBOutlet UILabel *Dif_TotalPrice;


@end
