//
//  MyWalletViewController.m
//  sosoYY
//
//  Created by zhy on 2017/5/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WalletHeadView.h"
#import "WalletCell.h"
#import "SwitchWalletBillView.h"
#import "WalletParams.h"
#import "BillParams.h"
#import "WalletModel.h"
#import "MonthBillModel.h"
#import "MyWalletDetailController.h"
#import "NoOrderView.h"
@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource> {

    UIButton *navigationBtn;
    //用于切换钱包和账单
    UIScrollView *scrollView;

    //********************钱包************************
    //钱包头部试图
    WalletHeadView *walletHeadView;
    /*钱包全部数据*/
    //已经分类的数据
    NSMutableArray *walletAll;
    //没有分类的数据
    NSMutableArray *walletAllList;
    
    /*钱包收入*/
    //已经分类的数据
    NSMutableArray *walletIn;
    //没有分类的数据
    NSMutableArray *walletInList;
    
    /*钱包支出*/
    //已经分类的数据
    NSMutableArray *walletOut;
    //没有分类的数据
    NSMutableArray *walletOutList;
    
    //是否加载完毕
    BOOL walletAllLoadFinish;
    BOOL walletInLoadFinish;
    BOOL walletOutLoadFinish;
    //******************账单**************************
    //已经分类的数据
    NSMutableArray *billAll;
    //没有分类的数据
    NSMutableArray *billAllList;
    
    //每月的账单支出
    NSMutableArray *monthOfBill;
    
    //是否加载完毕
    BOOL BillLoadFinish;
    
}

@property (nonatomic,strong)NoOrderView *noOrderView;

//钱包列表
@property (nonatomic,strong)UITableView *walletTableView;
//钱包参数
@property (nonatomic,strong)WalletParams *walletParams;
//账单列表
@property (nonatomic,strong)UITableView *billTableView;
//账单参数
@property (nonatomic,strong)BillParams *billParams;

@end

@implementation MyWalletViewController

-(NoOrderView *)noOrderView {

    if (_noOrderView == nil) {
        
        self.noOrderView = [[[NSBundle mainBundle] loadNibNamed:@"NoOrderView" owner:self options:nil] lastObject];
        self.noOrderView.Logo.image = [UIImage imageNamed:@"暂无收支明细"];
        self.noOrderView.tips.text = @"暂无收支明细";
    }
    return _noOrderView;
}

//请求钱包的参数
-(WalletParams *)walletParams {

    if (_walletParams == nil) {
        self.walletParams = [[WalletParams alloc]init];
    }
    return _walletParams;
}

//请求账单的参数
-(BillParams *)billParams {
    
    if (_billParams == nil) {
        self.billParams = [[BillParams alloc]init];
    }
    return _billParams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    walletAll = [NSMutableArray array];
    walletIn  = [NSMutableArray array];
    walletOut = [NSMutableArray array];
    walletAllList = [NSMutableArray array];
    walletInList  = [NSMutableArray array];
    walletOutList = [NSMutableArray array];
    monthOfBill   = [NSMutableArray array];
    
    billAll        = [NSMutableArray array];
    billAllList    = [NSMutableArray array];
    
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self initSubViews];
}

