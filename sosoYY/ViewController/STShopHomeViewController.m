//
//  STShopHomeViewController.m
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopHomeViewController.h"
#import "STShopHomeTopView.h"
#import "STShopHomeFiltrateView.h"
#import "STShopHomeViewCell.h"
#import "STShopHomeHeaderView.h"
#import "STShopHomeFiltrateView.h"
#import "STShopHomePromotionCell.h"
#import "STShopInfoViewController.h"
#import "STStorewideViewController.h"
#import "STStoreClassificationController.h"
#import "STProductSearchCell.h"
#import "STProductDetailsViewController.h"
#import "STShopHomeNavView.h"
#import "NoticeListViewController.h"
#define kSreenHeight [UIScreen mainScreen].bounds.size.height
#define kSreenWidth [UIScreen mainScreen].bounds.size.width



@interface STShopHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITabBarDelegate,STShopHomeTopViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    __block BOOL isHome;
    __block BOOL isAdd;
    __block BOOL isHot;
    __block BOOL isNew;
    __block BOOL isLoad;
    __block BOOL isOK;
    __block BOOL showNewsList;
}

@property (weak, nonatomic) IBOutlet UITabBar *shopHomeTabBar;
@property(strong,nonatomic)UICollectionViewFlowLayout *flowL;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)STShopHomeTopView *shopHomeTopView;
@property (strong, nonatomic)STShopHomeFiltrateView *shopHomeFiltrateView;
@property(strong,nonatomic)UICollectionReusableView *footerView;
@property(strong,nonatomic)NSMutableDictionary *selectDict;
@property(strong,nonatomic)NSMutableArray *bestProductList;
@property(strong,nonatomic)NSMutableArray *newsList;
@property(strong,nonatomic)NSMutableArray *visitProductList;
@property(strong,nonatomic)NSMutableArray *addPriceBuyProductsList;
@property(strong,nonatomic)NSMutableArray *SpecialPriceList;
@property(strong,nonatomic)NSMutableArray *hotProductList;
@property(strong,nonatomic)NSMutableDictionary *baseInfo;
@property(strong,nonatomic)NSMutableArray *neweProductList;
@property(strong,nonatomic)NSMutableArray *PromotionAry;
@property(strong,nonatomic)NSString *login;
@property(strong,nonatomic)NSString *isFavoriteStore;
@property(strong,nonatomic)NSMutableArray *searchProductResult;
@property(strong,nonatomic)UITableView *searchTableView;
@property(strong,nonatomic)UILabel *lab;
@property(assign,nonatomic)NSInteger VisitProductRecordCount;
@property(assign,nonatomic)NSInteger BestProductListRecordCount;
@property(strong,nonatomic)UIButton *topBtn;
@property(strong,nonatomic)NSDictionary *dataResultDict;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)STShopHomeNavView *shopHomeNavView;

@end

