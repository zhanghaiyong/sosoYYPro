//
//  WisdomShopCartViewController.m
//  sosoYY
//
//  Created by zhy on 17/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#define MASKVIEW_HEIGHT 40
#import "WisdomShopViewController.h"
#import "WisdomCell.h"
#import "WisdomHead.h"
#import "WisdomFoot.h"
#import "WisdomModel.h"
#import "LiModel.h"
#import "PurchasetAddPricePromotionsModel.h"
#import "STSwitchStoreView.h"
#import "STWisdomCollectionView.h"
#import "MaskingView.h"
#import "ExchangeView.h"
#import "STWisdomAddListViewController.h"
#import "WisdomTool.h"
#import "ImportView.h"
#import "STPaymentDetailsViewController.h"
#import "SelectListView.h"
#import "STWisdomWeedOutViewController.h"
#import "STArtificialPurchasingView.h"
#import "AnimationView.h"
#import "STWisdomSearchViewController.h"
#import "VoidDataView.h"
#import "STShopCartSeachViewController.h"
#import "FilterCollectionView.h"

@interface WisdomShopViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    WisdomCell *wisdomCell;
    
    int jumpCellCount;
    UIWebView *webView;
    
    //是否需要传方案名
    BOOL        isFa;
    //记录跳转的section
    int scrolSection;
    //记录跳转的row
    int scrolRow;
    //定时器
    NSTimer *time;
    //将要删除//淘汰的model
    LiModel *undoLiModel;
    WisdomModel *undoWisModel;
    //第一次进入的蒙版
    UIImageView *mattleImg;
    int timeCount;
    
    int mattelCount;
    //人工采购数量
    int laborCount;
    UILabel *filterCount;
    
}

@property (nonatomic,strong)UIImageView *filterArrow;
@property (nonatomic,strong)FilterCollectionView *filterView;
@property (nonatomic,strong)VoidDataView *voidDataView;
@property (nonatomic,strong)__block NSIndexPath *allDataIndex;
@property (nonatomic,strong)__block AnimationView *animationView;
@property (nonatomic,strong)STSwitchStoreView *switchStoreView;

@property(assign,nonatomic)CGFloat offsetY;//tableView的偏移量
//列表
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
//数据源模型
@property (nonatomic,strong)NSMutableArray *storeModel;
//所有数据
@property (nonatomic,strong)NSMutableArray *allData;

@property (nonatomic,copy)NSArray *filters;

//快捷选购界面
@property (nonatomic,strong)__block STWisdomCollectionView *wisdomCollectionView;
//店铺数量
@property (weak, nonatomic) IBOutlet UILabel *storeCount;
//总价
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
//邮费
@property (weak, nonatomic) IBOutlet UILabel *postage;
//人工采购
@property (strong, nonatomic) UIButton *laborButton;
//智慧采购
@property (strong, nonatomic) UIButton *wisdomButton;
@property (strong, nonatomic) UIView *bottonLine;
@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UIView *typeView;
@property (strong, nonatomic) UIView *noGoodView;
@property (nonatomic,strong) UILabel *noGoodCountText;
@property (strong, nonatomic) UITableView *tableV;
//撤销
@property (nonatomic,strong)UIView  *UndoView;
@property (nonatomic,strong)UILabel *UndoMsg;
@property (nonatomic,strong)__block  SelectListView *selectListView;
@property (nonatomic,strong)STArtificialPurchasingView *artificialPurchasingView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation WisdomShopViewController

-(FilterCollectionView *)filterView {
    
    __weak WisdomShopViewController *weakSelf = self;
    
    if (_filterView == nil) {
        
        NSArray *array = @[@[@"已勾选",@"未勾选",@"不符购买条件",@"手动添加"],@[@"不满起发",@"不满包邮"]];
        _filterView = [[FilterCollectionView alloc]initWithFrame:CGRectMake(0, self.typeView.bottom, kScreenWidth, 1) dataSource:array];
        _filterView.hidden = YES;
        [self.view addSubview:self.filterView];
        
        _filterView.finishBlock = ^(NSArray *filters) {
            
            weakSelf.animationView.userInteractionEnabled = YES;
            weakSelf.animationView.alpha = 1;
            weakSelf.filters = filters;
            [weakSelf dealFilter:filters];
        };
        
        _filterView.hideFilterView = ^{
            
            weakSelf.animationView.userInteractionEnabled = YES;
            weakSelf.animationView.alpha = 1;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.filterView.frame = CGRectMake(0, weakSelf.typeView.bottom, kScreenWidth, 1);
                weakSelf.filterArrow.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                weakSelf.filterView.hidden = YES;
            }];
        };
    }
    return _filterView;
}