- (void)initSubViews {
    
    navigationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [navigationBtn setTitle:@"钱包收支" forState:UIControlStateNormal];
    [navigationBtn setTitleColor:[UIColor fromHexValue:0x555555] forState:UIControlStateNormal];
    navigationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    navigationBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 90, 0, 0);
    navigationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navigationBtn addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    self.navigationItem.titleView = navigationBtn;

    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView.contentSize = CGSizeMake(self.view.width*2, kScreenHeight);
    scrollView.scrollEnabled = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    //钱包头部试图
    walletHeadView = [[[NSBundle mainBundle] loadNibNamed:@"WalletHeadView" owner:self options:nil] lastObject];
    walletHeadView.frame = CGRectMake(0, 0, scrollView.width, 120);
    [scrollView addSubview:walletHeadView];
    
    __weak MyWalletViewController *weakSelf = self;
    
    walletHeadView.walletTypeBlock = ^(NSInteger btnTag) {
        
        [weakSelf.walletTableView.mj_header beginRefreshing];
        weakSelf.walletParams.type = btnTag-100;
    };

    //钱包列表
    self.walletTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, scrollView.width, scrollView.height - 120 - 49 - 20)];
    self.walletTableView.delegate = self;
    self.walletTableView.dataSource = self;
    self.walletTableView.tableFooterView = [UIView new];
    self.walletTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, -8);
    [scrollView addSubview:self.walletTableView];
    self.walletTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshWalletData];
    }];
    self.walletTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadWalletData];
    }];
    [self.walletTableView.mj_header beginRefreshing];

    //账单列表
    self.billTableView = [[UITableView alloc]initWithFrame:CGRectMake(scrollView.width, 0, scrollView.width, scrollView.height - 49 - 20)];
    self.billTableView.delegate = self;
    self.billTableView.dataSource = self;
    self.billTableView.tableFooterView = [UIView new];
    self.billTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, -8);
    [scrollView addSubview:self.billTableView];
    self.billTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self refreshBillData];
    }];
    self.billTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadBillData];
    }];
}

