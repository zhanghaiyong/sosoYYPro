//
//  STWisdomAddListViewController.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomAddListViewController.h"
#import "STWisdomAddListBtnView.h"
#import "STWisdomAddListFilterView.h"
#import "STWisdomAddListNavView.h"
#import "STStorewideBgTableViewCell.h"
#import "STProductSearchCell.h"
#import "STShopListTableViewCell.h"
#import "STWisdomAddListLucencyView.h"
#import "STWisdomAddBCountuyView.h"
#import "STWisdomAddSwapBuyView.h"
#import "STWisdomAddListUITableViewCell.h"
#import "STWisdomAddListTabBarView.h"
#import "STProductDetailsViewController.h"

@interface STWisdomAddListViewController ()<STWisdomAddListBtnViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,STWisdomAddListUITableViewCellDelegate>{
    float lastContentOffset;
    __block  NSInteger pageCount;
    __block   NSInteger pageIndex;
    NSString *sortStr;
    __block BOOL isSelect;
    BOOL isSynthesize;
    UIView *bgView;
    UILabel *_lab;
    __block BOOL isOK;
}

@property(strong,nonatomic)STWisdomAddListBtnView *wisdomAddListBtnView;
@property(strong,nonatomic)STWisdomAddListFilterView *filterView;
@property(strong,nonatomic)UIView *wisdomAddListBgView;
@property(strong,nonatomic)STWisdomAddListNavView *wisdomAddListNavView;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UIView *headerView;
@property(strong,nonatomic)NSMutableArray *dataResult;
@property(strong,nonatomic)NSMutableDictionary *paramsDict;
@property(strong,nonatomic)UITableView *searchTableView;
@property(strong,nonatomic)NSMutableArray *searchstorewideResult;
@property(strong,nonatomic)UIButton *topBtn;
@property(strong,nonatomic)NSMutableDictionary *searchDict;
@property(strong,nonatomic)STWisdomAddListLucencyView *wisdomAddListLucencyView;
@property(strong,nonatomic)STWisdomAddBCountuyView *wisdomAddBCountuyView;
@property(strong,nonatomic)STWisdomAddSwapBuyView *wisdomAddSwapBuyView;
@property(strong,nonatomic)STWisdomAddListTabBarView *wisdomAddListTabBarView;

@end