-(STArtificialPurchasingView *)artificialPurchasingView {
    
    __weak WisdomShopViewController *weakSelf = self;
    if (_artificialPurchasingView == nil) {
        
        [self setShareTwo];
        self.artificialPurchasingView =[[STArtificialPurchasingView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
        self.artificialPurchasingView.controller = self;
        self.artificialPurchasingView.ArtificialPurchasingNumBlock = ^(NSString *num) {
            //人工采购数量
            [weakSelf.laborButton setTitle:[NSString stringWithFormat:@"人工采购(%d)",laborCount - [num intValue]] forState:UIControlStateNormal];
            laborCount -= [num intValue];
        };
    }
    return _artificialPurchasingView;
}

-(STWisdomCollectionView *)wisdomCollectionView {
    
    if (_wisdomCollectionView == nil) {
        
        __weak WisdomCell *weakwisdomCell = wisdomCell;
        WisdomShopViewController *weakSelf = self;
        self.wisdomCollectionView = [[STWisdomCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth - 10 - 130, 0, 150, 110)];
        self.wisdomCollectionView.layer.masksToBounds = YES;
        
        self.wisdomCollectionView.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
        self.wisdomCollectionView.layer.borderWidth = .5;
        _wisdomCollectionView.layer.cornerRadius = 3.0f;
        self.wisdomCollectionView.WisdomCollectionViewBlock = ^(NSString *text){
            
            [weakSelf.wisdomCollectionView removeFromSuperview];
            weakSelf.wisdomCollectionView = nil;
            weakwisdomCell.selectNumOflist = text;
        };
        [self.tableV addSubview:self.wisdomCollectionView];
    }
    return _wisdomCollectionView;
}

-(SelectListView *)selectListView {
    
    if (_selectListView == nil) {
        WisdomShopViewController *weakSelf = self;
        NSArray *selects = @[@{@"logo":@"class",@"label":@"淘汰品种列表"}];
        self.selectListView =  [[SelectListView alloc]initWithFrame:[UIScreen mainScreen].bounds selects:selects];
        self.selectListView.removeSelectListView = ^{
            
            [weakSelf.selectListView removeFromSuperview];
            weakSelf.selectListView = nil;
            
            weakSelf.animationView.userInteractionEnabled = YES;
            weakSelf.animationView.alpha = 1;
        };
        
        self.selectListView.selectSelectListView = ^(NSInteger row) {
            [weakSelf.selectListView removeFromSuperview];
            weakSelf.selectListView = nil;
            
            weakSelf.animationView.userInteractionEnabled = YES;
            weakSelf.animationView.alpha = 1;
            
            STWisdomWeedOutViewController *wisdomWeedOutVC = [STWisdomWeedOutViewController new];
            wisdomWeedOutVC.WeedOutBackBlock = ^(void){
                [weakSelf.tableV.mj_header beginRefreshing];
            };
            [weakSelf.navigationController pushViewController:wisdomWeedOutVC animated:YES];
        };
    }
    return _selectListView;
}

#pragma mark 筛选处理
- (void)dealFilter:(NSArray *)filters {
    
    if (filters.count == 0) {
        filterCount.hidden = YES;
        self.storeModel = self.allData;
    }else {
        filterCount.hidden = NO;
        filterCount.text = [NSString stringWithFormat:@"%ld",filters.count];
        
        NSMutableArray *array = [NSMutableArray new];
        for (WisdomModel *model in self.allData) {
            WisdomModel *copyModel = [model copy];
            copyModel.li = [model.li mutableCopy];
            [array addObject:copyModel];
        }
        self.storeModel = [WisdomTool filterData:array filters:filters];
    }
    
    [self.tableV reloadData];
}

//返回
- (void)backAction {
    
    [self.animationView removeFromSuperview];
    self.animationView = nil;
    
    if (_WisdomBackBlock) {
        _WisdomBackBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//查看淘汰商品
- (void)rightItemClick {
    
    self.animationView.userInteractionEnabled = NO;
    self.animationView.alpha = 0.7;
    
    [self removeCollectionView];
    [self.view addSubview:self.selectListView];
}

#pragma mark 点击跳转到不符合采购条件的商品
- (void)checkNOGoodClick {
    
    [self removeCollectionView];
    if (jumpCellCount > 0) {
        
        for (int section = scrolSection; section < self.storeModel.count; section++) {
            
            WisdomModel *wisdom = self.storeModel[section];
            for (int row = scrolRow; row < wisdom.li.count; row++) {
                LiModel *liModel = wisdom.li[row];
                
                if (row != wisdom.li.count-1) {
                    scrolSection = section;
                    scrolRow ++;
                }else if (row == wisdom.li.count-1 && section != self.storeModel.count-1) {
                    scrolSection = section+1;
                    scrolRow = 0;
                }else if (row == wisdom.li.count-1 && section == self.storeModel.count-1) {
                    scrolSection = 0;
                    scrolRow = 0;
                    [self checkNOGoodClick];
                    return;
                }else {
                    scrolSection = section;
                    scrolRow ++;
                }
                //出现不符合采购的商品
                if (liModel.isBadGood) {
                    if (![((WisdomModel *)self.storeModel[section]).Expand boolValue]) {
                        
                        NSIndexPath *indexPath = [self sectionRowInAllData:wisdom.store_Id section:YES];
                        ((WisdomModel *)self.allData[indexPath.section]).Expand = @"1";
                        ((WisdomModel *)self.storeModel[section]).Expand = @"1";
                        //                        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:section];
                        //                        [self.tableV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableV reloadData];
                    }
                    [self.tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    return;
                }
            }
        }
    }
}

//#pragma mark 全部/不满起发/不满包邮
//- (void)GoodTypeClassify:(UIButton *)sender {
//
//    [self removeCollectionView];
//    [self.tableV scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
//
//    for (int i = 0; i< 3; i++) {
//        UIButton *button = [self.typeView viewWithTag:100+i];
//        button.selected = NO;
//        button.layer.borderColor = [UIColor fromHexValue:0x555555].CGColor;
//    }
//
//    sender.selected = YES;
//    sender.layer.borderColor = [UIColor fromHexValue:0xEA5413].CGColor;
//
//    classifyTag = sender.tag;
//    [self.tableV reloadData];
//
//}

//条码扫描成功后刷新数据
-(void)wisdomRefreshing{
    
    [self requestData];
}

//条码扫描失败后刷新数据
-(void)failBlockwisdomRefreshing{
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.UndoView.hidden = YES;
    
    if (time) {
        [time invalidate];
        time = nil;
    }
    if (self.wisdomButton.selected) {
        
        self.animationView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (time) {
        [time invalidate];
        time = nil;
    }
    
    self.navigationController.navigationBar.hidden = YES;
    if (self.wisdomButton.selected) {
        self.animationView.hidden = NO;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    mattelCount = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    isFa = YES;
    
    if (![Uitils  getUserDefaultsForKey:@"FirstMattleImg"]) {
        
        [Uitils setUserDefaultsObject:@"YES" ForKey:@"FirstMattleImg"];
        mattleImg = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        mattleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zi",mattelCount]];
        mattleImg.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:mattleImg];
        UIButton *tapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2)];
        [tapButton addTarget:self action:@selector(tapChangeMattel) forControlEvents:UIControlEventTouchUpInside];
        [mattleImg addSubview:tapButton];
    }else {
        
        [self initSubViews];
    }
    
    self.storeModel = [[NSMutableArray alloc]init];
    self.allData = [[NSMutableArray alloc]init];
    self.filters = [[NSArray alloc]init];
    
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.navigationView.clipsToBounds = YES;
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationView];
    UIView *navigationLine = [[UIView alloc]initWithFrame:CGRectMake(0, 63, kScreenWidth, 1)];
    navigationLine.backgroundColor = [UIColor fromHexValue:0xEBEBEB];
    [self.navigationView addSubview:navigationLine];
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backButton];
    
    //淘汰按钮
    UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40, 20, 40, 40)];
    [itemButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:itemButton];
    
    UIView *navigationSubView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2-110, 20, 220, 44)];
    [self.navigationView addSubview:navigationSubView];
    
    //智慧采购按钮
    self.wisdomButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110, 43)];
    [self.wisdomButton setTitle:@"智慧采购(0)" forState:UIControlStateNormal];
    [self.wisdomButton setTitleColor:[UIColor fromHexValue:0x777777] forState:UIControlStateNormal];
    [self.wisdomButton setTitleColor:[UIColor fromHexValue:0xEA5413] forState:UIControlStateSelected];
    self.wisdomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.wisdomButton.selected = YES;
    [self.wisdomButton addTarget:self action:@selector(wisdomOrLaborClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationSubView addSubview:self.wisdomButton];
    
    //人工采购按钮
    self.laborButton = [[UIButton alloc]initWithFrame:CGRectMake(navigationSubView.width-110, 0, 110, 43)];
    [self.laborButton setTitle:@"人工采购(0)" forState:UIControlStateNormal];
    [self.laborButton setTitleColor:[UIColor fromHexValue:0x777777] forState:UIControlStateNormal];
    [self.laborButton setTitleColor:[UIColor fromHexValue:0xEA5413] forState:UIControlStateSelected];
    self.laborButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.laborButton addTarget:self action:@selector(wisdomOrLaborClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationSubView addSubview:self.laborButton];
    
    //下划线
    self.bottonLine = [[UIView alloc]initWithFrame:CGRectMake(0, navigationSubView.height-2, 110, 2)];
    self.bottonLine.backgroundColor = [UIColor fromHexValue:0xEA5413];
    [navigationSubView addSubview:self.bottonLine];
    
    
    self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.bottom, kScreenWidth, 44)];
    self.typeView.clipsToBounds = YES;
    self.typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.typeView];
    
    UIView *typeLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeView.height-1, kScreenWidth, 1)];
    typeLine.backgroundColor = [UIColor fromHexValue:0xEBEBEB];
    [self.typeView addSubview:typeLine];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.typeView.width-160, 0, 80, 44)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"filterSearch"] forState:UIControlStateNormal];
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [searchBtn setTitleColor:[UIColor fromHexValue:0x777777] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchBtn addTarget:self action:@selector(searchControl) forControlEvents:UIControlEventTouchUpInside];
    [self.typeView addSubview:searchBtn];
    
    UIButton *filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.typeView.width-80, 0, 80, 44)];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    //    [filterBtn setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    //    filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    [filterBtn setTitleColor:[UIColor fromHexValue:0x777777] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterControl) forControlEvents:UIControlEventTouchUpInside];
    filterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.typeView addSubview:filterBtn];
    
    self.filterArrow = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 24, 24)];
    self.filterArrow.contentMode = UIViewContentModeCenter;
    self.filterArrow.image = [UIImage imageNamed:@"list"];
    [filterBtn addSubview:self.filterArrow];
    
    filterCount = [[UILabel alloc]initWithFrame:CGRectMake(filterBtn.width-20, 10, 12, 12)];
    filterCount.textColor = [UIColor whiteColor];
    filterCount.layer.cornerRadius = 6;
    filterCount.hidden = YES;
    filterCount.textAlignment = NSTextAlignmentCenter;
    filterCount.clipsToBounds = YES;
    filterCount.backgroundColor = [UIColor fromHexValue:0xFF3333];
    filterCount.font = [UIFont systemFontOfSize:10];
    [filterBtn addSubview:filterCount];
    
    
    UIView *segmentline = [[UIView alloc]initWithFrame:CGRectMake(self.typeView.width-80, 11, 1, 22)];
    segmentline.backgroundColor = [UIColor fromHexValue:0x777777];
    [self.typeView addSubview:segmentline];
    
    //提示不满足数量的商品
    self.noGoodView = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeView.bottom, kScreenWidth, 35)];
    self.noGoodView.backgroundColor = [UIColor fromHexValue:0xFFFFCC];
    self.noGoodView.clipsToBounds = YES;
    self.noGoodView.hidden = YES;
    [self.view addSubview:self.noGoodView];
    
    UIImageView *alertImg = [[UIImageView alloc]initWithFrame:CGRectMake(8, (self.noGoodView.height-18)/2, 18, 18)];
    alertImg.image = [UIImage imageNamed:@"感叹号WWW"];
    [self.noGoodView addSubview:alertImg];
    
    self.noGoodCountText = [[UILabel alloc]initWithFrame:CGRectMake(alertImg.right+8, 0, self.noGoodView.width, self.noGoodView.height)];
    self.noGoodCountText.textColor = [UIColor fromHexValue:0x777777];
    self.noGoodCountText.backgroundColor = [UIColor clearColor];
    self.noGoodCountText.font = [UIFont systemFontOfSize:11];
    [self.noGoodView addSubview:self.noGoodCountText];
    
    UIButton *checkBadGood  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.noGoodView.width-10, self.noGoodView.height)];
    [checkBadGood setTitle:@"点击查看" forState:UIControlStateNormal];
    checkBadGood.backgroundColor = [UIColor clearColor];
    [checkBadGood setTitleColor:[UIColor fromHexValue:0xEA5413] forState:UIControlStateNormal];
    checkBadGood.titleLabel.font = [UIFont systemFontOfSize:12];
    [checkBadGood addTarget:self action:@selector(checkNOGoodClick) forControlEvents:UIControlEventTouchUpInside];
    checkBadGood.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.noGoodView addSubview:checkBadGood];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, self.noGoodView.bottom, kScreenWidth, kScreenHeight-self.navigationView.height-self.typeView.height-self.noGoodView.height-50) style:UITableViewStylePlain];
    self.tableV.backgroundColor = [UIColor whiteColor];
    self.tableV.separatorColor = [UIColor clearColor];
    self.tableV.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
    [self.view addSubview:self.tableV];
    self.tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.voidDataView.hidden = YES;
        [self requestData];
    }];
    [self requestData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCollectionView)];
    [tap setNumberOfTapsRequired:1];
    tap.delegate = self;
    [self.tableV addGestureRecognizer:tap];
    
    self.voidDataView = [[[NSBundle mainBundle] loadNibNamed:@"VoidDataView" owner:self options:nil] lastObject];
    self.voidDataView.frame = CGRectMake(kScreenWidth/2-150/2, 50, 150, 150);
    self.voidDataView.hidden = YES;
    [self.tableV addSubview:self.voidDataView];
    
    //撤销
    self.UndoView = [[UIView alloc]initWithFrame:CGRectMake(-kScreenWidth, kScreenHeight-90, kScreenWidth, 40)];
    self.UndoView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:self.UndoView];
    
    self.UndoMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.UndoView.width-100, self.UndoView.height)];
    self.UndoMsg.textColor = [UIColor whiteColor];
    self.UndoMsg.font = [UIFont systemFontOfSize:13];
    [self.UndoView addSubview:self.UndoMsg];
    
    UIButton *undoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-110, 0, 100, self.UndoView.height)];
    [undoBtn setTitle:@" 撤销" forState:UIControlStateNormal];
    undoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [undoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [undoBtn setImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    undoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [undoBtn addTarget:self action:@selector(undoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.UndoView addSubview:undoBtn];
    
    __weak WisdomShopViewController *weakSelf = self;
    _switchStoreView = [[[NSBundle mainBundle]loadNibNamed:@"STSwitchStoreView" owner:self options:nil]lastObject];
    _switchStoreView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _switchStoreView.hidden = YES;
    [_switchStoreView setSwitchStoreViewTitle:@"选择其他店铺"];
    _switchStoreView.SwitchStoreViewBlock = ^(int type, NSDictionary *dict, NSIndexPath *indexPath) {
        weakSelf.switchStoreView.hidden = YES;
        weakSelf.animationView.hidden = NO;
        [weakSelf.switchStoreView setSwitchStoreColseView];
        switch (type) {
            case 0:
                break;
            case 1:{
                NSDictionary *params = @{@"Pid":dict[@"Pid"],@"Goods_Package_ID":dict[@"Goods_Package_ID"],@"buyCount":dict[@"buyCount"]};
                [KSMNetworkRequest getRequest:requestSelectOtherStorePorduct params:params success:^(id responseObj) {
                    
                    if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
                        [ZHProgressHUD dismiss];
                        [weakSelf requestData];
                        [ZHProgressHUD showSuccessWithText:@"切换店铺成功！"];
                        
                    }else {
                        [ZHProgressHUD showErrorWithText:[responseObj objectForKey:@"info"]];
                    }
                } failure:^(NSError *error) {
                    [ZHProgressHUD dismiss];
                }];
                break;
            }
            default:
                break;
        }
    };
    [self.view addSubview:_switchStoreView];
    
    
    NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loading2" ofType:@"gif"]];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100,120,200,200)];
    webView.scalesPageToFit = YES;
    webView.userInteractionEnabled = NO;
    webView.scrollView.scrollEnabled = NO;
    [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.view addSubview:webView];
    
}

#pragma mark jump to searchcontrol
- (void)searchControl {
    
    __weak WisdomShopViewController *weakSelf = self;
    STShopCartSeachViewController *shopCartSearchVC = [[STShopCartSeachViewController alloc]init];
    shopCartSearchVC.ShopCartBlock = ^{
        
        [weakSelf requestData];
    };
    [self.navigationController pushViewController:shopCartSearchVC animated:YES];
    
    if (!self.filterView.hidden) {
        
        /* 旋转 */
        [UIView animateWithDuration:0.3 animations:^{
            self.filterArrow.transform = CGAffineTransformIdentity;
        }];
        self.animationView.userInteractionEnabled = YES;
        self.animationView.alpha = 1;
        self.filterView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, 1);
        self.filterView.hidden = YES;
    }
}

