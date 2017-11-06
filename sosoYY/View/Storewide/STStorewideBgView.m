//
//  STStorewideBgView.m
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideBgView.h"
#import "STStorewideBtnView.h"
#import "STStorewideBgTableViewCell.h"
#import "STStorewideNavView.h"
#import "STProductSearchCell.h"
#import "STShopListTableViewCell.h"

@interface STStorewideBgView ()<STStorewideBtnViewDelegate,UITableViewDelegate,UITableViewDataSource,STStorewideNavViewDelegate,UITextFieldDelegate>{
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
@property(strong,nonatomic)STStorewideBtnView *storewideBtnView;
@property(strong,nonatomic)UIView *headerView;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataResult;
@property(strong,nonatomic)NSMutableDictionary *paramsDict;
@property(strong,nonatomic)STStorewideNavView *storewideNavView;
@property(strong,nonatomic)UITableView *searchTableView;
@property(strong,nonatomic)NSMutableArray *searchstorewideResult;
@property(strong,nonatomic)UIButton *topBtn;
@property(strong,nonatomic)NSMutableDictionary *searchDict;
@property(strong,nonatomic)UITableView *synthesizeTableView;
@property(strong,nonatomic)NSArray *synthesizeTitles;
@property(strong,nonatomic)NSString *storeid;

@end

@implementation STStorewideBgView
-(instancetype)initWithFrame:(CGRect)frame typeDict:(NSDictionary *)typeDict{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _storeid = typeDict[@"storeid"];
        
        isOK = NO;
        pageIndex = 1;
        isSelect = YES;
        isSynthesize = YES;
        self.userInteractionEnabled = YES;
        _dataResult = [NSMutableArray new];
        _paramsDict = [NSMutableDictionary new];
        _searchstorewideResult = [NSMutableArray new];
        _searchDict = [NSMutableDictionary new];
        
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, self.frame.size.width, 30);
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height - 64)style:UITableViewStylePlain];
        _tableView.userInteractionEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 300;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableHeaderView = _headerView;
        [self addSubview:_tableView];
        
        
        _storewideBtnView = [[STStorewideBtnView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, 30)];
        _storewideBtnView.delegate = self;
        [self addSubview:_storewideBtnView];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"STStorewideNavView" owner:self options:nil];
        _storewideNavView = [nib objectAtIndex:0];
        _storewideNavView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
        [_storewideNavView setSearchTextField];
        _storewideNavView.delegate = self;
        [self addSubview:_storewideNavView];
        
        _synthesizeTitles = @[@"综合",@"人气"];
        _synthesizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth/4, 0)style:UITableViewStylePlain];
        _synthesizeTableView.delegate = self;
        _synthesizeTableView.dataSource = self;
        _synthesizeTableView.rowHeight = 30;
        [_synthesizeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_synthesizeTableView];
        
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 60, kScreenWidth - 100, 0)style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.layer.masksToBounds = YES;
        _searchTableView.layer.cornerRadius = 5.0f;
        _searchTableView.rowHeight = 30;
        [_searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_searchTableView];
        
        bgView = [UIView new];
        bgView.userInteractionEnabled = YES;
        bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        bgView.backgroundColor = [UIColor clearColor];
        bgView.hidden = YES;
        [self addSubview:bgView];
        
//        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(handleSwipe:)];
//        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
//        [bgView addGestureRecognizer:recognizer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(tapRightSwipe)];
        [bgView addGestureRecognizer:tap];
        
        