#pragma UIButton Action
- (void)switchAction {

    __block SwitchWalletBillView *maskView = [[SwitchWalletBillView alloc]initWithFrame:self.view.bounds data:@[@"钱包收支",@"账单记录"]];
    maskView.switchTableBlock = ^(NSInteger indexRow) {
        
        if (indexRow == 0) {
            [navigationBtn setTitle:@"钱包收支" forState:UIControlStateNormal];
        }else {
            [navigationBtn setTitle:@"账单记录" forState:UIControlStateNormal];
            
            if (billAll.count == 0) {
                
                [self refreshBillData];
            }
        }
        
        [maskView removeFromSuperview];
        maskView = nil;
        scrollView.contentOffset = CGPointMake(indexRow*scrollView.width, scrollView.contentOffset.y);
        
    };
    maskView.removeMaskBlock = ^{
        [maskView removeFromSuperview];
        maskView = nil;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
}

- (void)backAction {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (tableView == self.walletTableView) {
        
        switch (self.walletParams.type) {
            case 0:
                return walletAll.count;
                break;
            case 1:
                return walletOut.count;
                break;
            case 2:
                return walletIn.count;
                break;
                
            default:
                break;
        }
    }else {
    
        return billAll.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.walletTableView) {
        switch (self.walletParams.type) {
            case 0:
                return ((NSMutableArray *)walletAll[section]).count;
                break;
            case 1:
                return ((NSMutableArray *)walletOut[section]).count;
                break;
            case 2:
                return ((NSMutableArray *)walletIn[section]).count;
                break;
                
            default:
                break;
        }
    }else {
    
        return ((NSMutableArray *)billAll[section]).count;
    }

    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSArray *nowData = [[[NSDate date] toYMDString] componentsSeparatedByString:@"-"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = [UIColor fromHexValue:0xE5E5E5];
    
    if (tableView == self.billTableView) {
        
        MonthBillModel *monthBillModel = monthOfBill[section];
        NSArray *monthA = [monthBillModel.creat_time componentsSeparatedByString:@"-"];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-5, 0, kScreenWidth/2-5, 30)];
        label2.textColor = [UIColor fromHexValue:0x999999];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textAlignment = NSTextAlignmentRight;
        
        if ([monthA[0] isEqualToString:nowData[0]]) {
            
            label2.text = [NSString stringWithFormat:@"本月支出：%.2f  ",[monthBillModel.expenditureAll doubleValue]];
        }else {
        
            label2.text = [NSString stringWithFormat:@"本年支出：%.2f  ",[monthBillModel.expenditureAll doubleValue]];
        }
        
        [view addSubview:label2];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, 30)];
    label.textColor = [UIColor fromHexValue:0x555555];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    WalletModel *model;
    
    if (tableView == self.walletTableView) {
        
        switch (self.walletParams.type) {
            case 0:
                model = walletAll[section][0];
                break;
            case 1:
                model = walletOut[section][0];
                break;
            case 2:
                model = walletIn[section][0];
                break;
                
            default:
                break;
        }
    }else {
    
        model = billAll[section][0];
    }
    
    NSArray *dataDate = [model.creat_time componentsSeparatedByString:@"-"];
    
    
    if ([dataDate[0] isEqualToString:nowData[0]]) {
        
        if ([dataDate[1] isEqualToString:nowData[1]]) {
            
            label.text = @"  本月";
            
        }else {
        
            label.text = [NSString stringWithFormat:@"  %d月",[dataDate[1] intValue]];
        }
    }else {
    
        label.text = [NSString stringWithFormat:@"  %d年",[dataDate[0] intValue]];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"walletCell";
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WalletCell" owner:self options:nil] lastObject];
    }
    WalletModel *model;
    if (tableView == self.walletTableView) {
        switch (self.walletParams.type) {
            case 0:
                model = walletAll[indexPath.section][indexPath.row];
                break;
            case 1:
                model = walletOut[indexPath.section][indexPath.row];
                break;
            case 2:
                model = walletIn[indexPath.section][indexPath.row];
                break;
                
            default:
                break;
        }
    }else {
    
        model = billAll[indexPath.section][indexPath.row];
    }
    
    cell.payTime.text = [[model.creat_time substringWithRange:NSMakeRange(5, 11)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    if (tableView == self.walletTableView) {
        //支出
        if ([model.expenditure_money doubleValue] > 0) {
            
            cell.costMoney.text = [NSString stringWithFormat:@"-%@",[STCommon setHasSuffix:model.expenditure_money]];
            cell.costMoney.textColor = [UIColor fromHexValue:0x555555];
        }else {
            
            cell.costMoney.textColor = [UIColor fromHexValue:0xEA5413];
            cell.costMoney.text = [NSString stringWithFormat:@"+%@",[STCommon setHasSuffix:model.income_money]];
        }
    }else {
    
        //支出
        if ([model.expenditure_money doubleValue] > 0) {
            
            cell.costMoney.text = [NSString stringWithFormat:@"-%@",[STCommon setHasSuffix:model.expenditure_money]];
            cell.costMoney.textColor = [UIColor fromHexValue:0x555555];
        }else {
            
            cell.costMoney.textColor = [UIColor fromHexValue:0xEA5413];
            cell.costMoney.text = [NSString stringWithFormat:@"+%@",[STCommon setHasSuffix:model.income_money]];
        }
    }
    
    if (tableView == self.walletTableView) {
        
        if ([model.expenditure_money doubleValue] > 0) {
            cell.payMethod.text = model.payfriendname;
        }else {
            cell.payMethod.text = [NSString stringWithFormat:@"退款-%@",model.payfriendname];
        }
        cell.lastMontyH.constant = 0;
        
    }else {
        
        cell.lastMontyH.constant = 16.5;
        //支出
        if ([model.expenditure_money doubleValue] > 0) {
            
            if ([model.payfriendname isEqualToString:@"其他原因"]) {
                cell.payMethod.text = @"其他原因";
            }else {
                cell.payMethod.text = @"在线支付";
            }
        }else { //收入
            cell.payMethod.text = @"退款";
        }
        cell.lastMoney.text = model.payfriendname.length > 0 ?[NSString stringWithFormat:@"%@",model.payfriendname] : @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WalletModel *model;
    if (tableView == self.walletTableView) {
        switch (self.walletParams.type) {
            case 0:
                model = walletAll[indexPath.section][indexPath.row];
                break;
            case 1:
                model = walletOut[indexPath.section][indexPath.row];
                break;
            case 2:
                model = walletIn[indexPath.section][indexPath.row];
                break;
                
            default:
                break;
        }
    }else {
        
        model = billAll[indexPath.section][indexPath.row];
    }
    
    NSLog(@"payfriendname = %@",model.payfriendname);
    
    if (![model.payfriendname isEqualToString:@"其他原因"]) {
        
        MyWalletDetailController *walletDetail = [MyWalletDetailController new];
        walletDetail.paramsDic = @{@"id":model.id};
        [self.navigationController pushViewController:walletDetail animated:YES];
    }
}


#pragma mark*****************钱包********************
//刷新钱包
- (void)refreshWalletData {
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];

    self.walletParams.pageindex = 1;
    
    [KSMNetworkRequest postRequest:requestWallet params:self.walletParams.mj_keyValues success:^(id responseObj) {
        
        [self.walletTableView.mj_header endRefreshing];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        
        
        NSArray *dataArray = [responseObj objectForKey:@"Balance_list"];
        
        if (dataArray.count > 0) {
            
            [_noOrderView removeFromSuperview];
            _noOrderView = nil;
            
            walletHeadView.balanceLabel.text = [NSString stringWithFormat:@"%.2f",[[responseObj objectForKey:@"BalanceCount"] doubleValue]];
            
            switch (self.walletParams.type) {
                case 0:
                    walletAllLoadFinish = false;
                    if (self.walletParams.pageindex  == [[responseObj objectForKey:@"PageCount"] integerValue]) {
                        walletAllLoadFinish = YES;
                    }
                    walletAllList = [WalletModel mj_objectArrayWithKeyValuesArray:dataArray];
                    walletAll = [self dealDataByTime:walletAllList];
                    break;
                case 1:
                    walletOutLoadFinish = false;
                    if (self.walletParams.pageindex == [[responseObj objectForKey:@"PageCount"] integerValue]) {
                        walletOutLoadFinish = YES;
                    }
                    walletOutList = [WalletModel mj_objectArrayWithKeyValuesArray:dataArray];
                    walletOut = [self dealDataByTime:walletOutList];
                    break;
                case 2:
                    walletInLoadFinish  = false;
                    if (self.walletParams.pageindex == [[responseObj objectForKey:@"PageCount"] integerValue]) {
                        walletInLoadFinish = YES;
                    }
                    walletInList  = [WalletModel mj_objectArrayWithKeyValuesArray:dataArray];
                    walletIn = [self dealDataByTime:walletInList];
                    break;
                    
                default:
                    break;
            }
        }else {
            
            self.noOrderView.frame = CGRectMake((kScreenWidth-100)/2, 80, 100, 120);
            [self.walletTableView addSubview:self.noOrderView];
            
            switch (self.walletParams.type) {
                case 0:
                    walletAllLoadFinish = YES;
                    [walletAllList removeAllObjects];
                    [walletAll removeAllObjects];
                    break;
                case 1:
                    walletOutLoadFinish = YES;
                    [walletOutList removeAllObjects];
                    [walletOut removeAllObjects];
                    break;
                case 2:
                    walletInLoadFinish  = YES;
                    [walletInList removeAllObjects];
                    [walletIn removeAllObjects];
                    break;
                    
                default:
                    break;
            }
        }
        
        [self.walletTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.walletTableView.mj_header endRefreshing];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [ZHProgressHUD showErrorWithText:@"网络不给力！"];
    }];
}

//加载钱包
- (void)loadWalletData {

    switch (self.walletParams.type) {
        case 0:
            
            if (walletAllLoadFinish) {
                
                [ZHProgressHUD showInfoWithText:@"没有更多数据了"];
                [self.walletTableView.mj_footer endRefreshing];
                
                return;
            }
            
            break;
        case 1:
            if (walletOutLoadFinish) {
                
                [ZHProgressHUD showInfoWithText:@"没有更多数据了"];
                [self.walletTableView.mj_footer endRefreshing];
                
                return;
            }
            
            break;
        case 2:
            if (walletInLoadFinish) {
                
                [ZHProgressHUD showInfoWithText:@"没有更多数据了"];
                [self.walletTableView.mj_footer endRefreshing];
                
                return;
            }
            
            break;
            
        default:
            break;
    }
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    self.walletParams.pageindex += 1;
    
    [KSMNetworkRequest postRequest:requestWallet params:self.walletParams.mj_keyValues success:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    
        FxLog(@"walletParams = %@",self.walletParams);
        
        NSDictionary *walletData = (NSDictionary *)responseObj;
        [self.walletTableView.mj_footer endRefreshing];
        
        walletHeadView.balanceLabel.text = [NSString stringWithFormat:@"%.2f",[[walletData objectForKey:@"BalanceCount"] doubleValue]];
        
        switch (self.walletParams.type) {
            case 0:
                if (self.walletParams.pageindex == [[walletData objectForKey:@"PageCount"] integerValue]) {
                    walletAllLoadFinish = YES;
                }
                [walletAllList addObjectsFromArray:[WalletModel mj_objectArrayWithKeyValuesArray:[walletData objectForKey:@"Balance_list"]]];
                walletAll = [self dealDataByTime:walletAllList];
                
                break;
            case 1:
                if (self.walletParams.pageindex == [[walletData objectForKey:@"PageCount"] integerValue]) {
                    walletOutLoadFinish = YES;
                }
                [walletOutList addObjectsFromArray:[WalletModel mj_objectArrayWithKeyValuesArray:[walletData objectForKey:@"Balance_list"]]];
                walletOut = [self dealDataByTime:walletOutList];
                break;
            case 2:
                if (self.walletParams.pageindex == [[walletData objectForKey:@"PageCount"] integerValue]) {
                    walletInLoadFinish = YES;
                }
                [walletInList addObjectsFromArray:[WalletModel mj_objectArrayWithKeyValuesArray:[walletData objectForKey:@"Balance_list"]]];
                walletIn = [self dealDataByTime:walletInList];
                break;
                
            default:
                break;
        }
        
        
        [self.walletTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [self.walletTableView.mj_footer endRefreshing];
        [ZHProgressHUD showErrorWithText:@"网络不给力！"];
    }];
}


#pragma mark *****************账单********************
//刷新账单
- (void)refreshBillData {

    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    self.billParams.pageindex = 1;
    
    [KSMNetworkRequest postRequest:requestBill params:self.billParams.mj_keyValues success:^(id responseObj) {
        
        [self.billTableView.mj_header endRefreshing];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];

        NSArray *billList = [responseObj objectForKey:@"Bill_list"];
        NSMutableArray *expenditureList = [responseObj objectForKey:@"expenditure_list"];
        
        if (billList.count > 0) {
            
            [_noOrderView removeFromSuperview];
            _noOrderView = nil;
            
            BillLoadFinish = false;
            if (self.billParams.pageindex == [[responseObj objectForKey:@"PageCount"] integerValue]) {
                BillLoadFinish = YES;
            }
            billAllList = [WalletModel mj_objectArrayWithKeyValuesArray:billList];
            billAll = [self dealDataByTime:billAllList];
            
            monthOfBill = [MonthBillModel mj_objectArrayWithKeyValuesArray:expenditureList];
        }else {
        
            self.noOrderView.frame = CGRectMake((kScreenWidth-100)/2, 80, 100, 120);
            [self.billTableView addSubview:self.noOrderView];
            
            BillLoadFinish = YES;
            [billAllList removeAllObjects];
            [billAll removeAllObjects];
            [monthOfBill removeAllObjects];
            
        }
        
        [self.billTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [self.billTableView.mj_header endRefreshing];
        [ZHProgressHUD showErrorWithText:@"网络不给力！"];
    }];
}

//加载账单
- (void)loadBillData {

    if (BillLoadFinish) {
        
        [ZHProgressHUD showInfoWithText:@"没有更多数据了"];
        [self.billTableView.mj_footer endRefreshing];
        
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    self.billParams.pageindex += 1;

    [KSMNetworkRequest postRequest:requestBill params:self.billParams.mj_keyValues success:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        FxLog(@"billParams = %@",self.billParams);
        [self.billTableView.mj_footer endRefreshing];

        if (self.billParams.pageindex == [[responseObj objectForKey:@"PageCount"] integerValue]) {
            BillLoadFinish = YES;
        }
        [billAllList addObjectsFromArray:[WalletModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"Bill_list"]]];
        billAll = [self dealDataByTime:billAllList];
        
        monthOfBill = [self monthOfBill:[MonthBillModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"expenditure_list"]]];

        [self.billTableView reloadData];
        
    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [self.billTableView.mj_footer endRefreshing];
        [ZHProgressHUD showErrorWithText:@"网络不给力！"];
    }];
}

