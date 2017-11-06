//
//  STPaymentDetailsViewController.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STPaymentDetailsViewController.h"
#import "STOrderDetailsHeadView.h"
#import "STPaymentDetailsBtnView.h"
#import "STPaymentDetailsImgTableViewCell.h"
#import "STPaymentDetailsTableViewCell.h"
#import "STOrderSettlementHeadView.h"
#import "STMethodPaymentViewController.h"
#import "STProductDetailsViewController.h"
#import "STShopHomeViewController.h"
#import "STPaymentDetailsEntity.h"

#define selectBtn_tag 1000


@interface STPaymentDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    __block BOOL isOK;//是否请求成功
    
    NSString *lous;
    NSString *noLous;
}

@property (nonatomic,strong)UILabel *topAlertLabel;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)STPaymentDetailsBtnView *paymentDetailsBtnView;
@property(strong,nonatomic)STOrderDetailsHeadView *orderDetailsHeadView;
@property(strong,nonatomic)STOrderSettlementHeadView *orderSettlementHeadView;
@property(strong,nonatomic)NSMutableArray *dataResult;
@property(strong,nonatomic) NSMutableArray *dataAry;
@property(strong,nonatomic) STPaymentDetailsEntity *mode;
@property(strong,nonatomic) NSMutableArray *selectAry;

@property(strong,nonatomic) NSString *selectedCouponItemKeyList;
@property(strong,nonatomic) NSString *selectedCouponMoney;
@property(strong,nonatomic) NSString *selectedCouponCount;
@property(strong,nonatomic) NSArray *adrassAry;
@property(strong,nonatomic) NSArray *couponAry;
@property(strong,nonatomic) NSString *buyerRemark;
@property(strong,nonatomic) NSString *payBalance;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;


@property(strong,nonatomic) NSMutableArray *imgVAry;
@end

@implementation STPaymentDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    lous = @"NO";
    noLous = @"NO";
    _dataResult = [NSMutableArray new];
    
    _selectAry = [NSMutableArray new];
    
    _dataAry = [NSMutableArray new];
    
    _imgVAry = [NSMutableArray new];
    
    
    _selectedCouponItemKeyList = @"";
    
    _selectedCouponMoney = @"";
    
    _selectedCouponCount = @"";
    
    _buyerRemark = @"";
    
    isOK = NO;
    
    [self addSubView];
    
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//       
//        
//    }];
    
     [self getAppConfirmOrder:@{@"selectedCartItemKeyList":_orderId,@"saId":@""}];
    