//        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(handleSwipeLeft:)];
//        left.direction = UISwipeGestureRecognizerDirectionLeft;
//        [_tableView addGestureRecognizer:left];
        
        
        _topBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _topBtn.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 80, 40, 40);
        _topBtn.hidden = YES;
        [_topBtn addTarget:self action:@selector(topSelect) forControlEvents:UIControlEventTouchUpInside];
        [_topBtn setBackgroundImage:[UIImage imageNamed:@"topA"] forState:UIControlStateNormal];
        [self addSubview:_topBtn];
        
        _storewideNavView.searchTextField.text = typeDict[@"StorekeyWords"];
        _storewideNavView.searchTextField.delegate = self;
        
        
        
        [_paramsDict setObject:typeDict[@"CateId"] forKey:@"CateId"];
        [_paramsDict setObject:typeDict[@"storeid"] forKey:@"storeid"];
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [_paramsDict setObject:typeDict[@"storecateid"] forKey:@"storecateid"];
        [_paramsDict setObject:typeDict[@"sort"] forKey:@"sort"];
         [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_storewideNavView.searchTextField.text oldStr:_storewideNavView.searchTextField.text] forKey:@"StorekeyWords"];
         [_paramsDict setObject:typeDict[@"IsBest"] forKey:@"IsBest"];
        [_paramsDict setObject:@"0"forKey:@"producttype"];
        [_paramsDict setObject:@"0"forKey:@"cuxiao"];
        [_paramsDict setObject:@"" forKey:@"GrossMarginRange"];
        [_paramsDict setObject:@""forKey:@"PriceRange"];
        if ([typeDict[@"sort"] integerValue] == 10) {
         [_storewideBtnView setsynthesizeBtnTitle:@"人气"];
        }else{
         [_storewideBtnView setsynthesizeBtnTitle:@"综合"];
        }
        
        __weak STStorewideBgView *weakSelf = self;
 
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
                pageIndex ++;
                isOK = NO;
                [weakSelf.paramsDict setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageIndex"];
                [weakSelf httpDownloadParams:weakSelf.paramsDict];
            }else{
                 [ZHProgressHUD showInfoWithText:@"暂无更多数据"];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storewideProducttypeMothed:)
                                                     name:@"storewideProducttype"
                                                   object:nil];
        [_searchDict setObject:typeDict[@"storeid"] forKey:@"storeid"];
        
        _lab = [UILabel new];
        _lab.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, 30);
        _lab.text = @"暂无数据";
        _lab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.hidden = YES;
        [self addSubview:_lab];
    }
    return self;
}
-(void)viewWillAppear{
  [self.tableView.mj_header beginRefreshing];
}
-(void)storewideTextFieldResignFirstResponder{
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    [UIView animateWithDuration:.2 animations:^{
        _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
        isSynthesize = YES;
    }];
    
    [_storewideNavView.searchTextField resignFirstResponder];
}
#pragma mark -- 店铺内商品列表
-(void)httpDownloadParams:(NSMutableDictionary *)params{
//    [params setObject:[params[@"keyWords"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"keyWords"];
     __weak STStorewideBgView *weakSelf = self;
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getStorewideListUrl:requestInStoreSearchProduct params:params finshed:^(id dataResult, STStorewideEntity *entity, NSError *error) {
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

#pragma mark -- 店铺内商品联想搜索
-(void)httpDownStorewideLoadAssociate:(NSString *)text{
    __weak STStorewideBgView *weakSelf = self;
    [_searchDict setObject:text forKey:@"q"];
//    [_searchDict setObject:_storeid forKey:@"storeid"];
    
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

#pragma mark --  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _searchTableView) {
        return _searchstorewideResult.count;
    }else if (tableView == _synthesizeTableView){
        return _synthesizeTitles.count;
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
        STStorewideBgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StorewideBgName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STStorewideBgTableViewCell" owner:self options:nil]lastObject];
        }
        if (_dataResult.count != 0) {
            [cell setStoreBgDataResult:_dataResult andIndexPath:indexPath];
        }
        return cell;
    }else if(tableView == _synthesizeTableView){
        static NSString *ShopName = @"ShopName";
        STShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopListTableViewCell" owner:self options:nil]lastObject];
        }
        [cell setShopList:_synthesizeTitles indexPath:indexPath type:1];
        return cell;
    }
    return nil;
}
#pragma mark --  UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _searchTableView) {
         isSelect = NO;
        STProductSearchCell *cell = (STProductSearchCell *)[_searchTableView cellForRowAtIndexPath:indexPath];
        _storewideNavView.searchTextField.text = cell.nameLab.text;
        
        pageIndex = 1;
        [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:cell.nameLab.text oldStr:cell.nameLab.text] forKey:@"StorekeyWords"];
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [self.tableView.mj_header beginRefreshing];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }else if(tableView == _tableView){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StorewideDetails" object:nil userInfo:@{@"pid":[_dataResult[indexPath.row] Pid]}];
    }else if (tableView == _synthesizeTableView){
        STShopListTableViewCell *cell = (STShopListTableViewCell *)[_synthesizeTableView cellForRowAtIndexPath:indexPath];
        [_storewideBtnView setsynthesizeBtnTitle:cell.titleLab.text];
        
        if (indexPath.row == 0) {
            sortStr = @"default";
        }else{
            sortStr = @"10";
        }
        pageIndex = 1;
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [_paramsDict setObject:sortStr forKey:@"sort"];
        [self.tableView.mj_header beginRefreshing];
        [UIView animateWithDuration:.2 animations:^{
            _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
            isSynthesize = YES;
        }];
    }
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenFilterView" object:nil];
    bgView.hidden = YES;
}
-(void)tapRightSwipe{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenFilterView" object:nil];
    bgView.hidden = YES;
}
-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"filterView" object:nil];
    bgView.hidden = NO;
}
-(void)topSelect{
    //     [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//        [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:NO];
    _storewideBtnView.hidden = NO;
}
//筛选
#pragma mark --  STStorewideBtnViewDelegate
-(void)g_setStorewideSelectBtnTag:(NSInteger)tag andSelected:(BOOL)isSelected{
     pageIndex = 1;
    switch (tag) {
        case 0:
            if (isSynthesize) {
                [UIView animateWithDuration:.2 animations:^{
                    _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 60);
                    isSynthesize = NO;
                }];
            }else{
                [UIView animateWithDuration:.2 animations:^{
                    _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
                    isSynthesize = YES;
                }];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"filterView" object:nil];
            bgView.hidden = NO;
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    
    if (tag == 1 || tag == 2) {
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [_paramsDict setObject:sortStr forKey:@"sort"];
       [self.tableView.mj_header beginRefreshing];
    }
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    
    if (tag != 0) {
        [UIView animateWithDuration:.2 animations:^{
            _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
            isSynthesize = YES;
        }];
    }

}
//搜索
#pragma mark --  STStorewideNavViewDelegate
-(void)g_setStorewideSearchText:(NSString *)text{
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    pageIndex = 1;
     [_paramsDict setObject:@"1" forKey:@"pageIndex"];
    [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"StorekeyWords"];
    [self.tableView.mj_header beginRefreshing];
}

