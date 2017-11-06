//
//  MyWalletDetailController.m
//  sosoYY
//
//  Created by zhy on 2017/5/25.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "MyWalletDetailController.h"
#import "WalletDetailHeadView.h"
#import "WalletDetailCell.h"
#import "WalletDetailOtherHeadView.h"
#import "ObjectModel.h"
#import "orderproductlistModel.h"
#import "ProduceDetailListModel.h"
#import "CH_DifModel.h"
#import "STOrderDetailsViewController.h"
@interface MyWalletDetailController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSMutableArray *oneSectionTitle;
    NSMutableArray *oneSectionContent;
    ObjectModel *objectModel;
    NSArray *dataSource;
    UITableView *orderDetTable;
    WalletDetailHeadView *headView;
}

@end

@implementation MyWalletDetailController

-(void)setParamsDic:(NSDictionary *)paramsDic {

    _paramsDic = paramsDic;
    dataSource = [NSArray array];
    oneSectionTitle = [NSMutableArray array];
    oneSectionContent = [NSMutableArray array];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    [KSMNetworkRequest postRequest:requestBillDetail params:paramsDic success:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        
        FxLog(@"responseObj = %@",responseObj);
        objectModel = [ObjectModel mj_objectWithKeyValues:responseObj];
        
        headView.Section1_Money.text = [objectModel.type isEqualToString:@"支出"] ? [NSString stringWithFormat:@"-%.2f",objectModel.surplusmoney] : [NSString stringWithFormat:@"+%.2f",objectModel.income_money];
        headView.Section1_OrderType.text = [objectModel.type isEqualToString:@"支出"] ? @"在线支付" : @"退款";
        
        if ([objectModel.type isEqualToString:@"支出"]) {
            
            dataSource = [orderproductlistModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"orderlist"]];
            
            //混合支付
            if ([objectModel.payfriendname containsString:@"+"]) {
             
                [oneSectionTitle addObjectsFromArray:@[@"类型",
                                                       @"付款方式",
                                                       @"订单总额",
                                                       [[NSString stringWithFormat:@"%@",
                                                        [objectModel.payfriendname componentsSeparatedByString:@"+"][0]]stringByReplacingOccurrencesOfString:@" " withString:@""],
                                                       [[NSString stringWithFormat:@"%@",[objectModel.payfriendname componentsSeparatedByString:@"+"][1]]stringByReplacingOccurrencesOfString:@" " withString:@""],
                                                       @"交易单号",
                                                       @"创建时间"]];
                
                [oneSectionContent addObjectsFromArray:@[objectModel.type,
                                                         objectModel.payfriendname.length > 0 ? objectModel.payfriendname : @"优惠券抵扣",
                                                        [NSString stringWithFormat:@"￥%.2f(实付款￥%.2f)",objectModel.ordermoney,objectModel.surplusmoney],
                                                         [NSString stringWithFormat:@"-￥%.2f",objectModel.surplusmoney-objectModel.paybalancemoney],
                                                         [NSString stringWithFormat:@"-￥%.2f",objectModel.paybalancemoney],
                                                         objectModel.paysn,
                                                         objectModel.create_time]];
                if (objectModel.couponmoney > 0) {
                    [oneSectionTitle insertObject:@"优惠券" atIndex:3];
                    [oneSectionContent insertObject:[NSString stringWithFormat:@"抵扣￥%.2f",objectModel.couponmoney] atIndex:3];
                }
                
            }else {
            
                
                [oneSectionTitle addObjectsFromArray:@[@"类型",
                                                       @"付款方式",
                                                       @"订单总额",
                                                       @"交易单号",
                                                       @"创建时间"]];
                
                [oneSectionContent addObjectsFromArray:@[objectModel.type,
                                                         objectModel.payfriendname.length > 0 ? objectModel.payfriendname : @"优惠券抵扣",
                                                         [NSString stringWithFormat:@"￥%.2f(实付款￥%.2f)",objectModel.ordermoney,objectModel.surplusmoney],
                                                         objectModel.paysn,
                                                         objectModel.create_time]];
                if (![[objectModel.payfriendname stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"优惠券抵扣"]) {
                    
                    [oneSectionTitle insertObject:[objectModel.payfriendname stringByReplacingOccurrencesOfString:@" " withString:@""] atIndex:3];
                    
                    [oneSectionContent insertObject:[NSString stringWithFormat:@"-￥%.2f",objectModel.surplusmoney] atIndex:3];
                }
                
//                //非余额支付的在线支付账单明细不显示钱包余额
//                if ([objectModel.payfriendname containsString:@"钱包支付"]) {
//                    
//                    [oneSectionTitle insertObject:@"钱包余额" atIndex:4];
//                    [oneSectionContent insertObject:[NSString stringWithFormat:@"￥%.2f",objectModel.balance.doubleValue] atIndex:4];
//                }
                if (objectModel.couponmoney > 0) {
                    [oneSectionTitle insertObject:@"优惠券" atIndex:3];
                    [oneSectionContent insertObject:[NSString stringWithFormat:@"抵扣￥%.2f",objectModel.couponmoney] atIndex:3];
                }
            }
        }else {
        
            dataSource = [CH_DifModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"orderproductlist"]];
            [oneSectionTitle addObjectsFromArray:@[@"类型",@"退款方式",@"退款类型",@"交易单号",@"订单编号",@"创建时间"]];
            [oneSectionContent addObjectsFromArray:@[objectModel.type,@"钱包余额",objectModel.payfriendname,objectModel.paysn,objectModel.osn,objectModel.create_time]];
        }
        
        [orderDetTable reloadData];
        
    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [ZHProgressHUD showErrorWithText:@"网络错误，请重试"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账单明细";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor fromHexValue:0x555555], NSForegroundColorAttributeName,[UIFont fontWithName:@"PingFang-SC-Medium" size: 18], NSFontAttributeName, nil]];
    
    headView = [[[NSBundle mainBundle] loadNibNamed:@"WalletDetailHeadView" owner:self options:nil] firstObject];
    headView.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, kScreenWidth, 100);
    [self.view addSubview:headView];
    
    
    orderDetTable = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.bottom, kScreenWidth, kScreenHeight-100-64) style:UITableViewStyleGrouped];
    orderDetTable.delegate = self;
    orderDetTable.dataSource = self;
    orderDetTable.tableFooterView = [UIView new];
    orderDetTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, -8);
    [self.view addSubview:orderDetTable];
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)backAction {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //支出
    if ([objectModel.type isEqualToString:@"支出"]) {
        
        return dataSource.count+1;
    }else {
    
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return oneSectionTitle.count;
    }else {
    
        //支出
        if ([objectModel.type isEqualToString:@"支出"]) {
            
            orderproductlistModel *model = dataSource[section-1];
            return model.orderproductlist.count;
            
        }else {
            
            return dataSource.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return 44;
    }else {
    
        if ([objectModel.payfriendname isEqualToString:@"订单冲红"]) {
            return 85;
        }else if ([objectModel.payfriendname isEqualToString:@"发货差异"]) {
        
            return 75;
        }else {
        
            return 55;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 0.1;
    }else {
    
        if ([objectModel.type isEqualToString:@"支出"]) {
            if (section == 1) {
                
                return 95;
            }else {
                
                return 40;
            }
        }else {
            
            return 55;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    if (section != 0) {
        WalletDetailOtherHeadView *sectionHeadX = [[[NSBundle mainBundle] loadNibNamed:@"WalletDetailOtherHeadView" owner:self options:nil] lastObject];
        sectionHeadX.frame = CGRectMake(0, 0, kScreenWidth, 95);
        //支出
        if ([objectModel.type isEqualToString:@"支出"]) {
            //订单编号
            orderproductlistModel *model = dataSource[section-1];
            [sectionHeadX.OrderCode setTitle:[NSString stringWithFormat:@"%@",model.OSN] forState:UIControlStateNormal];
            
            sectionHeadX.jumpToOrderDetailBlock = ^{
                
                STOrderDetailsViewController *paymentVC = [STOrderDetailsViewController new];
                paymentVC.titleStr = @"订单详情";
                paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/OrderDetail?Oid=%@",requestHost,model.oid];
                paymentVC.orderId = model.oid;
                [self.navigationController pushViewController:paymentVC animated:YES];
            };
            
            if (section == 1) {
                
                sectionHeadX.ViewH1.constant = 55;
                sectionHeadX.ViewH2.constant = 40;
            }else {
                
                sectionHeadX.ViewH1.constant = 0;
                sectionHeadX.ViewH2.constant = 40;
            }
        }else {
            
            sectionHeadX.ViewH1.constant = 55;
            sectionHeadX.ViewH2.constant = 0;
        }
        return sectionHeadX;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        static NSString *reuseid = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseid];
        }
        cell.textLabel.text = oneSectionTitle[indexPath.row];  
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor fromHexValue:0x777777];
        
        cell.detailTextLabel.text = oneSectionContent[indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.numberOfLines = 0;
        
        if ([objectModel.type isEqualToString:@"支出"]) {
            
            if ([oneSectionTitle[indexPath.row] isEqualToString:@"订单总额"] || [oneSectionTitle[indexPath.row] isEqualToString:@"优惠券"] || [oneSectionTitle[indexPath.row] containsString:@"支付"]) {
                
                cell.detailTextLabel.textColor = [UIColor fromHexValue:0xEA5413];
            }else {
            
                cell.detailTextLabel.textColor = [UIColor fromHexValue:0x555555];
            }
        }else {
        
            if ([oneSectionTitle[indexPath.row] isEqualToString:@"订单编号"]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ >",[oneSectionContent[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""]];
                cell.detailTextLabel.textColor = [UIColor fromHexValue:0x219EFF];
            }
        }
        
        return cell;
        
    }else {
        
        if ([objectModel.payfriendname isEqualToString:@"订单冲红"]) {
            
            static NSString *reuseid = @"walletDetailCell";
            WalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletDetailCell" owner:self options:nil] firstObject];
            }
            CH_DifModel *model = dataSource[indexPath.row];
            cell.CH_GoodName.text = model.name;
            cell.CH_Company.text = model.DrugsBase_Manufacturer;
            cell.CH_Count.text = [NSString stringWithFormat:@"%@",model.num];
            cell.CH_Refund.text = [NSString stringWithFormat:@"￥%.2f",model.num.doubleValue*model.discountprice.doubleValue];
            cell.CH_UnitPrice.text = [NSString stringWithFormat:@"价格：%.2fx%@",model.discountprice.doubleValue,model.buycount];
            cell.CH_TotalPrice.text = [NSString stringWithFormat:@"￥%.2f",model.discountprice.doubleValue*model.buycount.doubleValue];
            cell.CH_Reason.text = model.des;
            
            return cell;
        }else if ([objectModel.payfriendname isEqualToString:@"发货差异"]) {
            
            static NSString *reuseid = @"walletDetailCell";
            WalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletDetailCell" owner:self options:nil] lastObject];
            }
            
            CH_DifModel *model = dataSource[indexPath.row];
            cell.Dif_GoodName.text = model.name;
            cell.Dif_Company.text = model.DrugsBase_Manufacturer;
            cell.Dif_Count.text = [NSString stringWithFormat:@"%@",model.buycount];
            cell.Dif_disSend.text = [NSString stringWithFormat:@"%.0f",[model.buycount doubleValue] - [model.buycount_s doubleValue]];
            cell.Dif_Refund.text = [NSString stringWithFormat:@"￥%.2f",([model.buycount doubleValue] - [model.buycount_s doubleValue])*model.discountprice.doubleValue];
            cell.Dif_UnitPrice.text = [NSString stringWithFormat:@"价格：%.2fx%@",model.discountprice.doubleValue,model.buycount];
            cell.Dif_TotalPrice.text = [NSString stringWithFormat:@"￥%.2f",model.discountprice.doubleValue*model.buycount.doubleValue];
            return cell;
            
        }else {
            
            static NSString *reuseid = @"walletDetailCell";
            WalletDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"WalletDetailCell" owner:self options:nil][1];
            }
            
            //支出
            if ([objectModel.type isEqualToString:@"支出"]) {
                
                orderproductlistModel *m = dataSource[indexPath.section-1];
                ProduceDetailListModel *model = m.orderproductlist[indexPath.row];
                cell.Cancle_GoodName.text = model.Name;
                cell.Cancle_Company.text = model.DrugsBase_Manufacturer;
                cell.Cancle_UnitPrice.text = [NSString stringWithFormat:@"价格：%.2fx%@",model.DiscountPrice.doubleValue,model.BuyCount];
                cell.Cancle_TotalPrice.text = [NSString stringWithFormat:@"￥%.2f",model.DiscountPrice.doubleValue*model.BuyCount.doubleValue];
            }else {
            
                CH_DifModel *model = dataSource[indexPath.row];
                cell.Cancle_GoodName.text = model.name;
                cell.Cancle_Company.text = model.DrugsBase_Manufacturer;
                cell.Cancle_UnitPrice.text = [NSString stringWithFormat:@"价格：%.2fx%@",model.discountprice.doubleValue,model.buycount];
                cell.Cancle_TotalPrice.text = [NSString stringWithFormat:@"￥%.2f",model.discountprice.doubleValue*model.buycount.doubleValue];
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if ([oneSectionTitle[indexPath.row] isEqualToString:@"订单编号"]) {
            
            CH_DifModel *model = dataSource[0];
            STOrderDetailsViewController *paymentVC = [STOrderDetailsViewController new];
            paymentVC.titleStr = @"订单详情";
            paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/OrderDetail?Oid=%@",requestHost,model.oid];
            paymentVC.orderId = model.oid;
            [self.navigationController pushViewController:paymentVC animated:YES];
        }
    }
}



@end