//
//  MixturePayGoodListViewController.m
//  sosoYY
//
//  Created by zhy on 2017/8/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "MixturePayGoodListViewController.h"
#import "MixturePayGoodsModel.h"
#import "MixturePayStoreModel.h"
#import "MixtureTableHeadView.h"
#import "BlankNoteCell.h"
#import "UnBlankNoteCell.h"
#import "IOUPayViewController.h"
@interface MixturePayGoodListViewController ()<UITableViewDelegate,UITableViewDataSource>
//实付金额
@property (weak, nonatomic) IBOutlet UILabel *ActualPayLab;
//白条支付
@property (weak, nonatomic) IBOutlet UIButton *IOUBtn;
//现金支付
@property (weak, nonatomic) IBOutlet UIButton *ActualBtn;

@property (nonatomic, strong) UITableView *tableView;

//支持白条的店铺列表
@property (nonatomic,copy)NSArray *BlankNoteStoreList;
//不支持白条的店铺列表
@property (nonatomic,copy)NSArray *UnBlankNoteStoreList;
@end

@implementation MixturePayGoodListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}

- (void)setUp {

    __weak MixturePayGoodListViewController *weakSelf = self;
    self.ActualPayLab.text = [NSString stringWithFormat:@"￥%@",[STCommon setHasSuffix:self.result[@"OrderAmount_NoteBlank"]]];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+35, kScreenWidth, kScreenHeight-64-49-35) style:UITableViewStylePlain];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    tableFooterView.backgroundColor = [UIColor fromHexValue:0xF0F0F0];
    self.tableView.tableFooterView = tableFooterView;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark 请求数据
- (void)loadData {

    __weak MixturePayGoodListViewController *weakSelf = self;
    [KSMNetworkRequest postRequest:requestIOUPrePayStoreList params:@{@"masterOid":self.result[@"MasterOidList"]} success:^(id responseObj) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"responseObj = %@",responseObj);
        
        if ([responseObj[@"success"] integerValue] == 1) {
            
            
            NSDictionary *data = responseObj[@"data"];
            NSArray *BlankNoteStoreList = data[@"BlankNoteStoreList"];
            self.BlankNoteStoreList = [MixturePayStoreModel mj_objectArrayWithKeyValuesArray:BlankNoteStoreList];
            
            self.UnBlankNoteStoreList = data[@"UnBlankNoteStoreList"];
            
            [weakSelf.tableView reloadData];
            
        }else {
        
            [ZHProgressHUD showInfoWithText:@"网络错误，请重试！"];
        }
        
    } failure:^(NSError *error) {
        
        [ZHProgressHUD showInfoWithText:@"网络错误，请重试！"];
    }];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.BlankNoteStoreList.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.UnBlankNoteStoreList.count;
    }else {
    
        MixturePayStoreModel *model = self.BlankNoteStoreList[section-1];
        return model.OrderProductList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return 44;
    }else {
    
        return 65;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 10;
    }else {
    
        return 54;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section > 0) {
        MixturePayStoreModel *model = self.BlankNoteStoreList[section-1];
        MixtureTableHeadView *head = [[[NSBundle mainBundle] loadNibNamed:@"MixtureTableHeadView" owner:self options:nil] lastObject];
        head.frame = CGRectMake(0, 0, kScreenWidth, 54);
        head.storeNameLab.text = model.StoreName;
        head.ShipFeelab.text = [NSString stringWithFormat:@"邮费：￥%@",[STCommon setHasSuffix:model.StoreShipFee]];
        head.AmountLab.text = [NSString stringWithFormat:@"小计：￥%@",[STCommon setHasSuffix:model.StoreOrderAmount]];
        return head;
    }else {
        
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        head.backgroundColor = [UIColor fromHexValue:0xF0F0F0];
        return head;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        static NSString *reuser = @"UnBlankNoteCell";
        UnBlankNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"UnBlankNoteCell" owner:self options:nil] lastObject];
        }
        NSDictionary *dic = self.UnBlankNoteStoreList[indexPath.row];
        cell.StoreNameLab.text = dic[@"StoreName"];
        return cell;
    }else {
    
        static NSString *reuser = @"BlankNoteCell";
        BlankNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
        if (!cell) {
            cell =  [[[NSBundle mainBundle] loadNibNamed:@"BlankNoteCell" owner:self options:nil] lastObject];
        }
        
        MixturePayStoreModel *storeModel = self.BlankNoteStoreList[indexPath.section-1];
        MixturePayGoodsModel *goodModel = storeModel.OrderProductList[indexPath.row];
        
        CGRect frame = [goodModel.ProductName boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil] context:nil];

        //判断特价
        if ([goodModel.SpelPriceTag integerValue] == 1) {
            
            cell.produceNameLabW.constant = frame.size.width;
            cell.lineImg.hidden = YES;
            cell.deleteLine.hidden = NO;
            cell.addPriceLabWidth.constant = 0;
            //原价
            cell.oriPriceLab.text = [NSString stringWithFormat:@"￥%@",[STCommon setHasSuffix:goodModel.ShopPrice]];
            cell.oriPriceLab.textColor = [UIColor fromHexValue:0x777777];
            cell.oriPriceLab.font = [UIFont systemFontOfSize:12];
            //特价
            cell.sepPriceLab.text = [NSString stringWithFormat:@"￥%@",[STCommon setHasSuffix:goodModel.DiscountPrice]];
            
         //判断加价购
        }else if ([goodModel.AddPriceTag integerValue] == 1) {
            
                if (frame.size.width > kScreenWidth/2) {
                    cell.produceNameLabW.constant = kScreenWidth/2;
                }else {
                    cell.produceNameLabW.constant = frame.size.width;
                }
                cell.lineImg.hidden =  NO;
                cell.sepPriceLab.text = @"";
                cell.deleteLine.hidden = YES;
                cell.oriPriceLab.text = goodModel.AddPriceDes;
                cell.addPriceLabWidth.constant = 44;
            
        }else {
        
            cell.produceNameLabW.constant = frame.size.width;
            cell.lineImg.hidden = YES;
            cell.deleteLine.hidden = YES;
            cell.addPriceLabWidth.constant = 0;
            cell.sepPriceLab.text = @"";
            cell.oriPriceLab.text = [NSString stringWithFormat:@"￥%@",[STCommon setHasSuffix:goodModel.DiscountPrice]];
            cell.oriPriceLab.textColor = [UIColor fromHexValue:0x555555];
            cell.oriPriceLab.font = [UIFont systemFontOfSize:15];
        }
    
        
        cell.produceNameLab.text = goodModel.ProductName;
        cell.DrugsLab.text = goodModel.DrugsBase_Specification;
        cell.buyCountLab.text = [NSString stringWithFormat:@"x%@",[STCommon setHasSuffix:goodModel.BuyCount]];
        return cell;
    }
}

#pragma mark 现金支付
- (IBAction)ActualPayClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 白条支付
- (IBAction)IOUPayClick:(id)sender {
    
    IOUPayViewController *iouPayVC = [[IOUPayViewController alloc]init];
    iouPayVC.result = _result;
    [self.navigationController pushViewController:iouPayVC animated:YES];
}

- (IBAction)BackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