-(void)g_setStorewideSearchAssociateText:(NSString *)text{
     [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"StorekeyWords"];
    [_searchstorewideResult removeAllObjects];
    if (![text isEqualToString:@""]) {
       [self httpDownStorewideLoadAssociate:text];
    }else{
        [_searchTableView reloadData];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _storewideNavView.searchTextField.text = @"";
    [_searchstorewideResult removeAllObjects];
    [_searchTableView reloadData];
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_storewideNavView.searchTextField resignFirstResponder];
    pageIndex = 1;
    [_paramsDict setObject:@"1" forKey:@"pageIndex"];
    [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_storewideNavView.searchTextField.text oldStr:_storewideNavView.searchTextField.text] forKey:@"StorekeyWords"];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

#pragma mark --  UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        [UIView animateWithDuration:.2 animations:^{
            _storewideBtnView.frame = CGRectMake(0, 34, self.frame.size.width, 30);
        }];
    }else{
        [UIView animateWithDuration:.2 animations:^{
            _storewideBtnView.frame = CGRectMake(0, 64, self.frame.size.width, 30);
        }];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:.2 animations:^{
        _storewideBtnView.frame = CGRectMake(0, 64, self.frame.size.width, 30);
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
            _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
            isSynthesize = YES;
        }];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }
    [_storewideNavView.searchTextField resignFirstResponder];
}
//筛选条件
-(void)storewideProducttypeMothed:(NSNotification *)sender{
    bgView.hidden = YES;
    pageIndex = 1;
    [_paramsDict setObject:[sender.userInfo objectForKey:@"producttype"] forKey:@"producttype"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"cuxiao"] forKey:@"cuxiao"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"GrossMarginRange"] forKey:@"GrossMarginRange"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"PriceRange"] forKey:@"PriceRange"];
    [_paramsDict setObject:@"1" forKey:@"pageIndex"];
    [self.tableView.mj_header beginRefreshing];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"storewideProducttype" object:nil];
}
@end
