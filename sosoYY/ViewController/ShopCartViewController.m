//
//  ShopCartViewController.m
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//

//#define WIDTH  ([UIScreen mainScreen].bounds.size.width)
//#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "ShopCartViewController.h"
#import "ShopCartCell.h"
#import "ShopCartHead.h"
#import "ShopCartFooter.h"
#import "BottomToolView.h"
#import "GoodSelectParams.h"
#import "UPPaymentControl.h"
#import "STShopHomeViewController.h"
#import "STPaymentDetailsViewController.h"
#import "STProductDetailsViewController.h"
#import "StoreInfoModel.h"
#import "OrderProductInfoModel.h"
#import "AddPriceBuyModel.h"
#import "SpecialPriceModel.h"
#import "AddProductModel.h"
@interface ShopCartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView    *tableV;
@property (nonatomic,strong)NSMutableArray *StoreCartList;
@property (nonatomic,strong)NSMutableArray *StoreInfoList;
@property (nonatomic,strong)BottomToolView *bottomTool;

@property (nonatomic,strong)GoodSelectParams *goodSelectP;

@end

@implementation ShopCartViewController


//是否选中
-(GoodSelectParams *)goodSelectP {
    
    if (_goodSelectP == nil) {
        
        self.goodSelectP = [[GoodSelectParams alloc]init];
    }
    return _goodSelectP;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _StoreCartList = [NSMutableArray array];
        _StoreInfoList = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeGoTab:) name:Notice_GoTab object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCount:) name:refresh_shopCart object:nil];
    }
    return self;
}

-(void)refreshCount:(NSNotification*) noticication {
    
    [self requestData];
}

