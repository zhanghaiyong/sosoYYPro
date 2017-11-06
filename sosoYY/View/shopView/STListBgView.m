//
//  STListBgView.m
//  my
//
//  Created by soso-mac on 2016/11/21.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STListBgView.h"
#import "STListBtnView.h"
#import "STListShopBtnView.h"
#import "STListTableViewCell.h"
#import "STShopListTableViewCell.h"
#import "STListNavView.h"
#import "STStoreTableViewCell.h"
#import "KSMNetworkRequest.h"
#import "STProductSearchCell.h"


@interface STListBgView ()<STListBtnViewDelegate,STListShopBtnViewDelegate,STListNavViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray *listTitles;
    __block BOOL isShop;
    __block   BOOL isListShop;
    float lastContentOffset;
    NSString *sortStr;
    __block  NSInteger pageCount;
    __block NSInteger pageIndex;
    __block NSInteger shopPageCount;
    __block NSInteger shopPageIndex;
    BOOL isSynthesize;
    __block BOOL isSelect;
    UIView *bgView;
    __block BOOL isUp;
    UILabel *_lab;
    __block BOOL isOK;
}

@property(strong,nonatomic)STListNavView *navView;
@property(strong,nonatomic)STListBtnView *btnView;
@property(strong,nonatomic)STListShopBtnView *shopBtnView;
@property(strong,nonatomic)UITableView *synthesizeTableView;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITableView *shopTableView;
@property(strong,nonatomic)UITableView *listTableView;
@property(strong,nonatomic)UITableView *searchTableView;
@property(strong,nonatomic)NSMutableArray *dataResult;
@property(strong,nonatomic)NSMutableArray *shopDataResult;
@property(strong,nonatomic)NSMutableArray *searchProductResult;
@property(strong,nonatomic)NSMutableDictionary *paramsDict;
@property(strong,nonatomic)NSMutableDictionary *shoppParamsDict;
@property(strong,nonatomic)UIButton *topBtn;
@property(strong,nonatomic)NSArray *synthesizeTitles;
@property(assign,nonatomic)CGFloat offsetY;
@property(assign,nonatomic)CGFloat contentSizeY;
@end
@implementation STListBgView