//    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark - 结算订单详情
-(void)getAppConfirmOrder:(id)params  {
    
    __weak STPaymentDetailsViewController *weakSelf = self;
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [KSMNetworkRequest getAppConfirmOrderUrl:requestAppConfirmOrder params:params finshed:^(id dataResult,id data,STPaymentDetailsEntity *entity, NSError *error) {
            if (!error) {
                
                [weakSelf.dataResult removeAllObjects];
                
                [weakSelf.selectAry removeAllObjects];
                
                [weakSelf.dataAry removeAllObjects];
                
                weakSelf.dataAry = data;
                
                weakSelf.dataResult = dataResult;
                
                weakSelf.mode = entity;
                
                
                //计算第一个支持白条的店铺位置
                for (int i = 0 ; i<_dataResult.count;i++) {
                    STPaymentDetailsEntity *model = _dataResult[i];
                    if ([model islous].integerValue == 1) {
                        lous = [NSString stringWithFormat:@"%d",i];
                        break;
                    }
                }
                
                //计算第一个普通店铺位置
                for (int i = 0 ; i<_dataResult.count;i++) {
                    STPaymentDetailsEntity *model = _dataResult[i];
                    if ([model islous].integerValue == 0) {
                        noLous = [NSString stringWithFormat:@"%d",i];
                        break;
                    }
                }
                
                //计算显示条件
                [weakSelf judgeCondition];
              
                
                NSString *SAIdStr = [NSString stringWithFormat:@"%@",_mode.SAId];
                
                if (SAIdStr.integerValue == 0) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有默认的收货地址,请设置收货地址" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        
                        STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
                        
                        detailsVC.urlStr = [NSString stringWithFormat:@"%@fromwhere=confirmorder",requestEditAddress];
                        
                        detailsVC.paymentBackBlock = ^(id sender) {
                            
                            _adrassAry = sender;
                            
                            _mode.SAId = [NSString stringWithFormat:@"%@",_adrassAry[7]];
                            
                            [weakSelf.orderSettlementHeadView setOrderchangeAdrass:_adrassAry];
                            
                        };
                        
                        [self.navigationController pushViewController:detailsVC animated:YES];
                        
                        
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
                for (int i = 0; i < weakSelf.dataResult.count; i++) {
                    
                    [_selectAry addObject:@"0"];
                }
                
                if (weakSelf.dataResult.count != 0) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.orderSettlementHeadView = [[[NSBundle mainBundle]loadNibNamed:@"STOrderSettlementHeadView" owner:self options:nil]lastObject];
                        
                        weakSelf.orderSettlementHeadView.OrderSettlementHeadViewBlock = ^(NSString *num, NSString *payBalance){//余额开关
                            
                            
                            [weakSelf judgeCondition];
                            
                            weakSelf.payBalance = payBalance;
                            
                            [weakSelf.paymentDetailsBtnView setPaymentDetails:num];
                        };
                        
                        weakSelf.orderSettlementHeadView.OrderCouponsNumBlock = ^{//优惠券选择
                            
                            [weakSelf judgeCondition];
                            
                            STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
                            detailsVC.urlStr = [NSString stringWithFormat:@"%@selectedCartItemKeyList=%@&selectedCouponItemKeyList=%@&selectedCouponMoney=%@&selectedCouponCount=%@",requestGetValidCouponList,_orderId,weakSelf.selectedCouponItemKeyList,weakSelf.selectedCouponMoney,weakSelf.selectedCouponCount];
                            
                            detailsVC.paymentBackBlock = ^(id sender) {
                                
                                _couponAry = sender;
                                
                                weakSelf.selectedCouponItemKeyList = [NSString stringWithFormat:@"%@",_couponAry[0]];
                                
                                weakSelf.selectedCouponMoney = [NSString stringWithFormat:@"%@",_couponAry[1]];
                                
                                weakSelf.selectedCouponCount = [NSString stringWithFormat:@"%@",_couponAry[2]];
                                
                                [weakSelf.orderSettlementHeadView setOrderCouponsMoney:[NSString stringWithFormat:@"%@",_couponAry[1]] count:[NSString stringWithFormat:@"%@",_couponAry[2]]];
                                
                            };
                            [self.navigationController pushViewController:detailsVC animated:YES];
                            
                        };
                        
                        
                        weakSelf.orderSettlementHeadView.OrderchangeAdrassBlock = ^{//地址改变
                            
                            STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
                            //                            detailsVC.hidesBottomBarWhenPushed = YES;
                            detailsVC.urlStr = [NSString stringWithFormat:@"%@fromwhere=confirmorder",requestGetAddress];
                            
                            detailsVC.paymentBackBlock = ^(id sender) {
                                
                                _adrassAry = sender;
                                
                                _mode.SAId = [NSString stringWithFormat:@"%@",_adrassAry[7]];
                                
                                [weakSelf.orderSettlementHeadView setOrderchangeAdrass:_adrassAry];
                                
                            };
                            detailsVC.backBlock = ^(id sender) {
                                
                                [self.tableView.mj_header beginRefreshing];
                            };
                            
                            [self.navigationController pushViewController:detailsVC animated:YES];
                        };
                        
                        
                        weakSelf.orderSettlementHeadView.OrderRemarkTextViewBlock = ^(NSString *text) {//修改备注
                            
                            weakSelf.buyerRemark = text;
                            
                        };
                        
                        _tableView.tableHeaderView = _orderSettlementHeadView;
                        
                        
                        [weakSelf.orderSettlementHeadView setOrderSettlementHeadView:weakSelf.mode];
                        
                        [weakSelf.tableView reloadData];
                        
                        [weakSelf.tableView.mj_header endRefreshing];
                        
                        [[UIApplication sharedApplication].keyWindow hideToastActivity];
                    });
                    
                }else{
                    [ZHProgressHUD showInfoWithText:@"暂无数据"];
                }
            }else{
                [ZHProgressHUD showInfoWithText:@"请求失败"];
            }
            isOK = YES;
        }];
    });
    
    [[STCommon sharedSTSTCommon] setHideToastActivity:^(BOOL isYes) {
        
        if (isYes) {
            
            if (isOK) {
                
                return ;
                
            }
            
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
    
}
#pragma mark - 提交订单
-(void)getAppSubmitOrder{
    
    _paymentDetailsBtnView.finisgdeBtn.enabled = NO;
    
    NSString *SAIdStr = [NSString stringWithFormat:@"%@",_mode.SAId];
    
    if (SAIdStr.integerValue == 0) {
        
        _paymentDetailsBtnView.finisgdeBtn.enabled = YES;
        
        [ZHProgressHUD showInfoWithText:@"您还没有默认的收货地址,请设置收货地址"];
        
    }else{
        if (_dataAry.count != 0) {
            
            [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
            
            [KSMNetworkRequest getAppSubmitOrderUrl:requestAppSubmitOrder params:@{@"saId":[NSString stringWithFormat:@"%@",_mode.SAId],@"selectedCartItemKeyList":_orderId,@"selectedCouponItemKeyList":_selectedCouponItemKeyList,@"express":@"",@"payBalance":_payBalance,@"buyerRemark":_buyerRemark,@"for_zhcg":[NSString stringWithFormat:@"%zi",_isZhui]} finshed:^(id dataResult, id data, STPaymentDetailsEntity *entity, NSError *error) {
                
                _paymentDetailsBtnView.finisgdeBtn.enabled = YES;
                
                [[UIApplication sharedApplication].keyWindow hideToastActivity];
                
                if (!error) {
                
                    NSString *success = dataResult[@"success"];
                    
                    if (success.intValue == 0) {
                        
                        [ZHProgressHUD showInfoWithText:dataResult[@"info"]];
                        
                    }else{
                        
                        NSDictionary *dataDict = dataResult[@"data"];
                        
                        STMethodPaymentViewController *methodPaymentVC = [STMethodPaymentViewController new];
                        
                        methodPaymentVC.masterOid = dataDict[@"MasterOidList"];
                        
                        [self.navigationController pushViewController:methodPaymentVC animated:YES];
                        
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:refresh_shopCart object:self userInfo:nil];
                }
            }];
        }else{
            
            _paymentDetailsBtnView.finisgdeBtn.enabled = YES;
            
            [ZHProgressHUD showInfoWithText:@"暂无数据"];
        }
    }
}

-(void)addSubView{
    
    self.topAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
    self.topAlertLabel.backgroundColor = [UIColor redColor];
    self.topAlertLabel.textColor = [UIColor whiteColor];
    self.topAlertLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.topAlertLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewOrTextFieldEditChanged:)name:@"UITextViewTextDidChange"object:nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - kNavBarHeight - 50)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    __weak STPaymentDetailsViewController *weakSelf = self;
    
    
    _paymentDetailsBtnView = [[STPaymentDetailsBtnView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50) type:_orderType];
    _paymentDetailsBtnView.PaymentDetailsBtnBlock = ^{
        [weakSelf getAppSubmitOrder];
    };
    [self.view addSubview:_paymentDetailsBtnView];
}

#pragma mark --UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //闭合状态
    if ([_selectAry[section] integerValue] == 0) {
            
            for (NSArray *ary in _dataAry) {
                
                 NSMutableArray *imgAry = [NSMutableArray new];
                
                for (STPaymentDetailsEntity *entity in ary) {
                    
                    if ([entity.IsAddPriceBuy intValue] != 2) {
                        
                        [imgAry addObject:entity];
                        
                    }
                }
                
                [_imgVAry addObject:imgAry];
                
            }

        return 1;
        
    }else{
        
        return [_dataAry[section] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_selectAry[indexPath.section] integerValue] == 0) {
        static NSString *DetailsImg = @"DetailsImg";
        STPaymentDetailsImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailsImg];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STPaymentDetailsImgTableViewCell" owner:self options:nil]lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if (_imgVAry.count != 0) {
            
            [cell setPaymentDetailsImg:_imgVAry[indexPath.section] indexPath:indexPath];
            
        }
        
        cell.selectorImgVBlock = ^(NSInteger index) {
            
            STPaymentDetailsEntity *entity = _imgVAry[indexPath.section][index];
            
            STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
            
            
            
            detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,entity.Pid];
            
            if ([entity.IsAddPriceBuy intValue] == 2) {
                
                detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,entity.secondpid];
            }
            
            [self.navigationController pushViewController:detailsVC animated:YES];
        };
        return cell;
    }else{
        static NSString *PaymentDetails = @"PaymentDetails";
        STPaymentDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PaymentDetails];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STPaymentDetailsTableViewCell" owner:self options:nil]lastObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if (_dataAry.count != 0) {
            [cell setPaymentDetails:_dataAry[indexPath.section][indexPath.row] indexPath:indexPath oderType:_orderType];
        }
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_selectAry[indexPath.section] integerValue] == 0) {
        
        return 60;
        
    }else{
        
        return 90;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    STPaymentDetailsEntity *entity = _dataAry[indexPath.section][indexPath.row];
    
    STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
    
    detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,entity.Pid];
    
    if ([entity.IsAddPriceBuy intValue] == 2) {
        
        detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,entity.secondpid];
    }
    
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (![lous isEqualToString:@"NO"] && ![noLous isEqualToString:@"NO"]) {
        
        if (section == lous.integerValue || section == noLous.integerValue) {
            return 50;
        }else {
        
            return 40;
        }
    }else{
        return 50;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    __weak STPaymentDetailsViewController *weakSelf = self;
    
    _orderDetailsHeadView = [[[NSBundle mainBundle]loadNibNamed:@"STOrderDetailsHeadView" owner:self options:nil]lastObject];
    
    
    if ([_dataResult[section] islous].integerValue == 1) {

        _orderDetailsHeadView.lousImg.hidden = NO;
        _orderDetailsHeadView.storeNameLeft.constant = 49;
        
    }else {
    
        _orderDetailsHeadView.lousImg.hidden = YES;
        _orderDetailsHeadView.storeNameLeft.constant = 5;
    }
    
    [_orderDetailsHeadView setOrderDetails:[_dataResult[section] storename]];
    
    _orderDetailsHeadView.cashLab.text = [NSString stringWithFormat:@"小计：￥%@",[STCommon setHasSuffix:[_dataResult[section] ProductAmount]]];
    
    _orderDetailsHeadView.OrderDetailsBlock = ^{
        STShopHomeViewController *shopHomeVC = [STShopHomeViewController new];
        
        shopHomeVC.typeDict = @{@"storeid":[weakSelf.dataResult[section] StoreId]};
        [weakSelf.navigationController pushViewController:shopHomeVC animated:YES];
    };
    
    return _orderDetailsHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footView = [UIView new];
    footView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    footView.backgroundColor = [UIColor whiteColor];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.backgroundColor = [UIColor whiteColor];
    selectBtn.tag = section + selectBtn_tag;
    selectBtn.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [selectBtn setTitle:@"展开" forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectMothed:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitleColor:[UIColor fromHexValue:0x555555] forState:UIControlStateNormal];
    [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -45, 0, 0)];
    [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 55, 0, 0)];
    
    
    if ([_selectAry[section] integerValue] == 0) {
        [selectBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        [selectBtn setTitle:@"展开" forState:UIControlStateNormal];
    }else{
        [selectBtn setImage:[UIImage imageNamed:@"uplist"] forState:UIControlStateNormal];
        [selectBtn setTitle:@"折叠" forState:UIControlStateNormal];
    }
    [footView addSubview:selectBtn];
    
    return footView;
}