@implementation STShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectDict = [NSMutableDictionary new];
    _newsList = [NSMutableArray new];
    _bestProductList = [NSMutableArray new];
    _visitProductList = [NSMutableArray new];
    _addPriceBuyProductsList = [NSMutableArray new];
    _hotProductList = [NSMutableArray new];
    _neweProductList = [NSMutableArray new];
    _baseInfo = [NSMutableDictionary new];
    _searchProductResult = [NSMutableArray new];
    _SpecialPriceList = [NSMutableArray new];
    _PromotionAry = [NSMutableArray new];
    
    _shopHomeTabBar.delegate = self;
    
    _searchTextField.delegate = self;
      [_shopHomeNavView.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    isHome = YES;
    isAdd = NO;
    isHot = NO;
    isNew = NO;
    isOK = NO;
    
    [_selectDict setObject:_typeDict[@"storeid"] forKey:@"storeid"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favorite:)
                                                 name:@"Favorite"
                                               object:nil];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSreenWidth, kSreenHeight - 64 - 49)style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self httpDownloadParams:_selectDict];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(void)httpDownloadParams:(NSMutableDictionary *)params{
    __weak STShopHomeViewController *weakSelf = self;
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getShopHomeListUrl:requestShopHome
                                       params:params finshed:^(id dataResult,NSError *error) {
                                           
                                           _searchTextField.text = @"";
                                           
                                           [_searchTextField resignFirstResponder];
                                           
                                           weakSelf.dataResultDict = dataResult;
                                           //精品推荐
                                           weakSelf.bestProductList =  weakSelf.dataResultDict[@"BestProductList"];
                                           //人气
                                           weakSelf.visitProductList =  weakSelf.dataResultDict[@"VisitProductList"];
                                           //促销---------
                                           weakSelf.addPriceBuyProductsList =  weakSelf.dataResultDict[@"AddPriceBuyProductsList"];
                                           //特价
                                           weakSelf.SpecialPriceList = weakSelf.dataResultDict[@"SpecialPriceList"];
                                           
                                           //是否显示公告
                                           weakSelf.newsList = weakSelf.dataResultDict[@"NewsList"];
                                           if (weakSelf.newsList.count > 0) {
                                               showNewsList = YES;
                                           }else {
                                               showNewsList = NO;
                                           }

                                           if (weakSelf.SpecialPriceList.count > 0) {
                                               for (NSDictionary *dict in  weakSelf.SpecialPriceList) {
                                                   [weakSelf.PromotionAry addObject:dict];
                                               }
                                           }
                                           if (weakSelf.addPriceBuyProductsList.count > 0) {
                                               for (NSDictionary *dict in  weakSelf.addPriceBuyProductsList) {
                                                   [weakSelf.PromotionAry addObject:dict];
                                               }
                                           }
                                           
                                           //热销
                                           weakSelf.hotProductList =  weakSelf.dataResultDict[@"HotProductList"];
                                           //新上
                                           weakSelf.neweProductList =  weakSelf.dataResultDict[@"NewProductList"];
                                           //资料
                                           weakSelf.baseInfo =  weakSelf.dataResultDict[@"BaseInfo"];
                                           weakSelf.login = [NSString stringWithFormat:@"%@", weakSelf.dataResultDict[@"IsLogin"]];
                                           weakSelf.isFavoriteStore = [NSString stringWithFormat:@"%@", weakSelf.dataResultDict[@"isFavoriteStore"]];
                                           weakSelf.VisitProductRecordCount = [weakSelf.dataResultDict[@"VisitProductRecordCount"] integerValue];
                                           weakSelf.BestProductListRecordCount = [weakSelf.dataResultDict[@"BestProductListRecordCount"] integerValue];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if (weakSelf.dataResultDict != nil || weakSelf.dataResultDict.count != 0) {
                                                   [weakSelf relodeView];
                                                   [[UIApplication sharedApplication].keyWindow hideToastActivity];
                                                   isLoad = YES;
                                               }
                                           });
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

-(void)httpDownProductLoadAssociate:(NSString *)text{
    if (isLoad) {
        __weak STShopHomeViewController *weakSelf = self;
        [KSMNetworkRequest getStoreClassAssociateUrl:requestInStoreSearchProductSearch params:@{@"storeid":_baseInfo[@"StoreId"],@"q":text} finshed:^(id dataResult, NSError *error) {
            weakSelf.searchProductResult = dataResult;
            if (weakSelf.searchProductResult.count > 6) {
                [UIView animateWithDuration:.2 animations:^{
                    weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 180);
                }];
            }else{
                [UIView animateWithDuration:.2 animations:^{
                    weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, weakSelf.searchProductResult.count * 30);
                }];
            }
            [weakSelf.searchTableView reloadData];
        }];
    }else{
        [ZHProgressHUD showInfoWithText:@"暂无数据"];
    }
}

-(void)relodeView {
    [self addSubView];
    [ self.shopHomeFiltrateView setSubBtn:@[@"店铺首页",[NSString stringWithFormat: @"促销(%lu)",(unsigned long) self.PromotionAry.count],[NSString stringWithFormat: @"热销(%lu)",(unsigned long) self.hotProductList.count],[NSString stringWithFormat: @"上新(%lu)",(unsigned long) self.neweProductList.count]]];
    [self.tableView.mj_header endRefreshing];
    self.tableView.hidden = YES;
}

