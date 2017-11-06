//
//  STOrderViewController.m
//  sosoYY
//
//  Created by zhy on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STOrderViewController.h"
#import "OrderCell.h"
#import "STOrderDetailsViewController.h"
#import "WaitPayOrderModel.h"
#import "GetOrderListParams.h"
#import "WaitPayParams.h"
#import "CH_ReceiveModel.h"
#import "LiOfOrderModel.h"
#import "STMethodPaymentViewController.h"
#import "NoOrderView.h"
#import "MyWalletDetailController.h"
@interface STOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (nonatomic,assign)NSInteger orderType;

@property (nonatomic,strong)NoOrderView *noOrderView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic,strong)UITableView  *tableView;


/*********待付款******/
@property (nonatomic,strong)NSMutableArray *waitPayData;
@property (nonatomic,strong)NSMutableArray *waitPayAllData;
@property (nonatomic,strong)WaitPayParams *waitPayParams;

@property (nonatomic,strong)GetOrderListParams *params;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation STOrderViewController

-(NoOrderView *)noOrderView {
    if (_noOrderView == nil) {
        self.noOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NoOrderView" owner:self options:nil] lastObject];
        self.noOrderView.frame = CGRectMake((kScreenWidth-150)/2, 100, 150, 147);
    }
    return _noOrderView;
}

//待付款
-(WaitPayParams *)waitPayParams {
    if (_waitPayParams == nil) {
        self.waitPayParams = [[WaitPayParams alloc]init];
    }
    return _waitPayParams;
}