- (void)initSubViews {
    
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49-50) style:UITableViewStyleGrouped];
    _tableV.showsVerticalScrollIndicator = NO;
    _tableV.showsHorizontalScrollIndicator = NO;
    _tableV.separatorColor = [UIColor clearColor];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.estimatedRowHeight = 110;
    [self.view addSubview:_tableV];
    
    _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestData];
    }];
    
    _bottomTool = [[[NSBundle mainBundle]loadNibNamed:@"BottomToolView" owner:self options:nil] lastObject];
    _bottomTool.frame = CGRectMake(0, self.tableV.bottom, kScreenWidth, 50);
    [self.view addSubview:_bottomTool];
    
    
    [_bottomTool selectAllMethod:^(BOOL select) {
        
        if (select) {
            
            //全部商品设置成选中
            for (int i = 0; i<_StoreCartList.count; i++) {
                NSArray *array = _StoreCartList[i];
                for (int j = 0; j<array.count; j++) {
                    ((OrderProductInfoModel *)((NSArray *)_StoreCartList[i])[j]).IsSelect = @"1";
                }
            }
        }else {
            
            //全部商品设置成未选中
            for (int i = 0; i<_StoreCartList.count; i++) {
                NSArray *array = _StoreCartList[i];
                for (int j = 0; j<array.count; j++) {
                    ((OrderProductInfoModel *)((NSArray *)_StoreCartList[i])[j]).IsSelect = @"0";
                }
            }
        }
        [_tableV reloadData];
        
    }];
    
    
    [_bottomTool toBalanceMethod:^{
        
        if ([self totalCash] > 0.0) {
            
            _bottomTool.goBalanceButton.userInteractionEnabled = NO;
            [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
            
            NSMutableArray *jsonArr = [NSMutableArray array];
            NSMutableArray *pidArr = [NSMutableArray array];
            
            BOOL isAlert = NO;
            
            for (int i = 0; i<_StoreCartList.count; i++) {
                
                //店铺信息
                StoreInfoModel *storeInfo = _StoreInfoList[i];
                NSArray *array = _StoreCartList[i];
                //不满发货金额的  不能结算
                if ([storeInfo.LowestdeliveryAmount floatValue] > 0 && [storeInfo.LowestdeliveryAmount floatValue] > [self sectionCash:i]) {
                    FxLog(@"不满足发货金额");
                }else {
                    //满足发货金额
                    //遍历商品
                    for (int j = 0; j<array.count; j++) {;
                        OrderProductInfoModel *model = array[j];
                        //商品是否选中
                        if ([model.IsSelect integerValue] == 1) {
                            NSMutableDictionary *dic = [NSMutableDictionary new];
                            [dic setValue:model.Pid forKey:@"pid"];
                            [dic setValue:model.BuyCount forKey:@"buyCount"];
                            [jsonArr addObject:dic];
                            [pidArr addObject:[NSString stringWithFormat:@"0_%@",model.Pid]];
                            //是否超出限购数量
                            if (!isAlert) {
                                
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                ShopCartCell *cell = [_tableV cellForRowAtIndexPath:indexPath];
                                if (cell.SALEViewH.constant > 0) {
                                    isAlert = YES;
                                }
                            }
                        }
                    }
                }
            }
            
            if (isAlert) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"有特价商品超出限购数量，将按原价结算，确定结算吗?" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self verifyAndSubmitOrder:@{@"data":jsonArr.mj_JSONString} pid:pidArr];
                    
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else {
                
                [self verifyAndSubmitOrder:@{@"data":jsonArr.mj_JSONString} pid:pidArr];
            }
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请先选择购物车商品" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [MobClick endLogPageView:@"购物车"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addTabNavView];
    
    /**
     状态栏颜色
     */
    UILabel *navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    navigationBarLabel.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
    navigationBarLabel.text = @"购物车";
    navigationBarLabel.textColor = [UIColor whiteColor];
    navigationBarLabel.textAlignment = NSTextAlignmentCenter;
    navigationBarLabel.font = [UIFont boldSystemFontOfSize:18];
    //navigation的navigationBar上添加状态栏
    [self.view addSubview:navigationBarLabel];
    
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_GoTab object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:refresh_shopCart object:nil];
}


-(void)noticeGoTab:(NSNotification*)sender {
    
    NSString *index= [sender.userInfo objectForKey:@"selectIndex"];
    self.tabBarController.selectedIndex=[index intValue];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self requestData];
    [MobClick beginLogPageView:@"购物车"];
    self.tabBarController.tabBar.hidden = NO;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)requestData {
    
    if ([Uitils getUserDefaultsForKey:@"cookie"]) {
        FxLog(@"已登录");
        [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [KSMNetworkRequest postRequest:requestShopCart params:nil success:^(id responseObj) {
                [[UIApplication sharedApplication].keyWindow hideToastActivity];
                [_tableV.mj_header endRefreshing];
                [_StoreInfoList removeAllObjects];
                [_StoreCartList removeAllObjects];
                
                _bottomTool.allSelectButton.selected = NO;
                
                NSDictionary *list = [responseObj objectForKey:@"list"];
                NSArray *StoreCartList = [list objectForKey:@"StoreCartList"];
                
                //统计商品种类数量
                NSInteger count = 0;
                if ([StoreCartList count] > 0) {
#pragma mark 封装模型
                    for (NSDictionary *dic in StoreCartList) {
                        
                        NSDictionary *StoreInfo = [dic objectForKey:@"StoreInfo"];
                        //店铺信息
                        [_StoreInfoList addObject:[StoreInfoModel mj_objectWithKeyValues:StoreInfo]];
                        NSMutableArray *array = [NSMutableArray array];
                        NSArray *CartProductList = [dic objectForKey:@"CartProductList"];
                        
                        for (NSDictionary *dic1 in CartProductList) {
                            NSDictionary *OrderProductInfo = [dic1 objectForKey:@"OrderProductInfo"];
                            [array addObject:[OrderProductInfoModel mj_objectWithKeyValues:OrderProductInfo]];
                        }
                        [_StoreCartList addObject:array];
                    }
                    
                    for (int i = 0;i<_StoreCartList.count;i++) {
                        NSArray *array = _StoreCartList[i];
                        for (int j = 0;j<array.count;j++) {
                            OrderProductInfoModel *model = array[j];
#pragma mark 是否选中加价购
                            if ([model.addpricebuyid intValue] > 0 && ([model.addpricebuypernum intValue] + [model.addpricebuynum intValue]) > 0) {
                                ((OrderProductInfoModel *)(NSArray *)_StoreCartList[i][j]).jjgStatus = @"YES";
                            }else {
                                ((OrderProductInfoModel *)(NSArray *)_StoreCartList[i][j]).jjgStatus = @"NO";
                            }
                            count ++;
                        }
                    }
                }else {
                    
                    _bottomTool.totalCash.text = @"¥0.00";
                    _bottomTool.allSelectButton.selected = NO;
                }
                
                // 回到主线程显示图片
                dispatch_async(dispatch_get_main_queue(), ^{
#pragma mark 显示item上面的角标
                    if (count > 0 && count <= 99) {
                        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)count];
                    }else if (count > 99) {
                        self.tabBarItem.badgeValue = @"99+";
                        
                    }else {
                        self.tabBarItem.badgeValue = nil;
                    }
                    
                    [_tableV reloadData];
                });
                
            } failure:^(NSError *error) {
                
                [_tableV.mj_header endRefreshing];
                [[UIApplication sharedApplication].keyWindow hideToastActivity];
            }];
        });
        
    }else {
        
        FxLog(@"未登录");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_StoreCartList.count > 0) {
                [_StoreCartList removeAllObjects];
                [_StoreInfoList removeAllObjects];
                [_tableV reloadData];
            }
            self.tabBarItem.badgeValue = nil;
            self.tabBarController.selectedIndex = 4;
        });
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _StoreCartList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *storeArray = _StoreCartList[section];
    return storeArray.count;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ShopCartCell";
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopCartCell" owner:self options:nil]lastObject];
    }
    
    //请求成功后，判断商品时候全部选中
    if ([self isAllSelected]) {
        _bottomTool.allSelectButton.selected = YES;
    }else {
        _bottomTool.allSelectButton.selected = NO;
    }
    
    __weak ShopCartCell *weakCell = cell;
    
    NSArray *array = _StoreCartList[indexPath.section];
    OrderProductInfoModel *model = array[indexPath.row];
    cell.OrderProductInfo = model;
    
    cell.oldCount = model.BuyCount;
    //商品是否选中
    cell.selectBtn.selected =  [model.IsSelect isEqualToString:@"1"] ? YES : NO;
    