-(instancetype)initWithFrame:(CGRect)frame  typeDict:(NSDictionary *)typeDict{
    self = [super initWithFrame:frame];
    if (self) {
        isListShop = YES;
        isSynthesize = YES;
        isOK = NO;
        isSelect = YES;
        self.userInteractionEnabled = YES;
        _dataResult = [NSMutableArray new];
        _paramsDict = [NSMutableDictionary new];
        _searchProductResult = [NSMutableArray new];
        _shopDataResult = [NSMutableArray new];
        _shoppParamsDict = [NSMutableDictionary new];
        pageIndex = 1;
        shopPageIndex = 1;
        
        isShop = [typeDict[@"isShop"] intValue];
        
        [self addSubView];
        _navView.searchTextField.delegate = self;
        _navView.searchTextField.text = typeDict[@"keyWork"];
        
        if (!isShop) {//商品
            [_navView.shopBtn setTitle:@"商品" forState:UIControlStateNormal];
            [_paramsDict setObject:typeDict[@"typeStr"] forKey:@"Tag_PharmAttribute_fullPath"];
            [_paramsDict setObject:@"0" forKey:@"producttype"];
            [_paramsDict setObject:@"0" forKey:@"cuxiao"];
            
            [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_navView.searchTextField.text oldStr:_navView.searchTextField.text] forKey:@"keyWords"];
            if ([typeDict[@"selected"] isEqualToString:@"T"]) {
                [_paramsDict setObject:@"2" forKey:@"producttype"];
            }else if ([typeDict[@"selected"] isEqualToString:@"J"]){
                [_paramsDict setObject:@"1" forKey:@"cuxiao"];
            }else if ([typeDict[@"selected"] isEqualToString:@"C"]){
                [_paramsDict setObject:@"3" forKey:@"cuxiao"];
            }else if ([typeDict[@"selected"] isEqualToString:@""]){
                [_paramsDict setObject:@"0" forKey:@"producttype"];
                [_paramsDict setObject:@"0" forKey:@"cuxiao"];
            }else if ([typeDict[@"selected"] isEqualToString:@"P"]){
                [_paramsDict setObject:@"1" forKey:@"producttype"];
            }else if ([typeDict[@"selected"] isEqualToString:@"Y"]){
                [_paramsDict setObject:@"2" forKey:@"cuxiao"];
            }
            
            [_paramsDict setObject:@"0" forKey:@"GrossMarginRange"];
            [_paramsDict setObject:@"0" forKey:@"PriceRange"];
            [_paramsDict setObject:@"default" forKey:@"sort"];
            [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        }else{//店铺
            _navView.searchTextField.placeholder = @"请输入店铺名称";
            [_navView.shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
            [_shoppParamsDict setObject:@"1" forKey:@"pageIndex"];
            [_shoppParamsDict setObject:@"0" forKey:@"sortwhere"];
            [_shoppParamsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_navView.searchTextField.text oldStr:_navView.searchTextField.text] forKey:@"keyWords"];
        }
        
        __weak STListBgView *weakSelf = self;
        
        self.tableView.mj_header.automaticallyChangeAlpha = YES;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (!isShop) {
                isOK = NO;
                pageIndex = 1;
                [weakSelf.paramsDict setObject:@"1" forKey:@"pageIndex"];
                [weakSelf httpDownloadParams:weakSelf.paramsDict];
            }else{
                isOK = NO;
                shopPageIndex = 1;
                [weakSelf.shoppParamsDict setObject:@"1" forKey:@"pageIndex"];
                [weakSelf httpDownloadShopParams:weakSelf.shoppParamsDict];
            }
        }];
        self.tableView.mj_footer.automaticallyChangeAlpha = YES;
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (!isShop) {
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
            }else{
                if (shopPageIndex < shopPageCount) {
                    shopPageIndex ++;
                    isOK = NO;
                    [_shoppParamsDict setObject:[NSString stringWithFormat:@"%ld",(long)shopPageIndex] forKey:@"pageIndex"];
                    [weakSelf httpDownloadShopParams:weakSelf.shoppParamsDict];
                }else{
                    [ZHProgressHUD showInfoWithText:@"暂无更多数据"];
                    [weakSelf.shopTableView.mj_header endRefreshing];
                    [weakSelf.shopTableView.mj_footer endRefreshing];
                }
            }
        }];
        
        self.shopTableView.mj_header.automaticallyChangeAlpha = YES;
        self.shopTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (!isShop) {
                pageIndex = 1;
                isOK = NO;
                [weakSelf.paramsDict setObject:@"1" forKey:@"pageIndex"];
                [weakSelf httpDownloadParams:weakSelf.paramsDict];
            }else{
                shopPageIndex = 1;
                isOK = NO;
                [weakSelf.shoppParamsDict setObject:@"1" forKey:@"pageIndex"];
                [weakSelf httpDownloadShopParams:weakSelf.shoppParamsDict];
            }
        }];
        self.shopTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (!isShop) {
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
            }else{
                if (shopPageIndex < shopPageCount) {
                    shopPageIndex ++;
                    isOK = NO;
                    [_shoppParamsDict setObject:[NSString stringWithFormat:@"%ld",(long)shopPageIndex] forKey:@"pageIndex"];
                    [weakSelf httpDownloadShopParams:weakSelf.shoppParamsDict];
                }else{
                    [ZHProgressHUD showInfoWithText:@"暂无更多数据"];
                    [weakSelf.shopTableView.mj_header endRefreshing];
                    [weakSelf.shopTableView.mj_footer endRefreshing];
                }
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(producttypeMothed:)
                                                     name:@"producttype"
                                                   object:nil];
    }
    return self;
}
-(void)viewWillAppear{
    if (!isShop) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.shopTableView.mj_header beginRefreshing];
    }
}
-(void)listTextFieldResignFirstResponder{
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 0);
        isListShop = YES;
    }];
    [UIView animateWithDuration:.2 animations:^{
        _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
        isSynthesize = YES;
    }];
    
    [_navView.searchTextField resignFirstResponder];
}
#pragma mark -- 商品列表数据

