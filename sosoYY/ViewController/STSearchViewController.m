//
//  STSearchViewController.m
//  my
//
//  Created by soso-mac on 2016/12/7.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STSearchViewController.h"
#import "STSearchTableViewCell.h"
#import "STSearchCollectionCell.h"
#import "STSearchHeaderView.h"
#import "STShopListTableViewCell.h"
#import "STSearchTabelHeaderView.h"
#import "STProductSearchCell.h"
#import "STListViewController.h"
#import "STProductDetailsViewController.h"
#import "STWisdomProcurementViewController.h"
#import "STArtificialPurchasingView.h"
#import "STSwitchStoreView.h"
#import <StoreKit/StoreKit.h>

#define kSreenHeight [UIScreen mainScreen].bounds.size.height
#define kSreenWidth [UIScreen mainScreen].bounds.size.width

@interface STSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,SKStoreProductViewControllerDelegate>{
    NSArray *listTitles;
    BOOL isShop;
    __block  BOOL isLoad;
    UILabel *_lab;
    __block BOOL isOK;
}
@property (weak, nonatomic) IBOutlet UIButton *listBtn;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITableView *listTableView;
@property(strong,nonatomic)UITableView *searchTableView;
@property(strong,nonatomic)UICollectionViewFlowLayout *searchFlowL;
@property (strong, nonatomic)UICollectionView *searchCollectionView;
@property (strong, nonatomic)STSearchHeaderView *searchHeaderView;
@property (strong, nonatomic)NSMutableArray *dataResult;
@property (strong, nonatomic)NSMutableDictionary *selectedDict;
@property (strong, nonatomic)NSMutableArray *searchData;
@property (strong, nonatomic)NSMutableArray *cateProducts;
@property(strong,nonatomic)UICollectionReusableView *footerView;
@property (strong, nonatomic)NSIndexPath *indexpath;
@property(strong,nonatomic)UITableView *mjTableView;

@end

@implementation STSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    isShop = NO;
    isOK = NO;
    _searchTextField.delegate = self;
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    listTitles = @[@"商品",@"店铺"];
    _dataResult = [NSMutableArray new];
    _searchData = [NSMutableArray new];
    _cateProducts = [NSMutableArray new];
    
    _selectedDict = [NSMutableDictionary new];
    [_selectedDict setObject:@"0" forKey:@"selected"];
    [_selectedDict setObject:@"0" forKey:@"Group"];
    isLoad = YES;
    
    _lab = [UILabel new];
    _lab.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, 30);
    _lab.text = @"暂无数据";
    _lab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.hidden = YES;
    [self.view addSubview:_lab];
    
    _mjTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSreenWidth, kSreenHeight - 64 - 49)style:UITableViewStylePlain];
    [_mjTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mjTableView];
    
    self.mjTableView.mj_header.automaticallyChangeAlpha = YES;
    self.mjTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isOK = NO;
        [self httpDownloadParams];
    }];
    
    //评论方法一
    //     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1135345334"]]];
    
    
    //评论方法二
    //    [self evaluate];
}
- (void)evaluate{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId
     @{SKStoreProductParameterITunesItemIdentifier : @"1135345334"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出AppStore应用界面
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}

//取消按钮监听方法
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)httpDownloadParams{
    __weak STSearchViewController *weakSelf = self;
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getSearchListUrl:requestCateList
                                     params:nil finshed:^(id dataResult, STCateListEntity *entity, NSError *error) {
                                         weakSelf.dataResult = dataResult;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (weakSelf.dataResult.count != 0) {
                                                 if ([[weakSelf.dataResult[0] GroupCateList] count] !=0) {
                                                     [self httpDownloadGetCateProductParams:@{@"cateId":[[weakSelf.dataResult[0] GroupCateList][0] CateId]} isYes:YES];
                                                     _lab.hidden = YES;
                                                 }else{
                                                     [[UIApplication sharedApplication].keyWindow hideToastActivity];
                                                     [self.mjTableView.mj_header endRefreshing];
                                                     _lab.hidden = NO;
                                                 }
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
            [self.mjTableView.mj_header endRefreshing];
        }
    }];
}
-(void)httpDownloadGetCateProductParams:(NSDictionary *)params isYes:(BOOL)isYes{
    if (!isYes) {
        [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    }
    __weak STSearchViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getSearchGetCateProductsUrl:requestCGetCateProducts
                                                params:params finshed:^(id dataResult, STCateListEntity *entity, NSError *error) {
                                                    isLoad = NO;
                                                    weakSelf.cateProducts = dataResult;
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (weakSelf.cateProducts.count != 0) {
                                                            if (isYes) {
                                                                [weakSelf addSubView];
                                                            }else{
                                                                [weakSelf.searchCollectionView reloadData];
                                                                [weakSelf.searchCollectionView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                                                                [self.mjTableView.mj_header endRefreshing];
                                                            }
                                                            [[UIApplication sharedApplication].keyWindow hideToastActivity];
                                                            [self.mjTableView.mj_header endRefreshing];
                                                        }
                                                    });
                                                }];
    });
}
-(void)httpDownProductLoadAssociate:(NSString *)text{
    __weak STSearchViewController *weakSelf = self;
    [KSMNetworkRequest getProductAssociateUrl:requestProductSearch text:text finshed:^(id dataResult, NSError *error) {
        weakSelf.searchData = dataResult;
        if (weakSelf.searchData.count > 6) {
            [UIView animateWithDuration:.2 animations:^{
                weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 264);
            }];
        }else{
            [UIView animateWithDuration:.2 animations:^{
                weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, weakSelf.searchData.count * 44);
            }];
        }
        [weakSelf.searchTableView reloadData];
    }];
}