#pragma mark 进入详情
    [cell toProDetailMethod:^{
        
        STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
        detailsVC.urlStr =  [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,model.Pid];
        [self tabBarControllerHidden];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }];
    
    //特价商品
    if ([model.specialpricemodel.pid doubleValue] > 0 && [self betweenTime:model.specialpricemodel]) {
        //特价
        cell.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f",[model.specialpricemodel.speprice doubleValue]];
        //原价
        cell.oriGoodsPrice.text = [NSString stringWithFormat:@"¥%.2f",model.ShopPrice.doubleValue];
        cell.oriGoodsPriceH.constant = 20;
        cell.deleteOriPriceLine.hidden = NO;
        //限购的情况
        if ([model.specialpricemodel.limittype integerValue] != 0) {
            //超过了限购的数量，按照原价出售
            if ([model.specialpricemodel.limitnumber doubleValue] - [model.specialpricemodel.buycount doubleValue] < [model.BuyCount doubleValue]) {
                
                //限购数等于已购数，则不提示
                if ([model.specialpricemodel.limitnumber doubleValue]==[model.specialpricemodel.buycount doubleValue]) {
                    
                    cell.SALEViewH.constant = 0;
                }else {
                    
                    cell.SALEViewH.constant = 35;
                    if ([model.BagCount doubleValue] > 0) {
                        
                        cell.SALE_Alert.text = [NSString stringWithFormat:@"超出限购数量%.2f，将按原价结算",[model.specialpricemodel.limitnumber doubleValue]-[model.specialpricemodel.buycount doubleValue]];
                    }else {
                        
                        cell.SALE_Alert.text = [NSString stringWithFormat:@"超出限购数量%.0f，将按原价结算",[model.specialpricemodel.limitnumber doubleValue]-[model.specialpricemodel.buycount doubleValue]];
                    }
                }
                //按原价出售
                cell.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f",[model.ShopPrice doubleValue]];
                cell.oriGoodsPriceH.constant = 0;
                cell.deleteOriPriceLine.hidden = YES;
                
            }else { //没有超过限购数量
                
                cell.SALEViewH.constant = 0;
            }
        }else { //不限购
            
            cell.SALEViewH.constant = 0;
        }
    }else {
        
        //价格
        cell.goodsPrice.text = [NSString stringWithFormat:@"¥%.2f",[model.ShopPrice doubleValue]];
        cell.oriGoodsPriceH.constant = 0;
        cell.deleteOriPriceLine.hidden = YES;
        cell.SALEViewH.constant = 0;
    }
    
    //加价购商品
    if (model.addproduct) {
        cell.jjgH.constant = 70;
        [Uitils cacheImage:model.addproduct.SmallImageUrl withImageV:cell.jjgImg withPlaceholder:@"加价小图"];
        cell.jjgName.text = model.addproduct.Name;
        cell.jjgStore.text = model.addproduct.DrugsBase_Manufacturer;
        cell.jjgspecification.text = model.addproduct.DrugsBase_Specification;
    }else {
        
        cell.jjgH.constant = 0;
    }
    
    if ([model.addpricebuymodel.addPriceType integerValue] == 0) {
        
        if ([model.BagCount doubleValue] > 0) {
            cell.jjgCount.text = [NSString stringWithFormat:@"X%.2f%@",[model.addpricebuymodel.secondProudctNum doubleValue],model.addproduct.Goods_Unit];
        }else {
            cell.jjgCount.text = [NSString stringWithFormat:@"X%@%@",model.addpricebuymodel.secondProudctNum,model.addproduct.Goods_Unit];
        }
        
    }else if ([model.addpricebuymodel.addPriceType integerValue] == 1){
        
        if ([model.BagCount doubleValue] > 0) {
            cell.jjgCount.text = [NSString stringWithFormat:@"X%.2f%@",[model.addpricebuymodel.secondProudctNum doubleValue]*(int)([model.BuyCount doubleValue]/[model.addpricebuymodel.firstProudctPerNum doubleValue]),model.addproduct.Goods_Unit];
        }else {
            cell.jjgCount.text = [NSString stringWithFormat:@"X%d%@",[model.addpricebuymodel.secondProudctNum intValue]*(int)([model.BuyCount intValue]/[model.addpricebuymodel.firstProudctPerNum intValue]),model.addproduct.Goods_Unit];
        }
    }
    
    //选中商品，在判断是否开启加价购
    if ([model.IsSelect isEqualToString:@"1"]) {
        cell.switchCtrl.on = [model.jjgStatus boolValue];
        cell.switchCtrl.userInteractionEnabled = YES;
    }else {
        
        //未选中的时候，不能加价购
        cell.switchCtrl.userInteractionEnabled = NO;
        cell.switchCtrl.on = NO;
    }
    
    //    //未选中的时候，不能加价购
    //    if ([model.IsSelect isEqualToString:@"0"]) {
    //
    //        cell.switchCtrl.userInteractionEnabled = NO;
    //
    //    }else {
    //
    //        cell.switchCtrl.userInteractionEnabled = YES;
    //    }
    
    //如果满足加价购条件，并且商品库存大于加价购商品的标准，并且加价购商品的库存大于加价购商品赠品数
    if (([model.addpricebuymodel.firstpid intValue] > 0 && [model.addpricebuymodel.secondpid intValue] > 0 && [model.stock intValue] > [model.addpricebuymodel.firstProudctStartNum intValue] && [model.addproduct.stock intValue] > [model.addpricebuymodel.secondProudctNum intValue]) || ([model.addpricebuymodel.firstpid intValue] > 0 && [model.addpricebuymodel.secondpid intValue] > 0 && [model.stock intValue] > [model.addpricebuymodel.firstProudctPerNum intValue] && [model.addproduct.stock intValue] > [model.addpricebuymodel.secondProudctNum intValue])) {
        
        cell.GiftViewH.constant = 40;
        //加价购类型----0----满多少，不叠加
        if ([model.addpricebuymodel.addPriceType integerValue] == 0) {
            
            //当前数量大于加价购的标准
            if ([model.BuyCount doubleValue] >= [model.addpricebuymodel.firstProudctStartNum intValue]) {
                
                //加价购和商品一样
                if ([model.addpricebuymodel.firstpid isEqual:model.addpricebuymodel.secondpid]) {
                    cell.jjgLabel.text = [NSString stringWithFormat:@"已购满%@%@,加价%@元可换购本品%@%@",model.addpricebuymodel.firstProudctStartNum,model.Goods_Unit,model.addpricebuymodel.addPrice,model.addpricebuymodel.secondProudctNum,model.addproduct.Goods_Unit];
                    
                }else { //赠品是其他商品
                    cell.jjgLabel.text = [NSString stringWithFormat:@"已购满%@%@,加价%@元可换购指定商品%@%@",model.addpricebuymodel.firstProudctStartNum,model.Goods_Unit,model.addpricebuymodel.addPrice,model.addpricebuymodel.secondProudctNum,model.addproduct.Goods_Unit];
                }
                //当前数量小于加价购的标准
            }else {
                
                //加价购和商品一样
                if ([model.addpricebuymodel.firstpid isEqual:model.addpricebuymodel.secondpid]) {
                    cell.jjgLabel.text = [NSString stringWithFormat:@"购满%@%@,加价%@元可换购本品%@%@",model.addpricebuymodel .firstProudctStartNum,model.Goods_Unit,model.addpricebuymodel.addPrice,model.addpricebuymodel.secondProudctNum,model.addproduct.Goods_Unit];
                    
                }else {//赠品是其他商品
                    
                    cell.jjgLabel.text = [NSString stringWithFormat:@"购满%@%@,加价%@元可换购指定商品%@%@",model.addpricebuymodel.firstProudctStartNum,model.Goods_Unit,model.addpricebuymodel.addPrice,model.addpricebuymodel.secondProudctNum,model.addproduct.Goods_Unit];
                }
            }
            
            //每满多少，叠加
        }else if ([model.addpricebuymodel.addPriceType integerValue] == 1){
            
            if ([model.addpricebuymodel.firstpid isEqual:model.addpricebuymodel.secondpid]) {
                cell.jjgLabel.text = [NSString stringWithFormat:@"每购满%@%@,加价%@元可换购本品%@%@",model.addpricebuymodel.firstProudctPerNum,model.Goods_Unit,model.addpricebuymodel.addPrice,model.addpricebuymodel.secondProudctNum,model.addproduct.Goods_Unit];
            }else {
                
                cell.jjgLabel.text = [NSString stringWithFormat:@"每购满%@%@,加价%@元可换购指定商品%@%@",model.addpricebuymodel.firstProudctPerNum,model.Goods_Unit,model.addpricebuymodel.addPrice,model.addpricebuymodel.secondProudctNum,model.addproduct.Goods_Unit];
            }
        }
        cell.switchCtrl.hidden = NO;
        
    }else {
        
        cell.GiftViewH.constant = 0;
    }
    