#pragma mark 根据时间来分类
- (NSMutableArray *)dealDataByTime:(NSArray *)allDataArray {

    //当前年份
    NSArray *nowYear = [[[NSDate date] toYMDString] componentsSeparatedByString:@"-"];
    
    NSMutableArray *returnArr = [NSMutableArray array];
    if (allDataArray.count == 0) {
        
        return returnArr;
    }
    NSMutableArray *middle = [NSMutableArray arrayWithObject:allDataArray[0]];
    [returnArr addObject:middle];

    for (NSInteger i = 1; i < allDataArray.count; i++){
        BOOL isCreat = NO;
        for (int j = 0; j<returnArr.count; j++){
            
            WalletModel *model = (WalletModel *)(NSMutableArray *)returnArr[j][0];
            WalletModel *m = allDataArray[i];
            
            if ([[model.creat_time componentsSeparatedByString:@"-"][0] isEqualToString:([m.creat_time componentsSeparatedByString:@"-"][0])]) {
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
    
    
    NSMutableArray *finalArr = [NSMutableArray arrayWithArray:returnArr];
    
    for (NSMutableArray *array in returnArr) {
        
        WalletModel *model = array[0];
        
        if ([[model.creat_time componentsSeparatedByString:@"-"][0] isEqualToString:nowYear[0]]) {
            
            [finalArr removeObject:array];
            
            NSMutableArray *middle = [NSMutableArray arrayWithObject:array.lastObject];
            [finalArr insertObject:middle atIndex:0];
            
            for (NSInteger i = array.count-2; i >= 0; i--){
                BOOL isCreat = NO;
                for (int j = 0; j<finalArr.count; j++) {
                    
                    WalletModel *model = (WalletModel *)(NSMutableArray *)finalArr[j][0];
                    WalletModel *m = array[i];
                    
                    if ([[model.creat_time componentsSeparatedByString:@"-"][1] isEqualToString:[m.creat_time componentsSeparatedByString:@"-"][1]]) {
                        [(NSMutableArray *)finalArr[j] insertObject:array[i] atIndex:0];
                        isCreat = YES;
                    }
                }
                if (!isCreat) {
                    NSMutableArray *other = [[NSMutableArray alloc]init];
                    [other addObject:array[i]];
                    [finalArr insertObject:other atIndex:0];
                }
            }
        }
    }
    return finalArr;
}

- (NSMutableArray *)monthOfBill:(NSArray *)billDataArray {

    NSMutableArray *array = [NSMutableArray arrayWithArray:monthOfBill];
    
    for (int i = 0 ; i < billDataArray.count; i++) {
         MonthBillModel *new = billDataArray[i];
//         for (int j = 0 ; j < array.count; j++) {
//             MonthBillModel *old = billDataArray[j];
            if (![self containObject:array object:new]) {
                [monthOfBill addObject:new];
            }
//        }
    }
    return monthOfBill;
}

- (BOOL)containObject:(NSArray *)array object:(MonthBillModel *)obj {

    int count = 0;
    for (MonthBillModel *model in array) {
        
        if (![obj.creat_time isEqualToString:model.creat_time]) {
            count ++;
        }
    }
    
    if (count == array.count) {
        return NO;
    }
    return YES;
}

@end