-(void)addSubView{
    _flowL = [UICollectionViewFlowLayout new];
    [_flowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSreenWidth, kSreenHeight  - 49)collectionViewLayout:_flowL];
    
    if (@available(iOS 11.0, *)){
        [_collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:[STShopHomePromotionCell.class description] bundle:nil] forCellWithReuseIdentifier:@"STShopHomePromotionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:[STShopHomeViewCell.class description] bundle:nil] forCellWithReuseIdentifier:@"STShopHomeViewCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:[STShopHomeTopView.class description] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STShopHomeTopView"];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    
    [self.view addSubview:_collectionView];
    
    _lab = [UILabel new];
    _lab.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, 30);
    _lab.text = @"暂无数据";
    _lab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
    _lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lab];
    if (_baseInfo.count + _visitProductList.count != 0) {
        _lab.hidden = YES;
    }
    
    __weak STShopHomeViewController *weakSelf = self;
    _shopHomeFiltrateView = [[STShopHomeFiltrateView alloc]init];
    _shopHomeFiltrateView.frame = CGRectMake(0, 199 + ((showNewsList) ? 40 : 0), kSreenWidth, 40);
    _shopHomeFiltrateView.FiltrateBlock = ^(NSInteger tag){
        weakSelf.lab.hidden = NO;
        switch (tag) {
            case 0:
                isHome = YES;
                isAdd = NO;
                isHot = NO;
                isNew = NO;
                if (weakSelf.baseInfo.count + weakSelf.visitProductList.count != 0) {
                    weakSelf.lab.hidden = YES;
                }
                break;
            case 1:
                isHome = NO;
                isAdd = YES;
                isHot = NO;
                isNew = NO;
                if (weakSelf.PromotionAry.count != 0) {
                    weakSelf.lab.hidden = YES;
                }
                break;
            case 2:
                isHome = NO;
                isAdd = NO;
                isHot = YES;
                isNew = NO;
                if (weakSelf.hotProductList.count != 0) {
                    weakSelf.lab.hidden = YES;
                }
                break;
            case 3:
                isHome = NO;
                isAdd = NO;
                isHot = NO;
                isNew = YES;
                if (weakSelf.neweProductList.count != 0) {
                    weakSelf.lab.hidden = YES;
                }
                break;
            default:
                break;
        }
        
        [weakSelf.collectionView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        //        [weakSelf.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
        //        NSIndexPath *indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        //        [weakSelf.collectionView scrollToItemAtIndexPath:indexPat atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        [weakSelf.collectionView reloadData];
    };
    [_collectionView addSubview:_shopHomeFiltrateView];
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 60, kScreenWidth - 100, 0)style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.layer.masksToBounds = YES;
    _searchTableView.layer.cornerRadius = 5.0f;
    _searchTableView.rowHeight = 30;
    [_searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_searchTableView];
    
    
    _topBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _topBtn.frame = CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 120, 40, 40);
    _topBtn.hidden = YES;
    [_topBtn addTarget:self action:@selector(topSelect) forControlEvents:UIControlEventTouchUpInside];
    [_topBtn setBackgroundImage:[UIImage imageNamed:@"topA"] forState:UIControlStateNormal];
    [self.view addSubview:_topBtn];
    
    
    _shopHomeNavView = [[[NSBundle mainBundle]loadNibNamed:@"STShopHomeNavView" owner:self options:nil]lastObject];
    _shopHomeNavView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    _shopHomeNavView.searchTextField.delegate = self;
    [_shopHomeNavView.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _shopHomeNavView.backBlock = ^{
        
        [weakSelf back:nil];
        
    };
    _shopHomeNavView.scanSelectedBlock = ^{
       
        [weakSelf scanSelected:nil];
    };
    
    _shopHomeNavView.searchSelectedBlock = ^{
        
        [weakSelf searchSelected:nil];
        
    };
    [self.view addSubview:_shopHomeNavView];

}