#pragma mark加价购开关可以使用的情况下
    if (cell.switchCtrl.userInteractionEnabled) {
        //加价购开关
        [cell JJGSwitchMethod:^(BOOL boo) {
            
            //修改是否开启加价购状态
            cell.jjgH.constant = boo ? 70 : 0;
            //替换加价购开关状态
            ((OrderProductInfoModel *)(NSArray *)_StoreCartList[indexPath.section][indexPath.row]).jjgStatus = boo ? @"YES" : @"NO";
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [_tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            _bottomTool.totalCash.text = [NSString stringWithFormat:@"¥%.2f",round([self totalCash]*100)/100];
        }];
    }
    
#pragma mark删除cell
    [cell deleteProMethod:^{
        [self.tableV beginUpdates];
        if (((NSArray *)_StoreCartList[indexPath.section]).count > 1) {
            
            [(NSMutableArray *)_StoreCartList[indexPath.section] removeObjectAtIndex:indexPath.row];
            [self.tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }else {
            
            [_StoreCartList removeObjectAtIndex:indexPath.section];
            [_StoreInfoList removeObjectAtIndex:indexPath.section];
            [self.tableV deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
        }
        [self.tableV endUpdates];
        [self.tableV reloadData];
        _bottomTool.totalCash.text = [NSString stringWithFormat:@"¥%.2f",round([self totalCash]*100)/100];
        
        if (_StoreInfoList.count == 0) {
            
            self.tabBarItem.badgeValue = nil;
        }
    }];
    
#pragma mark判断这歌组的商品是否全部选中
    [cell cellSelectGoodMethod:^(NSString *select) {
        if ([select isEqualToString:@"1"]) {
            //选中商品的情况下，如果加价购开关开启，显示开关
            if ([model.jjgStatus boolValue]) {
                cell.switchCtrl.on = YES;
            }
        }else {
            //未选中商品的情况下，开关如果开启，隐藏开关
            if ([model.jjgStatus boolValue]) {
                cell.switchCtrl.on = NO;
            }
        }
        //替换商品选中状态
        ((OrderProductInfoModel *)(NSArray *)_StoreCartList[indexPath.section][indexPath.row]).IsSelect = [select isEqualToString:@"1"] ? @"1" : @"0";
        //        [_tableV reloadData];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [_tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        _bottomTool.totalCash.text = [NSString stringWithFormat:@"¥%.2f",round([self totalCash]*100)/100];
        
    }];
    
    //销售方式
    //1 零销售
    //2 中包装
    //3 大包装
    
    //满
    if ([model.addpricebuymodel.addPriceType integerValue] == 0) {
        
        //如果加价购数量 大于当前数量，就隐藏开关
        if ([model.addpricebuymodel.firstProudctStartNum doubleValue] > [model.BuyCount doubleValue]) {
            cell.switchCtrl.hidden = YES;
        }else {//如果加价购数量 小雨当前数量，就隐藏开关
            cell.switchCtrl.hidden = NO;
        }
        
        //每满
    }else if ([model.addpricebuymodel.addPriceType integerValue] == 1){
        
        if ([model.addpricebuymodel.firstProudctPerNum doubleValue] > [model.BuyCount doubleValue]) {
            cell.switchCtrl.hidden = YES;
        }else {
            cell.switchCtrl.hidden = NO;
        }
    }
    
    if ([model.BagCount doubleValue]> 0) {
        cell.countLabel.text = [NSString stringWithFormat:@"%.2f",round([model.BuyCount floatValue]*100)/100];
    }else {
        cell.countLabel.text = [NSString stringWithFormat:@"%d",[model.BuyCount intValue]];
    }
    
    //单位
    cell.uintLabel.text = model.Goods_Unit;
    //商品图片
    [Uitils cacheImage:model.SmallImageUrl withImageV:cell.goodsImage withPlaceholder:@"上方大图"];
    
    if (model.DrugsBase_ProName.length > 0) {
        //商品名称
        cell.goodsName.text = [NSString stringWithFormat:@"%@(%@)",model.Name,model.DrugsBase_ProName];
    }else {
        cell.goodsName.text = [NSString stringWithFormat:@"%@",model.Name];
    }
    //规格
    cell.storeName.text = model.DrugsBase_Specification;
    //药铺名称
    cell.specification.text = model.DrugsBase_Manufacturer;
    
    //添加/减少商品数量，修改price
    [cell add_reduceCountMethod:^(double count) {
        
        //替换修改过后的商品数量
        ((OrderProductInfoModel *)(NSArray *)_StoreCartList[indexPath.section][indexPath.row]).BuyCount = [NSString stringWithFormat:@"%.2f",count];
        
        //数量小于规格数量，关闭加价购商品
        if (count < [model.addpricebuymodel.firstProudctPerNum doubleValue] || count < [model.addpricebuymodel.firstProudctStartNum doubleValue]) {
            ((OrderProductInfoModel *)(NSArray *)_StoreCartList[indexPath.section][indexPath.row]).jjgStatus = @"NO";
        }
        //修改数量的时候，未选中变成选中状态，并且处理是否需要改变头部状态和全选状态
        if (!weakCell.selectBtn.selected) {
            ((OrderProductInfoModel *)(NSArray *)_StoreCartList[indexPath.section][indexPath.row]).IsSelect = @"1";
        }
        //        [_tableV reloadData];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [_tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        _bottomTool.totalCash.text = [NSString stringWithFormat:@"¥%.2f",round([self totalCash]*100)/100];
    }];
    
    _bottomTool.totalCash.text = [NSString stringWithFormat:@"¥%.2f",round([self totalCash]*100)/100];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float h = 110;
    
    NSArray *array = _StoreCartList[indexPath.section];
    OrderProductInfoModel *model = array[indexPath.row];
    
    //特价商品
    if ([model.specialpricemodel.pid doubleValue] > 0 && [self betweenTime:model.specialpricemodel]) {
        //限购的情况
        if ([model.specialpricemodel.limittype integerValue] != 0) {
            //超过了限购的数量，按照原价出售
            if ([model.specialpricemodel.limitnumber doubleValue] - [model.specialpricemodel.buycount doubleValue] < [model.BuyCount doubleValue]) {
                //限购数等于已购数，则不提示
                if ([model.specialpricemodel.limitnumber doubleValue]==[model.specialpricemodel.buycount doubleValue]) {
                    
                }else {
                    
                    h += 35;
                }
            }
        }
    }
    
    //满足加价购条件
    if ([model.addpricebuymodel.firstpid intValue] > 0 && [model.addpricebuymodel.secondpid intValue] > 0) {
        
        //商品库存大于加价购商品的规则数量
        if ([model.stock intValue] > [model.addpricebuymodel.firstProudctStartNum intValue] || [model.stock intValue] > [model.addpricebuymodel.firstProudctPerNum intValue]) {
            
            //加价购的库存大于加价购商品的规则数量
            if ([model.addproduct.stock intValue] > [model.addpricebuymodel.secondProudctNum intValue] || [model.addproduct.stock intValue] > [model.addpricebuymodel.secondProudctNum intValue]) {
                
                h += 40;
                //是否选中了该商品
                if ([model.IsSelect isEqualToString:@"1"]) {
                    //此商品的加价购按钮是否打开
                    if ([model.jjgStatus boolValue]) {
                        h+=70;
                    }
                }
            }
        }
    }
    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat h = 54;
    StoreInfoModel *StoreInfo = _StoreInfoList[section];
    
    //满 包邮 (1.b包邮金额不为零 2.小计大于包邮金额 3.邮费为零)
    if ([StoreInfo.LowestFreeShippingAmount floatValue] > 0 && [StoreInfo.LowestFreeShippingAmount floatValue] > [self sectionCash:section] && [StoreInfo.DefaultShipFee floatValue] != 0) {
        h += 35;
    }
    //不满发货金额
    if ( [StoreInfo.LowestdeliveryAmount floatValue] > 0 && [StoreInfo.LowestdeliveryAmount floatValue] > [self sectionCash:section]) {
        h += 35;
    }
    //包邮
    if ([StoreInfo.DefaultShipFee floatValue] == 0 || ([StoreInfo.LowestFreeShippingAmount floatValue] > 0 && [StoreInfo.LowestFreeShippingAmount floatValue] < [self sectionCash:section])) {
        h += 35;
    }
    return h;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ShopCartHead *header = [[[NSBundle mainBundle]loadNibNamed:@"ShopCartHead" owner:self options:nil] lastObject];
    
    if (_StoreCartList.count > 0) {
        StoreInfoModel *StoreInfo = _StoreInfoList[section];
        header.selectBtn.selected = [self sectionSelected:section];
        header.StoreInfo = StoreInfo;
        header.lousImgW.constant = ([StoreInfo.islous integerValue] == 1) ? 39 : 0;
        //删除店铺商品
        [header deleteStoreMethod:^{
            [self.tableV beginUpdates];
            [_StoreCartList removeObjectAtIndex:section];
            [_StoreInfoList removeObjectAtIndex:section];
            [self.tableV deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableV endUpdates];
            [self.tableV reloadData];
            _bottomTool.totalCash.text = [NSString stringWithFormat:@"¥%.2f",round([self totalCash]*100)/100];
            if (_StoreCartList.count == 0) {
                
                self.tabBarItem.badgeValue = nil;
            }
        }];
        
        //选择商品
        [header headSelect:^(BOOL select) {
            
            //将row中的商品的RecordId加入数组中
            NSMutableArray *RecordIdArray = [NSMutableArray array];
            NSArray *CartProductList = _StoreCartList[section];
            
            //如果头部试选中，则把对应的row商品全部选中
            for (int i = 0; i<CartProductList.count; i++) {
                
                OrderProductInfoModel *model = CartProductList[i];
                //获取商品的RecordId，来修改商品状态
                [RecordIdArray addObject:[NSString stringWithFormat:@"%@",model.RecordId]];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
                ShopCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                ((OrderProductInfoModel *)(NSArray *)_StoreCartList[section][i]).IsSelect = select ? @"1" :@"0";
                cell.selectBtn.selected = select ? YES : NO;
            }
            
            //批量修改商品选中状态
            self.goodSelectP.recordid = [RecordIdArray componentsJoinedByString:@","];
            self.goodSelectP.Checked = select ? @"1" : @"0";
            
            [KSMNetworkRequest postRequest:requestProducChecked params:self.goodSelectP.mj_keyValues success:^(id responseObj) {;
                FxLog(@"批量修改商品选中状态 = %@",responseObj);
            } failure:^(NSError *error) {
            }];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
            [_tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            _bottomTool.totalCash.text = [NSString stringWithFormat:@"¥%.2f",round([self totalCash]*100)/100];
        }];
        
        //满 包邮
        if ([StoreInfo.LowestFreeShippingAmount floatValue] > 0 && [StoreInfo.LowestFreeShippingAmount floatValue] > [self sectionCash:section]) {
            header.postageH.constant = 35;
            header.postageCount.text = [NSString stringWithFormat:@"满¥%@.00包邮",StoreInfo.LowestFreeShippingAmount];
        }else {
            header.postageH.constant = 0;
        }
        
        //不满发货金额
        if ([StoreInfo.LowestdeliveryAmount floatValue] > 0 && [StoreInfo.LowestdeliveryAmount floatValue] > [self sectionCash:section]) {
            header.ShippingH.constant = 35;
            header.ShippingCount.text = [NSString stringWithFormat:@"低于¥%@.00，该店铺将不能发货",StoreInfo.LowestdeliveryAmount];
            header.PinkageH.constant = 0;
        }else {
            
            header.ShippingH.constant = 0;
        }
        
        //包邮
        if ([StoreInfo.DefaultShipFee doubleValue] == 0 || ([StoreInfo.LowestFreeShippingAmount doubleValue] > 0 && [StoreInfo.LowestFreeShippingAmount doubleValue] < [self sectionCash:section])) {
            header.PinkageH.constant = 35;
        }else {
            header.PinkageH.constant = 0;
        }
        [header.storeName setTitle:[NSString stringWithFormat:@" %@ ",StoreInfo.Name] forState:UIControlStateNormal];
        
        //进入店铺
        [header intoStoreMethod:^{
            
            STShopHomeViewController *ShopHome = [STShopHomeViewController new];
            ShopHome.typeDict =   @{@"storeid":StoreInfo.StoreId};
            [self tabBarControllerHidden];
            [self.navigationController pushViewController:ShopHome animated:YES];
        }];
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    ShopCartFooter *footer = [[[NSBundle mainBundle]loadNibNamed:@"ShopCartFooter" owner:self options:nil] lastObject];
    
    StoreInfoModel *StoreInfo = _StoreInfoList[section];
    //包邮
    if ([StoreInfo.DefaultShipFee floatValue] == 0 || [StoreInfo.LowestFreeShippingAmount floatValue] < [self sectionCash:section]) {
        
        footer.PinkageH.constant = 0;
    }else if ([StoreInfo.LowestdeliveryAmount floatValue] > 0 && [StoreInfo.LowestdeliveryAmount floatValue] > [self sectionCash:section]) {
        footer.PinkageH.constant = 0;
    }else{
        footer.PinkageLabel.text = [NSString stringWithFormat:@"邮费：¥%@",StoreInfo.DefaultShipFee];
    }
    
    footer.goodsPrice.text = [NSString stringWithFormat:@"小计：     ¥%.2f",round([self sectionCash:section]*100)/100];
    
    
    return footer;
}

-(BOOL)betweenTime:(SpecialPriceModel *)specialpricemodel {
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *startDate =[formater dateFromString:specialpricemodel.starttime];
    NSDate *endDate =[formater dateFromString:specialpricemodel.endtime];
    
    if ([[NSDate date] compare:startDate] == NSOrderedAscending)
        return NO;
    
    if ([[NSDate date] compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

- (void)verifyAndSubmitOrder:(NSDictionary *)params pid:(NSArray *)pid{
    
    [KSMNetworkRequest postRequest:BacthSubmitCartCheck params:params success:^(id responseObj) {
        
        _bottomTool.goBalanceButton.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        
        if ([[responseObj objectForKey:@"code"] integerValue] == 200) {
            
            STPaymentDetailsViewController *PaymentDetails=[[STPaymentDetailsViewController alloc]init];
            PaymentDetails.orderId = [pid componentsJoinedByString:@","];
            PaymentDetails.orderType = 2;
            PaymentDetails.isZhui = 0;
            [self tabBarControllerHidden];
            [self.navigationController pushViewController:PaymentDetails animated:YES];
            
        }else if ([[responseObj objectForKey:@"code"] integerValue]==0) {
            
            NSArray *list = responseObj[@"list"];  //buyCount  pid pmid stock
            NSString *alertMsg = nil;
            if (list.count == 1) {
                
                NSDictionary *dic = list[0];
                
                for (NSArray *array in _StoreCartList) {
                    for (OrderProductInfoModel *model in array) {
                        
                        NSLog(@"model.Pid = %@",model.Pid);
                        if ([[NSString stringWithFormat:@"%@",model.Pid] isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"pid"]]]) {
                            
                            if ([[dic objectForKey:@"stock"] doubleValue] <= 0) {
                                alertMsg = [NSString stringWithFormat:@"《%@》已经下架",model.Name];
                            }else {
                                
                                if (model.BuyCount.doubleValue > model.stock.doubleValue) {
                                    alertMsg = [NSString stringWithFormat:@"《%@》库存紧张,最多只能买%@%@哦",model.Name,model.stock,model.Goods_Unit];
                                    
                                }else if ([model.SellType doubleValue] == 2 && ![STCommon isRemainderD1:model.BuyCount.doubleValue withD2:model.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {}]) {
                                    
                                    alertMsg = [NSString stringWithFormat:@"《%@》购买数量必须是中包装【%@】的整数倍",model.Name,model.Product_Pcs_Small];
                                    
                                }else if ([model.SellType doubleValue] == 3 && ![STCommon isRemainderD1:model.BuyCount.doubleValue withD2:model.Product_Pcs.doubleValue Block:^(BOOL isRemainder, int multiple) {}]) {
                                    alertMsg = [NSString stringWithFormat:@"《%@》购买数量必须是件装【%@】的整数倍",model.Name,model.Product_Pcs_Small];
                                }else if ([model.SellType doubleValue] == 1 && [model.BagCount doubleValue] > 0) {
                                    if (fmod(model.BuyCount.doubleValue,[model.BagCount doubleValue]) != 0) {
                                        alertMsg = [NSString stringWithFormat:@"《%@》购买数量必须是最小包装【%@】的整数倍",model.Name,model.BagCount];
                                    }
                                }
                            }
                        }
                    }
                }
                [self requestData];
                
            }else {
                alertMsg = [NSString stringWithFormat:@"有%ld个药品不符合采购条件或已下架,请做调整",(unsigned long)list.count];
                [self requestData];
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        _bottomTool.goBalanceButton.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

#pragma mark 计算总金额
- (float)totalCash {
    
    //计算总价
    float totalPrice = 0.0;
    
    if (_StoreCartList.count == 0) {
        return totalPrice;
    }
    
    for (int i = 0; i<_StoreCartList.count; i++) {
        
        StoreInfoModel *infoModel = _StoreInfoList[i];
        //        if ([self sectionSelected:i]) {
        //排除不满足发货金额的商品
        if ([infoModel.LowestdeliveryAmount floatValue] > 0 && [infoModel.LowestdeliveryAmount floatValue] > [self sectionCash:i]) {
            FxLog(@"不满足发货金额");
            totalPrice += 0;
        }else {
            totalPrice += [self sectionCash:i];
            FxLog(@"满足发货金额  %f",totalPrice);
        }
        //        }
    }
    return totalPrice;
}

//计算section的金额
- (float)sectionCash:(NSInteger)section {
    
    NSArray *array = _StoreCartList[section];
    double subPrice = 0.0;
    for (OrderProductInfoModel *model in array) {
        //row选中状态
        if ([model.IsSelect intValue] == 1) {
            
            if ([model.specialpricemodel.pid doubleValue] > 0 && [self betweenTime:model.specialpricemodel]) {
                //限购的情况
                if ([model.specialpricemodel.limittype integerValue] != 0) {
                    
                    //超过了限购的数量，按照原价出售
                    if ([model.specialpricemodel.limitnumber doubleValue] - [model.specialpricemodel.buycount doubleValue] < [model.BuyCount doubleValue]) {
                        //原价计算
                        subPrice += [model.BuyCount doubleValue] * [model.ShopPrice doubleValue];
                    }else {
                        //特价计算
                        subPrice += [model.BuyCount doubleValue] * [model.specialpricemodel.speprice doubleValue];
                    }
                }else {
                    //特价计算
                    subPrice += [model.BuyCount doubleValue] * [model.specialpricemodel.speprice doubleValue];
                }
            }else {
                
                //原价计算
                subPrice += [model.BuyCount doubleValue] * [model.ShopPrice doubleValue];
            }
            //如果此商品开启加价购
            if ([model.jjgStatus boolValue]) {
                //通过加价购类型来添加加价购的价格
                if ([model.addpricebuymodel.addPriceType intValue] == 0) {
                    
                    subPrice += [model.addpricebuymodel.addPrice doubleValue];
                    
                }else if ([model.addpricebuymodel.addPriceType intValue] == 1){
                    
                    subPrice += [model.addpricebuymodel.addPrice doubleValue]*(int)([model.BuyCount doubleValue]/[model.addpricebuymodel.firstProudctPerNum doubleValue]);
                }
            }
            
        }
    }
    return subPrice;
}

#pragma mark 判断某一组是否选中
- (BOOL)sectionSelected:(NSInteger)section {
    
    NSArray *array = _StoreCartList[section];
    
    for (OrderProductInfoModel *model in array) {
        
        if ([model.IsSelect intValue] == 0) {
            
            return NO;
        }
    }
    return YES;
}


#pragma mark 判断是否全部选中
- (BOOL)isAllSelected {
    
    if (_StoreCartList.count == 0) {
        
        return NO;
    }
    
    for (NSArray *array in _StoreCartList) {
        
        for (OrderProductInfoModel *model in array) {
            
            if ([model.IsSelect intValue] == 0) {
                
                return NO;
            }
        }
    }
    return YES;
}

@end