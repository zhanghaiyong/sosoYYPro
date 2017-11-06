//
//  OrderCell.h
//  sosoYY
//
//  Created by zhy on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (nonatomic,copy)void(^checkWalletDetBlock)(void);

@property (nonatomic,copy)void(^jumpToDetailBlock)(void);

@property (nonatomic,copy)void(^cancelBlock)(UIButton *button);

@property (nonatomic,copy)void(^nowPayBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *hotCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotCountW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dianW;
@property (weak, nonatomic) IBOutlet UILabel *dianLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iouImageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iouImage;

//时间
@property (weak, nonatomic) IBOutlet UILabel *addTime;
//智慧采购标识
@property (weak, nonatomic) IBOutlet UILabel *zhcgTips;
//逾期
@property (weak, nonatomic) IBOutlet UILabel *overdue;
//日
@property (weak, nonatomic) IBOutlet UILabel *days;
//周
@property (weak, nonatomic) IBOutlet UILabel *weekly;
//商品名
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameH;
//总金额
@property (weak, nonatomic) IBOutlet UILabel *totalCash;
//总商品种类
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
//异常商品数
@property (weak, nonatomic) IBOutlet UILabel *difCount;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payButtonOfViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkDetailViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTimeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhcgTipsW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DivideViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nowPayBtnW;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@end