//待收货
-(GetOrderListParams *)params {
    if (_params == nil) {
        self.params = [[GetOrderListParams alloc]init];
    }
    return _params;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    self.switchView.hidden = NO;
    if (self.url) {
        STOrderDetailsViewController *paymentVC = [STOrderDetailsViewController new];
        paymentVC.urlStr = self.url;
        paymentVC.pushFlag = YES;
        [self.navigationController pushViewController:paymentVC animated:YES];
        self.url = nil;
    }
    
    if (self.btnTag > 0) {
        self.orderType = self.btnTag-100;
        switch (self.btnTag) {
            case 100:
                [self SwitchOrderTypeClick:self.waitPayBtn];
                self.btnTag = 0;
                break;
            case 101:
                [self SwitchOrderTypeClick:self.waitReceiveBtn];
                self.btnTag = 0;
                break;
            case 102:
                [self SwitchOrderTypeClick:self.chBtn];
                self.btnTag = 0;
                break;
            case 103:
                [self SwitchOrderTypeClick:self.allBtn];
                self.btnTag = 0;
                break;
            default:
                break;
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderType = 0;
    [self initSubViews];
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubViews {
    
    self.waitPayData = [NSMutableArray array];
    self.waitPayAllData = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.switchView.bottom, kScreenWidth, kScreenHeight-self.switchView.height- 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor fromHexValue:0xEBEBEB];
    self.tableView.separatorColor = [UIColor fromHexValue:0xEBEBEB];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, -8);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (self.orderType == 0) {
            [self refreshWaitPayData];
        }else {
            [self refreshCH_WaitOrder];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.orderType == 0) {
            [self loadWaitPayData];
        }else {
            [self loadCH_WaitOrder];
        }
    }];
    [self.view addSubview:self.tableView];

}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.orderType == 0) {
        return self.waitPayData.count;
    }else {
        return self.dataSource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    switch (self.orderType) {
        case 0:{
            NSArray *array = self.waitPayData[section];
            return array.count;
        }
            break;
        case 1:{
            CH_ReceiveModel *model = self.dataSource[section];
            return model.li.count;
        }
            break;
        case 2:{
            CH_ReceiveModel *model = self.dataSource[section];
            return model.li.count;
        }
            break;
        case 3:{
            CH_ReceiveModel *model = self.dataSource[section];
            //未支付
            if ([model.isPay isEqualToString:@"0"]) {
                return 1;
            }else {
                return model.li.count;
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    switch (self.orderType) {
        case 0:{
            return 73+40+40+10;
        }
            break;
        case 1:{
            CGFloat H = 73;
            
            CH_ReceiveModel *model = self.dataSource[indexPath.section];
            LiOfOrderModel *m = model.li[indexPath.row];
            if (indexPath.row == 0) {
                
                H += 40;
            }
            if ([m.orderstateInfo isEqualToString:@"已取消"]) {
                if ([m.transactionflow_userCancelId doubleValue] > 0) {
                    H += 40;
                }
            }
//            H += 46;
            return H;
        }
            break;
        case 2:{
            
            CGFloat H = 73;
            if (indexPath.row == 0) {
                
                H += 40;
            }
            return H;
            
        }
            break;
        case 3:{
            CH_ReceiveModel *model = self.dataSource[indexPath.section];
            LiOfOrderModel *m = model.li[indexPath.row];
            CGFloat H = 73;
            
            //未支付
            if ([model.isPay isEqualToString:@"0"]) {
                H += 40;
                //未取消
                if ([model.isCancel isEqualToString:@"0"]) {
                    
                    H += 46;
                }
                //已支付
            }else {
                
                if (indexPath.row == 0) {
                    H += 40;
                }
                if ([m.orderstateInfo isEqualToString:@"已取消"]) {
                    
                    if ([m.transactionflow_userCancelId doubleValue] > 0) {
                        H += 40;
                    }
                }
//                H += 46;
            }
            return H;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (self.orderType == 0) {
       
        if (section == 0) {
            return 30;
        }else {
            return 10;
        }
        
    }else {
    
        if (section == 0) {
            return 30;
        }else {
        
            CH_ReceiveModel *baseModel = self.dataSource[section-1];
            CH_ReceiveModel *model = self.dataSource[section];
            if (![[model.addtime substringToIndex:7] isEqualToString:[baseModel.addtime substringToIndex:7]]) {
                return 30;
            }else {
                return 10;
            }
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(6, 0, view.width, view.height)];
    label.textColor = [UIColor fromHexValue:0x555555];
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor fromHexValue:0xEBEBEB];
    [view addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(6, -1, 1, 32)];
    line.backgroundColor = [UIColor fromHexValue:0xCCCCCC alpha:0.8];
    [view addSubview:line];
    
    
    if (self.orderType == 0) {
        line.hidden = YES;
        label.hidden = NO;
        
        NSArray *array = self.waitPayData[section];
        WaitPayOrderModel *model = array[0];
        
        NSArray *dateArray = [[model.addtime substringToIndex:10] componentsSeparatedByString:@"-"];
        label.text = [NSString stringWithFormat:@"%@年%@月",dateArray[0],dateArray[1]];
    }else {
    
        //第一个section显示时间
        if (section == 0) {
            
            line.hidden = YES;
            label.hidden = NO;
            CH_ReceiveModel *baseModel = self.dataSource[0];
            NSArray *baseArray = [[baseModel.addtime substringToIndex:10] componentsSeparatedByString:@"-"];
            label.text = [NSString stringWithFormat:@"%@年%@月",baseArray[0],baseArray[1]];
        }else {
            //其他的section，和上一个secton的时间做对比。相同就不显示
            CH_ReceiveModel *baseModel = self.dataSource[section-1];
            CH_ReceiveModel *model = self.dataSource[section];
            if (![[model.addtime substringToIndex:7] isEqualToString:[baseModel.addtime substringToIndex:7]]) {
                NSArray *array = [[model.addtime substringToIndex:10] componentsSeparatedByString:@"-"];
                label.text = [NSString stringWithFormat:@"%@年%@月",array[0],array[1]];
                line.hidden = YES;
                label.hidden = NO;
            }else {
                
                line.hidden = NO;
                label.hidden = YES;
            }
        }
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseid = @"orderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:self options:nil] lastObject];
    }
    
#pragma mark 取消订单/再次购买
    cell.cancelBlock = ^(UIButton *button) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消该订单?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (self.orderType == 0) {
                
                NSArray *array = self.waitPayData[indexPath.section];
                WaitPayOrderModel *model = array[indexPath.row];
                [KSMNetworkRequest postRequest:requestCancelOrder params:@{@"parentid":model.parentid} success:^(id responseObj) {
                    FxLog(@"%@",responseObj);
                    
                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                    if ([[responseObj objectForKey:@"code"] integerValue] == 1) {
                        [self.tableView.mj_header beginRefreshing];
                    }
                    
                } failure:^(NSError *error) {
                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                }];
                
            }else {
                
                CH_ReceiveModel *model = self.dataSource[indexPath.section];
                LiOfOrderModel *liModel = model.li[indexPath.row];
                [KSMNetworkRequest postRequest:requestCancelOrder params:@{@"parentid":liModel.parentid} success:^(id responseObj) {
                    FxLog(@"%@",responseObj);
                    
                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                    if ([[responseObj objectForKey:@"code"] integerValue] == 1) {
                        
                        [self.tableView.mj_header beginRefreshing];
                    }
                    
                } failure:^(NSError *error) {
                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                }];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    };
#pragma mark 立即购买
    cell.nowPayBlock = ^{
        
        STMethodPaymentViewController *payMentVC = [[STMethodPaymentViewController alloc]init];
        payMentVC.orderListInto  = YES;
        if (self.orderType == 0 ) {
            NSArray *array = self.waitPayData[indexPath.section];
            WaitPayOrderModel *model = array[indexPath.row];
            payMentVC.masterOid = model.parentid;
        }else {
            
            CH_ReceiveModel *model = self.dataSource[indexPath.section];
            LiOfOrderModel *liModel = model.li[indexPath.row];
            payMentVC.masterOid = liModel.parentid;
        }
        [self.navigationController pushViewController:payMentVC animated:YES];
    };
    
#pragma mark 跳转到钱包详情
    cell.checkWalletDetBlock = ^{
        
        CH_ReceiveModel *model = self.dataSource[indexPath.section];
        LiOfOrderModel *liModel = model.li[indexPath.row];
        MyWalletDetailController *walletDetail = [MyWalletDetailController new];
        walletDetail.paramsDic = @{@"id":liModel.transactionflow_userCancelId};
        [self.navigationController pushViewController:walletDetail animated:YES];
    };
    
#pragma mark 跳转到详情
    cell.jumpToDetailBlock = ^{
        
        STOrderDetailsViewController *paymentVC = [STOrderDetailsViewController new];
        paymentVC.titleStr = @"订单详情";
        paymentVC.orderListInto = YES;
        
        switch (self.orderType) {
            case 0:
            {
                NSArray *array = self.waitPayData[indexPath.section];
                WaitPayOrderModel *model = array[indexPath.row];
                paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/MasterOrderDetail?masterOid=%@",requestHost,model.parentid];
                paymentVC.orderId = model.parentid;
                
                break;
            }
            case 1:
            {
                
                CH_ReceiveModel *model = self.dataSource[indexPath.section];
                LiOfOrderModel *liModel = model.li[indexPath.row];
                paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/OrderDetail?Oid=%@",requestHost,liModel.oid];
                paymentVC.orderId = liModel.oid;
                paymentVC.QQ = liModel.qq;
                if ([liModel.orderstateInfo isEqualToString:@"待收货"]) {
                    paymentVC.orderType = 5;
                }
                
                break;
            }
            case 2:
            {
                
                CH_ReceiveModel *model = self.dataSource[indexPath.section];
                LiOfOrderModel *liModel = model.li[indexPath.row];
                paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/OrderDetail?Oid=%@",requestHost,liModel.oid];
                paymentVC.orderId = liModel.oid;
                paymentVC.QQ = liModel.qq;
                
                break;
            }
            case 3:
            {
                CH_ReceiveModel *model = self.dataSource[indexPath.section];
                LiOfOrderModel *liModel = model.li[indexPath.row];
                paymentVC.QQ = liModel.qq;
                if ([liModel.orderstateInfo isEqualToString:@"待收货"]) {
                    paymentVC.orderType = 5;
                }
                //未付款
                if ([model.isPay isEqualToString:@"0"]) {
                    paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/MasterOrderDetail?masterOid=%@",requestHost,model.parentid];
                    paymentVC.orderId = model.parentid;
                    
                }else {
                    paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/OrderDetail?Oid=%@",requestHost,liModel.oid];
                    paymentVC.orderId = liModel.oid;
                }
                break;
            }
                
            default:
                break;
        }
        
        paymentVC.OrderDetailsBackBlock = ^{
            
            [self.tableView.mj_header beginRefreshing];
        };
        
        [self.navigationController pushViewController:paymentVC animated:YES];
    };
    
    switch (self.orderType) {
        case 0:
        {
            cell.dianW.constant = 0;
            cell.iouImageW.constant = 0;
            cell.hotCountLabel.hidden = YES;
            cell.hotCountW.constant = 0;
            //隐藏查看详情View
            cell.checkDetailViewH.constant = 0;
            //隐藏商品名
            cell.name.hidden = YES;
            //修改name的高度
            cell.nameH.constant = 10;
            //cell分割线
            cell.DivideViewH.constant = 10;
            //异常数label
            cell.difCount.hidden = YES;
            //显示顶部View
            cell.topViewH.constant = 40;
            
            //显示支付按钮
            cell.nowPayBtnW.constant = 80;
            [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
            cell.payButtonOfViewH.constant = 46;
            NSArray *array = self.waitPayData[indexPath.section];
            WaitPayOrderModel *model = array[indexPath.row];
            
            //智慧采购
            if ([model.channelType integerValue] == 5 || [model.channelType integerValue] == 6) {
                cell.zhcgTips.hidden = NO;
                cell.zhcgTipsW.constant = 60;
            }else {
                cell.zhcgTips.hidden = YES;
                cell.zhcgTipsW.constant = 0;
            }
            
            cell.addTimeW.constant = 0;
            cell.overdue.text = model.CountDownInfo.length > 0 ? model.CountDownInfo : [model.addtime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            if (model.CountDownInfo.length > 0) {
                
                cell.overdue.textColor = [UIColor fromHexValue:0xEA5413];
            }else {
                cell.overdue.textColor = [UIColor blackColor];
            }
            
            cell.orderType.textColor = [UIColor fromHexValue:0xEA5413];
            cell.orderType.text = @"待付款";
            cell.overdue.hidden = NO;
            cell.totalCash.text = [NSString stringWithFormat:@"需付款：￥%.2f",model.surplusmoney.doubleValue];
            cell.totalCount.text = [NSString stringWithFormat:@"共%@种商品",model.productcount];
            cell.weekly.text = [Uitils weekdayStringFromDate:[model.addtime substringToIndex:10]];
            cell.days.text = [[model.addtime substringToIndex:10] componentsSeparatedByString:@"-"][2];
        }
            break;
        case 1:
        {
            
            
            CH_ReceiveModel *model = self.dataSource[indexPath.section];
            LiOfOrderModel *liModel = model.li[indexPath.row];
            
            if (liModel.fpTag > 0) {
                cell.dianW.constant = 18;
                cell.dianLabel.layer.cornerRadius = 2;
                cell.dianLabel.layer.borderWidth = 1;
                cell.dianLabel.layer.borderColor = liModel.fpTag == 1 ? [UIColor fromHexValue:0x555555].CGColor : [UIColor fromHexValue:0x0073E5].CGColor;
                cell.dianLabel.layer.borderWidth = 1;
                cell.dianLabel.textColor = liModel.fpTag == 1 ? [UIColor fromHexValue:0x555555] : [UIColor fromHexValue:0x0073E5];
                cell.name.text = [NSString stringWithFormat:@" %@",liModel.storename];
            }else {
                cell.dianW.constant = 0;
                cell.name.text = liModel.storename;
            }
            
            //支持白条
            if (liModel.blanknotepay > 0) {
                cell.iouImageW.constant = 39;
            }else {
            
                cell.iouImageW.constant = 0;
            }
            
            cell.hotCountLabel.hidden = YES;
            cell.hotCountW.constant = 0;
            //隐藏逾期
            cell.overdue.hidden = YES;
            //隐藏分割view
            cell.DivideViewH.constant = 0;
            //显示时间
            cell.addTimeW.constant = 145;
            //显示商品名
            cell.name.hidden = NO;
            //恢复name的高度
            cell.nameH.constant = 20;
            
            cell.payButtonOfViewH.constant = 3;
            cell.nowPayBtnW.constant = 80;
            cell.checkDetailViewH.constant = 0;
            [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
            
            if ([liModel.orderstateInfo isEqualToString:@"已取消"]) {
                if ([liModel.transactionflow_userCancelId doubleValue] > 0) {
                    cell.checkDetailViewH.constant = 43;
                }
            }
            if (indexPath.row == 0) {
                cell.topViewH.constant = 40;
            }else {
                cell.topViewH.constant = 0;
            }

            if ([model.channelTypeInfo isEqualToString:@"智慧采购"]) {
                cell.zhcgTips.hidden = NO;
                cell.zhcgTipsW.constant = 60;
            }else {
                
                cell.zhcgTips.hidden = YES;
                cell.zhcgTipsW.constant = 0;
            }
            
            cell.addTime.text = model.addtime;
            cell.weekly.text = [Uitils weekdayStringFromDate:[liModel.addtime substringToIndex:10]];
            cell.days.text = [[liModel.addtime substringToIndex:10] componentsSeparatedByString:@"-"][2];
            cell.totalCash.text = [NSString stringWithFormat:@"总金额：￥%.2f",liModel.surplusmoney.doubleValue];
            cell.totalCount.text = [NSString stringWithFormat:@"共%@种商品",liModel.productcount];
            if ([liModel.diffCount integerValue] > 0) {
                cell.difCount.hidden = NO;
                cell.difCount.text = [NSString stringWithFormat:@"有%@种商品出库异常",liModel.diffCount];
            }else {
                
                cell.difCount.hidden = YES;
            }
            if ([liModel.orderstateInfo isEqualToString:@"已取消"] || [liModel.orderstateInfo isEqualToString:@"已出库"] || [liModel.orderstateInfo isEqualToString:@"待出库"] || [liModel.orderstateInfo isEqualToString:@"冲红中"]) {
                cell.orderType.textColor = [UIColor fromHexValue:0x999999];
            }else if([liModel.orderstateInfo isEqualToString:@"待收货"]){
                
                cell.orderType.textColor = [UIColor fromHexValue:0xEA5413];
            }else if([liModel.orderstateInfo isEqualToString:@"已完成"]){
                
                cell.orderType.textColor = [UIColor fromHexValue:0x5AB85A];
            }
            cell.orderType.text = liModel.orderstateInfo;
        }
            break;
        case 2:
        {
            CH_ReceiveModel *model = self.dataSource[indexPath.section];
            LiOfOrderModel *liModel = model.li[indexPath.row];
            
            //发票
            if (liModel.fpTag > 0) {
                cell.dianW.constant = 18;
                cell.dianLabel.layer.cornerRadius = 2;
                cell.dianLabel.layer.borderWidth = 1;
                cell.dianLabel.layer.borderColor = liModel.fpTag == 1 ? [UIColor fromHexValue:0x555555].CGColor : [UIColor fromHexValue:0x0073E5].CGColor;
                cell.dianLabel.layer.borderWidth = 1;
                cell.dianLabel.textColor = liModel.fpTag == 1 ? [UIColor fromHexValue:0x555555] : [UIColor fromHexValue:0x0073E5];
                cell.name.text = [NSString stringWithFormat:@" %@",liModel.storename];
            }else {
                cell.dianW.constant = 0;
                cell.name.text = liModel.storename;
            }
            
            //支持白条
            if (liModel.blanknotepay > 0) {
                cell.iouImageW.constant = 39;
            }else {
                
                cell.iouImageW.constant = 0;
            }
            
            if (liModel.orderproduct_hot.integerValue > 0) {
                cell.hotCountLabel.hidden = NO;
                cell.hotCountW.constant = 30;
                cell.hotCountLabel.text = [NSString stringWithFormat:@"%@商品",liModel.orderproduct_hot];
            }else {
                cell.hotCountLabel.hidden = NO;
                cell.hotCountW.constant = 0;
            }
            
            //隐藏逾期
            cell.overdue.hidden = YES;
            //隐藏分割view
            cell.DivideViewH.constant = 0;
            //显示时间
            cell.addTimeW.constant = 145;
            //显示商品名
            cell.name.hidden = NO;
            //恢复name的高度
            cell.nameH.constant = 20;
            cell.payButtonOfViewH.constant = 3;
            cell.nowPayBtnW.constant = 80;
            cell.checkDetailViewH.constant = 0;
            [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
            
            if ([liModel.orderstateInfo isEqualToString:@"已取消"]) {
                if ([liModel.transactionflow_userCancelId doubleValue] > 0) {
                    cell.checkDetailViewH.constant = 43;
                }
            }
            if (indexPath.row == 0) {
                cell.topViewH.constant = 40;
            }else {
                cell.topViewH.constant = 0;
            }
            
            if ([model.channelTypeInfo isEqualToString:@"智慧采购"]) {
                cell.zhcgTips.hidden = NO;
                cell.zhcgTipsW.constant = 60;
            }else {
                
                cell.zhcgTips.hidden = YES;
                cell.zhcgTipsW.constant = 0;
            }
            
            cell.addTime.text = model.addtime;
            cell.weekly.text = [Uitils weekdayStringFromDate:[liModel.addtime substringToIndex:10]];
            cell.days.text = [[liModel.addtime substringToIndex:10] componentsSeparatedByString:@"-"][2];
            cell.totalCash.text = [NSString stringWithFormat:@"总金额：￥%.2f",liModel.surplusmoney.doubleValue];
            cell.totalCount.text = [NSString stringWithFormat:@"共%@种商品",liModel.productcount];
            if ([liModel.diffCount integerValue] > 0) {
                
                cell.difCount.hidden = NO;
                cell.difCount.text = [NSString stringWithFormat:@"有%@种商品出库异常",liModel.diffCount];
            }else {
                cell.difCount.hidden = YES;
            }
            
            if ([liModel.orderstate_hot isEqualToString:@"已取消"] || [liModel.orderstate_hot isEqualToString:@"待处理"]) {
                cell.orderType.textColor = [UIColor fromHexValue:0x999999];
            }else if([liModel.orderstate_hot isEqualToString:@"已处理"]){
                
                cell.orderType.textColor = [UIColor fromHexValue:0x5AB85A];
            }
            cell.orderType.text = liModel.orderstate_hot;
        }
            break;
        case 3:
        {
            
            CH_ReceiveModel *model = self.dataSource[indexPath.section];
            LiOfOrderModel *liModel = model.li[indexPath.row];
            
            //未支付
            if ([model.isPay isEqualToString:@"0"]) {
                
                cell.iouImageW.constant = 0;
                cell.dianW.constant = 0;
                cell.hotCountLabel.hidden = YES;
                cell.hotCountW.constant = 0;
                //发货异常
                cell.difCount.hidden = YES;
                cell.DivideViewH.constant = 0;
                cell.checkDetailViewH.constant = 0;
                cell.topViewH.constant = 40;
                if ([model.channelTypeInfo isEqualToString:@"智慧采购"]) {
                    cell.zhcgTipsW.constant = 60;
                    cell.zhcgTips.hidden = NO;
                }else {
                    cell.zhcgTipsW.constant = 0;
                    cell.zhcgTips.hidden = YES;
                }

                //未取消
                if ([model.isCancel isEqualToString:@"0"]) {
                    cell.addTimeW.constant = 0;
                    cell.overdue.hidden = NO;
                    cell.overdue.text = model.CountDownInfo.length > 0 ? model.CountDownInfo : model.addtime;
                    if (model.CountDownInfo.length > 0) {
                        
                        cell.overdue.textColor = [UIColor fromHexValue:0xEA5413];
                    }else {
                        cell.overdue.textColor = [UIColor blackColor];
                    }
                    
                    cell.payButtonOfViewH.constant = 46;
                    cell.nowPayBtnW.constant = 80;
                    [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
                    cell.orderType.text = @"待付款";
                    cell.orderType.textColor = [UIColor fromHexValue:0xEA5413];
                }else {
                    cell.payButtonOfViewH.constant = 3;
                    cell.overdue.hidden = YES;
                    cell.addTimeW.constant = 145;
                    cell.addTime.text = liModel.addtime;
                    cell.orderType.text = @"已取消";
                    cell.orderType.textColor = [UIColor fromHexValue:0x999999];
                }
                //隐藏商品名
                cell.name.hidden = YES;
                //修改name的高度
                cell.nameH.constant = 10;
                cell.weekly.text = [Uitils weekdayStringFromDate:[model.addtime substringToIndex:10]];
                cell.days.text = [[model.addtime substringToIndex:10] componentsSeparatedByString:@"-"][2];
                cell.totalCash.text = [NSString stringWithFormat:@"需付款：￥%.2f",model.surplusmoney.doubleValue];
                cell.totalCount.text = [NSString stringWithFormat:@"共%@种商品",model.Count];
                
                
            }else {
                
                //发票
                if (liModel.fpTag > 0) {
                    cell.dianW.constant = 18;
                    cell.dianLabel.layer.cornerRadius = 2;
                    cell.dianLabel.layer.borderWidth = 1;
                    cell.dianLabel.layer.borderColor = liModel.fpTag == 1 ? [UIColor fromHexValue:0x555555].CGColor : [UIColor fromHexValue:0x0073E5].CGColor;
                    cell.dianLabel.layer.borderWidth = 1;
                    cell.dianLabel.textColor = liModel.fpTag == 1 ? [UIColor fromHexValue:0x555555] : [UIColor fromHexValue:0x0073E5];
                    cell.name.text = [NSString stringWithFormat:@" %@",liModel.storename];
                }else {
                    cell.dianW.constant = 0;
                    cell.name.text = liModel.storename;
                }
                
                //支持白条
                if (liModel.blanknotepay > 0) {
                    cell.iouImageW.constant = 39;
                }else {
                    
                    cell.iouImageW.constant = 0;
                }
                
                if (liModel.orderproduct_hot.integerValue > 0) {
                    cell.hotCountLabel.hidden = NO;
                    cell.hotCountW.constant = 30;
                    cell.hotCountLabel.text = [NSString stringWithFormat:@"%@商品",liModel.orderproduct_hot];
                }else {
                    cell.hotCountLabel.hidden = YES;
                    cell.hotCountW.constant = 0;
                }
                
                //隐藏逾期
                cell.overdue.hidden = YES;
                //隐藏分割view
                cell.DivideViewH.constant = 0;
                //显示时间
                cell.addTimeW.constant = 145;
                //显示商品名
                cell.name.hidden = NO;
                //恢复name的高度
                cell.nameH.constant = 20;
                cell.payButtonOfViewH.constant = 3;
                cell.nowPayBtnW.constant = 80;
                cell.checkDetailViewH.constant = 0;
                [cell.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];

                if ([liModel.orderstateInfo isEqualToString:@"已取消"]) {
                    if ([liModel.transactionflow_userCancelId doubleValue] > 0) {
                        cell.checkDetailViewH.constant = 43;
                    }
                }
                
                if (indexPath.row == 0) {
                    cell.topViewH.constant = 40;
                }else {
                    cell.topViewH.constant = 0;
                }
                if ([liModel.channelTypeInfo isEqualToString:@"智慧采购"]) {
                    
                    cell.zhcgTips.hidden = NO;
                    cell.zhcgTipsW.constant = 60;
                }else {
                    
                    cell.zhcgTips.hidden = YES;
                    cell.zhcgTipsW.constant = 0;
                }
                
                cell.addTime.text = model.addtime;
                cell.weekly.text = [Uitils weekdayStringFromDate:[liModel.addtime substringToIndex:10]];
                cell.days.text = [[liModel.addtime substringToIndex:10] componentsSeparatedByString:@"-"][2];
                cell.totalCash.text = [NSString stringWithFormat:@"总金额：￥%.2f",liModel.surplusmoney.doubleValue];
                cell.totalCount.text = [NSString stringWithFormat:@"共%@种商品",liModel.productcount];
                if ([liModel.diffCount integerValue] > 0) {
                    cell.difCount.hidden = NO;
                    cell.difCount.text = [NSString stringWithFormat:@"有%@种商品出库异常",liModel.diffCount];
                }else {
                    cell.difCount.hidden = YES;
                }
                if ([liModel.orderstateInfo isEqualToString:@"已取消"] || [liModel.orderstateInfo isEqualToString:@"已出库"]|| [liModel.orderstateInfo isEqualToString:@"待出库"] || [liModel.orderstateInfo isEqualToString:@"冲红中"]) {
                    cell.orderType.textColor = [UIColor fromHexValue:0x999999];
                }else if([liModel.orderstateInfo isEqualToString:@"待收货"]){
                    
                    cell.orderType.textColor = [UIColor fromHexValue:0xEA5413];
                }else if([liModel.orderstateInfo isEqualToString:@"已完成"]){
                    
                    cell.orderType.textColor = [UIColor fromHexValue:0x5AB85A];
                }
                cell.orderType.text = liModel.orderstateInfo;
            }

        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


//刷新待付款
- (void)refreshWaitPayData {

    [self.waitPayData removeAllObjects];
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    self.waitPayParams.pageindex = 1;
    
    [KSMNetworkRequest postRequest:requestWaitPay params:self.waitPayParams.mj_keyValues success:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [self.tableView.mj_header endRefreshing];
        
        FxLog(@"responseObj = %@",responseObj);
        NSArray *dataArray = [responseObj objectForKey:@"nopayorderlist"];
        
        if (dataArray.count > 0) {
            
            [_noOrderView removeFromSuperview];
            _noOrderView = nil;
            
            NSArray *array = [WaitPayOrderModel mj_objectArrayWithKeyValuesArray:dataArray];
            self.waitPayData = [self dealDataByTime:array];
        }else {
        
            [self.waitPayData removeAllObjects];
            [self.tableView addSubview:self.noOrderView];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
         [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [self.tableView.mj_header endRefreshing];
    }];
}

//加载待付款
- (void)loadWaitPayData {
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    self.waitPayParams.pageindex += 1;
    
    [KSMNetworkRequest postRequest:requestWaitPay params:self.waitPayParams.mj_keyValues success:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [self.tableView.mj_footer endRefreshing];
        
        FxLog(@"responseObj = %@",responseObj);
        
        NSArray *dataArray = [responseObj objectForKey:@"nopayorderlist"];
        
        if (dataArray.count > 0) {
            
            [self.waitPayAllData addObjectsFromArray:[WaitPayOrderModel mj_objectArrayWithKeyValuesArray:dataArray]];
            self.waitPayData = [self dealDataByTime:self.waitPayAllData];
            [self.tableView reloadData];
            
        }else {
        
            [ZHProgressHUD showInfoWithText:@"没有更多数据了"];
        }

    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


//刷新 待收货 冲红订单
- (void)refreshCH_WaitOrder {

    self.params.tab = self.orderType;
    self.params.pageIndex = 1;
    
    [self.dataSource removeAllObjects];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    [KSMNetworkRequest postRequest:requestGetOrderList params:self.params.mj_keyValues success:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        FxLog(@"responseObj = %@",responseObj);
        
        [self.tableView.mj_header endRefreshing];
        if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
            
            NSArray *dataArray = [[responseObj objectForKey:@"data"] objectForKey:@"list"];
            if (dataArray.count > 0) {
                [_noOrderView removeFromSuperview];
                _noOrderView = nil;
                
                self.dataSource = [CH_ReceiveModel mj_objectArrayWithKeyValuesArray:dataArray];
                [self.tableView reloadData];
                
            }else {
            
                    [self.dataSource removeAllObjects];
                    [self.tableView addSubview:self.noOrderView];
                    [self.tableView reloadData];
            }
        }else {
        
            [ZHProgressHUD showInfoWithText:@"请重试"];
            [self.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

//加载 待收货 冲红订单
- (void)loadCH_WaitOrder {

    self.params.pageIndex += 1;
    self.params.tab = self.orderType;

    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    [KSMNetworkRequest postRequest:requestGetOrderList params:self.params.mj_keyValues success:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        FxLog(@"responseObj = %@",responseObj);
        [self.tableView.mj_footer endRefreshing];
        
        if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
        
            NSArray *list = [[responseObj objectForKey:@"data"] objectForKey:@"list"];
            if (list.count > 0) {
                
                [self.dataSource addObjectsFromArray:[CH_ReceiveModel mj_objectArrayWithKeyValuesArray:list]];
                [self.tableView reloadData];
            }else {
                [ZHProgressHUD showInfoWithText:@"没有更多数据了"];
            }
        }else {
            
            [ZHProgressHUD showInfoWithText:@"请重试"];
        }
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

#pragma mark 订单类型切换
- (IBAction)SwitchOrderTypeClick:(id)sender {
    
    [KSMNetworkRequest cancelquest];
    
    UIButton *button = (UIButton *)sender;
    
    for (int i = 0; i < 4; i++) {
        
        UIButton *btn = [self.switchView viewWithTag:i+100];
        btn.selected = NO;
    }
    
    self.orderType = button.tag-100;
    [self.tableView.mj_header beginRefreshing];
    
    button.selected = YES;
    [self.switchView layoutIfNeeded];
    self.lineLeft.constant = (button.tag-100)*self.switchView.width/4;
    
    switch (button.tag) {
        case 100:
            self.titleLab.text = @"待付款";
            break;
        case 101:
            self.titleLab.text = @"待收货";
            break;
        case 102:
            self.titleLab.text = @"冲红";
            break;
        case 103:
            self.titleLab.text = @"全部";
            break;
            
        default:
            break;
    }
}

- (NSMutableArray *)dealDataByTime:(NSArray *)allDataArray {
    
    NSMutableArray *returnArr = [NSMutableArray array];
    if (allDataArray.count == 0) {
        
        return returnArr;
    }
    NSMutableArray *middle = [NSMutableArray arrayWithObject:allDataArray[0]];
    [returnArr addObject:middle];
    
    for (NSInteger i = 1; i < allDataArray.count; i++){
        BOOL isCreat = NO;
        for (int j = 0; j<returnArr.count; j++){
            
            WaitPayOrderModel *model = (WaitPayOrderModel *)(NSMutableArray *)returnArr[j][0];
            WaitPayOrderModel *m = allDataArray[i];
            
            if ([[model.addtime substringToIndex:7] isEqualToString:([m.addtime substringToIndex:7])]) {
                [(NSMutableArray *)returnArr[j] addObject:m];
                isCreat = YES;
            }
        }
        if (!isCreat) {
            NSMutableArray *other = [[NSMutableArray alloc]init];
            [other addObject:allDataArray[i]];
            [returnArr addObject:other];
        }
    }
    
    return returnArr;
}


@end