#pragma mark filterMethod
- (void)filterControl {
    
    if (self.filterView.hidden) {
        self.animationView.userInteractionEnabled = NO;
        self.animationView.alpha = 0.7;
        
        /* 旋转 */
        [UIView animateWithDuration:0.3 animations:^{
            self.filterArrow.transform = CGAffineTransformMakeRotation(-M_PI);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.filterView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, kScreenHeight);
            self.filterView.hidden = NO;
        }];
    }else {
        
        /* 旋转 */
        [UIView animateWithDuration:0.3 animations:^{
            self.filterArrow.transform = CGAffineTransformIdentity;
        }];
        
        self.animationView.userInteractionEnabled = YES;
        self.animationView.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.filterView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, 1);
        } completion:^(BOOL finished) {
            self.filterView.hidden = YES;
        }];
    }
}

#pragma mark UITapGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    
    if (touch.view.tag == 2000 || touch.view.tag == 1000 || touch.view.tag == 1001 || touch.view.tag == 1002) {
        return NO;
    }
    return YES;
}

- (void)removeCollectionView {
    
    if (_wisdomCollectionView) {
        [_wisdomCollectionView removeFromSuperview];
        _wisdomCollectionView = nil;
    }
}

- (void)tapChangeMattel {
    
    if (mattelCount < 4) {
        mattelCount ++;
        mattleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zi",mattelCount]];
    }else {
        [mattleImg removeFromSuperview];
        mattleImg = nil;
        [self initSubViews];
    }
}
#pragma mark 智慧采购/人工采购 切换
- (void)wisdomOrLaborClick:(UIButton *)sender {
    
    [self removeCollectionView];
    if (sender == self.wisdomButton) {
        
        self.animationView.hidden = NO;
        self.artificialPurchasingView.hidden = YES;
        self.tableV.hidden = NO;
        self.typeView.hidden = NO;
        self.bottomView.hidden = NO;
        
    }else {
        self.animationView.hidden = YES;
        
        if (!_artificialPurchasingView) {
            
            [self.view addSubview:self.artificialPurchasingView];
        }else {
            
            self.artificialPurchasingView.hidden = NO;
        }
        
        self.tableV.hidden = YES;
        self.typeView.hidden = YES;
        self.bottomView.hidden = YES;
    }
    
    self.laborButton.selected  = NO;
    self.wisdomButton.selected  = NO;
    sender.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottonLine.frame = CGRectMake(sender.origin.x, self.bottonLine.origin.y, self.bottonLine.width, self.bottonLine.height);
    }];
}