#pragma mark --UICollectionView dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (isHome) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isHome) {
        if (section == 0) {
            if (_bestProductList.count > 6) {
                return 6;
            }else{
                if (_bestProductList.count %2 == 0) {
                    return _bestProductList.count;
                }else{
                    return _bestProductList.count + 1;
                }
            }
        }else{
            if (_visitProductList.count > 6) {
                return 6;
            }else{
                if (_visitProductList.count %2 == 0) {
                    return _visitProductList.count;
                }else{
                    return _visitProductList.count + 1;
                }
            }
        }
    }else if (isAdd){
        if (_PromotionAry.count %2 == 0) {
            return _PromotionAry.count;
        }else{
            return _PromotionAry.count + 1;
        }
    }else if (isHot){
        if (_hotProductList.count %2 == 0) {
            return _hotProductList.count;
        }else{
            return _hotProductList.count + 1;
        }
    }else if (isNew){
        if (_neweProductList.count %2 == 0) {
            return _neweProductList.count;
        }else{
            return _neweProductList.count + 1;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!isAdd) {
        STShopHomeViewCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STShopHomeViewCell" forIndexPath:indexPath];
        if (isHome) {
            if (indexPath.section == 0) {
                if (_bestProductList.count != 0) {
                    [MyCell setTopHomeIndexPath:indexPath andTitleAry:_bestProductList logIn:_login type:0];
                }
            }else{
                if (_visitProductList.count != 0) {
                    [MyCell setTopHomeIndexPath:indexPath andTitleAry:_visitProductList logIn:_login type:1];
                }
            }
        }else if(isHot){
            if (_hotProductList.count != 0) {
                [MyCell setTopHomeIndexPath:indexPath andTitleAry:_hotProductList logIn:_login type:2];
            }
        }else if (isNew){
            if (_neweProductList.count != 0) {
                [MyCell setTopHomeIndexPath:indexPath andTitleAry:_neweProductList logIn:_login type:3];
            }
        }
        return MyCell;
    }else{
        STShopHomePromotionCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STShopHomePromotionCell" forIndexPath:indexPath];
        if (_PromotionAry.count != 0) {
            [MyCell setTopHomePromotionIndexPath:indexPath andTitleAry:_PromotionAry logIn:_login];
        }
        return MyCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isAdd) {
        return CGSizeMake(kSreenWidth/2, 204);
    }else{
        return CGSizeMake(kSreenWidth/2, 257);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (isHome) {
        if (section == 0) {
            if (_bestProductList.count == 0){
                if (showNewsList) {
                    return CGSizeMake(kSreenWidth,210 + 64);
                }else {
                    return CGSizeMake(kSreenWidth,170 + 64);
                }
            }else{
                if (showNewsList) {
                    return CGSizeMake(kSreenWidth,260 + 64);
                }else {
                    return CGSizeMake(kSreenWidth,220 + 64);
                }
            }
        }else{
            return CGSizeMake(kSreenWidth,50);
        }
    }else{
        if (showNewsList) {
            return CGSizeMake(kSreenWidth,220 + 64);
        }else {
            return CGSizeMake(kSreenWidth,180 + 64);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (isHome) {
        if (section == 0) {
            return CGSizeMake(kSreenWidth,0);
        }else{
            return CGSizeMake(kSreenWidth,.5);
        }
    }else{
        return CGSizeMake(kSreenWidth,.5);
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    __weak STShopHomeViewController *waekSelf = self;
    if (kind == UICollectionElementKindSectionHeader) {
        if (isHome) {
            UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STShopHomeTopView" forIndexPath:indexPath];
            
            for (UIView *view in reusableView.subviews) {
                [view removeFromSuperview];
            }
            
            if (indexPath.section == 0) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"STShopHomeTopView" owner:self options:nil];
                self.shopHomeTopView = [nib objectAtIndex:0];
                self.shopHomeTopView.delegate = self;
                if (_bestProductList.count == 0) {
                    if (showNewsList) {
                       self.shopHomeTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 210 + 64);
                    }else {
                        self.shopHomeTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 170 + 64);
                    }
                }else{
                    if (showNewsList) {
                        self.shopHomeTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 260 + 64);
                    }else {
                        self.shopHomeTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 220 + 64);
                    }
                }
                if (_baseInfo.count != 0) {
                    self.shopHomeTopView.newsList = self.newsList;
                    [self.shopHomeTopView setShopHomeTop:_baseInfo index:_BestProductListRecordCount favoriteStore:_isFavoriteStore];
                }
                self.shopHomeTopView.moreBlock = ^(id sender){
                    STStorewideViewController *StorewideVC = [STStorewideViewController new];
                    StorewideVC.typeDict = @{@"storeid":waekSelf.baseInfo[@"StoreId"],@"storecateid":@"",@"sort":@"1",@"IsBest":@"1",@"StorekeyWords":@"",@"CateId":@""};
                    [waekSelf.navigationController pushViewController:StorewideVC animated:YES];
                };
                [reusableView addSubview:self.shopHomeTopView];
            }else{
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"STShopHomeHeaderView" owner:self options:nil];
                STShopHomeHeaderView *headerView = [nib objectAtIndex:0];
                headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
                [headerView setShopHomeHeaderView:_VisitProductRecordCount];
                headerView.popularityBlock = ^(id sender){
                    STStorewideViewController *StorewideVC = [STStorewideViewController new];
                    StorewideVC.typeDict = @{@"storeid":_baseInfo[@"StoreId"],@"storecateid":@"",@"sort":@"10",@"IsBest":@"",@"StorekeyWords":@"",@"CateId":@""};
                    [self.navigationController pushViewController:StorewideVC animated:YES];
                };
                [reusableView addSubview:headerView];
            }
            return reusableView;
            
        }else{
            UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STShopHomeTopView" forIndexPath:indexPath];
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"STShopHomeTopView" owner:self options:nil];
            self.shopHomeTopView = [nib objectAtIndex:0];
            self.shopHomeTopView.delegate = self;
            if (showNewsList) {
                self.shopHomeTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 220 + 64);
            }else {
                self.shopHomeTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, 180 + 64);
            }
            
            if (_baseInfo.count != 0) {
                self.shopHomeTopView.newsList = self.newsList;
                [self.shopHomeTopView setShopHomeTop:_baseInfo index:_VisitProductRecordCount favoriteStore:_isFavoriteStore];
            }
            self.shopHomeTopView.moreBlock = ^(id sender){
                STStorewideViewController *StorewideVC = [STStorewideViewController new];
                StorewideVC.typeDict = @{@"storeid":waekSelf.baseInfo[@"StoreId"],@"storecateid":@"",@"sort":@"1",@"IsBest":@"1",@"StorekeyWords":@"",@"CateId":@""};
                [waekSelf.navigationController pushViewController:StorewideVC animated:YES];
            };
            [reusableView addSubview:self.shopHomeTopView];
            return reusableView;
        }
    }else if(kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        if (isHome) {
            if (indexPath.section != 0) {
                _footerView = [UICollectionReusableView new];
                _footerView.frame = CGRectMake(0, 0, kSreenWidth, .5);
                _footerView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
                [reusableView addSubview:_footerView];
                return reusableView;
            }
        }else{
            _footerView = [UICollectionReusableView new];
            _footerView.frame = CGRectMake(0, 0, kSreenWidth, .5);
            _footerView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
            [reusableView addSubview:_footerView];
            return reusableView;
        }
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *pidStr = nil;
    if (isHome) {
        if (indexPath.section == 0) {
            if (_bestProductList.count %2 == 0) {
                pidStr = _bestProductList[indexPath.row][@"pid"];
            }else{
                if (indexPath.row != _bestProductList.count) {
                    pidStr = _bestProductList[indexPath.row][@"pid"];
                }else{
                    return;
                }
            }
        }else{
            if (_visitProductList.count %2 == 0) {
                pidStr = _visitProductList[indexPath.row][@"pid"];
            }else{
                if (indexPath.row != _visitProductList.count) {
                    pidStr = _visitProductList[indexPath.row][@"pid"];
                }else{
                    return;
                }
            }
        }
    }else if (isAdd){
        if (_PromotionAry.count %2 == 0) {
            pidStr = _PromotionAry[indexPath.row][@"pid"];
        }else{
            if (indexPath.row != _PromotionAry.count) {
                pidStr = _PromotionAry[indexPath.row][@"pid"];
            }else{
                return;
            }
        }
    }else if (isHot){
        if (_hotProductList.count %2 == 0) {
            pidStr = _hotProductList[indexPath.row][@"pid"];
        }else{
            if (indexPath.row != _hotProductList.count) {
                pidStr = _hotProductList[indexPath.row][@"pid"];
            }else{
                if (indexPath.row != _hotProductList.count) {
                    pidStr = _hotProductList[indexPath.row][@"pid"];
                }else{
                    return;
                }
            }
        }
    }else if (isNew){
        if (_neweProductList.count %2 == 0) {
            pidStr = _neweProductList[indexPath.row][@"pid"];
        }else{
            if (indexPath.row != _neweProductList.count) {
                pidStr = _neweProductList[indexPath.row][@"pid"];
            }else{
                return;
            }
        }
    }
    
    STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
    detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,pidStr];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark -- UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (self.dataResultDict != nil || self.dataResultDict.count != 0) {
        switch (item.tag) {
            case 0:{
                STStoreClassificationController *StoreClassVC = [STStoreClassificationController new];
                StoreClassVC.storeid = _baseInfo[@"StoreId"];
                [self.navigationController pushViewController:StoreClassVC animated:YES];
                break;
            }
            case 1:{
                STStorewideViewController *StorewideVC = [STStorewideViewController new];
                StorewideVC.typeDict = @{@"storeid":_baseInfo[@"StoreId"],@"storecateid":@"",@"sort":@"1",@"IsBest":@"",@"StorekeyWords":@"",@"CateId":@""};
                [self.navigationController pushViewController:StorewideVC animated:YES];
                break;
            }
            case 2:{
                STShopInfoViewController *shopInfoVC = [STShopInfoViewController new];
                shopInfoVC.storeid = _baseInfo[@"StoreId"];
                shopInfoVC.login = _login;
                [self.navigationController pushViewController:shopInfoVC animated:YES];
                break;
            }
            default:
                break;
        }
    }else{
        [ZHProgressHUD showInfoWithText:@"暂无数据"];
        [_shopHomeTabBar setSelectedItem:nil];
    }
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchProductResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SearchName = @"SearchName";
    STProductSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchName];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"STProductSearchCell" owner:self options:nil]lastObject];
    }
    if (_searchProductResult.count != 0) {
        [cell setProductSearch:_searchProductResult indexPath:indexPath];
    }
    return cell;
}