-(void)httpDownloadParams:(NSMutableDictionary *)params{
    __weak STListBgView *weakSelf = self;
//    if (isUp) {
     [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
//    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getProductListUrl:[NSString stringWithFormat:@"%@",requestProductListDetail]
                                      params:params finshed:^(id dataResult, STProductListEntity *entity, NSError *error) {
                                          pageCount = entity.pageCount;
                                          if (pageIndex == 1 || pageIndex == 0) {
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
                                              [weakSelf setchangBtnView];
                                              [weakSelf.tableView.mj_header endRefreshing];
                                              [weakSelf.tableView.mj_footer endRefreshing];
                                              [[UIApplication sharedApplication].keyWindow hideToastActivity];
                                              isUp = YES;
                                          });
                                      }];
        isOK = YES;
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

#pragma mark -- 店铺列表数据
-(void)httpDownloadShopParams:(NSMutableDictionary *)params{
    __weak STListBgView *weakSelf = self;
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getShopListUrl:requestStoreListResult
                                   params:params finshed:^(id dataResult, STShopListEntity *entity, NSError *error) {
                                       shopPageCount = entity.pageCount;
                                       if (shopPageIndex == 1 || shopPageIndex == 0) {
                                           weakSelf.shopDataResult = dataResult;
                                           if (weakSelf.shopDataResult.count == 0) {
                                               [ZHProgressHUD showInfoWithText:@"暂无更多数据"];
                                               _lab.hidden = NO;
                                           }else{
                                               _lab.hidden = YES;
                                           }
                                       }else{
                                           [weakSelf.shopDataResult addObjectsFromArray:dataResult];
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [weakSelf.shopTableView reloadData];
                                           [weakSelf setchangBtnView];
                                           [weakSelf.shopTableView.mj_header endRefreshing];
                                           [weakSelf.shopTableView.mj_footer endRefreshing];
                                           [[UIApplication sharedApplication].keyWindow hideToastActivity];
                                       });
                                   }];
        isOK = YES;
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

#pragma mark -- 商品搜索数据
-(void)httpDownProductLoadAssociate:(NSString *)text{
    __weak STListBgView *weakSelf = self;
    [KSMNetworkRequest getProductAssociateUrl:requestProductSearch text:text finshed:^(id dataResult, NSError *error) {
        weakSelf.searchProductResult = dataResult;
        if (isSelect) {
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
        }
    }];
    isSelect = YES;
}