#pragma mark 撤销
- (void)undoClick {
    
    NSDictionary *params = nil;
    NSString *goodId = @"";
    
    if (undoLiModel) {
        params = @{@"id":undoLiModel.id};
        goodId = undoLiModel.id;
    }else{
        LiModel *model = undoWisModel.li[0];
        params = @{@"id":model.id};
        goodId = model.id;
    }
    
    [KSMNetworkRequest getCancelDeletePurchaseEliminateForIdUrl:requestCancelDeletePurchaseEliminateForId params:params finshed:^(BOOL isYes, NSError *error) {
        //撤销成功
        if (isYes) {
            
            [time invalidate];
            time = nil;
            
            if (undoLiModel) {
                [((WisdomModel *)self.allData[self.allDataIndex.section]).li insertObject:undoLiModel atIndex:self.allDataIndex.row];
            }else{
                [self.allData insertObject:undoWisModel atIndex:self.allDataIndex.section];
            }
            [self.tableV reloadData];
            
            [UIView animateWithDuration:0.4 animations:^{
                self.UndoView.frame = CGRectMake(-kScreenWidth, kScreenHeight-90, kScreenWidth, 40);
            }];
        }else{
            
            for (int i = 0; i<self.allData.count;i++) {
                WisdomModel *wisModel = self.allData[i];
                for (int j = 0; j<wisModel.li.count;j++) {
                    LiModel *model = wisModel.li[j];
                    if ([model.id isEqualToString:goodId]) {
                        if (wisModel.li.count > 1) {
                            [((NSMutableArray *)((WisdomModel *)self.allData[i]).li) removeObject:model];
                        }else {
                            [self.allData removeObject:wisModel];
                        }
                    }
                }
            }
        }
    }];
}