#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    STProductSearchCell *cell = (STProductSearchCell *)[_searchTableView cellForRowAtIndexPath:indexPath];
    STStorewideViewController *StorewideVC = [STStorewideViewController new];
    StorewideVC.typeDict = @{@"storeid":_baseInfo[@"StoreId"],@"storecateid":@"",@"sort":@"1",@"IsBest":@"",@"StorekeyWords":cell.nameLab.text,@"CateId":@""};
    [self.navigationController pushViewController:StorewideVC animated:YES];
}

#pragma mark -- STShopHomeTopViewDelegate
-(void)g_setLogin:(void (^)(BOOL))finshed{
    __weak STShopHomeViewController *weakSelf = self;
    if ([weakSelf.login intValue] == 1) {
        finshed(YES);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还未登录,是否登录?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:@{@"selectIndex":@"4",@"frome":@"0"}];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        finshed(NO);
    }
}

-(void)g_setChangeFavoriteStore:(NSString *)favoriteStore{
    _isFavoriteStore = favoriteStore;
}

- (void)showNotice {
    
    NoticeListViewController *noticeList = [NoticeListViewController new];
    noticeList.newsList = self.newsList;
    noticeList.storeId = _baseInfo[@"StoreId"];
    [self.navigationController pushViewController:noticeList animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= 64) {
        
        _shopHomeNavView.backImgV.image = [UIImage imageNamed:@"橙色"];
        
    }else{
        
        _shopHomeNavView.backImgV.image = [UIImage imageNamed:@"透明"];
    }
    
    if (scrollView.contentOffset.y >= (140 + ((showNewsList ? 40 : 0)))) {
        _shopHomeFiltrateView.frame = CGRectMake(0, scrollView.contentOffset.y + 64, kSreenWidth, 40);
    }else{
        _shopHomeFiltrateView.frame = CGRectMake(0, 199+(showNewsList ? 40 : 0), kSreenWidth, 40);
    }
    if (scrollView != _searchTableView) {
        _searchTextField.text = @"";
        _shopHomeNavView.searchTextField.text = @"";
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }
    [_searchTextField resignFirstResponder];
    [_shopHomeNavView.searchTextField resignFirstResponder];
    
    
    if (scrollView.contentOffset.y >= 200) {
        _topBtn.hidden = NO;
    }else{
        _topBtn.hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= 64) {
        
        _shopHomeNavView.backImgV.image = [UIImage imageNamed:@"橙色"];
 
    }else{
        
      _shopHomeNavView.backImgV.image = [UIImage imageNamed:@"透明"];
    }
    
    
    
    if (scrollView.contentOffset.y >= 140) {
        _shopHomeFiltrateView.frame = CGRectMake(0, scrollView.contentOffset.y + 64, kSreenWidth, 40);
    }
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(isLoad){
        STStorewideViewController *StorewideVC = [STStorewideViewController new];
        StorewideVC.typeDict = @{@"storeid":_baseInfo[@"StoreId"],@"storecateid":@"",@"sort":@"1",@"IsBest":@"",@"StorekeyWords":textField.text,@"CateId":@""};
        [self.navigationController pushViewController:StorewideVC animated:YES];
    }else{
        [ZHProgressHUD showInfoWithText:@"暂无数据"];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (isLoad) {
        if (_searchProductResult.count != 0) {
            [_searchProductResult removeAllObjects];
        }
        
        if (![textField.text isEqualToString:@""]) {
            [self httpDownProductLoadAssociate:_shopHomeNavView.searchTextField.text];
            
        }else{
            [_searchTableView reloadData];
            [UIView animateWithDuration:.2 animations:^{
                _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
            }];
        }
    }else{
        [ZHProgressHUD showInfoWithText:@"暂无数据"];
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (isLoad) {
        _searchTextField.text = @"";
        _shopHomeNavView.searchTextField.text = @"";
        [_searchProductResult removeAllObjects];
        [_searchTableView reloadData];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }else{
        [ZHProgressHUD showInfoWithText:@"暂无数据"];
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_shopHomeTabBar setSelectedItem:nil];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_searchTextField resignFirstResponder];
    _searchTextField.text = @"";
    [_shopHomeNavView.searchTextField resignFirstResponder];
    _shopHomeNavView.searchTextField.text = @"";
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self performSelector:@selector(setSeachResignFirstResponder) withObject:self afterDelay:.5];
}