#pragma mark -- 店铺搜索数据
-(void)httpDownLoadShopAssociate:(NSString *)text{
    __weak STListBgView *weakSelf = self;
    [KSMNetworkRequest getShopAssociateUrl:requestStoreSearch text:text finshed:^(id dataResult, NSError *error) {
        weakSelf.searchProductResult = dataResult;
        if (isSelect) {
            if (weakSelf.searchProductResult.count > 6) {
                [UIView animateWithDuration:.2 animations:^{
                    weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 180);
                }];
            }else{
                weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, weakSelf.searchProductResult.count * 30);
                
            }
            [weakSelf.searchTableView reloadData];
        }
    }];
    isSelect = YES;
}
-(void)addSubView{
    
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    
    _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height - 64)style:UITableViewStylePlain];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    _shopTableView.estimatedRowHeight = 300;
    _shopTableView.rowHeight = UITableViewAutomaticDimension;
    [_shopTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _shopTableView.tableHeaderView = headView;
    [self addSubview:_shopTableView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.frame.size.height - 64)style:UITableViewStylePlain];
    _tableView.userInteractionEnabled = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.tableHeaderView = headView;
    [self addSubview:_tableView];
    
    
    _btnView = [[STListBtnView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, 30)];
    _btnView.delegate = self;
    [self addSubview:_btnView];
    
    _shopBtnView = [[STListShopBtnView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, 30)];
    _shopBtnView.delegate = self;
    [self addSubview:_shopBtnView];
    
    _synthesizeTitles = @[@"综合",@"人气"];
    _synthesizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth/4, 0)style:UITableViewStylePlain];
    _synthesizeTableView.delegate = self;
    _synthesizeTableView.dataSource = self;
    _synthesizeTableView.rowHeight = 30;
    [_synthesizeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_synthesizeTableView];
    
    
    if (!isShop) {
        _shopBtnView.hidden = YES;
        _shopTableView.hidden = YES;
        _btnView.hidden = NO;
        _tableView.hidden = NO;
    }else{
        _shopBtnView.hidden = NO;
        _shopTableView.hidden = NO;
        _btnView.hidden = YES;
        _tableView.hidden = YES;
    }
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"STListNavView" owner:self options:nil];
    _navView = [nib objectAtIndex:0];
    _navView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
    [_navView setSearchTextField];
    _navView.delegate = self;
    [self addSubview:_navView];
    
    
    listTitles = @[@"商品",@"店铺"];
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 60, 60, 0)style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.scrollEnabled = NO;
    _listTableView.layer.masksToBounds = YES;
    _listTableView.layer.cornerRadius = 5.0f;
    _listTableView.rowHeight = 30;
    _listTableView.backgroundColor = [UIColor fromHexValue:0xe6e6e6 alpha:1];
    [_listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_listTableView];
    
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
    
    //    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(handleSwipe:)];
    //    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    //    [bgView addGestureRecognizer:recognizer];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(tapRightSwipe)];
    [bgView addGestureRecognizer:tap];
    
    
    //    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(LeftHandleSwipe:)];
    //    left.direction = UISwipeGestureRecognizerDirectionLeft;
    //    [_tableView addGestureRecognizer:left];
    
    _topBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _topBtn.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 80, 40, 40);
    _topBtn.hidden = YES;
    [_topBtn addTarget:self action:@selector(topSelect) forControlEvents:UIControlEventTouchUpInside];
    [_topBtn setBackgroundImage:[UIImage imageNamed:@"topA"] forState:UIControlStateNormal];
    [self addSubview:_topBtn];
    
    
    _lab = [UILabel new];
    _lab.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, 30);
    _lab.text = @"暂无数据";
    _lab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.hidden = YES;
    [self addSubview:_lab];
}
#pragma mark --  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _listTableView) {
        return listTitles.count;
    }else if (tableView == _searchTableView){
        return _searchProductResult.count;
    }else if (tableView == _tableView){
        return _dataResult.count;
    }else if (tableView == _shopTableView){
        return _shopDataResult.count;
    }else if (tableView == _synthesizeTableView){
        return _synthesizeTitles.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _listTableView) {
        static NSString *ShopName = @"ShopName";
        STShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopListTableViewCell" owner:self options:nil]lastObject];
        }
        [cell setShopList:listTitles indexPath:indexPath type:0];
        return cell;
    }else if(tableView == _searchTableView){
        static NSString *SearchName = @"SearchName";
        STProductSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STProductSearchCell" owner:self options:nil]lastObject];
        }
        if (_searchProductResult.count != 0) {
            [cell setProductSearch:_searchProductResult indexPath:indexPath];
        }
        return cell;
    }else if (tableView == _synthesizeTableView){
        static NSString *ShopName = @"ShopName";
        STShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopListTableViewCell" owner:self options:nil]lastObject];
        }
        [cell setShopList:_synthesizeTitles indexPath:indexPath type:1];
        return cell;
    }else if(tableView == _tableView){
        static NSString *ListName = @"ListName";
        STListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STListTableViewCell" owner:self options:nil]lastObject];
        }
        if (_dataResult.count != 0) {
            [cell setProduceDataResult:_dataResult andIndexPath:indexPath];
        }
        return cell;
    }else if (tableView == _shopTableView){
        static NSString *StoreName = @"StoreName";
        STStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STStoreTableViewCell" owner:self options:nil]lastObject];
        }
        if (_shopDataResult.count != 0) {
            [cell setStoreDataResult:_shopDataResult andIndexPath:indexPath];
        }
        return cell;
    }
    return nil;
}