- (IBAction)buyAction:(id)sender {
    
    [self removeCollectionView];
    NSMutableArray *jsonArray = [NSMutableArray new];
    NSMutableArray *pidArray = [NSMutableArray new];
    
    int noGoodCount = [self changeParamsBadGood:self.allData];
    NSArray *array = [WisdomTool classifyData:self.allData type:0];
    if (noGoodCount > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"❗️" message:@"还有商品不符合购买条件，不能提交订单" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if (array.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"❗️" message:@"还有店铺不足发货金额，不能提交订单" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }else if ([WisdomTool statNOGoodCountWithData:self.allData] == 0 && [WisdomTool statOKGoodCountWithData:self.allData] != 0) {
        
        self.buyButton.userInteractionEnabled = NO;
        [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
        
        for (int i = 0; i<self.allData.count; i++) {
            
            WisdomModel *model = (WisdomModel *)self.allData[i];
            
            //满足发货金额的店铺
            if ([WisdomTool judgeAllGoodOK:i Data:self.allData]) {
                
                for (LiModel *li in model.li) {
                    
                    if ([li.isSelect isEqualToString:@"1"]) {
                        
                        NSMutableDictionary *dic = [NSMutableDictionary new];
                        [dic setValue:li.pid forKey:@"pid"];
                        [dic setValue:li.buyCount forKey:@"buyCount"];
                        
                        if ([li.pmid integerValue] > 0) {
                            [dic setValue:li.pmid forKey:@"pmid"];
                        }
                        [jsonArray addObject:dic];
                        [pidArray addObject:[NSString stringWithFormat:@"0_%@",li.pid]];
                        
                    }
                }
            }
        }
        
        __weak WisdomShopViewController *weakSelf = self;
        [KSMNetworkRequest postRequest:requestPurchaseCartCheck params:@{@"data":jsonArray.mj_JSONString} success:^(id responseObj) {
            
            self.buyButton.userInteractionEnabled = YES;
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            
            if ([[responseObj objectForKey:@"code"] integerValue] == 200) {
                
                STPaymentDetailsViewController *sureOrder = [[STPaymentDetailsViewController alloc]init];
                sureOrder.orderId = [pidArray componentsJoinedByString:@","];
                sureOrder.isZhui = 1;
                sureOrder.orderType = 2;
                [self.navigationController pushViewController:sureOrder animated:YES];
                
            }else if ([[responseObj objectForKey:@"code"] integerValue]==0) {
                
                NSArray *list = responseObj[@"list"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"有%ld个药品不符合采购条件,请做调整",(unsigned long)list.count] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSArray *copyStoreModel = weakSelf.storeModel;
                    for (NSDictionary *dic in list) {
                        for (int i = 0; i< copyStoreModel.count; i++) {
                            WisdomModel *wisdomModel = weakSelf.storeModel[i];
                            for (int j = 0; j<wisdomModel.li.count; j++) {
                                LiModel *liModel = wisdomModel.li[j];
                                if ([dic[@"pid"] integerValue] == [liModel.pid integerValue]) {
                                    ((LiModel *)((WisdomModel *)self.storeModel[i]).li[j]).stock = dic[@"stock"];
                                }
                            }
                        }
                    }
                    [weakSelf.tableV reloadData];
                    [self checkNOGoodClick];
                }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {
            self.buyButton.userInteractionEnabled = YES;
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }];
        
    }else if ([WisdomTool statNOGoodCountWithData:self.storeModel] == 0 && [WisdomTool statOKGoodCountWithData:self.storeModel] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"❗️" message:@"请选择需要采购的商品" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)initSubViews {
    
    NSArray *data = @[@{@"title":@"搜索添加",@"logo":@"addSearch",@"color":[UIColor fromHexValue:0xEA5413]},@{@"title":@"扫码添加",@"logo":@"addScan",@"color":[UIColor fromHexValue:0x219EFF]}];
    self.animationView = [[AnimationView alloc]initWithFrame:CGRectMake(kScreenWidth-70, kScreenHeight-150, 50, 50) dataSource:data];
    [[UIApplication sharedApplication].keyWindow addSubview:self.animationView];
    __weak WisdomShopViewController *selfSelf = self;
    
    self.animationView.foldAnimationBlock = ^(BOOL openAnimation) {
        
        if (openAnimation) {
            selfSelf.tableV.userInteractionEnabled = NO;
        }else {
            selfSelf.tableV.userInteractionEnabled = YES;
        } 
    };
    
    self.animationView.searchScanBlock = ^(NSInteger row) {
        
        switch (row) {
            case 0:
            {
                STWisdomSearchViewController *searchVC = [STWisdomSearchViewController new];
                
                searchVC.codeStr = @"";
                
                searchVC.dataResult = [NSMutableArray new];
                
                searchVC.backBlock = ^{
                    
                    [selfSelf requestData];
                };
                [selfSelf.navigationController pushViewController:searchVC animated:YES];
            }
                break;
            case 1:
            {
                NSDictionary *dict =@{@"scanSelected":@"2",@"storeid":@""};
                
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"scanSelected"];
                
                [[STCommon sharedSTSTCommon]toScanViewWith:selfSelf];
            }
                break;
            default:
                break;
        }
    };
}

- (void)requestData {
    
    if (isFa == NO) {
        [[UIApplication sharedApplication].keyWindow showLoadingView: @"loading"];
    }
    [KSMNetworkRequest postRequest:requestWisdomCart params:@{@"init":isFa ? @"1" : @"0"} success:^(id responseObj) {
        
        
        [webView removeFromSuperview];
        webView = nil;
        [self.tableV.mj_header endRefreshing];
        if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
            
            scrolSection = 0;
            scrolRow = 0;
            
            NSDictionary *data = [responseObj objectForKey:@"data"];
            //智慧采购数量
            [self.wisdomButton setTitle:[NSString stringWithFormat:@"智慧采购(%@)",[data objectForKey:@"matchingCount"]] forState:UIControlStateNormal];
            //人工采购数量
            [self.laborButton setTitle:[NSString stringWithFormat:@"人工采购(%@)",[data objectForKey:@"notMatchingCount"]] forState:UIControlStateNormal];
            laborCount = [[data objectForKey:@"notMatchingCount"] intValue];
            
            NSArray *list = [data objectForKey:@"list"];
            self.allData = [WisdomModel mj_objectArrayWithKeyValuesArray:list];
            //            self.storeModel = self.allData;
            [self dealFilter:self.filters];
            if (isFa) {
                self.tableV.delegate = self;
                self.tableV.dataSource = self;
            }
            [self.tableV reloadData];
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            [self changeParamsBadGood:self.storeModel];
            isFa = NO;
        }else {
            
            [ZHProgressHUD showSuccessWithText:[responseObj objectForKey:@"info"]];
        }
        
    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [ZHProgressHUD showSuccessWithText:@"网络错误，请重试"];
        [self.tableV.mj_header endRefreshing];
    }];
}

#pragma mark UITableVIewDelegate&&Datasource
//组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.contentSize.height <= tableView.height) {
        
        self.animationView.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            if (self.navigationView.height != 64) {
                self.navigationView.frame = CGRectMake(0, 0, kScreenHeight, 64);
                self.typeView.frame = CGRectMake(0, self.navigationView.bottom, kScreenWidth, 44);
                if (self.filters.count > 0) {
                    self.noGoodView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, 0);
                }else {
                    self.noGoodView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, [self changeParamsBadGood:self.storeModel] > 0 ? 35 : 0);
                }
                
                self.tableV.frame = CGRectMake(0, self.noGoodView.bottom, kScreenWidth, kScreenHeight-self.navigationView.height-self.typeView.height-self.noGoodView.height-50);
            }
        }];
    }
    
    if (self.allData.count > 0) {
        
        if (self.storeModel.count > 0) {
            
            self.voidDataView.hidden = YES;
        }else {
            
            self.voidDataView.hidden = NO;
            self.voidDataView.alertMsg.text = @"没有符合条件的商品";
            self.voidDataView.alertImg.image = [UIImage imageNamed:@"filterNOGood"];
        }
        
    }else {
        self.voidDataView.alertImg.image = [UIImage imageNamed:@"无商品所有提示"];
        self.voidDataView.alertMsg.text = @"暂无采购计划";
        self.voidDataView.hidden = NO;
    }
    
    self.noGoodView.hidden = NO;
    if (self.filters.count > 0) {
        
        self.noGoodView.frame =  CGRectMake(0, self.typeView.bottom, kScreenWidth, 0);
    }else {
        self.noGoodCountText.text = [NSString stringWithFormat:@"有%zi个商品因购买数量不符条件无法购买",[self changeParamsBadGood:self.storeModel]];
        self.noGoodView.frame =  CGRectMake(0, self.typeView.bottom, kScreenWidth, [self changeParamsBadGood:self.storeModel] > 0 ? 35 : 0);
    }
    
    
    self.tableV.frame = CGRectMake(0, self.noGoodView.bottom, kScreenWidth, kScreenHeight-self.navigationView.height-self.typeView.height-self.noGoodView.height-50);
    
    self.storeCount.text = [NSString stringWithFormat:@"店铺 %d", [WisdomTool OKStoreCountWithData:self.allData]];
    self.totalPrice.text = [NSString stringWithFormat:@"合计 ¥%@",[STCommon setHasSuffix:[NSString stringWithFormat:@"%f",[WisdomTool computeTotalPriceWithData:self.self.allData]]]];
    self.postage.text = [NSString stringWithFormat:@"邮费：¥%@",[STCommon setHasSuffix:[NSString stringWithFormat:@"%f",[WisdomTool totalPostageWithData:self.self.allData]]]];
    [self.buyButton setTitle:[NSString stringWithFormat:@"购买(%d)",[WisdomTool statOKGoodCountWithData:self.allData]+[WisdomTool statNOGoodCountWithData:self.allData]] forState:UIControlStateNormal];
    
    return self.storeModel.count;
}

//每一组的row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    WisdomModel *model = self.storeModel[section];
    
    if ([model.Expand boolValue]) {
        return model.li.count;
    }else {
        
        return 0;
    }
}