-(void)httpDownLoadShopAssociate:(NSString *)text{
    __weak STSearchViewController *weakSelf = self;
    
    [KSMNetworkRequest getShopAssociateUrl:requestStoreSearch text:text finshed:^(id dataResult, NSError *error) {
        weakSelf.searchData = dataResult;
        if (weakSelf.searchData.count > 6) {
            [UIView animateWithDuration:.2 animations:^{
                weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 180);
            }];
        }else{
            weakSelf.searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, weakSelf.searchData.count * 30);
        }
        [weakSelf.searchTableView reloadData];
    }];
}

-(void)addSubView{
    __weak STSearchViewController *weakSelf = self;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 100, kSreenHeight - 64 - 49)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    _searchFlowL = [UICollectionViewFlowLayout new];
    [_searchFlowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"STSearchHeaderView" owner:self options:nil];
    _searchHeaderView = [nib objectAtIndex:0];
    _searchHeaderView.frame = CGRectMake(0, 0, kSreenWidth - 100, (kSreenWidth - 100) / 1.47);
    _searchHeaderView.prodRankBlock = ^(id sender){
        STProductDetailsViewController *prodRankVC = [STProductDetailsViewController new];
        //        prodRankVC.hidesBottomBarWhenPushed = YES;
        NSString *urlString = requestCheckTop;
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"cateid=%@&iskong=0&nearest=0",[[weakSelf.dataResult[weakSelf.indexpath.section] GroupCateList][weakSelf.indexpath.row] CateId]]];
        prodRankVC.urlStr = urlString;
        [weakSelf tabBarControllerHidden];
        [weakSelf.navigationController pushViewController:prodRankVC animated:YES];
    };
    _searchCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(100, 64, kSreenWidth - 100, kSreenHeight - 64 - 49)collectionViewLayout:_searchFlowL];
    _searchCollectionView.backgroundColor = [UIColor whiteColor];
    _searchCollectionView.delegate = self;
    _searchCollectionView.dataSource = self;
    [_searchCollectionView registerNib:[UINib nibWithNibName:[STSearchCollectionCell.class description] bundle:nil] forCellWithReuseIdentifier:@"STSearchCollectionCell"];
    [_searchCollectionView registerNib:[UINib nibWithNibName:[STSearchHeaderView.class description] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STSearchHeaderView"];
    [self.view addSubview:_searchCollectionView];
    [_searchCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    
    listTitles = @[@"商品",@"店铺"];
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 60, 80, 0)style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.scrollEnabled = NO;
    _listTableView.layer.masksToBounds = YES;
    _listTableView.layer.cornerRadius = 5.0f;
    _listTableView.rowHeight = 30;
    _listTableView.backgroundColor = [UIColor fromHexValue:0xe6e6e6 alpha:1];
    [_listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_listTableView];
    
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(50, 60, kScreenWidth - 100, 0)style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.layer.masksToBounds = YES;
    _searchTableView.layer.cornerRadius = 5.0f;
    _searchTableView.rowHeight = 30;
    [_searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_searchTableView];
    
    [self.mjTableView.mj_header endRefreshing];
    self.mjTableView.hidden = YES;
}
#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return _dataResult.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _listTableView) {
        return listTitles.count;
    }else if (tableView == _searchTableView){
        return _searchData.count;
    }
    return [[_dataResult[section] GroupCateList] count] ;
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
    }else if (tableView == _searchTableView){
        static NSString *SearchName = @"SearchName";
        STProductSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchName];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STProductSearchCell" owner:self options:nil]lastObject];
        }
        if (_searchData.count != 0) {
            [cell setProductSearch:_searchData indexPath:indexPath];
        }
        return cell;
    }else{
        static NSString *SearchNameA = @"SearchNameA";
        STSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchNameA];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STSearchTableViewCell" owner:self options:nil]lastObject];
        }
        [cell setSearchDataResult:[_dataResult[indexPath.section] GroupCateList] selectedDict:_selectedDict indexPath:indexPath];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        STSearchTabelHeaderView *searchTabelHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"STSearchTabelHeaderView" owner:self options:nil]lastObject];
        [searchTabelHeaderView setSearchTabelHeaderView:_dataResult imges:@[@"Wesmedicine",@"Chinmedicine",@"machine",@"healthCare",@"dailyNecessities"] section:section];
        return searchTabelHeaderView;
    }
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    return headerView;
}
#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _listTableView) {
        STShopListTableViewCell *cell = (STShopListTableViewCell *)[_listTableView cellForRowAtIndexPath:indexPath];
        [_listBtn setTitle:[NSString stringWithFormat:@"%@",cell.titleLab.text] forState:UIControlStateNormal];
        [UIView animateWithDuration:.3 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
        }];
        if ([cell.titleLab.text isEqualToString:@"店铺"]) {
            _searchTextField.placeholder = @"请输入商铺名";
            isShop = YES;
        }else{
            _searchTextField.placeholder = @"药品通用名,商品名";
            isShop = NO;
        }
    }else if (tableView == _searchTableView){
        STProductSearchCell *cell = (STProductSearchCell *)[_searchTableView cellForRowAtIndexPath:indexPath];
        STListViewController *listVC = [STListViewController new];
        //        listVC.hidesBottomBarWhenPushed = YES;
        if (isShop) {
            listVC.typeDict = @{@"keyWork": cell.nameLab.text,@"isShop":@YES,@"typeStr":@"",@"selected":@""};
        }else{
            listVC.typeDict = @{@"keyWork": cell.nameLab.text,@"isShop":@NO,@"typeStr":@"",@"selected":@""};
        }
        [self tabBarControllerHidden];
        [self.navigationController pushViewController:listVC animated:YES];
        
        [_searchTextField resignFirstResponder];
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
        }];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
        
    }else{
        _indexpath = indexPath;
        [_selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"selected"];
        [_selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section] forKey:@"Group"];
        [self httpDownloadGetCateProductParams:@{@"cateId":[[_dataResult[indexPath.section] GroupCateList][indexPath.row] CateId]} isYes:NO];
        
        [self.tableView reloadData];
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [tableView scrollToRowAtIndexPath:scrollIndexPath
                         atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

#pragma mark --UICollectionView dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_cateProducts.count %2 == 0) {
        return _cateProducts.count;
    }else{
        return _cateProducts.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    STSearchCollectionCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STSearchCollectionCell" forIndexPath:indexPath];
    [MyCell setSearch:_cateProducts indexPath:indexPath];
    return MyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kSreenWidth - 100)/2 - 2.5, (kSreenWidth - 100)/2 + 15);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 0);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kSreenWidth - 100,(kSreenWidth - 100) / 1.47);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kSreenWidth - 100,.5);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"STSearchHeaderView" forIndexPath:indexPath];
        if (_dataResult.count != 0) {
            [_searchHeaderView setSearchHeaderView:[[_dataResult[_indexpath.section] GroupCateList][_indexpath.row] CateName]];
        }
        [reusableView addSubview:_searchHeaderView];
        return reusableView;
    }else if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        _footerView = [UICollectionReusableView new];
        _footerView.frame = CGRectMake(5, 0, kSreenWidth - 100, .5);
        _footerView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
        [reusableView addSubview:_footerView];
        return reusableView;
    }
    return nil;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *typeDict = nil;
    if (_cateProducts.count %2 == 0) {
        typeDict = @{@"typeStr": [_cateProducts[indexPath.row] CateId],@"isShop":@NO,@"keyWork":@"",@"selected":@""};
    }else{
        if (indexPath.row != _cateProducts.count){
            typeDict = @{@"typeStr": [_cateProducts[indexPath.row] CateId],@"isShop":@NO,@"keyWork":@"",@"selected":@""};
        }else{
            return;
        }
    }
    
    STListViewController *listVC = [STListViewController new];
    listVC.typeDict = typeDict;
    [self tabBarControllerHidden];
    [self.navigationController pushViewController:listVC animated:YES];
}