@implementation STWisdomAddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addSubView];
    
     __weak STWisdomAddListViewController *weakSelf = self;
    
    _wisdomAddListLucencyView = [[STWisdomAddListLucencyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _wisdomAddListLucencyView.hidden = YES;
     [self.view addSubview:_wisdomAddListLucencyView];
    
    _wisdomAddBCountuyView = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomAddBCountuyView" owner:self options:nil]lastObject];
    _wisdomAddBCountuyView.frame = CGRectMake(20, kScreenHeight/2 - 105, kScreenWidth - 40, 190);
    [_wisdomAddBCountuyView setWisdomAddBCountuy:nil indexpath:nil];
    _wisdomAddBCountuyView.hidden = YES;
    _wisdomAddBCountuyView.WisdomBuyCountBlock = ^(int type, NSDictionary *dict,NSIndexPath *indexpath){
        switch (type) {
            case 0:{
                weakSelf.wisdomAddListLucencyView.hidden = YES;
                weakSelf.wisdomAddBCountuyView.hidden = YES;
                break;
            }
            case 1:{
                weakSelf.wisdomAddListLucencyView.hidden = YES;
                weakSelf.wisdomAddBCountuyView.hidden = YES;
                
              [weakSelf  addPurchaseProduct:dict finshed:^(STStorewideEntity *entity,NSString *mesg,NSString *code,NSError *error) {
                 
                  if (!error) {
                      if ([code intValue] == 1) {
                          
                          [ZHProgressHUD showInfoWithText:@"操作成功"];
                          
                           [weakSelf.wisdomAddListTabBarView setWisdomAddListTabBarView:entity];
                          
                          STStorewideEntity *entity = weakSelf.dataResult[indexpath.row];
                          
                          entity.isBuy = @"1";
                          
                          [weakSelf.dataResult replaceObjectAtIndex:indexpath.row withObject:entity];
                          
                          [weakSelf.tableView reloadData];
                      }else{
                        [ZHProgressHUD showInfoWithText:mesg];
                      }
                  }else{
                      [ZHProgressHUD showInfoWithText:@"请求失败"];
                  }
              }];
                break;
            }
                    default:
                break;
        }
    };
    [self.view addSubview:_wisdomAddBCountuyView];
    
    
    _wisdomAddSwapBuyView = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomAddSwapBuyView" owner:self options:nil]lastObject];
    _wisdomAddSwapBuyView.frame = CGRectMake(20, kScreenHeight/2 - 155, kScreenWidth - 40, 290);
   _wisdomAddSwapBuyView.hidden = YES;
    _wisdomAddSwapBuyView.WisdomAddSwapBuyBlock = ^(void){
        weakSelf.wisdomAddListLucencyView.hidden = YES;
        weakSelf.wisdomAddSwapBuyView.hidden = YES;
    };
    _wisdomAddSwapBuyView.setToDetailsBlock = ^(NSString *pid){
        STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
        detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,pid];
        [weakSelf.navigationController pushViewController:detailsVC animated:YES];
        
        weakSelf.wisdomAddListLucencyView.hidden = YES;
        weakSelf.wisdomAddSwapBuyView.hidden = YES;
    };
    [self.view addSubview:_wisdomAddSwapBuyView];

}
-(void)addSubView{
    __weak STWisdomAddListViewController *weakSelf = self;
    isOK = NO;
    pageIndex = 1;
    isSelect = YES;
    isSynthesize = YES;
    _dataResult = [NSMutableArray new];
    _paramsDict = [NSMutableDictionary new];
    _searchstorewideResult = [NSMutableArray new];
    _searchDict = [NSMutableDictionary new];
    
    _filterView = [[STWisdomAddListFilterView alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth - 100, kScreenHeight)];
    [self.view addSubview:_filterView];
    
    _wisdomAddListBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_wisdomAddListBgView];
    
    
    _headerView = [UIView new];
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 30);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kNavBarHeight)style:UITableViewStylePlain];
    _tableView.userInteractionEnabled = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.tableHeaderView = _headerView;
    [_wisdomAddListBgView addSubview:_tableView];
    
    
    _wisdomAddListBtnView = [[STWisdomAddListBtnView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
    _wisdomAddListBtnView.delegate = self;
    [_wisdomAddListBgView addSubview:_wisdomAddListBtnView];
    
    _wisdomAddListNavView = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomAddListNavView" owner:self options:nil]lastObject];
    _wisdomAddListNavView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    [_wisdomAddListNavView setSearchTextField];
    _wisdomAddListNavView.BackBlock = ^{
        if (weakSelf.WisdomAddListBackBlock) {
            weakSelf.WisdomAddListBackBlock();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _wisdomAddListNavView.WisdomAddListSearchTextBlock = ^(NSString *text){
        
        [UIView animateWithDuration:.2 animations:^{
            weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
        pageIndex = 1;
        [weakSelf.paramsDict setObject:@"1" forKey:@"pageIndex"];
        [weakSelf.paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"StorekeyWords"];
        [weakSelf.tableView.mj_header beginRefreshing];
  
    };
    
    _wisdomAddListNavView.WisdomAddListSearchAssociateTextBlock = ^(NSString *text){
        [weakSelf.paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"StorekeyWords"];
        [weakSelf.searchstorewideResult removeAllObjects];
        if (![text isEqualToString:@""]) {
            [weakSelf httpDownStorewideLoadAssociate:text];
        }else{
            [weakSelf.searchTableView reloadData];
            [UIView animateWithDuration:.2 animations:^{
                weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
            }];
        }

    };
    
    [_wisdomAddListBgView addSubview:_wisdomAddListNavView];


    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 60, kScreenWidth - 100, 0)style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.layer.masksToBounds = YES;
    _searchTableView.layer.cornerRadius = 5.0f;
    _searchTableView.rowHeight = 30;
    [_searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_wisdomAddListBgView addSubview:_searchTableView];
    
    
    _wisdomAddListTabBarView = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomAddListTabBarView" owner:self options:nil]lastObject];
    _wisdomAddListTabBarView.frame = CGRectMake(0, kScreenHeight - kTabBarHeight, kScreenWidth, kTabBarHeight);
    _wisdomAddListTabBarView.wisdomAddListTabBarViewBlock = ^(void){
        if (weakSelf.WisdomAddListBackBlock) {
            weakSelf.WisdomAddListBackBlock();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [_wisdomAddListTabBarView setWisdomAddListTabBarView:nil];
    [_wisdomAddListBgView addSubview:_wisdomAddListTabBarView];
    
    
    _topBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _topBtn.frame = CGRectMake(kScreenWidth - 60, kScreenHeight - 120, 40, 40);
    _topBtn.hidden = YES;
    [_topBtn addTarget:self action:@selector(topSelect) forControlEvents:UIControlEventTouchUpInside];
    [_topBtn setBackgroundImage:[UIImage imageNamed:@"topA"] forState:UIControlStateNormal];
    [_wisdomAddListBgView addSubview:_topBtn];
    
    bgView = [UIView new];
    bgView.userInteractionEnabled = YES;
    bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    bgView.backgroundColor = [UIColor clearColor];
    bgView.hidden = YES;
    [_wisdomAddListBgView addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(tapRightSwipe)];
    [bgView addGestureRecognizer:tap];
    
    _wisdomAddListNavView.searchTextField.delegate = self;
    
    [_paramsDict setObject:@"0" forKey:@"producttype"];
    [_paramsDict setObject:@"0" forKey:@"cuxiao"];
    [_paramsDict setObject:@""forKey:@"GrossMarginRange"];
    [_paramsDict setObject:@"" forKey:@"PriceRange"];
    
    [_paramsDict setObject:_storeid forKey:@"storeid"];
    [_paramsDict setObject:@"1" forKey:@"sort"];
     [_paramsDict setObject:@""forKey:@"StorekeyWords"];
//    [_paramsDict setObject:@"storelist" forKey:@"from"];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
         isOK = NO;
        [weakSelf.paramsDict setObject:@"1" forKey:@"pageIndex"];
        [weakSelf httpDownloadParams:weakSelf.paramsDict];
        
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (pageIndex < pageCount) {
            isOK = NO;
            pageIndex ++;
            [weakSelf.paramsDict setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageIndex"];
            [weakSelf httpDownloadParams:weakSelf.paramsDict];
        }else{
            [ZHProgressHUD showInfoWithText:@"暂无更多数据"];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wisdomAddListeProducttypeMothed:)
                                                 name:@"wisdomAddListeProducttype"
                                               object:nil];
    
    _lab = [UILabel new];
    _lab.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, 30);
    _lab.text = @"暂无数据";
    _lab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.hidden = YES;
    [_wisdomAddListBgView addSubview:_lab];
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark -- 数据请求
-(void)httpDownloadParams:(NSMutableDictionary *)params{
    
    __weak STWisdomAddListViewController *weakSelf = self;
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getSearchProductNewUrl:requestSearchProductNew params:params finshed:^(id dataResult, STStorewideEntity *entity, NSError *error) {
            [weakSelf.wisdomAddListTabBarView setWisdomAddListTabBarView:entity];
            if (!error) {
                pageCount = entity.pageCount;
                if (pageIndex == 1 || pageIndex ==  0) {
                    weakSelf.dataResult = dataResult;
                    if (weakSelf.dataResult.count == 0) {
                        [ZHProgressHUD showInfoWithText:@"暂无更多数据"];
                        _lab.hidden = NO;
                    }else{
                        _lab.hidden = YES;
                    }
                }else{
                    [weakSelf.dataResult addObjectsFromArray:dataResult];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.tableView.mj_footer endRefreshing];
                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                });
                isOK = YES;
            }else{
                [weakSelf.dataResult removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
              [ZHProgressHUD showInfoWithText:@"网络请求失败"];
            }
        }];
    });
    [[STCommon sharedSTSTCommon] setHideToastActivity:^(BOOL isYes) {
        if (isYes) {
            if (isOK) {
                return ;
            }
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark -- 搜索联想
-(void)httpDownStorewideLoadAssociate:(NSString *)text{
    __weak STWisdomAddListViewController *weakSelf = self;
    
    [_searchDict setObject:text forKey:@"q"];
    [_searchDict setObject:_storeid forKey:@"storeid"];
    
    [KSMNetworkRequest getStoreClassAssociateUrl:requestInStoreSearchProductSearch params:_searchDict finshed:^(id dataResult, NSError *error) {
        weakSelf.searchstorewideResult = dataResult;
        if (isSelect) {
            if (weakSelf.searchstorewideResult.count > 6) {
                [UIView animateWithDuration:.2 animations:^{
                    weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 180);
                }];
            }else{
                weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, weakSelf.searchstorewideResult.count * 30);
            }
            [weakSelf.searchTableView reloadData];
        }
    }];
    isSelect = YES;
}
-(void)addPurchaseProduct:(NSDictionary *)params finshed:(void(^)(STStorewideEntity *entity,NSString *mesg,NSString *code,NSError *error))finshed{
    [KSMNetworkRequest getAddPurchaseProductUrl:requestAddPurchaseProduct params:params finshed:^(STStorewideEntity *entity,NSString *mesg,NSString *code, NSError *error) {
            finshed(entity,mesg,code,error);
    }];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchTableView) {
        return _searchstorewideResult.count;
    }else if (tableView == _tableView){
        return _dataResult.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _searchTableView) {
        static NSString *SearchName = @"SearchName";
        STProductSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STProductSearchCell" owner:self options:nil]lastObject];
        }
        [cell setProductSearch:_searchstorewideResult indexPath:indexPath];
        return cell;
    }else if(tableView == _tableView){
        static NSString *StorewideBgName = @"StorewideBgName";
        STWisdomAddListUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StorewideBgName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomAddListUITableViewCell" owner:self options:nil]lastObject];
            cell.delegate = self;
        }
        if (_dataResult.count != 0) {
            [cell setWisdomAddList:_dataResult indexPath:indexPath];
        }
        return cell;
    }
    return nil;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _searchTableView) {
        isSelect = NO;
        STProductSearchCell *cell = (STProductSearchCell *)[_searchTableView cellForRowAtIndexPath:indexPath];
        _wisdomAddListNavView.searchTextField.text = cell.nameLab.text;
        
        pageIndex = 1;
        [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:cell.nameLab.text oldStr:cell.nameLab.text] forKey:@"StorekeyWords"];
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [self.tableView.mj_header beginRefreshing];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }else if(tableView == _tableView){
//        STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
//        detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,[_dataResult[indexPath.row] Pid]];
//        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}

#pragma mark - STWisdomAddListUITableViewCellDelegate
-(void)g_setTradeBuy:(STWisdomAddListUITableViewCell *)cell{
    _wisdomAddListLucencyView.hidden = NO;
    _wisdomAddSwapBuyView.hidden = NO;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_wisdomAddSwapBuyView setWisdomAddSwapBuy:_dataResult[indexPath.row]];
}
-(void)g_setSelectBuy:(STWisdomAddListUITableViewCell *)cell{
    
      NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    if ([_dataResult[indexPath.row]isBuy].intValue == 1) {
           [ZHProgressHUD showInfoWithText:@"已加入购买"];
    }else{
        _wisdomAddListLucencyView.hidden = NO;
        
        _wisdomAddBCountuyView.hidden = NO;
        
        [_wisdomAddBCountuyView setWisdomAddBCountuy:_dataResult[indexPath.row] indexpath:indexPath];
    }
}