//row的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WisdomModel *model = self.storeModel[indexPath.section];
    NSArray *liArray = model.li;
    LiModel *liModel = liArray[indexPath.row];
    
    return liModel.cellHeight;
}

//header的高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 54;
}

//footer的高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    WisdomModel *model = self.storeModel[section];
    if ([model.Expand boolValue]) {
        return 44;
    }else {
        return 84;
    }
}

//headView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WisdomModel *model = self.storeModel[section];
    __weak WisdomHead *head = [[[NSBundle mainBundle] loadNibNamed:@"WisdomHead" owner:self options:nil] lastObject];
    head.wisdomModel = model;
    
    __weak WisdomShopViewController *weakSelf = self;
    head.selectbtn.selected = [WisdomTool sectionSelectAll:section data:self.storeModel];
    
    //凑单
    head.toCollectBlock = ^(void){
        
        STWisdomAddListViewController *wisdomAddListVC = [STWisdomAddListViewController new];
        wisdomAddListVC.storeid = model.store_Id;
        [self.navigationController pushViewController:wisdomAddListVC animated:YES];
        
        wisdomAddListVC.WisdomAddListBackBlock = ^(void) {
            [weakSelf requestData];
        };
    };
    
    //section的状态来控制row的状态
    head.headSelectBlock = ^(BOOL headSelectStatus) {
        
        head.selectbtn.selected = headSelectStatus;
        
        NSMutableArray *idAry = [NSMutableArray new];
        for (LiModel *liModel in model.li) {
            [idAry addObject:liModel.id];
        }
        NSString *idString = [idAry componentsJoinedByString:@","];//分隔符逗号
        [WisdomTool setChangeSelect:@{@"id":idString,@"isSelect":headSelectStatus ? @"true" : @"false",@"forCart":@"1"} finshed:^(BOOL isYes) {
            if (isYes) {
                
                //修改对应section所有row的选中状态
                [weakSelf sectionControlRow:headSelectStatus section:section];
                [weakSelf changeParamsBadGood:self.storeModel];
                //                [weakSelf.tableV reloadData];
                [self dealFilter:self.filters];
                
                
            }
        }];
    };
    
    
    double subPrice = 0.0;
    if (self.filters.count > 0) {
        
        //section中有选中的商品
        NSIndexPath *indexP = [self sectionRowInAllData:model.store_Id section:YES];
        subPrice = [WisdomTool computeSectionPrice:indexP.section Data:self.allData];
        head.haveSelectGood = [WisdomTool isSelectInScetion:indexP.section data:self.allData];
    }else {
        
        head.haveSelectGood = [WisdomTool isSelectInScetion:section data:self.storeModel];
        subPrice = [WisdomTool computeSectionPrice:section Data:self.allData];
    }
    
    head.sectionCash = subPrice;
    
    return head;
}