#pragma mark -- btn - mothed
- (IBAction)listSelectedMothed:(UIButton *)sender {
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 65);
    }];
}

- (IBAction)searchSelectedMothed:(UIButton *)sender {
    STListViewController *listVC = [STListViewController new];
    if (isShop) {
        listVC.typeDict = @{@"keyWork": _searchTextField.text,@"isShop":@YES,@"typeStr":@"",@"selected":@""};
        
    }else{
        listVC.typeDict = @{@"keyWork": _searchTextField.text,@"isShop":@NO,@"typeStr":@"",@"selected":@""};
    }
    [self tabBarControllerHidden];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)scanSelecetedMothed:(UIButton *)sender {
    NSDictionary *dict =@{@"scanSelected":@"0",@"storeid":@""};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"scanSelected"];
    
    self.tabBarController.tabBar.hidden = YES;
    [[STCommon sharedSTSTCommon] toScanViewWith:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if (isLoad) {
        [self.mjTableView.mj_header beginRefreshing];
    }
    self.tabBarController.tabBar.hidden = NO;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 0);
    }];
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kSreenWidth - 100, 0);
    }];
    [_searchTextField resignFirstResponder];
    _searchTextField.text = @"";
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self performSelector:@selector(setHomeResignFirstResponder) withObject:self afterDelay:.5];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != _searchTableView) {
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kSreenWidth - 100, 0);
        }];
        [UIView animateWithDuration:.2 animations:^{
            _listTableView.frame = CGRectMake(50, 60, 80, 0);
        }];
    }
    [_searchTextField resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 0);
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    STListViewController *listVC = [STListViewController new];
    if (isShop) {
        listVC.typeDict = @{@"keyWork": _searchTextField.text,@"isShop":@YES,@"typeStr":@"",@"selected":@""};
        
    }else{
        listVC.typeDict = @{@"keyWork": _searchTextField.text,@"isShop":@NO,@"typeStr":@"",@"selected":@""};
    }
    [self tabBarControllerHidden];
    [self.navigationController pushViewController:listVC animated:YES];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField{
    [_searchData removeAllObjects];
    if (![textField.text isEqualToString:@""]) {
        if (!isShop) {
            [self httpDownProductLoadAssociate:_searchTextField.text];
        }else{
            [self httpDownLoadShopAssociate:_searchTextField.text];
        }
    }else{
        [_searchTableView reloadData];
        [UIView animateWithDuration:.2 animations:^{
            _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
        }];
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _searchTextField.text = @"";
    [_searchData removeAllObjects];
    [_searchTableView reloadData];
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
    return YES;
}

-(void)setHomeResignFirstResponder{
    [UIView animateWithDuration:.2 animations:^{
        _listTableView.frame = CGRectMake(50, 60, 80, 0);
    }];
    [_searchTextField resignFirstResponder];
    _searchTextField.text = @"";
    [_searchData removeAllObjects];
    [_searchTableView reloadData];
    [UIView animateWithDuration:.2 animations:^{
        _searchTableView.frame = CGRectMake(50, 60, kScreenWidth - 100, 0);
    }];
}

@end