-(void)tapRightSwipe{
    [self hiddenFilterView];
    bgView.hidden = YES;
}

-(void)topSelect{
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:NO];
    _wisdomAddListBgView.hidden = NO;
}
//筛选
#pragma mark STStorewideBtnViewDelegate
-(void)g_setWisdomAddListBtnTag:(NSInteger)tag andSelected:(BOOL)isSelected{
    pageIndex = 1;
    switch (tag) {
        case 0:
            if (isSelected) {
                sortStr = @"1";
            }else{
                sortStr = @"2";
            }
            break;
        case 1:
            if (isSelected) {
                sortStr = @"3";
            }else{
                sortStr = @"4";
            }
            break;
        case 2:
            if (isSelected) {
                sortStr = @"5";
            }else{
                sortStr = @"6";
            }
            break;
        case 3:
            [self showFilterView];
            bgView.hidden = NO;
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    
    if (tag == 1 || tag == 2 || tag == 0) {
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [_paramsDict setObject:sortStr forKey:@"sort"];
        [self.tableView.mj_header beginRefreshing];
    }
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
}
//搜索
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _wisdomAddListNavView.searchTextField.text = @"";
    [_searchstorewideResult removeAllObjects];
    [_searchTableView reloadData];
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_wisdomAddListNavView.searchTextField resignFirstResponder];
    pageIndex = 1;
    [_paramsDict setObject:@"1" forKey:@"pageIndex"];
    [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_wisdomAddListNavView.searchTextField.text oldStr:_wisdomAddListNavView.searchTextField.text] forKey:@"StorekeyWords"];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        [UIView animateWithDuration:.2 animations:^{
            _wisdomAddListBtnView.frame = CGRectMake(0, 34, kScreenWidth, 30);
        }];
    }else{
        [UIView animateWithDuration:.2 animations:^{
            _wisdomAddListBtnView.frame = CGRectMake(0, 64,kScreenWidth, 30);
        }];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:.2 animations:^{
        _wisdomAddListBtnView.frame = CGRectMake(0, 64, kScreenWidth, 30);
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 100) {
        _topBtn.hidden = YES;
    }else{
        _topBtn.hidden = NO;
    }
    if (scrollView != _searchTableView) {
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }
    [_wisdomAddListNavView.searchTextField resignFirstResponder];
}
//筛选条件
-(void)wisdomAddListeProducttypeMothed:(NSNotification *)sender{
    bgView.hidden = YES;
    pageIndex = 1;
    [_paramsDict setObject:[sender.userInfo objectForKey:@"producttype"] forKey:@"producttype"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"cuxiao"] forKey:@"cuxiao"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"GrossMarginRange"] forKey:@"GrossMarginRange"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"PriceRange"] forKey:@"PriceRange"];
    [_paramsDict setObject:@"1" forKey:@"pageIndex"];
    [self.tableView.mj_header beginRefreshing];
    [self hiddenFilterView];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wisdomAddListeProducttype" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)showFilterView{
        [UIView animateWithDuration:0.3 animations:^{
            _wisdomAddListBgView.frame  = CGRectMake(-(kScreenWidth - 100), 0, kScreenWidth, kScreenHeight);
        }];

}
-(void)hiddenFilterView{
    [UIView animateWithDuration:0.3 animations:^{
        _wisdomAddListBgView.frame  = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

@end