//footView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    WisdomFoot *foot = [[[NSBundle mainBundle] loadNibNamed:@"WisdomFoot" owner:self options:nil] lastObject];
    WisdomModel *model = self.storeModel[section];
    foot.model = model;
    
    double subPrice = 0.0;
    if (self.filters.count > 0) {
        
        NSIndexPath *indexP = [self sectionRowInAllData:model.store_Id section:YES];
        subPrice = [WisdomTool computeSectionPrice:indexP.section Data:self.allData];
    }else {
        
        subPrice = [WisdomTool computeSectionPrice:section Data:self.allData];
    }
    
    
    foot.foldButton.selected = [model.Expand boolValue];
    foot.backButton.selected = [model.Expand boolValue];
    foot.msgContentH.constant = [model.Expand boolValue] ? 0 : 40;
    
    foot.isFoldBlock = ^(BOOL isFold) {
        
        [self removeCollectionView];
        NSIndexPath *allDataIndePath = [self sectionRowInAllData:model.store_Id section:YES];
        ((WisdomModel *)self.allData[allDataIndePath.section]).Expand = isFold ? @"1" : @"0";
        ((WisdomModel *)self.storeModel[section]).Expand = isFold ? @"1" : @"0";
        [self.tableV reloadData];
    };
    
    //满足包邮条件
    if (subPrice >= [model.MoneyFreePostage doubleValue]) {
        
        foot.PinkageLabel.text = @"邮费:¥0";
    }else {
        
        for (LiModel *liModel in model.li) {
            
            if ([liModel.isSelect isEqualToString:@"1"]) {
                
                foot.PinkageLabel.text = [NSString stringWithFormat:@"邮费:¥%d",[model.Postage intValue]];
                break;
            }
        }
    }
    //同时修改价钱
    foot.subPriceLabel.text = [NSString stringWithFormat:@"小计：¥%@",[STCommon setHasSuffix:[NSString stringWithFormat:@"%f",subPrice]]];
    
    return foot;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"WisdomCell";
    WisdomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WisdomCell" owner:self options:nil] lastObject];
        
    }
    __weak WisdomCell *selfCell = cell;
    __weak WisdomShopViewController *selfSelf = self;
    
    WisdomModel *model = self.storeModel[indexPath.section];
    NSArray *liArray = model.li;
    LiModel *liModel = liArray[indexPath.row];
    cell.goodModel = liModel;
    
    //展示快捷购买
    cell.showCollectionBlock = ^(void){
        
        if (!_wisdomCollectionView) {
            
            self.animationView.hidden = YES;
            CGFloat height = self.tableV.frame.size.height;
            CGFloat contentOffsetY = self.tableV.contentOffset.y;
            CGFloat bottomOffset = self.tableV.contentSize.height - contentOffsetY;
            if (bottomOffset <= height) {
                
                //在最底部
                if (indexPath.section == self.storeModel.count-1 && indexPath.row == model.li.count-1 && selfSelf.tableV.contentSize.height > selfSelf.tableV.height-70) {
                    [UIView animateWithDuration:0.4 animations:^{
                        
                        self.animationView.hidden = YES;
                        selfSelf.tableV.contentOffset = CGPointMake(0, self.offsetY+70);
                    }];
                }
            }
            
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            wisdomCell = selfCell;
            selfSelf.wisdomCollectionView.frame = CGRectMake(kScreenWidth - 8 - 150, rect.origin.y+cell.otherAlertLabelH.constant+cell.AlertH.constant+95, 150, 110);
            
            //判断是否是手动添加
            if ([liModel.source integerValue] > 0) {
                selfSelf.wisdomCollectionView.titles = @[@"从其他店铺选择",@"删除商品"];
            }else {
                selfSelf.wisdomCollectionView.titles = @[@"从其他店铺选择",@"淘汰商品"];
            }
            self.wisdomCollectionView.WisdomBtnBlock = ^(UIButton *btn) {
                [selfSelf removeCollectionView];
#pragma mark 其他店铺选择
                if (btn.tag == 100) {
                    
                    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
                    NSDictionary *params = @{@"StoreId":model.store_Id,@"Goods_Package_ID":liModel.Goods_Package_ID};
                    [KSMNetworkRequest  getSwitchStoreUrl:requestGetOtherStorePorductList params:params finshed:^(id dataResult, NSError *error) {
                        selfSelf.switchStoreView.hidden = NO;
                        selfSelf.animationView.hidden = YES;
                        [selfSelf.switchStoreView setSwitchStoreViewResult:dataResult indexPath:indexPath];
                        [[UIApplication sharedApplication].keyWindow hideToastActivity];
                    }];
                }else {
                    
                    NSString *alertTitle = @"";
                    NSString *alertStr = @"";
                    NSString *errorMSg = @"";
                    NSString *url = @"";
                    NSDictionary *params = nil;
                    NSString *undoMsg = @"";
                    undoLiModel = nil;
                    undoWisModel = nil;
                    
#pragma mark 删除商品 淘汰商品
                    if ([btn.currentTitle isEqualToString:@"删除商品"]) {
                        
                        alertTitle = @"温馨提示";
                        alertStr = @"确认删除该商品?";
                        url = requestWisdomDeleteGood;
                        params = @{@"pid":liModel.pid};
                        errorMSg = @"删除失败";
                    }else {
                        alertTitle = @"确认淘汰该商品?";
                        alertStr = @"淘汰后商品将不再出现在采购清单当中,手动恢复请点击右上角按钮进入淘汰商品清单中加入采购清单";
                        url = requestDeletePurchaseEliminate;
                        params = @{@"id":liModel.id};
                        errorMSg = @"淘汰失败";
                        undoMsg = @"该商品已被移入淘汰商品列表";
                    }
                    
                    selfSelf.allDataIndex = [selfSelf sectionRowInAllData:liModel.id section:NO];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertStr preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
                        [KSMNetworkRequest WisdomShopCartWeekOutProduce:url params:params finished:^(BOOL finish) {
                            [[UIApplication sharedApplication].keyWindow hideToastActivity];
                            if (finish) {
                                
                                if (undoMsg.length > 0) {
                                    [selfSelf showUndoView:undoMsg];
                                }
                                
                                [selfSelf.wisdomCollectionView removeFromSuperview];
                                selfSelf.wisdomCollectionView = nil;
                                
                                if (model.li.count > 1) {
                                    
                                    [selfSelf.tableV beginUpdates];
                                    undoLiModel = liModel;
                                    [((WisdomModel *)selfSelf.storeModel[indexPath.section]).li removeObjectAtIndex:indexPath.row];
                                    [selfSelf.tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                    [selfSelf.tableV endUpdates];
                                    [selfSelf.tableV reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                                    
                                }else {
                                    [selfSelf.tableV beginUpdates];
                                    undoWisModel = model;
                                    [selfSelf.storeModel removeObjectAtIndex:indexPath.section];
                                    [selfSelf.tableV deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                                    [selfSelf.tableV endUpdates];
                                    [selfSelf.tableV reloadData];
                                }
                            }else {
                                [ZHProgressHUD showErrorWithText:errorMSg];
                            }
                        }];
                    }]];
                    [selfSelf presentViewController:alert animated:YES completion:nil];
                }
            };
            
            NSArray *array = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",liModel.buyNumList[0]],[NSString stringWithFormat:@"%@",liModel.buyNumList[1]],[NSString stringWithFormat:@"%@",liModel.buyNumList[2]], nil];
            NSMutableArray *list = [NSMutableArray array];
            [list addObject:array];
            [selfSelf.wisdomCollectionView setSelectAry:list frame:_wisdomCollectionView.frame];
        }else {
            
            self.animationView.hidden = YES;
            CGFloat height = self.tableV.frame.size.height;
            CGFloat contentOffsetY = self.tableV.contentOffset.y;
            CGFloat bottomOffset = self.tableV.contentSize.height - contentOffsetY;
            if (bottomOffset <= height) {
                //在最底部
                if (indexPath.section == self.storeModel.count-1 && indexPath.row == model.li.count-1 && selfSelf.tableV.contentSize.height > selfSelf.tableV.height-70) {
                    [UIView animateWithDuration:0.4 animations:^{
                        
                        self.animationView.hidden = YES;
                        selfSelf.tableV.contentOffset = CGPointMake(0, selfSelf.tableV.contentOffset.y-70);
                    }];
                }
            }
            [self removeCollectionView];
        }
    };
    
    //修改数量
    cell.WisdomAdd_reduceBlock = ^(double count) {
        
        if (_wisdomCollectionView) {
            
            [self removeCollectionView];
        }
        NSIndexPath *allDataIndePath = [selfSelf sectionRowInAllData:liModel.id section:NO];
        ((LiModel *)((WisdomModel *)selfSelf.allData[allDataIndePath.section]).li[allDataIndePath.row]).buyCount = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];
        
        //修改了数量，不满换购
        if (selfCell.selectBtn.selected) {
            if ([liModel.PromotionTypes integerValue] == 1 && [liModel.pmid integerValue] > 0) {
                
                NSDictionary *params = @{@"pid":liModel.pid,@"pmid":@"0"};
                [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
                    ((LiModel *)((WisdomModel *)self.allData[allDataIndePath.section]).li[allDataIndePath.row]).pmid = @"0";
                } failure:^(NSError *error) {
                    FxLog(@"error = %@",error);
                }];
            }
        }
        
        //        [selfSelf.tableV reloadData];
        [self dealFilter:self.filters];
        [selfSelf changeParamsBadGood:self.storeModel];
    };
    
    //修改主商品选中状态
    cell.selectGoodBlock = ^(BOOL selectStatus) {
        
        [WisdomTool setChangeSelect:@{@"id":liModel.id,@"isSelect":selectStatus ? @"true" : @"false",@"forCart":@"1"} finshed:^(BOOL isYes) {
            
            if (isYes) {
                //修改商品选中状态
                NSIndexPath *allDataIndePath = [selfSelf sectionRowInAllData:liModel.id section:NO];
                ((LiModel *)((WisdomModel *)self.allData[allDataIndePath.section]).li[allDataIndePath.row]).isSelect = selectStatus ? @"1" : @"0";
                selfCell.selectBtn.selected = selectStatus;
                [selfSelf changeParamsBadGood:self.storeModel];
                //                [selfSelf.tableV reloadData];
                [self dealFilter:self.filters];
                
                //取消勾选
                if (!selectStatus) {
                    if ([liModel.PromotionTypes integerValue] == 1 && [liModel.pmid integerValue] > 0) {
                        NSDictionary *params = @{@"pid":liModel.pid,@"pmid":@"0"};
                        [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
                            ((LiModel *)((WisdomModel *)self.allData[allDataIndePath.section]).li[allDataIndePath.row]).pmid = @"0";
                        } failure:^(NSError *error) {
                            FxLog(@"error = %@",error);
                        }];
                    }
                }
            }
        }];
    };
    
    //去换购
    cell.showExchangeViewBlock = ^(void) {
        
        __block ExchangeView *exchangeView = [[ExchangeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [[UIApplication sharedApplication].keyWindow addSubview:exchangeView];
        exchangeView.pmid = liModel.pmid;
        exchangeView.liModel = liModel;
        exchangeView.selectExchangeGoodBlock = ^(BOOL isCancle){
            
            if (isCancle) {
                [selfSelf requestData];
            }else {
                [WisdomTool setChangeSelect:@{@"id":liModel.id,@"isSelect": @"true",@"forCart":@"1"} finshed:^(BOOL isYes) {
                    
                    if (isYes) {
                        
                        [selfSelf requestData];
                    }
                }];
            }
        };
        
        exchangeView.removeExchangeView = ^(ExchangeView *view){
            
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(view.origin.x, self.view.height, view.width, view.height);
            }completion:^(BOOL finished) {
                [exchangeView removeFromSuperview];
                exchangeView = nil;
            }];
        };
    };
    
    //输入框
    cell.showImportViewBlock = ^(void) {
        __block ImportView *importView = [[[NSBundle mainBundle] loadNibNamed:@"ImportView" owner:self options:nil] lastObject];
        importView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        importView.goodModel = liModel;
        importView.deleteImportBlock = ^{
            
            [importView removeFromSuperview];
            importView = nil;
        };
        
        //修改数量
        importView.WisdomAdd_reduceBlock = ^(double count) {
            
            if (_wisdomCollectionView) {
                [self removeCollectionView];
            }
            
            NSIndexPath *allDataIndePath = [selfSelf sectionRowInAllData:liModel.id section:NO];
            ((LiModel *)((WisdomModel *)selfSelf.allData[allDataIndePath.section]).li[allDataIndePath.row]).buyCount = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];
            
            //修改了数量，不满换购
            if (selfCell.selectBtn.selected) {
                if ([liModel.PromotionTypes integerValue] == 1 && [liModel.pmid integerValue] > 0) {
                    NSDictionary *params = @{@"pid":liModel.pid,@"pmid":@"0"};
                    [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
                        ((LiModel *)((WisdomModel *)self.allData[allDataIndePath.section]).li[allDataIndePath.row]).pmid = @"0";
                    } failure:^(NSError *error) {
                        FxLog(@"error = %@",error);
                    }];
                }
            }
            
            [self dealFilter:self.filters];
            [selfSelf changeParamsBadGood:self.storeModel];
        };
        
        [[UIApplication sharedApplication].keyWindow addSubview:importView];
    };
    
    return cell;
}