- (IBAction)back:(id)sender {
    [self.shopHomeTopView.noticeView.time invalidate];
    self.shopHomeTopView.noticeView.time = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanSelected:(id)sender {
    NSDictionary *dict =@{@"scanSelected":@"1",@"storeid":_typeDict[@"storeid"]};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"scanSelected"];
   [[STCommon sharedSTSTCommon]toScanViewWith:self];
}

- (IBAction)searchSelected:(id)sender {
    if (isLoad) {
        STStorewideViewController *StorewideVC = [STStorewideViewController new];
        StorewideVC.typeDict = @{@"storeid":_baseInfo[@"StoreId"],@"storecateid":@"",@"sort":@"1",@"IsBest":@"",@"StorekeyWords":_shopHomeNavView.searchTextField.text,@"CateId":@""};
        [self.navigationController pushViewController:StorewideVC animated:YES];
    }else{
        [ZHProgressHUD showInfoWithText:@"暂无数据"];
    }
}


-(void)favorite:(NSNotification *)sender{
    _isFavoriteStore = [sender.userInfo objectForKey:@"Concern"];
    [self.collectionView reloadData];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Favorite" object:nil];
}

-(void)setSeachResignFirstResponder{
    [_searchTextField resignFirstResponder];
    _searchTextField.text = @"";
    [_shopHomeNavView.searchTextField resignFirstResponder];
    _shopHomeNavView.searchTextField.text = @"";
    
    
    [_searchProductResult removeAllObjects];
    [_searchTableView reloadData];
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
}

-(void)topSelect{
    [_collectionView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}
@end