#pragma mark --  UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _listTableView) {
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
            isListShop = YES;
        }];
        [_navView setChaneShopBtnTitle:listTitles[indexPath.row]];
        if (indexPath.row == 0) {
            isShop = NO;
        }else{
            isShop = YES;
        }
    }else if(tableView == _searchTableView){
        isSelect = NO;
        STProductSearchCell *cell = (STProductSearchCell *)[_searchTableView cellForRowAtIndexPath:indexPath];
        _navView.searchTextField.text = cell.nameLab.text;
        if (!isShop) {
            _shopBtnView.hidden = YES;
            _shopTableView.hidden = YES;
            _btnView.hidden = NO;
            _tableView.hidden = NO;
            pageIndex = 1;
            [_paramsDict setObject:@"1" forKey:@"pageIndex"];
            [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:cell.nameLab.text oldStr:cell.nameLab.text] forKey:@"keyWords"];
            [self.tableView.mj_header beginRefreshing];
        }else{
            _shopBtnView.hidden = NO;
            _shopTableView.hidden = NO;
            _tableView.hidden = YES;
            _btnView.hidden = YES;
            shopPageIndex = 1;
            [_shoppParamsDict setObject:@"1" forKey:@"pageIndex"];
            [_shoppParamsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:cell.nameLab.text oldStr:cell.nameLab.text] forKey:@"keyWords"];
            [self.shopTableView.mj_header beginRefreshing];
        }
        
        [_navView.searchTextField resignFirstResponder];
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
            isListShop = YES;
        }];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }else if (tableView == _synthesizeTableView){
        STShopListTableViewCell *cell = (STShopListTableViewCell *)[_synthesizeTableView cellForRowAtIndexPath:indexPath];
        [_btnView setsynthesizeBtnTitle:cell.titleLab.text];
        
        if (indexPath.row == 0) {
            sortStr = @"default";
        }else{
            sortStr = @"10";
        }
        pageIndex = 1;
        [_paramsDict setObject:sortStr forKey:@"sort"];
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [self.tableView.mj_header beginRefreshing];
        [UIView animateWithDuration:.2 animations:^{
            _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
            isSynthesize = YES;
        }];
    }else if (tableView == _tableView){
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[_dataResult[indexPath.row] goods_Package_ID],@"goods_Package_ID",@"1",@"isShop",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Details" object:nil userInfo:dict];
        
        [_navView.searchTextField resignFirstResponder];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
            isListShop = YES;
        }];
    }else if (tableView == _shopTableView){
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[_shopDataResult[indexPath.row] storeId],@"storeid",@"3",@"isShop",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Details" object:nil userInfo:dict];
        [_navView.searchTextField resignFirstResponder];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
            isListShop = YES;
        }];
    }
}
#pragma mark --  STListBtnViewDelegate
//商品筛选
-(void)g_setSelectBtnTag:(NSInteger)tag andSelected:(BOOL)isSelected{
    pageIndex = 1;
    switch (tag) {
        case 0:{
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
        }
        case 1:{
            if (isSelected) {
                sortStr = @"3";
            }else{
                sortStr = @"4";
            }
            [UIView animateWithDuration:.2 animations:^{
                _listTableView.frame = CGRectMake(50, 60, 80, 0);
                isListShop = YES;
            }];
            break;
        }
        case 2:{
            if (isSelected) {
                sortStr = @"5";
            }else{
                sortStr = @"6";
            }
            [UIView animateWithDuration:.2 animations:^{
                _listTableView.frame = CGRectMake(50, 60, 80, 0);
                isListShop = YES;
            }];
            break;
        }
        case 3:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showListFilterView" object:nil];
            bgView.hidden = NO;
            [UIView animateWithDuration:.2 animations:^{
                _listTableView.frame = CGRectMake(50, 60, 80, 0);
                isListShop = YES;
            }];
            break;
        }
        default:
            break;
    }
    if (tag == 1 || tag == 2) {
        [_paramsDict setObject:sortStr forKey:@"sort"];
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
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
//筛选条件
-(void)producttypeMothed:(NSNotification *)sender{
    bgView.hidden = YES;
    pageIndex = 1;
    [_paramsDict setObject:[sender.userInfo objectForKey:@"producttype"] forKey:@"producttype"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"cuxiao"] forKey:@"cuxiao"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"GrossMarginRange"] forKey:@"GrossMarginRange"];
    [_paramsDict setObject:[sender.userInfo objectForKey:@"PriceRange"] forKey:@"PriceRange"];
    [_paramsDict setObject:@"1" forKey:@"pageIndex"];
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark --  STListShopBtnViewDelegate
//店铺筛选
-(void)g_setSelectShopBtnTag:(NSInteger)tag{
    shopPageIndex = 1;
    switch (tag) {
        case 0:
            [_shoppParamsDict setObject:@"0" forKey:@"sortwhere"]; //综合
            break;
        case 1:
            [_shoppParamsDict setObject:@"2" forKey:@"sortwhere"]; //最新
            
            break;
        case 2:
            [_shoppParamsDict setObject:@"3" forKey:@"sortwhere"]; //免邮
            break;
        case 3:
            #warning 需要调整
            [_shoppParamsDict setObject:@"1" forKey:@"sortwhere"]; //白条支付
            break;
        default:
            break;
    }
    
    [_shoppParamsDict setObject:@"1" forKey:@"pageIndex"];
    [self.shopTableView.mj_header beginRefreshing];
}