#pragma 滑动tableView 隐藏数量选择view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.allData.count > 0) {
        
        if (scrollView.contentOffset.y > self.offsetY && scrollView.contentOffset.y > 0) {//向上滑动
            
            if (self.wisdomButton.selected) {
                
                self.animationView.hidden = YES;
            }
            [UIView animateWithDuration:0.4 animations:^{
                
                if (self.navigationView.height != 20) {
                    self.navigationView.frame = CGRectMake(0, 0, kScreenHeight, 20);
                    self.typeView.frame = CGRectMake(0, self.navigationView.bottom, kScreenWidth, 44);
                    if (self.filters.count > 0) {
                        self.noGoodView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, 0);
                    }else {
                        self.noGoodView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, [self changeParamsBadGood:self.storeModel] > 0 ? 35 : 0);
                    }
                    self.tableV.frame = CGRectMake(0, self.noGoodView.bottom, kScreenWidth, kScreenHeight-self.navigationView.height-self.typeView.height-self.noGoodView.height-50);
                }
            }];
            
        }else if (scrollView.contentOffset.y < self.offsetY ){//向下滑动
            
            if (self.wisdomButton.selected) {
                self.animationView.hidden = NO;
            }
            CGFloat height = scrollView.frame.size.height;
            CGFloat contentOffsetY = scrollView.contentOffset.y;
            CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
            if (bottomOffset <= height)
            {
                //在最底部
                if (self.wisdomButton.selected) {
                    
                    self.animationView.hidden = YES;
                }
            }else {
                
                [UIView animateWithDuration:0.4 animations:^{
                    if (self.navigationView.height != 64) {
                        self.navigationView.frame = CGRectMake(0, 0, kScreenHeight, 64);
                        self.typeView.frame = CGRectMake(0, self.navigationView.bottom, kScreenWidth, 44);
                        if (self.filters.count > 0) {
                            self.noGoodView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, 0);
                        }else {
                            self.noGoodView.frame = CGRectMake(0, self.typeView.bottom, kScreenWidth, [self changeParamsBadGood:self.storeModel] > 0 ? 35 : 0);
                        }
                        self.tableV.frame = CGRectMake(0, self.noGoodView.bottom, kScreenWidth, kScreenHeight-self.navigationView.height-self.typeView.height-self.noGoodView.height-50);
                    }
                }];
            }
        }
        
        self.offsetY = scrollView.contentOffset.y;
        
        if (scrollView.contentOffset.y == 0) {
            scrolSection = 0;
            scrolRow = 0;
        }
        
        [self removeCollectionView];
    }
}

#pragma mark 通过section的选中状态来控制row的选中状态
- (void)sectionControlRow:(BOOL)status section:(NSInteger)section {
    
    WisdomModel *wisModel = self.storeModel[section];
    NSArray *array = wisModel.li;
    for (int i = 0; i<array.count; i++) {
        //        LiModel *liModel = array[i];
        ((LiModel *)((WisdomModel *)self.storeModel[section]).li[i]).isSelect = status ? @"1" : @"0";
        
        //        if ([liModel.PromotionTypes integerValue] == 1 && [liModel.pmid integerValue] > 0) {
        //
        //            ((LiModel *)((WisdomModel *)self.storeModel[section]).li[i]).isCheckedExchangeGood = status;
        //        }
    }
}

- (int)changeParamsBadGood:(NSArray *)array {
    
    jumpCellCount = 0;
    
    for (int i = 0; i<array.count; i++) {
        
        WisdomModel *wisdomModel = array[i];
        
        for (int j = 0; j < wisdomModel.li.count; j++) {
            
            LiModel *liModel = wisdomModel.li[j];
            
            if ([liModel.isSelect isEqualToString:@"1"]) {
                __block BOOL Remainder = NO;
                
                [STCommon isRemainderD1:liModel.buyCount.doubleValue withD2:liModel.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {
                    
                    Remainder = isRemainder;
                }];
                
                //购买数低于最低购买数 || 购买数超出库存
                if ([liModel.buyCount doubleValue] < [liModel.minBuy doubleValue] || [liModel.buyCount doubleValue] > [liModel.stock doubleValue] || ([liModel.sellType doubleValue] == 2 && !Remainder)) {
                    
                    jumpCellCount ++;
                    ((LiModel *)((WisdomModel *)array[i]).li[j]).isBadGood = YES;
                }else {
                    ((LiModel *)((WisdomModel *)array[i]).li[j]).isBadGood = NO;
                }
            }else {
                ((LiModel *)((WisdomModel *)array[i]).li[j]).isBadGood = NO;
            }
        }
    }
    return jumpCellCount;
}

- (void)showUndoView:(NSString *)alert {
    
    self.UndoMsg.text = alert;
    
    timeCount = 5;
    time =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerReduce:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.UndoView.frame = CGRectMake(0, kScreenHeight-90, kScreenWidth, 40);
    }];
}

/**
 *  倒计时逻辑
 */
-(void)timerReduce:(NSTimer *)timer {
    
    __weak WisdomShopViewController *weakSelf = self;
    
    if (timeCount == 0) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.UndoView.frame = CGRectMake(-kScreenWidth, kScreenHeight-90, kScreenWidth, 40);
        }];
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    }
    timeCount--;
}

- (NSIndexPath *)sectionRowInAllData:(NSString *)goodID section:(BOOL)isSection {
    
    NSIndexPath *indexPath = nil;
    
    for (int i = 0; i < self.allData.count; i++) {
        WisdomModel *wsiM = self.allData[i];
        if (isSection) {
            if ([wsiM.store_Id isEqualToString:goodID]) {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                return indexPath;
            }
            
        }else {
            for (int j = 0; j< wsiM.li.count; j++) {
                LiModel *model = wsiM.li[j];
                if ([model.id isEqualToString:goodID]) {
                    indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    return indexPath;
                }
            }
        }
    }
    return nil;
}

@end