-(void)selectMothed:(UIButton *)btn{
    
    if ([_selectAry[btn.tag - selectBtn_tag] integerValue] == 0) {
        
        [_selectAry replaceObjectAtIndex:btn.tag - selectBtn_tag withObject:@"1"];
        
    }else{
        [_selectAry replaceObjectAtIndex:btn.tag - selectBtn_tag withObject:@"0"];
    }
    
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)judgeCondition {

    //计算支持白条店铺商品总金额
    double iouPrice = 0.0;
    for (int i = 0 ; i<_dataResult.count;i++) {
        STPaymentDetailsEntity *model = _dataResult[i];
        if ([model islous].integerValue == 1) {
            iouPrice += model.ProductAmount.doubleValue;
        }
    }
    
    //case1
    if (![lous isEqualToString:@"NO"] && iouPrice < 500.0) {
        
        self.tableView.frame = CGRectMake(0, 30+64, kScreenWidth, kScreenHeight - kNavBarHeight - 50-30);
        self.topAlertLabel.text = @"  注意，您目前不满足'500元白条起贷'的条件";
        self.topAlertLabel.hidden = NO;
        
    }else if(![lous isEqualToString:@"NO"] && iouPrice >= 500.0) {
        
        //case2
        if (!self.orderSettlementHeadView.switchBtn.on && ([self.orderSettlementHeadView.selectLab.text isEqualToString:@"请选择"] || self.orderSettlementHeadView.selectLab.text.length == 0)) {

            self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - kNavBarHeight - 50);
            self.topAlertLabel.hidden = YES;
        }else {
            self.tableView.frame = CGRectMake(0, 30+64, kScreenWidth, kScreenHeight - kNavBarHeight - 50-30);
            self.topAlertLabel.text = @"  注意，白条与钱包余额，优惠券不可同时使用";
            self.topAlertLabel.hidden = NO;
        }
    }else {
        
        self.topAlertLabel.hidden = YES;
        self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - kNavBarHeight - 50);
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextViewTextDidChange" object:nil];
}

@end