#pragma mark --  STListNavViewDelegate
-(void)g_setListShopHidden{
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    if (isListShop) {
        isListShop = NO;
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 65);
        }];
    }else{
        isListShop = YES;
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
        }];
    }
}
//搜索
-(void)g_setSearchSelectedText:(NSString *)text{
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 0);
        isListShop = YES;
    }];
    
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    
    if (!isShop) {
        _shopBtnView.hidden = YES;
        _shopTableView.hidden = YES;
        _btnView.hidden = NO;
        _tableView.hidden = NO;
        pageIndex = 1;
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"keyWords"];
        [self.tableView.mj_header beginRefreshing];
    }else{
        _shopBtnView.hidden = NO;
        _shopTableView.hidden = NO;
        _btnView.hidden = YES;
        _tableView.hidden = YES;
        shopPageIndex = 1;
        [_shoppParamsDict setObject:@"1" forKey:@"pageIndex"];
        [_shoppParamsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"keyWords"];
        [self.shopTableView.mj_header beginRefreshing];
    }
}

-(void)g_setSearchAssociateText:(NSString *)text{
    [_searchProductResult removeAllObjects];
    if (![text isEqualToString:@""]) {
        if (!isShop) {
            [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"keyWords"];
            [self httpDownProductLoadAssociate:text];
        }else{
            [_shoppParamsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:text oldStr:text] forKey:@"keyWords"];
            [self httpDownLoadShopAssociate:text];
        }
    }else{
        [_searchTableView reloadData];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _navView.searchTextField.text = @"";
    if (!isShop) {
        [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_navView.searchTextField.text oldStr:_navView.searchTextField.text] forKey:@"keyWords"];
    }else{
        [_shoppParamsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_navView.searchTextField.text oldStr:_navView.searchTextField.text] forKey:@"keyWords"];
    }
    [_searchProductResult removeAllObjects];
    [_searchTableView reloadData];
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_navView.searchTextField resignFirstResponder];
    if (!isShop) {
        pageIndex = 1;
        [_paramsDict setObject:@"1" forKey:@"pageIndex"];
        [_paramsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_navView.searchTextField.text oldStr:_navView.searchTextField.text] forKey:@"keyWords"];
        [self.tableView.mj_header beginRefreshing];
    }else{
        shopPageIndex = 1;
        [_shoppParamsDict setObject:@"1" forKey:@"pageIndex"];
        [_shoppParamsDict setObject:[[STCommon sharedSTSTCommon] setchengStr:_navView.searchTextField.text oldStr:_navView.searchTextField.text] forKey:@"keyWords"];
        [self.shopTableView.mj_header beginRefreshing];
    }
    return YES;
}
-(void)g_setSearchFieldDidBeginEditing{
    isListShop = YES;
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 0);
    }];
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenListFilterView" object:nil];
    bgView.hidden = YES;
}
-(void)tapRightSwipe{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenListFilterView" object:nil];
    bgView.hidden = YES;
}
-(void)LeftHandleSwipe:(UISwipeGestureRecognizer *)recognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showListFilterView" object:nil];
    bgView.hidden = NO;
}
-(void)setchangBtnView{
    if (!isShop) {
        _shopBtnView.hidden = YES;
        _shopTableView.hidden = YES;
        _btnView.hidden = NO;
        _tableView.hidden = NO;
    }else{
        _shopBtnView.hidden = NO;
        _shopTableView.hidden = NO;
        _btnView.hidden = YES;
        _tableView.hidden = YES;
    }
}
-(void)topSelect{
    //         [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    //        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    if (!self.tableView.hidden) {
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.shopTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
#pragma mark --  UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 0);
        isListShop = YES;
    }];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        [UIView animateWithDuration:.2 animations:^{
            _btnView.frame = CGRectMake(0, 34, self.frame.size.width, 30);
            _shopBtnView.frame = CGRectMake(0, 34, self.frame.size.width, 30);
        }];
    }else{
        [UIView animateWithDuration:.2 animations:^{
            _btnView.frame = CGRectMake(0, 64, self.frame.size.width, 30);
            _shopBtnView.frame = CGRectMake(0, 64, self.frame.size.width, 30);
        }];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:.2 animations:^{
        _btnView.frame = CGRectMake(0, 64, self.frame.size.width, 30);
        _shopBtnView.frame = CGRectMake(0, 64, self.frame.size.width, 30);
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
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
            isListShop = YES;
        }];
        [UIView animateWithDuration:.2 animations:^{
            _synthesizeTableView.frame = CGRectMake(0, 94, kScreenWidth/4, 0);
            isSynthesize = YES;
        }];
    }
    [_navView.searchTextField resignFirstResponder];
    
    
//#pragma mark -- 预加载
//    self.contentSizeY = scrollView.contentSize.height - self.tableView.frame.size.height * 2;
//    if (scrollView.contentOffset.y > self.offsetY && scrollView.contentOffset.y > 0) {//向上滑动
//        
//        if (self.offsetY >= self.contentSizeY) {//self.offsetY == scrollView.contentSize.height - self.tableView.frame.size.height为最底部
//            if (pageIndex < pageCount) {
//                if (isUp) {
//                    isUp = NO;
//                    pageIndex ++;
//                    [self.paramsDict setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"pageIndex"];
//                    [self httpDownloadParams:self.paramsDict];
//                }
//            }else{
//                [ZHProgressHUD showInfoWithText:@"暂无更多数据"];
//            }
//        }
//    }else if (scrollView.contentOffset.y < self.offsetY ){//向下滑动
//        
//    };
//    self.offsetY = scrollView.contentOffset.y;//将当前位移变成缓存位移
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"producttype" object:nil];
}


@end
