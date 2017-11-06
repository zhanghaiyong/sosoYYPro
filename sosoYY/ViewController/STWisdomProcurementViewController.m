//
//  STWisdomProcurementViewController.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomProcurementViewController.h"
#import "STWisdomBtnView.h"
#import "STWisdomProcurementTableViewCell.h"
#import "STWisdomFooterView.h"
#import "STProductDetailsViewController.h"
#import "STWisdomHeadererView.h"
#import "STWisdomNotShopTableViewCell.h"
#import "STWisdomNotView.h"
#import "STWisdomCollectionView.h"
#import "STWisdomShopTableViewCell.h"
#import "STWisdomUndoView.h"
#import "STWisdomSlideView.h"
#import "STWisdomWeedOutViewController.h"
#import "STWisdomAddListViewController.h"
#import "STWisdomProcurementNavView.h"
#import "STWisdomWeedOutView.h"
#import "STWisdomSelectListTableView.h"
#import "MaskingView.h"
#import "STWisdomHelpViewController.h"
#import "STWisdomSearchViewController.h"
#import "STWisdomToLeftView.h"
#import "STWisdomFilterView.h"
#import "WisdomShopViewController.h"
#define btn_Tag 10000
#define selectBtn_tag 100


@interface STWisdomProcurementViewController ()<UITableViewDelegate,UITableViewDataSource,STWisdomProcurementTableViewCellDelegate,STWisdomShopTableViewCellDelegate,UIGestureRecognizerDelegate,STWisdomNotShopTableViewCellDelegate>{
    BOOL isSearch;//判断是否显示中间字母
    
    __block BOOL isSelect;//判断是否点击数字下拉菜单
    
    __block NSInteger letterIndex;//字母，库存，紧急程度 ，2，1，0
    
    __block NSInteger topIndex;//智慧采购，暂不采购，人工采购，0，1，2
    
    __block UILabel *lab;//有无数据
    
    __block UIImageView *imgV;//有无数据
    
    __block BOOL isChange;//判断是否显示中间字母
    
    __block NSInteger regainKeepTime;//撤消时间
    
    BOOL isSelectList;//淘汰下拉菜单
    
    __block BOOL isOK;//是否请求成功
    
    UIView *bgView;//半透明覆盖
    
    __block BOOL isOpen;//加号打开
    
    BOOL isFailCode;//扫描
    
    __block BOOL isHidden;//黑色指导图取消
    
    __block BOOL isHelpBackBlock;//帮助返回
    
    __block BOOL isHandAdd;//帮助返回
    
    __block BOOL isShare;//分享返回
    
    __block NSString *jsonStr;//把数组变为json的数据
    
}

@property(assign,nonatomic)STWisdomToLeftView *wisdomToLeftView;//首次启动指导

@property(assign,nonatomic)CGFloat offsetY;//tableView的偏移量

@property(assign,nonatomic) BOOL isAllSelect;//全选

@property(strong,nonatomic)MaskingView *btnMaskView;

@property(strong,nonatomic)MaskingView *deleteMaskView;

@property(strong,nonatomic)MaskingView *addMaskView;

@property(strong,nonatomic)MaskingView *shareMaskView;

@property(strong,nonatomic)UIView *centrView;

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)STWisdomFooterView *wisdomFooterView;

@property(strong,nonatomic)UIView *footerVuew;

@property(strong,nonatomic)STWisdomHeadererView *wisdomHeadererView;

@property(strong,nonatomic)STWisdomBtnView *wisdomBtnView;

@property(strong,nonatomic)STWisdomNotView *notView;

@property(strong,nonatomic)UILabel *letterLab;

@property(strong,nonatomic)NSMutableArray *dataResultOR;

@property(strong,nonatomic)NSMutableArray *indexAry;

@property(strong,nonatomic)NSMutableArray *selectAry;

@property(strong,nonatomic)STWisdomCollectionView *wisdomCollectionView;

@property(strong,nonatomic)NSIndexPath *mIndexPath;

@property(strong,nonatomic)NSMutableDictionary *paramsDict;

@property(strong,nonatomic)NSString *mobileStr;

@property(assign,nonatomic)NSInteger matchingCount;

@property(assign,nonatomic)NSInteger notPurchaseCount;

@property(assign,nonatomic)NSInteger notMatchingCount;

@property(strong,nonatomic)NSMutableArray *removeDataResultOR;

@property(strong,nonatomic)NSMutableArray *removeIndexAry;

@property(strong,nonatomic)STWisdomUndoView *undoView;

@property(strong,nonatomic)NSIndexPath *mIndexPath2;

@property(assign,nonatomic)BOOL isFirst;

@property(assign,nonatomic)NSInteger type;

@property(strong,nonatomic)UIView *myLoadView;

@property(strong,nonatomic)UITableView *selectListTableView;

@property(strong,nonatomic)UIImageView *selectListImgV;

@property(strong,nonatomic)STWisdomWeedOutView *wisdomWeedOutView;

@property(strong,nonatomic)NSMutableArray *weedOutDataResultOR;

@property(strong,nonatomic)NSMutableArray *weedOutIndexAry;

@property (strong, nonatomic)  UIView *openView;

@property (strong, nonatomic)  UILabel *searchLab;

@property (strong, nonatomic)  UIView *searchView;

@property (strong, nonatomic)  UILabel *scanLab;

@property (strong, nonatomic)  UIView *scanView;

@property (strong, nonatomic)  UILabel *closeLab;

@property (strong, nonatomic)  NSMutableArray *countArray;

@property (strong, nonatomic)  NSMutableArray *countNotArray;

@property (strong, nonatomic)  NSMutableArray *allNotArray;

@property(strong,nonatomic)NSMutableArray *sectionAry;

@property(strong,nonatomic)NSMutableArray *sectionNumAry;

@property(strong,nonatomic)NSMutableArray *cellAry;

@property(strong,nonatomic)STWisdomFilterView *wisdomFilterView;

@property(assign,nonatomic) BOOL isWisdomFilterView;//判断WisdomFilterView是否显示

@property(assign,nonatomic)NSInteger filterIndex;

@property(strong,nonatomic)NSMutableArray *selectAllAry;

@property(strong,nonatomic)NSMutableArray *notSelectAllAry;

@property(strong,nonatomic)NSMutableArray *selectAllIndexAry;

@property(strong,nonatomic)NSMutableArray *notSelectAllIndexAry;

@property(assign,nonatomic)int removeSection;

@property(assign,nonatomic)int removeRow;

@property(strong,nonatomic)NSString *selectFilterBtnTitle;

@end

@implementation STWisdomProcurementViewController
-(void)g_setNotFinished:(NSIndexPath *)indexPath{}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.合并
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setShareAppBack) name:SHARE_Notification object:nil];
    
    _dataResultOR = [NSMutableArray new];
    
    _indexAry = [NSMutableArray new];
    
    _selectAry = [NSMutableArray new];
    
    _paramsDict = [NSMutableDictionary new];
    
    _removeDataResultOR = [NSMutableArray new];
    
    _removeIndexAry = [NSMutableArray new];
    
    _weedOutDataResultOR = [NSMutableArray new];
    
    _weedOutIndexAry = [NSMutableArray new];
    
    _countArray = [NSMutableArray new];
    
    _countNotArray = [NSMutableArray new];
    
    _allNotArray = [NSMutableArray new];
    
    _sectionAry = [NSMutableArray new];
    
    _sectionNumAry = [NSMutableArray new];
    
    _cellAry = [NSMutableArray new];
    
    _selectAllAry = [NSMutableArray new];
    
    _notSelectAllAry = [NSMutableArray new];
    
    _selectAllIndexAry = [NSMutableArray new];
    
    _notSelectAllIndexAry = [NSMutableArray new];
    
    [_paramsDict setObject:@"0" forKey:@"tab"];
    
    [_paramsDict setObject:@"2" forKey:@"order"];
    
    [_paramsDict setObject:@"1" forKey:@"init"];
    
    isSearch = YES;
    
    isSelect = YES;
    
    isChange = NO;
    
    _isFirst = NO;
    
    letterIndex = 0;
    
    topIndex = 0;
    
    _type = 2;
    
    isOK = NO;
    
    [self myAddSubView];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (topIndex == 2) {
            
            [self artificialPurchasing];
            
        }else{
            
            [self httpDownloadWisdomProcurementParams:_paramsDict type:_type];
            
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self setShareTwo];
}
#pragma mark- 数据请求
-(void)httpDownloadWisdomProcurementParams:(NSMutableDictionary *)params type:(NSInteger)type{
    
    __weak STWisdomProcurementViewController *weakSelf = self;
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [KSMNetworkRequest getWisdomProcurementUrl:requestPurchaseHome
                                            params:params type:type finshed:^(id dataResult,NSMutableArray *indexResult,NSError *error,NSMutableDictionary *indexDict,NSString *mobile) {
                                                
                                                _myLoadView.hidden = YES;
                                                
                                                [weakSelf.countArray removeAllObjects];
                                                
                                                [weakSelf.dataResultOR removeAllObjects];
                                                
                                                if (!error) {
                                                    
                                                    [_paramsDict setObject:@"0" forKey:@"init"];
                                                    
                                                    weakSelf.dataResultOR = dataResult;
                                                    
                                                    weakSelf.indexAry = indexResult;
                                                    
                                                    weakSelf.mobileStr = mobile;
                                                    
                                                    weakSelf.matchingCount = [indexDict[@"matchingCount"] integerValue];
                                                    
                                                    weakSelf.notPurchaseCount = [indexDict[@"notPurchaseCount"] integerValue];
                                                    
                                                    weakSelf.notMatchingCount = [indexDict[@"notMatchingCount"] integerValue];
                                                    
                                                    for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                                        
                                                        NSArray *ary = weakSelf.dataResultOR[i];
                                                        
                                                        for (int j = 0;j < ary.count;j++) {
                                                            
                                                            STWisdomEntity *entity = ary[j];
                                                            
                                                            if (entity.isSelect.intValue == 1) {
                                                                
                                                                [weakSelf.countArray addObject:entity];
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    if (indexResult.count != 0) {
                                                        
                                                        _centrView.hidden = YES;
                                                        
                                                    }else{
                                                        
                                                        [ZHProgressHUD showInfoWithText:@"暂无数据"];
                                                        
                                                        _centrView.hidden = NO;
                                                        
                                                        if (topIndex == 0) {
                                                            
                                                            lab.text = @"暂无计划要审";
                                                            
                                                            imgV.image = [UIImage imageNamed:@"jihuan"];
                                                            
                                                        }else if (topIndex == 1){
                                                            
                                                            lab.text = @"没有暂不采购的商品";
                                                            
                                                            imgV.image = [UIImage imageNamed:@"notCaigou"];
                                                            
                                                        }else if (topIndex == 2){
                                                            
                                                            lab.text = @"没有暂不匹配的商品";
                                                            
                                                            imgV.image = [UIImage imageNamed:@"notPiPei"];
                                                        }
                                                    }
                                                }else{
                                                    [ZHProgressHUD showInfoWithText:@"加载失败"];
                                                    
                                                    weakSelf.centrView.hidden = NO;
                                                    
                                                    if (topIndex == 0) {
                                                        
                                                        lab.text = @"暂无计划要审";
                                                        
                                                        imgV.image = [UIImage imageNamed:@"jihuan"];
                                                        
                                                    }else if (topIndex == 1){
                                                        
                                                        lab.text = @"没有暂不采购的商品";
                                                        
                                                        imgV.image = [UIImage imageNamed:@"notCaigou"];
                                                        
                                                    }else if (topIndex == 2){
                                                        
                                                        lab.text = @"没有暂不匹配的商品";
                                                        
                                                        imgV.image = [UIImage imageNamed:@"notPiPei"];
                                                    }
                                                }
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    if (weakSelf.dataResultOR.count != 0) {
                                                        
                                                        if (topIndex == 0) {
                                                            if (weakSelf.countArray.count != 0) {
                                                                weakSelf.wisdomFooterView.backgroundColor = RGB(249, 83, 32);
                                                            }
                                                        }else if (topIndex == 1){
                                                            
                                                            weakSelf.wisdomFooterView.backgroundColor = RGB(77, 183, 98);
                                                            
                                                        }else if (topIndex == 2){
                                                            
                                                            weakSelf.wisdomFooterView.iphoneBtn.backgroundColor = RGB(77, 183, 98);
                                                            
                                                            weakSelf.shareMaskView.hidden = NO;
                                                        }
                                                    }
                                                    
                                                    if (topIndex == 0) {
                                                        
                                                        [weakSelf toGuideFigure];
                                                    }
                                                    
                                                    isSearch = YES;
                                                    
                                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                                                    
                                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                                                    
                                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notMatchingCount] type:2];
                                                    
                                                    [_wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                                                    
                                                    [weakSelf.tableView reloadData];
                                                    
                                                    [weakSelf.tableView.mj_header endRefreshing];
                                                    
                                                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                                                    
                                                    if (isHidden) {
                                                        
                                                        _wisdomToLeftView.hidden = NO;
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
            
            _myLoadView.hidden = YES;
        }
    }];
}


#pragma mark- 删除数据
-(void)deletePurchaseParams:(NSDictionary *)params indexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    __weak STWisdomProcurementViewController *weakSelf = self;
    
    [KSMNetworkRequest getDeletePurchaseUrl:requestDeletePurchase params:params finshed:^(id dataResult,NSError *error) {
        if (!error) {
            
            if ([dataResult[@"code"] intValue] == 200) {
                
                if (topIndex == 0) {
                    
                    weakSelf.matchingCount = weakSelf.matchingCount - 1;
                    
                    if (weakSelf.matchingCount < 0) {
                        
                        weakSelf.matchingCount = 0;
                    }
                    
                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                    
                    if (isHandAdd) {
                        
                        isHandAdd = NO;
                        
                    }else{
                        
                        weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  + 1;
                        
                        [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                    }
                }
                
                NSMutableArray *removeDataResultOR2 = [NSMutableArray new];
                
                NSMutableArray *removeIndexAry2 = [NSMutableArray new];
                
                switch (_filterIndex) {
                    case 0:{
                        if ([weakSelf.dataResultOR[indexPath.section] count] == 1) {
                            
                            weakSelf.isFirst = YES;
                            
                            [removeDataResultOR2 addObject:weakSelf.dataResultOR [indexPath.section][0]];
                            
                            [removeIndexAry2 addObject:weakSelf.indexAry[indexPath.section][0]];
                            
                            [weakSelf.removeDataResultOR addObject:removeDataResultOR2];
                            
                            [weakSelf.removeIndexAry addObject:removeIndexAry2];
                            
                            if (weakSelf.dataResultOR.count > indexPath.section) {
                                
                                [weakSelf.dataResultOR removeObjectAtIndex:indexPath.section];
                                
                                [weakSelf.indexAry removeObjectAtIndex:indexPath.section];
                            }
                            
                            [weakSelf.tableView reloadData];
                        }else{
                            
                            weakSelf.isFirst = NO;
                            
                            [removeDataResultOR2 addObject:weakSelf.dataResultOR [indexPath.section][indexPath.row]];
                            
                            [removeIndexAry2 addObject:weakSelf.indexAry[indexPath.section][indexPath.row]];
                            
                            [weakSelf.removeDataResultOR addObject:removeDataResultOR2];
                            
                            [weakSelf.removeIndexAry addObject:removeIndexAry2];
                            
                            if ([weakSelf.dataResultOR[indexPath.section] count] > indexPath.row) {
                                
                                [weakSelf.dataResultOR[indexPath.section] removeObjectAtIndex:indexPath.row];
                                
                                [weakSelf.indexAry[indexPath.section] removeObjectAtIndex:indexPath.row];
                                
                                [weakSelf.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                        }
                        
                        if (weakSelf.dataResultOR.count == 0) {
                            
                            weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
                            
                            weakSelf.centrView.hidden = NO;
                            
                            if (topIndex == 0) {
                                
                                lab.text = @"暂无计划要审";
                                
                                imgV.image = [UIImage imageNamed:@"jihuan"];
                                
                            }else if (topIndex == 1){
                                
                                lab.text = @"没有暂不采购的商品";
                                
                                imgV.image = [UIImage imageNamed:@"notCaigou"];
                                
                            }else if (topIndex == 2){
                                
                                lab.text = @"没有暂不匹配的商品";
                                
                                imgV.image = [UIImage imageNamed:@"notPiPei"];
                            }
                        }
                        if (weakSelf.dataResultOR.count != 0) {
                            
                            [weakSelf.countArray removeAllObjects];
                            
                            for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                
                                NSArray *ary = weakSelf.dataResultOR[i];
                                
                                for (int j = 0;j < ary.count;j++) {
                                    
                                    STWisdomEntity *entity = ary[j];
                                    
                                    if (entity.isSelect.intValue == 1) {
                                        
                                        [weakSelf.countArray addObject:entity];
                                    }
                                }
                            }
                            
                            [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                        }
                        break;
                    }
                    case 1:{
                        if ([weakSelf.selectAllAry[indexPath.section] count] == 1) {
                            
                            weakSelf.isFirst = YES;
                            
                            [removeDataResultOR2 addObject:weakSelf.selectAllAry [indexPath.section][0]];
                            
                            STWisdomEntity *mode = weakSelf.selectAllAry [indexPath.section][0];
                            
                            [removeIndexAry2 addObject:weakSelf.selectAllIndexAry[indexPath.section][0]];
                            
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                    STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }
                            
                            [weakSelf.removeDataResultOR addObject:removeDataResultOR2];
                            
                            [weakSelf.removeIndexAry addObject:removeIndexAry2];
                            
                            [weakSelf.tableView reloadData];
                            
                        }else{
                            
                            weakSelf.isFirst = NO;
                            
                            [removeDataResultOR2 addObject:weakSelf.selectAllAry [indexPath.section][indexPath.row]];
                            
                            STWisdomEntity *mode = weakSelf.selectAllAry [indexPath.section][indexPath.row];
                            
                            [removeIndexAry2 addObject:weakSelf.selectAllIndexAry[indexPath.section][indexPath.row]];
                            
                            [weakSelf.removeDataResultOR addObject:removeDataResultOR2];
                            
                            [weakSelf.removeIndexAry addObject:removeIndexAry2];
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                    STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }
                            
                            [weakSelf.tableView reloadData];
                        }
                        
                        if (weakSelf.selectAllAry.count == 0) {
                            
                            weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
                            
                            weakSelf.centrView.hidden = NO;
                            
                            if (topIndex == 0) {
                                
                                lab.text = @"暂无计划要审";
                                
                                imgV.image = [UIImage imageNamed:@"jihuan"];
                                
                            }else if (topIndex == 1){
                                
                                lab.text = @"没有暂不采购的商品";
                                
                                imgV.image = [UIImage imageNamed:@"notCaigou"];
                                
                            }else if (topIndex == 2){
                                
                                lab.text = @"没有暂不匹配的商品";
                                
                                imgV.image = [UIImage imageNamed:@"notPiPei"];
                            }
                        }
                        if (weakSelf.dataResultOR.count != 0) {
                            
                            [weakSelf.countArray removeAllObjects];
                            
                            for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                
                                NSArray *ary = weakSelf.dataResultOR[i];
                                
                                for (int j = 0;j < ary.count;j++) {
                                    
                                    STWisdomEntity *entity = ary[j];
                                    
                                    if (entity.isSelect.intValue == 1) {
                                        
                                        [weakSelf.countArray addObject:entity];
                                    }
                                }
                            }
                            
                            [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                        }
                        break;
                    }
                    case 2:{
                        if ([weakSelf.notSelectAllAry[indexPath.section] count] == 1) {
                            
                            weakSelf.isFirst = YES;
                            
                            [removeDataResultOR2 addObject:weakSelf.notSelectAllAry [indexPath.section][0]];
                            
                            STWisdomEntity *mode = weakSelf.notSelectAllAry [indexPath.section][0];
                            
                            [removeIndexAry2 addObject:weakSelf.notSelectAllIndexAry[indexPath.section][0]];
                            
                            
                            [weakSelf.removeDataResultOR addObject:removeDataResultOR2];
                            
                            [weakSelf.removeIndexAry addObject:removeIndexAry2];
                            
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                     STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }
                            
                            [weakSelf.tableView reloadData];
                            
                          
                        }else{
                            
                            weakSelf.isFirst = NO;
                            
                            [removeDataResultOR2 addObject:weakSelf.notSelectAllAry [indexPath.section][indexPath.row]];
                            
                            STWisdomEntity *mode = weakSelf.notSelectAllAry [indexPath.section][indexPath.row];
                            
                            [removeIndexAry2 addObject:weakSelf.notSelectAllIndexAry[indexPath.section][indexPath.row]];
                            
                            [weakSelf.removeDataResultOR addObject:removeDataResultOR2];
                            
                            [weakSelf.removeIndexAry addObject:removeIndexAry2];
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                    STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }
                            [weakSelf.tableView reloadData];
                            
                        }
                        
                        if (weakSelf.notSelectAllAry.count == 0) {
                            
                            weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
                            
                            weakSelf.centrView.hidden = NO;
                            
                            if (topIndex == 0) {
                                
                                lab.text = @"暂无计划要审";
                                
                                imgV.image = [UIImage imageNamed:@"jihuan"];
                                
                            }else if (topIndex == 1){
                                
                                lab.text = @"没有暂不采购的商品";
                                
                                imgV.image = [UIImage imageNamed:@"notCaigou"];
                                
                            }else if (topIndex == 2){
                                
                                lab.text = @"没有暂不匹配的商品";
                                
                                imgV.image = [UIImage imageNamed:@"notPiPei"];
                            }
                        }
                        if (weakSelf.dataResultOR.count != 0) {
                            
                            [weakSelf.countArray removeAllObjects];
                            
                            for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                
                                NSArray *ary = weakSelf.dataResultOR[i];
                                
                                for (int j = 0;j < ary.count;j++) {
                                    
                                    STWisdomEntity *entity = ary[j];
                                    
                                    if (entity.isSelect.intValue == 1) {
                                        
                                        [weakSelf.countArray addObject:entity];
                                    }
                                }
                            }
                            
                            [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
                
                [ZHProgressHUD showInfoWithText:@"删除成功"];
                
                weakSelf.undoView.numLab.text = @"该商品已被移除";
                
            }else{
                
                [ZHProgressHUD showInfoWithText:@"删除失败"];
                
                weakSelf.undoView.numLab.text = @"删除失败";
            }
            
        }else{
            
            [ZHProgressHUD showInfoWithText:@"网络请求失败"];
            
            weakSelf.undoView.numLab.text = @"网络请求失败";
            
        }
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        
    }];
    
}

#pragma mark- 智慧采购改变数量
-(void)changePurchaseCountParams:(NSDictionary *)params indexPath:(NSIndexPath *)indexPath finshed:(void(^)(BOOL isYes))finshed{
    [KSMNetworkRequest getChangePurchaseCountUrl:requestChangePurchaseCount
                                          params:params finshed:^(id dataResult,NSError *error) {
                                              
                                              isSearch = YES;
                                              if (!error) {
                                                  
                                                  finshed(YES);
                                                  
                                              }else{
                                                  
                                                  finshed(NO);
                                                  
                                              }
                                          }];
    
    
}
#pragma mark- 加入计划
-(void)cancelDeletePurchaseForPsn:(NSDictionary *)params indexPath:(NSIndexPath *)indexPath{
    
    __weak STWisdomProcurementViewController *weakSelf = self;
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    [KSMNetworkRequest getChangePurchaseCountUrl:requestCancelDeletePurchaseForPsn  params:params finshed:^(id dataResult,NSError *error) {
        isSearch = YES;
        if (!error) {
            
            if (![params[@"psn"] isEqualToString:@""]) {
                
                weakSelf.matchingCount = weakSelf.matchingCount + 1;
                
                [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                
                weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  - 1;
                
                if (weakSelf.notPurchaseCount < 0) {
                    
                    weakSelf.notPurchaseCount = 0;
                    
                }
                [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                
                if (weakSelf.dataResultOR.count > indexPath.section) {
                    
                    [weakSelf.dataResultOR removeObjectAtIndex:indexPath.section];
                    
                    [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                }
                
            }else{
                
                weakSelf.matchingCount = weakSelf.matchingCount + _dataResultOR.count;
                
                [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                
                [weakSelf.wisdomHeadererView setNumStr:@"0" type:1];
                
                [weakSelf.dataResultOR removeAllObjects];
                
                [weakSelf.tableView reloadData];
            }
            
            [ZHProgressHUD showInfoWithText:@"加入成功"];
            
        }else{
            
            [ZHProgressHUD showInfoWithText:@"加入失败"];
            
        }
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        
        if (weakSelf.dataResultOR.count == 0) {
            
            weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
            
            weakSelf.centrView.hidden = NO;
            
            if (topIndex == 0) {
                
                lab.text = @"暂无计划要审";
                
                imgV.image = [UIImage imageNamed:@"jihuan"];
                
            }else if (topIndex == 1){
                
                lab.text = @"没有暂不采购的商品";
                
                imgV.image = [UIImage imageNamed:@"notCaigou"];
                
            }else if (topIndex == 2){
                
                lab.text = @"没有暂不匹配的商品";
                
                imgV.image = [UIImage imageNamed:@"notPiPei"];
            }
        }
    }];
}
#pragma mark- 恢复删除
-(void)cancelDeletePurchaseForId:(NSDictionary *)params finshed:(void(^)(BOOL isYes))finshed{
    
    [KSMNetworkRequest getCancelDeletePurchaseForIdUrl:requestCancelDeletePurchaseForId params:params finshed:^(BOOL isYes, NSError *error) {
        
        if (!error) {
            
            finshed(isYes);
            
        }else{
            
            [_removeDataResultOR removeAllObjects];
            
            [_removeIndexAry removeAllObjects];
        }
    }];
}

#pragma mark- 淘汰
-(void)deletePurchaseEliminateParams:(NSDictionary *)params indexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    __weak STWisdomProcurementViewController *weakSelf = self;
    
    [KSMNetworkRequest getDeletePurchaseEliminateParamsUrl:requestDeletePurchaseEliminate params:params finshed:^(id dataResult,NSError *error) {
        if (!error) {
            
            if ([dataResult[@"code"] intValue] == 200) {
                
                if (topIndex == 0) {
                    
                    weakSelf.matchingCount = weakSelf.matchingCount - 1;
                    
                    if (weakSelf.matchingCount < 0) {
                        
                        weakSelf.matchingCount = 0;
                    }
                    
                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                    
                    weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  + 1;
                }
                
                NSMutableArray *weedOutDataResultOR2 = [NSMutableArray new];
                
                NSMutableArray *weedOutIndexAry2 = [NSMutableArray new];
                
                switch (_filterIndex) {
                    case 0:{
                        if ([weakSelf.dataResultOR[indexPath.section] count] == 1) {
                            
                            weakSelf.isFirst = YES;
                            
                            [weedOutDataResultOR2 addObject:weakSelf.dataResultOR [indexPath.section][0]];
                            
                            [weedOutIndexAry2 addObject:weakSelf.indexAry[indexPath.section][0]];
                            
                            [weakSelf.weedOutDataResultOR addObject:weedOutDataResultOR2];
                            
                            [weakSelf.weedOutIndexAry addObject:weedOutIndexAry2];
                            
                            if (weakSelf.dataResultOR.count > indexPath.section) {
                                
                                [weakSelf.dataResultOR removeObjectAtIndex:indexPath.section];
                                
                                [weakSelf.indexAry removeObjectAtIndex:indexPath.section];
                            }
                            
                            [weakSelf.tableView reloadData];
                            
                        }else{
                            
                            weakSelf.isFirst = NO;
                            
                            [weedOutDataResultOR2 addObject:weakSelf.dataResultOR [indexPath.section][indexPath.row]];
                            
                            [weedOutIndexAry2 addObject:weakSelf.indexAry[indexPath.section][indexPath.row]];
                            
                            [weakSelf.weedOutDataResultOR addObject:weedOutDataResultOR2];
                            
                            [weakSelf.weedOutIndexAry addObject:weedOutIndexAry2];
                            
                            if ([weakSelf.dataResultOR[indexPath.section] count] > indexPath.row) {
                                
                                [weakSelf.dataResultOR[indexPath.section] removeObjectAtIndex:indexPath.row];
                                
                                [weakSelf.indexAry[indexPath.section] removeObjectAtIndex:indexPath.row];
                                
                                [weakSelf.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            }
                            
                            if (weakSelf.dataResultOR.count == 0) {
                                
                                weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
                                
                                weakSelf.centrView.hidden = NO;
                                
                                if (topIndex == 0) {
                                    
                                    lab.text = @"暂无计划要审";
                                    
                                    imgV.image = [UIImage imageNamed:@"jihuan"];
                                    
                                }else if (topIndex == 1){
                                    
                                    lab.text = @"没有暂不采购的商品";
                                    
                                    imgV.image = [UIImage imageNamed:@"notCaigou"];
                                    
                                }else if (topIndex == 2){
                                    
                                    lab.text = @"没有暂不匹配的商品";
                                    
                                    imgV.image = [UIImage imageNamed:@"notPiPei"];
                                }
                            }
                            if (weakSelf.dataResultOR.count != 0) {
                                
                                [weakSelf.countArray removeAllObjects];
                                
                                for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                    
                                    NSArray *ary = weakSelf.dataResultOR[i];
                                    
                                    for (int j = 0;j < ary.count;j++) {
                                        
                                        STWisdomEntity *entity = ary[j];
                                        
                                        if (entity.isSelect.intValue == 1) {
                                            
                                            [weakSelf.countArray addObject:entity];
                                        }
                                    }
                                }
                                
                                [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                            }
                        }
                        break;
                    }
                    case 1:{
                        if ([weakSelf.selectAllAry[indexPath.section] count] == 1) {
                            
                            weakSelf.isFirst = YES;
                            
                            [weedOutDataResultOR2 addObject:weakSelf.selectAllAry [indexPath.section][0]];
                            
                            STWisdomEntity *mode = weakSelf.selectAllAry [indexPath.section][0];
                            
                            [weedOutIndexAry2 addObject:weakSelf.selectAllIndexAry[indexPath.section][0]];
                            
                            [weakSelf.weedOutDataResultOR addObject:weedOutDataResultOR2];
                            
                            [weakSelf.weedOutIndexAry addObject:weedOutIndexAry2];
                            
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                    STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }
                            
                            [weakSelf.tableView reloadData];
                            
                        }else{
                            
                            weakSelf.isFirst = NO;
                            
                            [weedOutDataResultOR2 addObject:weakSelf.selectAllAry [indexPath.section][indexPath.row]];
                            
                            STWisdomEntity *mode = weakSelf.selectAllAry [indexPath.section][indexPath.row];
                            
                            [weedOutIndexAry2 addObject:weakSelf.selectAllIndexAry[indexPath.section][indexPath.row]];
                            
                            
                            [weakSelf.weedOutDataResultOR addObject:weedOutDataResultOR2];
                            
                            [weakSelf.weedOutIndexAry addObject:weedOutIndexAry2];
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                    STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }
                            [weakSelf.tableView reloadData];
                            
                            
                            if (weakSelf.selectAllAry.count == 0) {
                                
                                weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
                                
                                weakSelf.centrView.hidden = NO;
                                
                                if (topIndex == 0) {
                                    
                                    lab.text = @"暂无计划要审";
                                    
                                    imgV.image = [UIImage imageNamed:@"jihuan"];
                                    
                                }else if (topIndex == 1){
                                    
                                    lab.text = @"没有暂不采购的商品";
                                    
                                    imgV.image = [UIImage imageNamed:@"notCaigou"];
                                    
                                }else if (topIndex == 2){
                                    
                                    lab.text = @"没有暂不匹配的商品";
                                    
                                    imgV.image = [UIImage imageNamed:@"notPiPei"];
                                }
                            }
                            if (weakSelf.dataResultOR.count != 0) {
                                
                                [weakSelf.countArray removeAllObjects];
                                
                                for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                    
                                    NSArray *ary = weakSelf.dataResultOR[i];
                                    
                                    for (int j = 0;j < ary.count;j++) {
                                        
                                        STWisdomEntity *entity = ary[j];
                                        
                                        if (entity.isSelect.intValue == 1) {
                                            
                                            [weakSelf.countArray addObject:entity];
                                        }
                                    }
                                }
                                
                                [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                            }
                        }
                        
                        
                        break;
                    }
                    case 2:{
                        if ([weakSelf.notSelectAllAry[indexPath.section] count] == 1) {
                            
                            weakSelf.isFirst = YES;
                            
                            [weedOutDataResultOR2 addObject:weakSelf.notSelectAllAry [indexPath.section][0]];
                            
                            STWisdomEntity *mode = weakSelf.notSelectAllAry [indexPath.section][0];
                            
                            [weedOutIndexAry2 addObject:weakSelf.notSelectAllIndexAry[indexPath.section][0]];
                            
                            [weakSelf.weedOutDataResultOR addObject:weedOutDataResultOR2];
                            
                            [weakSelf.weedOutIndexAry addObject:weedOutIndexAry2];
                            
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                    STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }
                            
                            [weakSelf.tableView reloadData];
                            
                        }else{
                            
                            weakSelf.isFirst = NO;
                            
                            [weedOutDataResultOR2 addObject:weakSelf.notSelectAllAry [indexPath.section][indexPath.row]];
                            
                            STWisdomEntity *mode = weakSelf.notSelectAllAry [indexPath.section][indexPath.row];
                            
                            [weedOutIndexAry2 addObject:weakSelf.notSelectAllIndexAry[indexPath.section][indexPath.row]];
                            
                            [weakSelf.weedOutDataResultOR addObject:weedOutDataResultOR2];
                            
                            [weakSelf.weedOutIndexAry addObject:weedOutIndexAry2];
                            
                            
                            for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                                
                                for (int j = 0;j < [weakSelf.dataResultOR[i] count];j++) {
                                    
                                    STWisdomEntity *entity = weakSelf.dataResultOR[i][j];
                                    
                                    if (entity.Goods_Package_ID == mode.Goods_Package_ID) {
                                        
                                        weakSelf.removeSection = i;
                                        
                                        weakSelf.removeRow = j;
                                        
                                        [weakSelf.dataResultOR[i] removeObjectAtIndex:j];
                                        
                                        [weakSelf.indexAry[i] removeObjectAtIndex:j];
                                        
                                    }
                                }
                            }

                            [weakSelf.tableView reloadData];
                            
                            if (weakSelf.notSelectAllAry.count == 0) {
                                
                                weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
                                
                                weakSelf.centrView.hidden = NO;
                                
                                if (topIndex == 0) {
                                    
                                    lab.text = @"暂无计划要审";
                                    
                                    imgV.image = [UIImage imageNamed:@"jihuan"];
                                    
                                }else if (topIndex == 1){
                                    
                                    lab.text = @"没有暂不采购的商品";
                                    
                                    imgV.image = [UIImage imageNamed:@"notCaigou"];
                                    
                                }else if (topIndex == 2){
                                    
                                    lab.text = @"没有暂不匹配的商品";
                                    
                                    imgV.image = [UIImage imageNamed:@"notPiPei"];
                                }
                            }
                            if (weakSelf.dataResultOR.count != 0) {
                                
                                [weakSelf.countArray removeAllObjects];
                                
                                for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                    
                                    NSArray *ary = weakSelf.dataResultOR[i];
                                    
                                    for (int j = 0;j < ary.count;j++) {
                                        
                                        STWisdomEntity *entity = ary[j];
                                        
                                        if (entity.isSelect.intValue == 1) {
                                            
                                            [weakSelf.countArray addObject:entity];
                                        }
                                    }
                                }
                                
                                [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                            }
                        }
                        
                        break;
                    }
                    default:
                        break;
                }
                
                [ZHProgressHUD showInfoWithText:@"淘汰成功"];
                
                weakSelf.wisdomWeedOutView.numLab.text =@"该商品已被淘汰";
                
            }else{
                
                [ZHProgressHUD showInfoWithText:@"淘汰失败"];
                
                weakSelf.wisdomWeedOutView.numLab.text =@"淘汰失败";
            }
            
        }else{
            
            [ZHProgressHUD showInfoWithText:@"网络请求失败"];
            
            weakSelf.wisdomWeedOutView.numLab.text =@"网络请求失败";
        }
        
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
    
}

#pragma mark- 恢复淘汰
-(void)cancelDeletePurchaseEliminateForId:(NSDictionary *)params finshed:(void(^)(BOOL isYes))finshed{
    
    [KSMNetworkRequest getCancelDeletePurchaseEliminateForIdUrl:requestCancelDeletePurchaseEliminateForId params:params finshed:^(BOOL isYes, NSError *error) {
        
        if (!error) {
            
            finshed(isYes);
            
        }else{
            
            [_weedOutDataResultOR removeAllObjects];
            
            [_weedOutIndexAry removeAllObjects];
        }
    }];
}

#pragma mark- 人工采购
-(void)artificialPurchasing{
    
    __weak STWisdomProcurementViewController *weakSelf = self;
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getArtificialPurchasingUrl:requestPurchaseHome_TabManual finshed:^(id dataResult,NSError *error) {
            
            _myLoadView.hidden = YES;
            
            [weakSelf.dataResultOR removeAllObjects];
            
            [weakSelf.allNotArray removeAllObjects];
            
            [weakSelf.countNotArray removeAllObjects];
            
            [weakSelf.cellAry removeAllObjects];
            
            if (!error) {
                
                [_paramsDict setObject:@"0" forKey:@"init"];
                
                weakSelf.dataResultOR = dataResult;
                
                for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                    
                    NSMutableArray *cellTwoAry = [NSMutableArray new];
                    
                    for (int j = 0;j < [weakSelf.dataResultOR[i]dataAryTwo].count;j++) {
                        
                        STWisdomEntity *entity = [weakSelf.dataResultOR[i]dataAryTwo][j];
                        
                        if (entity.isSelect.intValue == 1) {
                            
                            [weakSelf.countNotArray addObject:entity];
                        }
                        [weakSelf.allNotArray addObject:entity];
                        
                        static NSString *cellNameA = @"cellNameA";
                        
                        STWisdomNotShopTableViewCell *cell = [weakSelf.tableView dequeueReusableCellWithIdentifier:cellNameA];
                        
                        if (!cell) {
                            
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomNotShopTableViewCell" owner:self options:nil]lastObject];
                            
                            cell.delegate = self;
                        }
                        
                        [cellTwoAry addObject:cell];
                    }
                    
                    [weakSelf.cellAry addObject:cellTwoAry];
                }
                
                [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.allNotArray.count] type:2];
                
                [weakSelf.wisdomFooterView.iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%zi)",weakSelf.countNotArray.count] forState:UIControlStateNormal];
                
                if (weakSelf.dataResultOR .count != 0) {
                    if (_countNotArray.count == _allNotArray.count) {
                        
                        _isAllSelect = YES;
                        
                        [_wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                    }else{
                        [_wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                        
                        _isAllSelect = NO;
                    }
                }else{
                    [_wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                    
                    _isAllSelect = NO;
                }
            }else{
                
                [ZHProgressHUD showInfoWithText:@"暂无数据"];
                
                weakSelf.centrView.hidden = NO;
                
                if (topIndex == 0) {
                    
                    lab.text = @"暂无计划要审";
                    
                    imgV.image = [UIImage imageNamed:@"jihuan"];
                    
                }else if (topIndex == 1){
                    
                    lab.text = @"没有暂不采购的商品";
                    
                    imgV.image = [UIImage imageNamed:@"notCaigou"];
                    
                }else if (topIndex == 2){
                    
                    lab.text = @"没有暂不匹配的商品";
                    
                    imgV.image = [UIImage imageNamed:@"notPiPei"];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.dataResultOR.count != 0) {
                    
                    if (topIndex == 0) {
                        
                        weakSelf.wisdomFooterView.backgroundColor = RGB(249, 83, 32);
                        
                    }else if (topIndex == 1){
                        
                        weakSelf.wisdomFooterView.backgroundColor = RGB(77, 183, 98);
                        
                    }else if (topIndex == 2){
                        if (weakSelf.countNotArray.count != 0) {
                            weakSelf.wisdomFooterView.iphoneBtn.backgroundColor = RGB(77, 183, 98);
                        }else{
                            weakSelf.wisdomFooterView.iphoneBtn.backgroundColor = RGB(119, 119, 119);
                        }
                        
                        weakSelf.shareMaskView.hidden = NO;
                    }
                    
                    weakSelf.addMaskView.hidden = NO;
                    
                    weakSelf.deleteMaskView.hidden = NO;
                    
                    weakSelf.btnMaskView.hidden = NO;
                    
                }else{
                    
                    [ZHProgressHUD showInfoWithText:@"暂无数据"];
                    
                    _centrView.hidden = NO;
                    
                    lab.text = @"没有暂不匹配的商品";
                    
                    imgV.image = [UIImage imageNamed:@"notPiPei"];
                    
                }
                isSearch = YES;
                
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView.mj_header endRefreshing];
                
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
            
            _myLoadView.hidden = YES;
        }
    }];
}
#pragma mark - 人工采购分享接口
-(void)purchaseHome_TabManualShare:(NSDictionary *)params finshed:(void(^)(NSDictionary *paramsData,NSError *error))finshed{
    
    [KSMNetworkRequest getpurchaseHome_TabManualShareUrl:requestPurchaseHome_TabManualShare params:params finshed:^(NSDictionary *data, NSError *error) {
        
        if (!error) {
            
            finshed(data,nil);
        }
    }];
}
#pragma mark - 是否勾选品种
-(void)setChangeSelect:(NSDictionary *)params finshed:(void(^)(BOOL isYes))finshed{
    
    [KSMNetworkRequest setChangeSelectUrl:requestChangeSelect params:params finshed:^(BOOL isYes) {
        if (isYes) {
            finshed(isYes);
        }else{
            [ZHProgressHUD showInfoWithText:@"请求失败"];
        }
    }];
}

#pragma mark - 人工采购数量变化
-(void)setChangePurchaseCountForPsn:(NSDictionary *)params indexPath:(NSIndexPath *)indexPath finshed:(void(^)(BOOL isYes))finshed{
    [KSMNetworkRequest getChangePurchaseCountForPsnUrl:requestChangePurchaseCountForPsn params:params finshed:^(BOOL isYes) {
        if (isYes) {
            finshed(isYes);
        }else{
            [ZHProgressHUD showInfoWithText:@"请求失败"];
        }
    }];
}

#pragma mark - 判断有木有分享成功
-(void)setShareOfSuccess:(NSDictionary *)params finshed:(void(^)(BOOL isSuccess))finshed{
    [KSMNetworkRequest getShareOfSuccessUrl:requestPurchaseHome_TabManualShareFinsh params:params finshed:^(BOOL isSuccess) {
        if (isSuccess) {
            finshed(isSuccess);
        }else{
            [ZHProgressHUD showInfoWithText:@"分享失败"];
        }
    }];
}

-(void)myAddSubView{
    
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
#pragma mark -导航条
    STWisdomProcurementNavView *nav = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomProcurementNavView" owner:self options:nil]lastObject];
    nav.frame = CGRectMake(0, 0, kScreenWidth, kNavBarHeight);
    nav.dateLab.text = [NSString stringWithFormat:@"更新日期:%@",[[STCommon sharedSTSTCommon] setDate]];
    nav.WisdomProcurementNavViewBlock = ^(int type){
        
        [weakSelf disMissMasking];
        
        [weakSelf  setWisdomCollectionView];
        
        switch (type) {
                
            case 0://返回
                
                if (_controlScanBlock) {
                    
                    _controlScanBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                break;
                
            case 1://下啦list
                
                if (isSelectList) {
                    
                    weakSelf.selectListImgV.hidden = NO;
                    
                    isSelectList = NO;
                    
                    bgView.hidden = NO;
                    
                    if (topIndex == 0) {
                        isOpen = NO;
                        
                        _openView.hidden = YES;
                        
                        _searchView.hidden = YES;
                        
                        _scanView.hidden = YES;
                        
                        _searchLab.hidden = YES;
                        
                        _scanLab.hidden =  YES;
                        
                        _closeLab.hidden =  YES;
                        
                    }
                }else{
                    
                    weakSelf.selectListImgV.hidden = YES;
                    
                    isSelectList = YES;
                    
                    bgView.hidden = YES;
                }
                break;
                
            default:
                break;
        }
    };
    
    [self.view addSubview:nav];
    
    
#pragma mark - 采购类型view
    _wisdomHeadererView = [STWisdomHeadererView new];
    _wisdomHeadererView.frame = CGRectMake(0, 64, kScreenWidth, 40);
    _wisdomHeadererView.WisdomTopBtnBlock = ^(NSInteger tag){
        
        [weakSelf  setWisdomCollectionView];
        
        weakSelf.wisdomWeedOutView.hidden = YES;
        
        weakSelf.undoView.hidden = YES;
        
        isSelectList = YES;
        
        weakSelf.selectListImgV.hidden = YES;
        
        weakSelf.myLoadView.hidden = NO;
        
        weakSelf.centrView.hidden = YES;
        
        weakSelf.wisdomCollectionView.hidden = YES;
        
        isSelect = YES;
        
        isChange = NO;
        
        [weakSelf.dataResultOR removeAllObjects];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf disMissMasking];
        
        topIndex = tag;
        
        weakSelf.centrView.hidden = YES;
        
        if (tag == 0) {//
            
            isSearch = YES;
            
            weakSelf.notView.hidden = YES;
            
            weakSelf.footerVuew.frame = CGRectMake(0, 0, kScreenWidth, 70);
            
            weakSelf.wisdomBtnView.hidden = NO;
            
            weakSelf.tableView.frame = CGRectMake(0, 144, kScreenWidth, kScreenHeight - kNavBarHeight - 130);
            
            [weakSelf.wisdomFooterView setSTWisdomFooterView:0 index:@"0"];
            
            weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
            
            isOpen = YES;
            
            weakSelf.openView.hidden = NO;
            
            weakSelf.searchView.hidden = NO;
            
            weakSelf.scanView.hidden = NO;
            
        }else if(tag == 1){
            
            isSearch = YES;
            
            weakSelf.notView.hidden = YES;
            
            weakSelf.wisdomBtnView.hidden = YES;
            
            weakSelf.footerVuew.frame = CGRectMake(0, 0, kScreenWidth, 0);
            
            weakSelf.tableView.frame = CGRectMake(0, kNavBarHeight + 40, kScreenWidth, kScreenHeight - kNavBarHeight - 90);
            
            [weakSelf.wisdomFooterView setSTWisdomFooterView:1 index:@"0"];
            
            weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
            
            isOpen = NO;
            
            weakSelf.openView.hidden = YES;
            
            weakSelf.searchView.hidden = YES;
            
            weakSelf.scanView.hidden = YES;
            
            weakSelf.searchLab.hidden = YES;
            
            weakSelf.scanLab.hidden = YES;
            
            weakSelf.closeLab.hidden = YES;
            
        }else if (tag == 2){
            
            isSearch = YES;
            
            weakSelf.notView.hidden = NO;
            
            weakSelf.footerVuew.frame = CGRectMake(0, 0, kScreenWidth, 70);
            
            weakSelf.wisdomBtnView.hidden = YES;
            
            weakSelf.tableView.frame = CGRectMake(0, 104 + 50, kScreenWidth, kScreenHeight - kNavBarHeight - 90 - 50);
            
            [weakSelf.wisdomFooterView setSTWisdomFooterView:2 index:[NSString stringWithFormat:@"%zi",weakSelf.countNotArray.count]];
            
            weakSelf.wisdomFooterView.backgroundColor = RGB(255, 255, 255);
            
            weakSelf.wisdomFooterView.iphoneBtn.backgroundColor = RGB(119, 119, 119);
            
            isOpen = NO;
            
            weakSelf.openView.hidden = YES;
            
            weakSelf.searchView.hidden = YES;
            
            weakSelf.scanView.hidden = YES;
            
            weakSelf.searchLab.hidden = YES;
            
            weakSelf.scanLab.hidden = YES;
            
            weakSelf.closeLab.hidden = YES;
        }
        
        if (topIndex == 0) {
            
            [weakSelf.paramsDict setObject:@"0" forKey:@"tab"];
            
            if (letterIndex == 0) {
                
                weakSelf.type = 2;
                
                [weakSelf.tableView.mj_header beginRefreshing];
                
            }else if (letterIndex == 1){
                
                weakSelf.type = 1;
                
                [weakSelf.tableView.mj_header beginRefreshing];
                
            }else if (letterIndex == 1){
                
                weakSelf.type = 0;
                
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        }else if(topIndex == 1){
            
            [weakSelf.paramsDict setObject:@"2" forKey:@"tab"];
            
            weakSelf.type = 2;
            
            [weakSelf.tableView.mj_header beginRefreshing];
            
        }else if(topIndex == 2){
            
            [weakSelf.paramsDict setObject:@"1" forKey:@"tab"];
            
            weakSelf.type = 3;
            
            [weakSelf.tableView.mj_header beginRefreshing];
        }
        
        [weakSelf.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        
    };
    [self.view addSubview:_wisdomHeadererView];
    
#pragma mark - 人工采购
    _notView = [STWisdomNotView new];
    _notView.hidden = YES;
    _notView.frame = CGRectMake(0, 104, kScreenWidth, 50);
    [_notView setError:@"因条码错误等原因造成的匹配失败的商品可在ERP中添加或修改为正确的条码信息,系统将自动同步."];
    [self.view addSubview:_notView];
    
    
#pragma mark - 排序方式
    _wisdomBtnView = [STWisdomBtnView new];
    _wisdomBtnView.frame = CGRectMake(0, 104, kScreenWidth, 40);
    _wisdomBtnView.WisdomBtnBlock = ^(NSInteger tag){
        
        [weakSelf  setWisdomCollectionView];
        
        weakSelf.wisdomWeedOutView.hidden = YES;
        
        weakSelf.undoView.hidden = YES;
        
        isSelectList = YES;
        
        weakSelf.selectListImgV.hidden = YES;
        
        weakSelf.wisdomCollectionView.hidden = YES;
        
        isSelect = YES;
        
        isChange = NO;
        
        weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
        
        weakSelf.centrView.hidden = YES;
        
        [weakSelf disMissMasking];
        
        switch (tag) {
                
            case 0:{
                letterIndex = tag;
                
                weakSelf.myLoadView.hidden = NO;
                
                [weakSelf.dataResultOR removeAllObjects];
                
                [weakSelf.tableView reloadData];
                
                [weakSelf.paramsDict setObject:@"2" forKey:@"order"];
                
                weakSelf.type = 2;
                
                [weakSelf.tableView.mj_header beginRefreshing];
                
                break;
            }
            case 1:{
                
                weakSelf.type = 0;
                
                letterIndex = tag;
                
                weakSelf.myLoadView.hidden = NO;
                
                [weakSelf.dataResultOR removeAllObjects];
                
                [weakSelf.tableView reloadData];
                
                [weakSelf.paramsDict setObject:@"0" forKey:@"order"];
                
                [weakSelf.tableView.mj_header beginRefreshing];
                
                break;
            }
            case 2:{
                
                weakSelf.wisdomFooterView.backgroundColor = RGB(249, 83, 32);
                
                
                if (weakSelf.isWisdomFilterView) {
                    weakSelf.isWisdomFilterView = NO;
                    [UIView animateWithDuration:.2 animations:^{
                        weakSelf.wisdomFilterView.frame = CGRectMake(0, 144, kScreenWidth, 40);
                        [weakSelf.wisdomFilterView setWisdomFilterViewHieght:40];
                    }];
                }else{
                    weakSelf.isWisdomFilterView = YES;
                    [UIView animateWithDuration:.2 animations:^{
                        weakSelf.wisdomFilterView.frame = CGRectMake(0, 144, kScreenWidth, 0);
                        [weakSelf.wisdomFilterView setWisdomFilterViewHieght:0];
                    }];
                }
                break;
            }
            default:
                break;
        }
        
        [weakSelf.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    };
    [self.view addSubview:_wisdomBtnView];
    
    
    _footerVuew = [UIView new];
    _footerVuew.frame = CGRectMake(0, 104, kScreenWidth, 70);
    
#pragma mark - tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 144, kScreenWidth, kScreenHeight - kNavBarHeight - 130)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.sectionIndexColor = RGB(51, 51, 51);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.tableFooterView =  _footerVuew;
    _tableView.userInteractionEnabled = YES;
    [self.view addSubview:_tableView];
    
    
    UISwipeGestureRecognizer *disTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(disMissMasking)];
    disTap.delegate = self;
    [self.tableView addGestureRecognizer:disTap];
    
    
    _letterLab = [UILabel new];
    _letterLab.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    _letterLab.textColor = RGB(85, 85, 85);
    _letterLab.textAlignment = NSTextAlignmentCenter;
    _letterLab.layer.masksToBounds = YES;
    _letterLab.layer.cornerRadius = 5.0f;
    _letterLab.frame = CGRectMake(kScreenWidth/2 - 20, kScreenHeight/2 - 20, 40, 40);
    _letterLab.hidden = YES;
    _letterLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_letterLab];
    
#pragma mark - 低部按钮
    _wisdomFooterView = [STWisdomFooterView new];
    _wisdomFooterView.backgroundColor = RGB(119, 119, 119);
    _wisdomFooterView.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    [_wisdomFooterView setSTWisdomFooterView:0 index:0];
    _wisdomFooterView.STWisdomBlock = ^(NSInteger tag){
        
        [weakSelf  setWisdomCollectionView];
        
        if (tag == 0) {
            
            if (weakSelf.countArray.count != 0) {
                
                weakSelf.wisdomFooterView.gouBtn.enabled = NO;
                
                [weakSelf disMissMasking];
                
                NSMutableArray *jsonArray = [NSMutableArray new];
                
                for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                    
                    NSArray *ary = weakSelf.dataResultOR[i];
                    
                    for (int j = 0;j < ary.count;j++) {
                        
                        STWisdomEntity *entity = ary[j];
                        
                        if (entity.isSelect.intValue == 1) {
                            
                            NSMutableDictionary *dict = [NSMutableDictionary new];
                            
                            [dict setValue:entity.Goods_Package_ID forKey:@"Goods_Package_ID"];
                            
                            [dict setValue:weakSelf.indexAry[i][j] forKey:@"buyCount"];
                            
                            [jsonArray addObject:dict];
                        }
                    }
                }
                
#pragma mark - 智慧采购审计划批量提交购买数量
                
                [KSMNetworkRequest getBatchSubmitForPurchaseHomeUrl:requestBatchSubmitForPurchaseHome params:@{@"data":jsonArray.mj_JSONString} finshed:^(NSString *code, NSError *error) {
                    
                    weakSelf.wisdomFooterView.gouBtn.enabled = YES;
                    
                    if (!error) {
                        
                        if (code.intValue == 200) {
                            
                            WisdomShopViewController *wisdomShopVC = [WisdomShopViewController new];
                            
                            wisdomShopVC.WisdomBackBlock = ^(void){
                                
                                [weakSelf.dataResultOR removeAllObjects];
                                
                                [weakSelf.countArray removeAllObjects];
                                
                                [weakSelf.countNotArray removeAllObjects];
                                
                                [weakSelf.wisdomFooterView.iphoneBtn setTitle:@"发送(0)" forState:UIControlStateNormal];
                                
                                [weakSelf.wisdomFooterView.gouBtn setTitle:@"生成采购方案(0)" forState:UIControlStateNormal];
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.tableView.mj_header beginRefreshing];
                            };
                            
                            [weakSelf.navigationController pushViewController:wisdomShopVC animated:YES];
                        }
                    }
                }];
            }else{
                
                [ZHProgressHUD showInfoWithText:@"暂无数据"];
            }
        }else if(tag == 2){
            
#pragma mark - 人工采购发送分享
            
            if (weakSelf.countNotArray.count != 0) {
                
                [weakSelf disMissMasking];
                
                NSMutableArray *idAry = [NSMutableArray new];
                
                for (STWisdomEntity *entity in weakSelf.countNotArray) {
                    
                    [idAry addObject:entity.memberID];
                }
                
                NSString *tempString = [idAry componentsJoinedByString:@","];//分隔符逗号
                
                [weakSelf purchaseHome_TabManualShare:@{@"id":tempString} finshed:^(NSDictionary *paramsData,NSError *error) {
                    
                    if (!error) {
                        
                        isShare = YES;
                        
                        jsonStr = tempString;
                        
                        [[STCommon sharedSTSTCommon] setShare:@{@"title":paramsData[@"title"],@"image":@"hudST_logo",@"url":paramsData[@"url"],@"descr":paramsData[@"descr"]} shareView:weakSelf Finished:^(BOOL isSuccessful) {
                            
                            if (isSuccessful) {
                                
                                isShare = YES;
                                
                            }else{
                                
                                isShare = NO;
                                
                            }
                        }];
                    }
                }];
            }else{
                
                [ZHProgressHUD showInfoWithText:@"暂无数据"];
            }
        }else if(tag == 1){
            
            if (weakSelf.dataResultOR.count != 0) {
                
                [weakSelf cancelDeletePurchaseForPsn:@{@"psn":@""} indexPath:nil];
                
            }else{
                
                [ZHProgressHUD showInfoWithText:@"暂无数据"];
            }
        }
    };
#pragma mark - 人工采购全选
    _wisdomFooterView.STWisdomselectAllBlock = ^{
        
        [weakSelf  setWisdomCollectionView];
        
        [weakSelf disMissMasking];
        
        if (weakSelf.dataResultOR.count != 0) {
            
            if (weakSelf.isAllSelect) {
                
                NSMutableArray *idAry = [NSMutableArray new];
                
                for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                    
                    for (int j = 0; j < [weakSelf.dataResultOR[i] dataAryTwo].count; j++) {
                        
                        STWisdomEntity *entity = [weakSelf.dataResultOR[i] dataAryTwo][j];
                        
                        [idAry addObject:entity.memberID];
                    }
                }
                
                NSString *tempString = [idAry componentsJoinedByString:@","];//分隔符逗号
                
                [weakSelf setChangeSelect:@{@"id":tempString,@"isSelect":@"false"} finshed:^(BOOL isYes) {
                    
                    if (isYes) {
                        weakSelf.isAllSelect = NO;
                        
                        for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                            
                            for (int j = 0; j < [weakSelf.dataResultOR[i] dataAryTwo].count; j++) {
                                
                                STWisdomEntity *entity = [weakSelf.dataResultOR[i] dataAryTwo][j];
                                
                                entity.isSelect = @"0";
                                
                                [[weakSelf.dataResultOR[i] dataAryTwo] replaceObjectAtIndex:j withObject:entity];
                            }
                        }
                        
                        [weakSelf.countNotArray removeAllObjects];
                        
                        [weakSelf.sectionAry removeAllObjects];
                        
                        [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                        
                        [weakSelf.wisdomFooterView.iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%zi)",weakSelf.countNotArray.count] forState:UIControlStateNormal];
                        
                        [weakSelf changeWisdomFooterViewBackgroundColor];
                        
                        for (int i = 0; i < weakSelf.cellAry.count; i++) {
                            for (STWisdomNotShopTableViewCell *cell in weakSelf.cellAry[i]) {
                                [cell.selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                            }
                            
                            UIButton *btn = [weakSelf.view viewWithTag:selectBtn_tag + i];
                            [btn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                        }
                    }
                    
                }];
                
            }else{
                
                NSMutableArray *idAry = [NSMutableArray new];
                
                for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                    
                    for (int j = 0; j < [weakSelf.dataResultOR[i] dataAryTwo].count; j++) {
                        
                        STWisdomEntity *entity = [weakSelf.dataResultOR[i] dataAryTwo][j];
                        
                        [idAry addObject:entity.memberID];
                    }
                }
                
                NSString *tempString = [idAry componentsJoinedByString:@","];//分隔符逗号
                
                [weakSelf setChangeSelect:@{@"id":tempString,@"isSelect":@"true"} finshed:^(BOOL isYes) {
                    
                    if (isYes) {
                        
                        weakSelf.isAllSelect = YES;
                        
                        for (int i = 0; i < weakSelf.dataResultOR.count; i++) {
                            
                            for (int j = 0; j < [weakSelf.dataResultOR[i] dataAryTwo].count; j++) {
                                
                                STWisdomEntity *entity = [weakSelf.dataResultOR[i] dataAryTwo][j];
                                
                                if (entity.isSelect.intValue == 0) {
                                    
                                    entity.isSelect = @"1";
                                    
                                    [weakSelf.countNotArray addObject:entity];
                                }
                                
                                [[weakSelf.dataResultOR[i] dataAryTwo] replaceObjectAtIndex:j withObject:entity];
                                
                            }
                            
                            [weakSelf.sectionAry addObject:[weakSelf.dataResultOR[i] supplierName]];
                        }
                        
                        [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                        
                        [weakSelf.wisdomFooterView.iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%zi)",weakSelf.countNotArray.count] forState:UIControlStateNormal];
                        
                        [weakSelf changeWisdomFooterViewBackgroundColor];
                        
                        for (int i = 0; i < weakSelf.cellAry.count; i++) {
                            for (STWisdomNotShopTableViewCell *cell in weakSelf.cellAry[i]) {
                                [cell.selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                            }
                            UIButton *btn = [weakSelf.view viewWithTag:selectBtn_tag + i];
                            [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                        }
                    }
                }];
            }
        }else{
            
            [ZHProgressHUD showInfoWithText:@"暂无数据"];
        }
    };
    [self.view addSubview:_wisdomFooterView];
    
#pragma mark - 下拉筛选框
    
    _isWisdomFilterView = YES;
    
    _filterIndex = 0;
    
    _selectFilterBtnTitle = @"筛选";
    
    _wisdomFilterView = [STWisdomFilterView new];
    _wisdomFilterView.frame = CGRectMake(0, 144, kScreenWidth, 0);
    [_wisdomFilterView setWisdomFilterViewHieght:0];
    _wisdomFilterView.WisdomFilterViewBlock = ^(NSInteger index){
        
        switch (index) {
            case 0:
                weakSelf.selectFilterBtnTitle = @"筛选";
                break;
            case 1:
                weakSelf.selectFilterBtnTitle = @"已选";
                break;
            case 2:
                weakSelf.selectFilterBtnTitle = @"未选";
                break;
                
            default:
                break;
        }
        
        weakSelf.filterIndex = index;
        
        [weakSelf  setWisdomCollectionView];
        
        weakSelf.wisdomWeedOutView.hidden = YES;
        
        weakSelf.undoView.hidden = YES;
        
        isSelectList = YES;
        
        weakSelf.selectListImgV.hidden = YES;
        
        weakSelf.wisdomCollectionView.hidden = YES;
        
        isSelect = YES;
        
        isChange = NO;
        
        weakSelf.centrView.hidden = YES;
        
        [weakSelf disMissMasking];
        
        weakSelf.isWisdomFilterView = YES;
        
        [UIView animateWithDuration:.2 animations:^{
            
            weakSelf.wisdomFilterView.frame = CGRectMake(0, 144, kScreenWidth, 0);
            
             [weakSelf.wisdomBtnView selectFilterBtn:weakSelf.selectFilterBtnTitle];
            
            [weakSelf.wisdomFilterView setWisdomFilterViewHieght:0];
            
            weakSelf.wisdomBtnView.isSeleceted = YES;
            
        }];
        
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:_wisdomFilterView];
    
    
#pragma mark - 下拉数量单
    _wisdomCollectionView = [[STWisdomCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 0, 0, 0)];
    _wisdomCollectionView.titles = nil;
    _wisdomCollectionView.layer.masksToBounds = YES;
    _wisdomCollectionView.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _wisdomCollectionView.layer.borderWidth = .5;
    _wisdomCollectionView.layer.cornerRadius = 3.0f;
    _wisdomCollectionView.WisdomCollectionViewBlock = ^(NSString *text){
        
        if (topIndex == 2) {
            
            STWisdomEntity *entity = [weakSelf.dataResultOR[weakSelf.mIndexPath.section] dataAryTwo][weakSelf.mIndexPath.row];
            
            entity.buyCount = text;
            
            [[weakSelf.dataResultOR[weakSelf.mIndexPath.section] dataAryTwo] replaceObjectAtIndex:weakSelf.mIndexPath.row withObject:entity];
            
            STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[weakSelf.tableView cellForRowAtIndexPath:weakSelf.mIndexPath];
            
            cell.textTextField.text = text;
            
            weakSelf.wisdomCollectionView.hidden = YES;
            
            [weakSelf setChangePurchaseCountForPsn:@{@"psn":[[weakSelf.dataResultOR[weakSelf.mIndexPath.section] dataAryTwo][weakSelf.mIndexPath.row] psn],@"num":text} indexPath:weakSelf.mIndexPath finshed:^(BOOL isYes) {
                
                if (isYes) {
                    return ;
                }
            }];
        }else{
            [weakSelf disMissMasking];
            
            [weakSelf.indexAry[weakSelf.mIndexPath.section] replaceObjectAtIndex:weakSelf.mIndexPath.row withObject:text];
            
            isSelect = YES;
            
            isChange = YES;
            
            STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[weakSelf.tableView cellForRowAtIndexPath:weakSelf.mIndexPath];
            
            cell.textTextField.text = text;
            
            weakSelf.wisdomCollectionView.hidden = YES;
            
            [weakSelf changePurchaseCountParams:@{@"Goods_Package_ID":[weakSelf.dataResultOR[weakSelf.mIndexPath.section][weakSelf.mIndexPath.row] Goods_Package_ID],@"num":text} indexPath:weakSelf.mIndexPath finshed:^(BOOL isYes) {
                
                if (isYes) {
                    return ;
                }
            }];
        }
    };
    
    _wisdomCollectionView.hidden = YES;
    
    
    _centrView = [UIView new];
    _centrView.hidden = YES;
    _centrView.frame = CGRectMake(kScreenWidth/2 - 75, kScreenHeight/2 - 75, 150, 150);
    [self.view addSubview:_centrView];
    
    
    imgV =[UIImageView new];
    imgV.frame = CGRectMake(_centrView.frame.size.width/2 - 60, 0, 120, 120);
    [_centrView addSubview:imgV];
    
    
    lab = [UILabel new];
    lab.frame = CGRectMake(0, _centrView.frame.size.height - 30, _centrView.frame.size.width, 30);
    lab.text = @"暂无数据";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
    lab.textAlignment = NSTextAlignmentCenter;
    [_centrView addSubview:lab];
    
#pragma mark - 撤销删除
    _undoView = [STWisdomUndoView new];
    _undoView.hidden = YES;
    _undoView.frame = CGRectMake(0, kScreenHeight - 93, kScreenWidth, 44);
    _undoView.WisdomUndoViewBlock = ^(void){
        
        [weakSelf disMissMasking];
        
        weakSelf.undoView.hidden = YES;
        
        if (regainKeepTime != 0) {
            
            switch (weakSelf.filterIndex) {
                case 0:{
                    if (weakSelf.removeDataResultOR.count == 1) {
                        
                        [weakSelf cancelDeletePurchaseEliminateForId:@{@"id":[weakSelf.removeDataResultOR[0][0] memberID]} finshed:^(BOOL isYes) {
                            
                            if (isYes) {
                                
                                if (topIndex == 0) {
                                    
                                    weakSelf.matchingCount = weakSelf.matchingCount + 1;
                                    
                                    if (weakSelf.matchingCount < 0) {
                                        
                                        weakSelf.matchingCount = 0;
                                    }
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                                    
                                    weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  - 1;
                                    
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                                }
                                
                                if (weakSelf.isFirst) {
                                    
                                    [weakSelf.dataResultOR insertObject:weakSelf.removeDataResultOR[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    [weakSelf.indexAry insertObject:weakSelf.removeIndexAry[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    weakSelf.isFirst = NO;
                                    
                                }else{
                                    
                                    NSMutableArray *newAry = [weakSelf.dataResultOR[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    NSMutableArray *newIndex = [weakSelf.indexAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    [newAry insertObject:weakSelf.removeDataResultOR[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    [newIndex insertObject:weakSelf.removeIndexAry[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    
                                    [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newAry];
                                    
                                    [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newIndex];
                                }
                                if(weakSelf.dataResultOR.count != 0){
                                    
                                    weakSelf.centrView.hidden = YES;
                                    
                                    [weakSelf.countArray removeAllObjects];
                                    
                                    for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                        
                                        NSArray *ary = weakSelf.dataResultOR[i];
                                        
                                        for (int j = 0;j < ary.count;j++) {
                                            
                                            STWisdomEntity *entity = ary[j];
                                            
                                            if (entity.isSelect.intValue == 1) {
                                                
                                                [weakSelf.countArray addObject:entity];
                                            }
                                        }
                                    }
                                    
                                    [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                                }
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.removeDataResultOR removeAllObjects];
                                
                                [weakSelf.removeIndexAry removeAllObjects];
                                
                            }else{
                                
                                [weakSelf.removeDataResultOR removeAllObjects];
                                
                                [weakSelf.removeIndexAry removeAllObjects];
                            }
                        }];
                    }else{
                        
                        if(weakSelf.dataResultOR.count != 0){
                            
                            weakSelf.centrView.hidden = YES;
                        }
                        
                        [weakSelf.removeDataResultOR removeAllObjects];
                        
                        [weakSelf.removeIndexAry removeAllObjects];
                    }
                    break;
                }
                case 1:{
                    if (weakSelf.removeDataResultOR.count == 1) {
                        
                        [weakSelf cancelDeletePurchaseEliminateForId:@{@"id":[weakSelf.removeDataResultOR[0][0] memberID]} finshed:^(BOOL isYes) {
                            
                            if (isYes) {
                                
                                if (topIndex == 0) {
                                    
                                    weakSelf.matchingCount = weakSelf.matchingCount + 1;
                                    
                                    if (weakSelf.matchingCount < 0) {
                                        
                                        weakSelf.matchingCount = 0;
                                    }
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                                    
                                    weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  - 1;
                                    
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                                }
                                
                                if (weakSelf.isFirst) {
                                    
                                    [weakSelf.selectAllAry insertObject:weakSelf.removeDataResultOR[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    [weakSelf.selectAllIndexAry insertObject:weakSelf.removeIndexAry[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.removeDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.removeIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.removeDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.removeIndexAry[0] atIndex:weakSelf.removeSection];
                                    }
                                    
                                    weakSelf.isFirst = NO;
                                    
                                }else{
                                    
                                    NSMutableArray *newAry = [weakSelf.selectAllAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    NSMutableArray *newIndex = [weakSelf.selectAllIndexAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    [newAry insertObject:weakSelf.removeDataResultOR[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    [newIndex insertObject:weakSelf.removeIndexAry[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    
                                    [weakSelf.selectAllAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newAry];
                                    
                                    [weakSelf.selectAllIndexAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newIndex];
                                    
                                    
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.removeDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.removeIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.removeDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.removeIndexAry[0] atIndex:weakSelf.removeSection];
                                    }
                                }
                                
                                
                                if(weakSelf.dataResultOR.count != 0){
                                    
                                    weakSelf.centrView.hidden = YES;
                                    
                                    [weakSelf.countArray removeAllObjects];
                                    
                                    for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                        
                                        NSArray *ary = weakSelf.dataResultOR[i];
                                        
                                        for (int j = 0;j < ary.count;j++) {
                                            
                                            STWisdomEntity *entity = ary[j];
                                            
                                            if (entity.isSelect.intValue == 1) {
                                                
                                                [weakSelf.countArray addObject:entity];
                                            }
                                        }
                                    }
                                    
                                    [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                                }
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.removeDataResultOR removeAllObjects];
                                
                                [weakSelf.removeIndexAry removeAllObjects];
                                
                            }else{
                                
                                [weakSelf.removeDataResultOR removeAllObjects];
                                
                                [weakSelf.removeIndexAry removeAllObjects];
                            }
                        }];
                    }else{
                        
                        if(weakSelf.selectAllAry.count != 0){
                            
                            weakSelf.centrView.hidden = YES;
                        }
                        
                        [weakSelf.removeDataResultOR removeAllObjects];
                        
                        [weakSelf.removeIndexAry removeAllObjects];
                    }
                    
                    break;
                }
                case 2:{
                    if (weakSelf.removeDataResultOR.count == 1) {
                        
                        [weakSelf cancelDeletePurchaseEliminateForId:@{@"id":[weakSelf.removeDataResultOR[0][0] memberID]} finshed:^(BOOL isYes) {
                            
                            if (isYes) {
                                
                                if (topIndex == 0) {
                                    
                                    weakSelf.matchingCount = weakSelf.matchingCount + 1;
                                    
                                    if (weakSelf.matchingCount < 0) {
                                        
                                        weakSelf.matchingCount = 0;
                                    }
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                                    
                                    weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  - 1;
                                    
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                                }
                                
                                if (weakSelf.isFirst) {
                                    
                                    [weakSelf.notSelectAllAry insertObject:weakSelf.removeDataResultOR[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    [weakSelf.notSelectAllIndexAry insertObject:weakSelf.removeIndexAry[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.removeDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.removeIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.removeDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.removeIndexAry[0] atIndex:weakSelf.removeSection];
                                    }
                                    
                                    weakSelf.isFirst = NO;
                                    
                                }else{
                                    
                                    NSMutableArray *newAry = [weakSelf.notSelectAllAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    NSMutableArray *newIndex = [weakSelf.notSelectAllIndexAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    [newAry insertObject:weakSelf.removeDataResultOR[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    [newIndex insertObject:weakSelf.removeIndexAry[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    
                                    [weakSelf.notSelectAllAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newAry];
                                    
                                    [weakSelf.notSelectAllIndexAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newIndex];
                                    
                                    
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.removeDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.removeIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.removeDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.removeIndexAry[0] atIndex:weakSelf.removeSection];
                                    }
                                    
                                }
                                if(weakSelf.dataResultOR.count != 0){
                                    
                                    weakSelf.centrView.hidden = YES;
                                    
                                    [weakSelf.countArray removeAllObjects];
                                    
                                    for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                        
                                        NSArray *ary = weakSelf.dataResultOR[i];
                                        
                                        for (int j = 0;j < ary.count;j++) {
                                            
                                            STWisdomEntity *entity = ary[j];
                                            
                                            if (entity.isSelect.intValue == 1) {
                                                
                                                [weakSelf.countArray addObject:entity];
                                            }
                                        }
                                    }
                                    
                                    [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                                }
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.removeDataResultOR removeAllObjects];
                                
                                [weakSelf.removeIndexAry removeAllObjects];
                                
                            }else{
                                
                                [weakSelf.removeDataResultOR removeAllObjects];
                                
                                [weakSelf.removeIndexAry removeAllObjects];
                            }
                        }];
                    }else{
                        
                        if(weakSelf.notSelectAllAry.count != 0){
                            
                            weakSelf.centrView.hidden = YES;
                        }
                        
                        [weakSelf.removeDataResultOR removeAllObjects];
                        
                        [weakSelf.removeIndexAry removeAllObjects];
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
    };
    
    [self.view addSubview:_undoView];
    
#pragma mark - 撤销淘汰
    _wisdomWeedOutView = [STWisdomWeedOutView new];
    _wisdomWeedOutView.hidden = YES;
    _wisdomWeedOutView.frame = CGRectMake(0, kScreenHeight - 93, kScreenWidth, 44);
    _wisdomWeedOutView.WisdomWeedOutViewBlock = ^(void){
        
        [weakSelf disMissMasking];
        
        weakSelf.wisdomWeedOutView.hidden = YES;
        
        if (regainKeepTime != 0) {
            
            switch (weakSelf.filterIndex) {
                case 0:{
                    if (weakSelf.weedOutDataResultOR.count == 1) {
                        
                        [weakSelf cancelDeletePurchaseEliminateForId:@{@"id":[weakSelf.weedOutDataResultOR[0][0] memberID]} finshed:^(BOOL isYes) {
                            
                            if (isYes) {
                                
                                if (topIndex == 0) {
                                    
                                    weakSelf.matchingCount = weakSelf.matchingCount + 1;
                                    
                                    if (weakSelf.matchingCount < 0) {
                                        
                                        weakSelf.matchingCount = 0;
                                    }
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                                    
                                    weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  - 1;
                                    
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                                }
                                
                                if (weakSelf.isFirst) {
                                    
                                    [weakSelf.dataResultOR insertObject:weakSelf.weedOutDataResultOR[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    [weakSelf.indexAry insertObject:weakSelf.weedOutIndexAry[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    weakSelf.isFirst = NO;
                                    
                                }else{
                                    
                                    NSMutableArray *newAry = [weakSelf.dataResultOR[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    NSMutableArray *newIndex = [weakSelf.indexAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    [newAry insertObject:weakSelf.weedOutDataResultOR[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    [newIndex insertObject:weakSelf.weedOutIndexAry[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    
                                    [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newAry];
                                    
                                    [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newIndex];
                                }
                                if(weakSelf.dataResultOR.count != 0){
                                    
                                    weakSelf.centrView.hidden = YES;
                                    
                                    [weakSelf.countArray removeAllObjects];
                                    
                                    for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                        
                                        NSArray *ary = weakSelf.dataResultOR[i];
                                        
                                        for (int j = 0;j < ary.count;j++) {
                                            
                                            STWisdomEntity *entity = ary[j];
                                            
                                            if (entity.isSelect.intValue == 1) {
                                                
                                                [weakSelf.countArray addObject:entity];
                                            }
                                        }
                                    }
                                    
                                    [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                                }
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.weedOutDataResultOR removeAllObjects];
                                
                                [weakSelf.weedOutIndexAry removeAllObjects];
                                
                            }else{
                                
                                [weakSelf.weedOutDataResultOR removeAllObjects];
                                
                                [weakSelf.weedOutIndexAry removeAllObjects];
                            }
                        }];
                    }else{
                        if(weakSelf.dataResultOR.count != 0){
                            
                            weakSelf.centrView.hidden = YES;
                        }
                        
                        [weakSelf.weedOutDataResultOR removeAllObjects];
                        
                        [weakSelf.weedOutIndexAry removeAllObjects];
                    }
                    
                    break;
                }
                case 1:{
                    if (weakSelf.weedOutDataResultOR.count == 1) {
                        
                        [weakSelf cancelDeletePurchaseEliminateForId:@{@"id":[weakSelf.weedOutDataResultOR[0][0] memberID]} finshed:^(BOOL isYes) {
                            
                            if (isYes) {
                                
                                if (topIndex == 0) {
                                    
                                    weakSelf.matchingCount = weakSelf.matchingCount + 1;
                                    
                                    if (weakSelf.matchingCount < 0) {
                                        
                                        weakSelf.matchingCount = 0;
                                    }
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                                    
                                    weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  - 1;
                                    
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                                }
                                
                                if (weakSelf.isFirst) {
                                    
                                    [weakSelf.selectAllAry insertObject:weakSelf.weedOutDataResultOR[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    [weakSelf.selectAllIndexAry insertObject:weakSelf.weedOutIndexAry[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                  
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.weedOutDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.weedOutIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.weedOutDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.weedOutIndexAry[0] atIndex:weakSelf.removeSection];
                                    }

                                    weakSelf.isFirst = NO;
                                    
                                }else{
                                    
                                    NSMutableArray *newAry = [weakSelf.selectAllAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    NSMutableArray *newIndex = [weakSelf.selectAllIndexAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    [newAry insertObject:weakSelf.weedOutDataResultOR[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    [newIndex insertObject:weakSelf.weedOutIndexAry[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    
                                    [weakSelf.selectAllAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newAry];
                                    
                                    [weakSelf.selectAllIndexAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newIndex];
                                    
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.weedOutDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.weedOutIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.weedOutDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.weedOutIndexAry[0] atIndex:weakSelf.removeSection];
                                    }
                                }
                                if(weakSelf.dataResultOR.count != 0){
                                    
                                    weakSelf.centrView.hidden = YES;
                                    
                                    [weakSelf.countArray removeAllObjects];
                                    
                                    for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                        
                                        NSArray *ary = weakSelf.dataResultOR[i];
                                        
                                        for (int j = 0;j < ary.count;j++) {
                                            
                                            STWisdomEntity *entity = ary[j];
                                            
                                            if (entity.isSelect.intValue == 1) {
                                                
                                                [weakSelf.countArray addObject:entity];
                                            }
                                        }
                                    }
                                    
                                    [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                                }
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.weedOutDataResultOR removeAllObjects];
                                
                                [weakSelf.weedOutIndexAry removeAllObjects];
                                
                            }else{
                                
                                [weakSelf.weedOutDataResultOR removeAllObjects];
                                
                                [weakSelf.weedOutIndexAry removeAllObjects];
                            }
                        }];
                    }else{
                        if(weakSelf.selectAllAry.count != 0){
                            
                            weakSelf.centrView.hidden = YES;
                        }
                        
                        [weakSelf.weedOutDataResultOR removeAllObjects];
                        
                        [weakSelf.weedOutIndexAry removeAllObjects];
                    }
                    
                    break;
                }
                case 2:{
                    if (weakSelf.weedOutDataResultOR.count == 1) {
                        
                        [weakSelf cancelDeletePurchaseEliminateForId:@{@"id":[weakSelf.weedOutDataResultOR[0][0] memberID]} finshed:^(BOOL isYes) {
                            
                            if (isYes) {
                                
                                if (topIndex == 0) {
                                    
                                    weakSelf.matchingCount = weakSelf.matchingCount + 1;
                                    
                                    if (weakSelf.matchingCount < 0) {
                                        
                                        weakSelf.matchingCount = 0;
                                    }
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.matchingCount] type:0];
                                    
                                    weakSelf.notPurchaseCount = weakSelf.notPurchaseCount  - 1;
                                    
                                    [weakSelf.wisdomHeadererView setNumStr:[NSString stringWithFormat:@"%zi",weakSelf.notPurchaseCount] type:1];
                                }
                                
                                if (weakSelf.isFirst) {
                                    
                                    [weakSelf.notSelectAllAry insertObject:weakSelf.weedOutDataResultOR[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    [weakSelf.notSelectAllIndexAry insertObject:weakSelf.weedOutIndexAry[0] atIndex:weakSelf.mIndexPath2.section];
                                    
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.weedOutDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.weedOutIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.weedOutDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.weedOutIndexAry[0] atIndex:weakSelf.removeSection];
                                    }
                                    
                                    weakSelf.isFirst = NO;
                                    
                                }else{
                                    
                                    NSMutableArray *newAry = [weakSelf.notSelectAllAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    NSMutableArray *newIndex = [weakSelf.notSelectAllIndexAry[weakSelf.mIndexPath2.section] mutableCopy];
                                    
                                    [newAry insertObject:weakSelf.weedOutDataResultOR[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    [newIndex insertObject:weakSelf.weedOutIndexAry[0][0] atIndex:weakSelf.mIndexPath2.row];
                                    
                                    
                                    [weakSelf.notSelectAllAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newAry];
                                    
                                    [weakSelf.notSelectAllIndexAry  replaceObjectAtIndex:weakSelf.mIndexPath2.section withObject:newIndex];
                                    
                                    NSMutableArray *newAryTwo = [weakSelf.dataResultOR[weakSelf.removeSection] mutableCopy];
                                    
                                    NSMutableArray *newIndexTwo = [weakSelf.indexAry[weakSelf.removeSection] mutableCopy];
                                    
                                    if (newAryTwo.count != 0) {
                                        [newAryTwo insertObject:weakSelf.weedOutDataResultOR[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [newIndexTwo insertObject:weakSelf.weedOutIndexAry[0][0] atIndex:weakSelf.removeRow];
                                        
                                        [weakSelf.dataResultOR  replaceObjectAtIndex:weakSelf.removeSection withObject:newAryTwo];
                                        
                                        [weakSelf.indexAry  replaceObjectAtIndex:weakSelf.removeSection withObject:newIndexTwo];
                                    }else{
                                        [weakSelf.dataResultOR insertObject:weakSelf.weedOutDataResultOR[0] atIndex:weakSelf.removeSection];
                                        
                                        [weakSelf.indexAry insertObject:weakSelf.weedOutIndexAry[0] atIndex:weakSelf.removeSection];
                                    }
                                }
                                if(weakSelf.dataResultOR.count != 0){
                                    
                                    weakSelf.centrView.hidden = YES;
                                    
                                    [weakSelf.countArray removeAllObjects];
                                    
                                    for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                                        
                                        NSArray *ary = weakSelf.dataResultOR[i];
                                        
                                        for (int j = 0;j < ary.count;j++) {
                                            
                                            STWisdomEntity *entity = ary[j];
                                            
                                            if (entity.isSelect.intValue == 1) {
                                                
                                                [weakSelf.countArray addObject:entity];
                                            }
                                        }
                                    }
                                    
                                    [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                                }
                                
                                [weakSelf.tableView reloadData];
                                
                                [weakSelf.weedOutDataResultOR removeAllObjects];
                                
                                [weakSelf.weedOutIndexAry removeAllObjects];
                                
                            }else{
                                
                                [weakSelf.weedOutDataResultOR removeAllObjects];
                                
                                [weakSelf.weedOutIndexAry removeAllObjects];
                            }
                        }];
                    }else{
                        if(weakSelf.notSelectAllAry.count != 0){
                            
                            weakSelf.centrView.hidden = YES;
                        }
                        
                        [weakSelf.weedOutDataResultOR removeAllObjects];
                        
                        [weakSelf.weedOutIndexAry removeAllObjects];
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
    };
    
    [self.view addSubview:_wisdomWeedOutView];
    
    
#pragma mark - 上覆盖
    _myLoadView = [UIView new];
    _myLoadView.backgroundColor = [UIColor clearColor];
    _myLoadView.frame = CGRectMake(0, 64, kScreenWidth, 80);
    [self.view addSubview:_myLoadView];
    
#pragma mark - 每次启动指导
    NSString *title = @" 查看淘汰的品种  ";
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    _btnMaskView = [[MaskingView alloc]initWithFrame:CGRectMake(kScreenWidth - rect.size.width - 13.5, 50, rect.size.width, 40) direction:RIGHT_TOP];
    _btnMaskView.alertString = title;
    _btnMaskView.hidden = YES;
    [self.view addSubview:_btnMaskView];
    
    
    NSString *deleteTitle = @" 删除的商品在这里  ";
    CGRect deleteRect = [deleteTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    _deleteMaskView = [[MaskingView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - deleteRect.size.width + 20, 100, deleteRect.size.width, 40) direction:RIGHT_TOP];
    _deleteMaskView.alertString = deleteTitle;
    _deleteMaskView.hidden = YES;
    //    [self.view addSubview:_deleteMaskView];
    
    
    NSString *shareTwoTitle = @" 复制采购清单,发送给好友  ";
    CGRect shareRect = [shareTwoTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    _shareMaskView = [[MaskingView alloc]initWithFrame:CGRectMake(kScreenWidth - shareRect.size.width - 40, kScreenHeight - 90, shareRect.size.width, 40) direction:RIGHT_BOTTOM];
    _shareMaskView.alertString = shareTwoTitle;
    _shareMaskView.hidden = YES;
    [self.view addSubview:_shareMaskView];
    
    
    NSString *addTitle = @" 点击可添加商品 ";
    CGRect addRect = [addTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    _addMaskView = [[MaskingView alloc]initWithFrame:CGRectMake(kScreenWidth - addRect.size.width - 18, kScreenHeight - 160, addRect.size.width, 40) direction:RIGHT_BOTTOM];
    _addMaskView.alertString = addTitle;
    _addMaskView.hidden = YES;
    [self.view addSubview:_addMaskView];
    
    
#pragma mark - 全覆盖膜
    bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .3;
    bgView.hidden = YES;
    [self.view addSubview:bgView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewHidden)];
    [bgView addGestureRecognizer:tap];
    
    
#pragma mark - 淘汰下拉页面
    _selectListImgV = [UIImageView new];
    _selectListImgV.layer.masksToBounds = YES;
    _selectListImgV.userInteractionEnabled = YES;
    _selectListImgV.layer.cornerRadius = 3.0f;
    _selectListImgV.frame = CGRectMake(kScreenWidth - 152, 54, 135, 43);
    _selectListImgV.image = [UIImage imageNamed:@"listed"];
    [self.view addSubview:_selectListImgV];
    
    isSelectList = YES;
    
    
    _selectListImgV.hidden = YES;
    
    
    _selectListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 6, 135, 40)style:UITableViewStylePlain];
    _selectListTableView.scrollEnabled = NO;
    _selectListTableView.delegate = self;
    _selectListTableView.dataSource = self;
    _selectListTableView.rowHeight = 40;
    [_selectListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _selectListTableView.layer.masksToBounds = YES;
    _selectListTableView.layer.cornerRadius = 3.0f;
    [_selectListImgV addSubview:_selectListTableView];
    
    
#pragma mark - ➕号按钮
    _searchLab = [UILabel new];
    _searchLab.userInteractionEnabled = YES;
    _searchLab.textAlignment = NSTextAlignmentCenter;
    _searchLab.alpha = .9;
    _searchLab.backgroundColor = RGB(71, 71, 71);
    _searchLab.layer.masksToBounds = YES;
    _searchLab.layer.cornerRadius = 3.0f;
    //    _searchLab.frame = CGRectMake(kScreenWidth - 142, kScreenHeight - 234.5, 70, 20);
    _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 105, 0, 0);
    _searchLab.textColor = [UIColor whiteColor];
    _searchLab.font = [UIFont systemFontOfSize:16];
    _searchLab.text = @"搜索添加";
    [self.view addSubview:_searchLab];
    
    
    UITapGestureRecognizer *searcLabTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAdd)];
    [_searchLab addGestureRecognizer:searcLabTap];
    
    
    _scanLab = [UILabel new];
    _scanLab.userInteractionEnabled = YES;
    _scanLab.textAlignment = NSTextAlignmentCenter;
    _scanLab.alpha = .9;
    _scanLab.backgroundColor = RGB(71, 71, 71);
    _scanLab.layer.masksToBounds = YES;
    _scanLab.layer.cornerRadius = 3.0f;
    //    _scanLab.frame =  CGRectMake(kScreenWidth - 142, kScreenHeight - 169.5, 70, 20);
    _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 105, 0, 0);
    _scanLab.textColor = [UIColor whiteColor];
    _scanLab.font = [UIFont systemFontOfSize:16];
    _scanLab.text = @"扫码添加";
    [self.view addSubview:_scanLab];
    
    
    UITapGestureRecognizer *scanLabTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanAdd)];
    [_scanLab addGestureRecognizer:scanLabTap];
    
    
    _closeLab = [UILabel new];
    _closeLab.textAlignment = NSTextAlignmentCenter;
    _closeLab.alpha = .9;
    _closeLab.backgroundColor = RGB(71, 71, 71);
    _closeLab.layer.masksToBounds = YES;
    _closeLab.layer.cornerRadius = 3.0f;
    //    _closeLab.frame =  CGRectMake(kScreenWidth - 115, kScreenHeight - 102.5, 40, 20);
    _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 105, 0, 0);
    _closeLab.textColor = [UIColor whiteColor];
    _closeLab.font = [UIFont systemFontOfSize:16];
    _closeLab.text = @"关闭";
    [self.view addSubview:_closeLab];
    
    _searchView = [UIView new];
    _searchView.hidden = YES;
    _searchView.userInteractionEnabled = NO;
    _searchView.backgroundColor = RGB(255, 150, 49);
    _searchView.layer.masksToBounds= YES;
    _searchView.layer.cornerRadius = 25;
    _searchView.alpha = .9;
    _searchView.hidden = YES;
    _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
    [self.view addSubview:_searchView];
    
    
    UIImageView *searchImgV = [UIImageView new];
    searchImgV.image = [UIImage imageNamed:@"addSearch"];
    searchImgV.frame = CGRectMake(10,10, 30, 30);
    [_searchView addSubview:searchImgV];
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAdd)];
    [_searchView addGestureRecognizer:searchTap];
    
    
    _scanView = [UIImageView new];
    _scanView.hidden = YES;
    _scanView.userInteractionEnabled = NO;
    _scanView.backgroundColor = RGB(39, 164, 229);
    _scanView.alpha = .9;
    _scanView.layer.masksToBounds= YES;
    _scanView.layer.cornerRadius = 25;
    _scanView.hidden = YES;
    _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
    [self.view addSubview:_scanView];
    
    UIImageView *scanImgV = [UIImageView new];
    scanImgV.image = [UIImage imageNamed:@"addScan"];
    scanImgV.frame = CGRectMake(10,10, 30, 30);
    [_scanView addSubview:scanImgV];
    
    
    UITapGestureRecognizer *scanTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanAdd)];
    [_scanView addGestureRecognizer:scanTap];
    
    _openView = [UIView new];
    _openView.userInteractionEnabled = NO;
    _openView.hidden = YES;
    _openView.frame = CGRectMake(kScreenWidth - 65, kScreenHeight - 120, 55, 55);
    _openView.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
    _openView.layer.masksToBounds= YES;
    _openView.layer.cornerRadius = 27.5;
    [self.view addSubview:_openView];
    
    
    UIImageView *openImgV = [UIImageView new];
    openImgV.frame = CGRectMake(12.5, 12.5, 30, 30);
    openImgV.image = [UIImage imageNamed:@"addBtn"];
    [_openView addSubview:openImgV];
    
    
    UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addSelect)];
    [_openView addGestureRecognizer:openTap];
    
    isOpen = YES;
    
#pragma mark - 首次启动指导
    if (!kFirstStartWisdom) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartWisdom"];
        
        isHidden = YES;
        
        _wisdomToLeftView = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomToLeftView" owner:self options:nil]lastObject];
        
        _wisdomToLeftView.hidden = YES;
        
        _wisdomToLeftView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        [_wisdomToLeftView setWisdomToLeftView];
        
        _wisdomToLeftView.WisdomToLeftViewBlock = ^{
            
            [weakSelf selectedLaftView];
        };
        
        [self.view addSubview:_wisdomToLeftView];
    }
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        return  148;
    }else{
        return  40;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _selectListTableView) {
        
        return 1;
    }
    
    if (topIndex == 2) {
        if (_dataResultOR.count != 0) {
            return _dataResultOR.count;
        }else{
            return 0;
        }
    }else{
        switch (_filterIndex) {
                
            case 0:{
                
                if (_dataResultOR.count != 0) {
                    
                    return _dataResultOR.count;
                    
                }else{
                    
                    return 0;
                }
                break;
            }
            case 1:{
                
                [_selectAllAry removeAllObjects];
                
                [_selectAllIndexAry removeAllObjects];
                
#pragma mark - 选中的商品
                for (int i = 0;i< _dataResultOR.count;i++) {
                    
                    NSArray *ary = _dataResultOR[i];
                    
                    NSMutableArray *selectAllAryTwo = [NSMutableArray new];
                    
                    NSMutableArray *selectAllIndexAryTwo = [NSMutableArray new];
                    
                    for (int j = 0;j < ary.count;j++) {
                        
                        STWisdomEntity *entity = ary[j];
                        
                        if (entity.isSelect.intValue == 1) {
                            
                            [selectAllAryTwo addObject:entity];
                            
                            [selectAllIndexAryTwo addObject:_indexAry[i][j]];
                        }
                    }
                    if (selectAllAryTwo.count != 0) {
                        
                        [_selectAllAry addObject:selectAllAryTwo];
                        
                        [_selectAllIndexAry addObject:selectAllIndexAryTwo];
                    }
                }
                
                if (_selectAllAry.count != 0) {
                    
                    return _selectAllAry.count;
                    
                }else{
                    
                    return 0;
                }
                break;
            }
            case 2:{
                
                [_notSelectAllAry removeAllObjects];
                
                [_notSelectAllIndexAry removeAllObjects];
                
#pragma mark - 未选中的商品
                for (int i = 0;i< _dataResultOR.count;i++) {
                    
                    NSArray *ary = _dataResultOR[i];
                    
                    NSMutableArray *notSelectAllAryTwo = [NSMutableArray new];
                    
                    NSMutableArray *notSelectAllIndexAryTwo = [NSMutableArray new];
                    
                    for (int j = 0;j < ary.count;j++) {
                        
                        STWisdomEntity *entity = ary[j];
                        
                        if (entity.isSelect.intValue != 1) {
                            
                            [notSelectAllAryTwo addObject:entity];
                            
                            [notSelectAllIndexAryTwo addObject:_indexAry[i][j]];
                        }
                    }
                    if (notSelectAllAryTwo.count != 0) {
                        
                        [_notSelectAllAry addObject:notSelectAllAryTwo];
                        
                        [_notSelectAllIndexAry addObject:notSelectAllIndexAryTwo];
                    }
                    
                }
                
                if (_notSelectAllAry.count != 0) {
                    
                    return _notSelectAllAry.count;
                    
                }else{
                    return 0;
                }
                break;
            }
                
            default:
                break;
        }
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _selectListTableView) {
        
        return 1;
    }else{
        if (topIndex == 2) {
            
            if ([[_dataResultOR[section]dataAryTwo] count] != 0) {
                
                return [[_dataResultOR[section]dataAryTwo] count];
                
            }else{
                
                return 0;
            }
        }else{
            if ([_dataResultOR[section] count] != 0) {
                
                switch (_filterIndex) {
                        
                    case 0:{
                        return [_dataResultOR[section] count];
                        
                        break;
                    }
                    case 1:{
                        return [_selectAllAry[section] count];
                        
                        break;
                    }
                    case 2:{
                        return [_notSelectAllAry[section] count];
                        
                        break;
                    }
                    default:
                        break;
                }
                return 0;
                
            }else{
                
                return 0;
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _selectListTableView) {
        
        static NSString *cellName = @"cellName";
        
        STWisdomSelectListTableView *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomSelectListTableView" owner:self options:nil]lastObject];
        }
        
        [cell setWisdomSelectList:nil indexPath:indexPath];
        
        return cell;
    }else{
        
        if (topIndex == 0) {
            
            static NSString *cellName = @"cellName";
            
            STWisdomProcurementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            
            if (!cell) {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomProcurementTableViewCell" owner:self options:nil]lastObject];
                
                cell.delegate = self;
            }
            
            if (letterIndex == 1) {
                
                if (isSearch) {
                    
                    isSearch = NO;
                    
                    [self performSelector:@selector(labHidden) withObject:self afterDelay:2];
                    
                }else{
                    
                    _letterLab.hidden = NO;
                    
                    if (isChange) {
                        
                        _letterLab.hidden = YES;
                    }
                    
                    if ([_dataResultOR[indexPath.section] count] != 0) {
                        
                        switch (_filterIndex) {
                            case 0:{
                                _letterLab.text = [_dataResultOR[indexPath.section][0] PreChar];
                                break;
                            }
                            case 1:{
                                _letterLab.text = [_selectAllAry[indexPath.section][0] PreChar];
                                break;
                            }
                            case 2:{
                                _letterLab.text = [_notSelectAllAry[indexPath.section][0] PreChar];
                                break;
                            }
                            default:
                                break;
                        }
                    }
                    
                    [self performSelector:@selector(labHidden) withObject:self afterDelay:2];
                }
                
                
                if ([_dataResultOR[indexPath.section] count] != 0) {
                    
                    switch (_filterIndex) {
                        case 0:{
                            [cell setWisdom:_dataResultOR indexPath:indexPath textTextFieldAry:_indexAry];
                            break;
                        }
                        case 1:{
                            [cell setWisdom:_selectAllAry indexPath:indexPath textTextFieldAry:_selectAllIndexAry];
                            break;
                        }
                        case 2:{
                            [cell setWisdom:_notSelectAllAry indexPath:indexPath textTextFieldAry:_notSelectAllIndexAry];
                            break;
                        }
                        default:
                            break;
                    }
                }
                
            }else{
                
                if ([_dataResultOR[indexPath.section] count] != 0) {
                    
                    switch (_filterIndex) {
                        case 0:{
                            [cell setWisdom:_dataResultOR indexPath:indexPath textTextFieldAry:_indexAry];
                            break;
                        }
                        case 1:{
                            [cell setWisdom:_selectAllAry indexPath:indexPath textTextFieldAry:_selectAllIndexAry];
                            break;
                        }
                        case 2:{
                            [cell setWisdom:_notSelectAllAry indexPath:indexPath textTextFieldAry:_notSelectAllIndexAry];
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
            
            return cell;
            
        }else if(topIndex == 1){
            
            static NSString *cellNameB = @"cellNameB";
            
            STWisdomShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameB];
            
            if (!cell) {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomShopTableViewCell" owner:self options:nil]lastObject];
                
                cell.delegate = self;
                
            }
            
            if ([_dataResultOR[indexPath.section] count]  != 0) {
                
                [cell setWisdomShop:_dataResultOR indexPath:indexPath];
            }
            
            return cell;
        }else{
            
            STWisdomNotShopTableViewCell *cell =_cellAry[indexPath.section][indexPath.row];
            
            if ([[_dataResultOR[indexPath.section]dataAryTwo] count] != 0) {
                
                [cell setWisdomNotShop:_dataResultOR indexPath:indexPath];
            }
            
            return cell;
        }
    }
    return 0;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView) {
        
        if (topIndex == 0) {
            
            isSelect = YES;
            
            _wisdomCollectionView.hidden = YES;
            
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (topIndex == 0) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
        }
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self disMissMasking];
    
    [self hideenOpenView];
    
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    _mIndexPath2 = indexPath;
    
    switch (_filterIndex) {
        case 0:{
            if (![[_dataResultOR[indexPath.section][indexPath.row] psn] isEqualToString:@""]) {//判断是否是手动添加
#pragma mark - 非手动添加产品添加一个淘汰按钮
                UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"淘汰\n品种" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                    
                    [self deletePurchaseEliminateParams:@{@"id":[_dataResultOR[indexPath.section][indexPath.row] memberID]} indexPath:indexPath];
                    
                    weakSelf.wisdomWeedOutView.hidden = NO;
                    
                    weakSelf.wisdomWeedOutView.numLab.text =@"要淘汰该商品吗?";
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        for (int i = 3; i > 0; i--) {
                            
                            regainKeepTime = i;
                            
                            sleep(1);
                        }
                        // 主线程执行：
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.wisdomWeedOutView.hidden = YES;
                            
                            [weakSelf.weedOutDataResultOR removeAllObjects];
                            
                            [weakSelf.weedOutIndexAry removeAllObjects];
                        });
                    });
                }];
                // 将设置好的按钮放到数组中返回
                return @[topRowAction];
            }else{
#pragma mark -  手动添加产品添加一个删除按钮
                // 添加一个删除按钮
                UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                    
                    [self deletePurchaseParams:@{@"id":[_dataResultOR[indexPath.section][indexPath.row] memberID]} indexPath:indexPath];
                    
                    isHandAdd = YES;
                    
                    weakSelf.undoView.hidden = NO;
                    
                    weakSelf.undoView.numLab.text = @"要移除该商品吗?";
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        for (int i = 3; i > 0; i--) {
                            
                            regainKeepTime = i;
                            
                            sleep(1);
                        }
                        // 主线程执行：
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.undoView.hidden = YES;
                            
                            [weakSelf.removeDataResultOR removeAllObjects];
                            
                            [weakSelf.removeIndexAry removeAllObjects];
                        });
                    });
                }];
                // 将设置好的按钮放到数组中返回
                return @[deleteRowAction];
            }
            
            break;
        }
        case 1:{
            if (![[_selectAllAry[indexPath.section][indexPath.row] psn] isEqualToString:@""]) {//判断是否是手动添加
#pragma mark - 非手动添加产品添加一个淘汰按钮
                UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"淘汰\n品种" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                    
                    [self deletePurchaseEliminateParams:@{@"id":[_selectAllAry[indexPath.section][indexPath.row] memberID]} indexPath:indexPath];
                    
                    weakSelf.wisdomWeedOutView.hidden = NO;
                    
                    weakSelf.wisdomWeedOutView.numLab.text =@"要淘汰该商品吗?";
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        for (int i = 3; i > 0; i--) {
                            
                            regainKeepTime = i;
                            
                            sleep(1);
                        }
                        // 主线程执行：
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.wisdomWeedOutView.hidden = YES;
                            
                            [weakSelf.weedOutDataResultOR removeAllObjects];
                            
                            [weakSelf.weedOutIndexAry removeAllObjects];
                        });
                    });
                }];
                // 将设置好的按钮放到数组中返回
                return @[topRowAction];
            }else{
#pragma mark -  手动添加产品添加一个删除按钮
                // 添加一个删除按钮
                UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                    
                    [self deletePurchaseParams:@{@"id":[_selectAllAry[indexPath.section][indexPath.row] memberID]} indexPath:indexPath];
                    
                    isHandAdd = YES;
                    
                    weakSelf.undoView.hidden = NO;
                    
                    weakSelf.undoView.numLab.text = @"要移除该商品吗?";
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        for (int i = 3; i > 0; i--) {
                            
                            regainKeepTime = i;
                            
                            sleep(1);
                        }
                        // 主线程执行：
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.undoView.hidden = YES;
                            
                            [weakSelf.removeDataResultOR removeAllObjects];
                            
                            [weakSelf.removeIndexAry removeAllObjects];
                        });
                    });
                }];
                // 将设置好的按钮放到数组中返回
                return @[deleteRowAction];
            }
            
            break;
        }
        case 2:{
            if (![[_notSelectAllAry[indexPath.section][indexPath.row] psn] isEqualToString:@""]) {//判断是否是手动添加
#pragma mark - 非手动添加产品添加一个淘汰按钮
                UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"淘汰\n品种" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                    
                    [self deletePurchaseEliminateParams:@{@"id":[_notSelectAllAry[indexPath.section][indexPath.row] memberID]} indexPath:indexPath];
                    
                    weakSelf.wisdomWeedOutView.hidden = NO;
                    
                    weakSelf.wisdomWeedOutView.numLab.text =@"要淘汰该商品吗?";
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        for (int i = 3; i > 0; i--) {
                            
                            regainKeepTime = i;
                            
                            sleep(1);
                        }
                        // 主线程执行：
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.wisdomWeedOutView.hidden = YES;
                            
                            [weakSelf.weedOutDataResultOR removeAllObjects];
                            
                            [weakSelf.weedOutIndexAry removeAllObjects];
                        });
                    });
                }];
                // 将设置好的按钮放到数组中返回
                return @[topRowAction];
            }else{
#pragma mark -  手动添加产品添加一个删除按钮
                // 添加一个删除按钮
                UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                    
                    [self deletePurchaseParams:@{@"id":[_notSelectAllAry[indexPath.section][indexPath.row] memberID]} indexPath:indexPath];
                    
                    isHandAdd = YES;
                    
                    weakSelf.undoView.hidden = NO;
                    
                    weakSelf.undoView.numLab.text = @"要移除该商品吗?";
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        for (int i = 3; i > 0; i--) {
                            
                            regainKeepTime = i;
                            
                            sleep(1);
                        }
                        // 主线程执行：
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            weakSelf.undoView.hidden = YES;
                            
                            [weakSelf.removeDataResultOR removeAllObjects];
                            
                            [weakSelf.removeIndexAry removeAllObjects];
                        });
                    });
                }];
                // 将设置好的按钮放到数组中返回
                return @[deleteRowAction];
            }
            break;
        }
        default:
            break;
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (topIndex == 0) {
        
        return @"删除";
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        
        if ( topIndex == 2) {
            
            return 40;
            
        }else if (topIndex == 0){
            
            if (letterIndex == 1) {
                
                return 40;
            }
        }
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [UIView new];
    
    headView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    
    headView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    
    if (tableView == _tableView) {
        
        if (topIndex == 2) {
            
            headView.backgroundColor = [UIColor whiteColor];
            headView.frame = CGRectMake(0, 0, kScreenWidth, 40);
            
            UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectBtn.tag = section + selectBtn_tag;
            selectBtn.frame = CGRectMake(0, 0, 40, 40);
            
            
            [selectBtn addTarget:self action:@selector(selectMothed:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:selectBtn];
            
            
            [_sectionNumAry removeAllObjects];
            
            for (int i = 0; i < [_dataResultOR[section] dataAryTwo].count; i++) {
                
                STWisdomEntity *entity = [_dataResultOR[section] dataAryTwo][i];
                
                if (entity.isSelect.intValue == 1) {
                    
                    [_sectionNumAry addObject:entity];
                    
                }
            }
            
            if ([_dataResultOR[section] dataAryTwo].count != _sectionNumAry.count) {
                
                [selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                
            }else{
                
                [selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
            }
            
            
            UILabel *titel = [UILabel new];
            titel.frame = CGRectMake(50, 0, kScreenWidth - 60, 40);
            titel.textColor = RGB(51, 51, 51);
            titel.text = [_dataResultOR[section]supplierName];
            titel.font = [UIFont systemFontOfSize:16];
            [headView addSubview:titel];
            
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.tag = section + btn_Tag;
            shareBtn.frame = CGRectMake(kScreenWidth - 40, 0, 40, 40);
            [shareBtn setImage:[UIImage imageNamed:@"addShare"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareApp:) forControlEvents:UIControlEventTouchUpInside];
            //                        [headView addSubview:shareBtn];
            
            UILabel *line = [UILabel new];
            line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
            line.frame = CGRectMake(0, 39, kScreenWidth, .5);
            [headView addSubview:line];
            
            return headView;
            
        }else if (topIndex == 0){
            
            if (letterIndex == 1) {
                
                headView.backgroundColor = [UIColor whiteColor];
                headView.frame = CGRectMake(0, 0, kScreenWidth, 40);
                
                UILabel *titel = [UILabel new];
                titel.frame = CGRectMake(10, 0, kScreenWidth - 10, 40);
                titel.textColor = RGB(119, 119, 119);
                
                titel.font = [UIFont systemFontOfSize:14];
                [headView addSubview:titel];
                
                
                switch (_filterIndex) {
                    case 0:
                        titel.text = [_dataResultOR[section][0] PreChar];
                        break;
                    case 1:
                        titel.text = [_selectAllAry[section][0] PreChar];
                        break;
                    case 2:
                        titel.text = [_notSelectAllAry[section][0] PreChar];
                        break;
                        
                    default:
                        break;
                }
                
                UILabel *line = [UILabel new];
                line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
                line.frame = CGRectMake(0, 39, kScreenWidth, .5);
                [headView addSubview:line];
                
                return headView;
            }
        }
    }
    return headView;
}
#pragma mark---tableView索引相关设置----
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView == _tableView) {
        
        if (topIndex == 0){
            
            if (letterIndex == 1) {
                
                switch (_filterIndex) {
                    case 0:
                        if ([_dataResultOR[section] count]  != 0) {
                            
                            return [_dataResultOR[section][0] PreChar];
                        }
                        break;
                    case 1:
                        if ([_selectAllIndexAry[section] count]  != 0) {
                            
                            return [_selectAllIndexAry[section][0] PreChar];
                        }
                        break;
                    case 2:
                        if ([_notSelectAllIndexAry[section] count]  != 0) {
                            
                            return [_notSelectAllIndexAry[section][0] PreChar];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
    return nil;
}
//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    if (tableView == _tableView) {
        
        if (topIndex == 0){
            
            if (letterIndex == 1) {
                
                NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
                
                switch (_filterIndex) {
                    case 0:
                        for (int i = 0; i < self.dataResultOR.count; i++) {
                            
                            NSString *title = [_dataResultOR[i][0] PreChar];
                            
                            [resultArray addObject:title];
                        }
                        return resultArray;
                        break;
                    case 1:
                        for (int i = 0; i < self.selectAllAry.count; i++) {
                            
                            NSString *title = [_selectAllAry[i][0] PreChar];
                            
                            [resultArray addObject:title];
                        }
                        return resultArray;
                        break;
                    case 2:
                        for (int i = 0; i < self.notSelectAllAry.count; i++) {
                            
                            NSString *title = [_notSelectAllAry[i][0] PreChar];
                            
                            [resultArray addObject:title];
                        }
                        return resultArray;
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
    return 0;
}

//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    if (tableView == _tableView) {
        
        if (topIndex == 0){
            
            if (letterIndex == 1) {
                
                //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
                if ([title isEqualToString:UITableViewIndexSearch]){
                    
                    [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
                    
                    return NSNotFound;
                }
                else{
                    
                    isSearch = YES;
                    
                    isChange = NO;
                    
                    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
                }
            }
        }
    }
    return 0;
}

#pragma mark- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    if (tableView == _selectListTableView) {
        
        _selectListImgV.hidden = YES;
        
        isSelectList = YES;
        
        bgView.hidden = YES;
        
        switch (indexPath.row) {
                
            case 0:{
                
                STWisdomWeedOutViewController *wisdomWeedOutVC = [STWisdomWeedOutViewController new];
                
                wisdomWeedOutVC.WeedOutBackBlock = ^(void){
                    
                    [weakSelf.dataResultOR removeAllObjects];
                    
                    [weakSelf.indexAry removeAllObjects];
                    
                    [weakSelf.countArray removeAllObjects];
                    
                    [weakSelf.countNotArray removeAllObjects];
                    
                    [weakSelf.selectAllAry removeAllObjects];
                    
                    [weakSelf.selectAllIndexAry removeAllObjects];
                    
                    [weakSelf.notSelectAllAry removeAllObjects];
                    
                    [weakSelf.notSelectAllIndexAry removeAllObjects];
                    
                    [weakSelf.wisdomFooterView.iphoneBtn setTitle:@"发送(0)" forState:UIControlStateNormal];
                    
                    [weakSelf.wisdomFooterView.gouBtn setTitle:@"生成采购方案(0)" forState:UIControlStateNormal];
                    
                    [weakSelf.tableView reloadData];
                    
                    [weakSelf.tableView.mj_header beginRefreshing];
                };
                
                [self.navigationController pushViewController:wisdomWeedOutVC animated:YES];
                
                break;
            }
            case 1:{
                
                STWisdomHelpViewController *helpVC = [STWisdomHelpViewController new];
                
                helpVC.strUrl = requesthelpCenterSrc;
                
                helpVC.HelpBackBlock = ^{
                    
                    isHelpBackBlock = YES;
                };
                
                [self.navigationController pushViewController:helpVC animated:YES];
                
                break;
            }
            default:
                break;
        }
    }else{
        
        //        if (topIndex == 0) {
        //
        //            STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        //
        //            [self g_setChangeSelect:cell];
        //
        //        }else if(topIndex == 2){
        //
        //            STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        //
        //            [self g_setNotChangeSelect:cell];
        //        }
    }
}

#pragma mark- STWisdomProcurementTableViewCellDelegate 智慧采购
//减数量
-(void)g_setSubtract:(STWisdomProcurementTableViewCell *)cell{
    
    //     __weak STWisdomProcurementViewController *weakSelf  = self;
    
    [self disMissMasking];
    
    [self  setWisdomCollectionView];
    
    isSearch = YES;
    
    isChange = YES;
    
    if ( [cell.textTextField.text intValue] <= 1) {
        
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        
    }else{
        
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        
        NSString *changeStr = [NSString stringWithFormat:@"%d",[cell.textTextField.text intValue] - 1];
        
        [_indexAry[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:changeStr];
        
        cell.textTextField.text = changeStr;
        
        [self changePurchaseCountParams:@{@"Goods_Package_ID":[_dataResultOR[indexPath.section][indexPath.row] Goods_Package_ID],@"num":changeStr} indexPath:indexPath finshed:^(BOOL isYes) {
            
            if (isYes) {
                return ;
            }
        }];
    }
}
//加数量
-(void)g_setAdd:(STWisdomProcurementTableViewCell *)cell{
    
    //    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    [self disMissMasking];
    
    [self  setWisdomCollectionView];
    
    isSearch = YES;
    
    isChange = YES;
    
    if ( [cell.textTextField.text intValue] >= 99999) {
        
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于库存数"];
        
    }else{
        
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        
        NSString *changeStr = [NSString stringWithFormat:@"%d",[cell.textTextField.text intValue] + 1];
        
        [_indexAry[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:changeStr];
        
        cell.textTextField.text = changeStr;
        
        [self changePurchaseCountParams:@{@"Goods_Package_ID":[_dataResultOR[indexPath.section][indexPath.row] Goods_Package_ID],@"num":changeStr} indexPath:indexPath finshed:^(BOOL isYes) {
            
            if (isYes) {
                return ;
            }
        }];
    }
}
//下拉数量
-(void)g_setList:(STWisdomProcurementTableViewCell *)cell{
    
    [self disMissMasking];
    
    [self hideenOpenView];
    
    isChange = YES;
    
    isSearch = YES;
    
    if (isSelect) {
        
        [self setWisdomCollectionViewFrame:cell];
        
    }else{
        
        isSelect = YES;
        
        _wisdomCollectionView.hidden = YES;
    }
}
//填写数量
-(void)g_setTextFieldDidBeginEditing:(STWisdomProcurementTableViewCell *)cell{
    
    [self disMissMasking];
    
    [self  setWisdomCollectionView];
    
    isSearch = YES;
    
    isChange = YES;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    //    if (self.mIndexPath.section == indexPath.section) {
    //        [IQKeyboardManager sharedManager].enable = NO;
    //    }else{
    //       [IQKeyboardManager sharedManager].enable = YES;
    //    }
    
    self.mIndexPath = indexPath;
}
-(void)g_setfinished{
    
    //     __weak STWisdomProcurementViewController *weakSelf  = self;
    
    [self disMissMasking];
    
    __block  STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[_tableView cellForRowAtIndexPath:self.mIndexPath];
    
    [_indexAry[self.mIndexPath.section] replaceObjectAtIndex:self.mIndexPath.row withObject:cell.textTextField.text];
    
    
    
    [self changePurchaseCountParams:@{@"Goods_Package_ID":[_dataResultOR[self.mIndexPath.section][self.mIndexPath.row] Goods_Package_ID],@"num":cell.textTextField.text} indexPath:self.mIndexPath finshed:^(BOOL isYes) {
        
        if (isYes) {
            return ;
        }
    }];
}

-(void)g_setChangeSelect:(STWisdomProcurementTableViewCell *)cell{
    
    
    [self  setWisdomCollectionView];
    
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    
    switch (_filterIndex) {
        case 0:{
            __block NSMutableArray *newAry = [weakSelf.dataResultOR[indexPath.section] mutableCopy];
            
            STWisdomEntity *entity = newAry[indexPath.row];
            
            if ([_dataResultOR[indexPath.section][indexPath.row] isSelect].intValue == 1) {
                
                [self setChangeSelect:@{@"id":[_dataResultOR[indexPath.section][indexPath.row] memberID],@"isSelect":@"false"} finshed:^(BOOL isYes) {
                    
                    if (isYes) {
                        
                        entity.isSelect = @"0";
                        
                        [newAry replaceObjectAtIndex:indexPath.row withObject:entity];
                        
                        [weakSelf.dataResultOR  replaceObjectAtIndex:indexPath.section withObject:newAry];
                        
                        [cell.selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                        
                        [weakSelf.countArray removeObject:entity];
                        
                        [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                        
                        [weakSelf changeWisdomFooterViewBackgroundColor];
                        
                    }
                }];
            }else{
                
                [self setChangeSelect:@{@"id":[_dataResultOR[indexPath.section][indexPath.row] memberID],@"isSelect":@"true"} finshed:^(BOOL isYes) {
                    
                    if (isYes) {
                        
                        entity.isSelect = @"1";
                        
                        [newAry replaceObjectAtIndex:indexPath.row withObject:entity];
                        
                        [weakSelf.dataResultOR  replaceObjectAtIndex:indexPath.section withObject:newAry];
                        
                        [cell.selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                        
                        [weakSelf.countArray addObject:entity];
                        
                        [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                        
                        [weakSelf changeWisdomFooterViewBackgroundColor];
                    }
                }];
            }
            break;
        }
        case 1:{
            __block NSMutableArray *newAry = [weakSelf.selectAllAry[indexPath.section] mutableCopy];
            
            __block NSMutableArray *newIndexAry = [weakSelf.selectAllIndexAry[indexPath.section] mutableCopy];
            
            NSString *buyCout = newIndexAry[indexPath.row];
            
            STWisdomEntity *entity = newAry[indexPath.row];
            
            if ([_selectAllAry[indexPath.section][indexPath.row] isSelect].intValue == 1) {
                
                [self setChangeSelect:@{@"id":[_selectAllAry[indexPath.section][indexPath.row] memberID],@"isSelect":@"false"} finshed:^(BOOL isYes) {
                    
                    if (isYes) {
                        
                        entity.isSelect = @"0";
                        
                        [newAry removeObject:entity];
                        
                        [weakSelf.selectAllAry  replaceObjectAtIndex:indexPath.section withObject:newAry];
                        
                        
                        [newIndexAry removeObject:buyCout];
                        
                        [weakSelf.selectAllIndexAry  replaceObjectAtIndex:indexPath.section withObject:newIndexAry];
                        
                        for (int i = 0; i< weakSelf.dataResultOR.count; i++) {
                            
                            for (STWisdomEntity *mode in weakSelf.dataResultOR[i]) {
                                
                                if (mode.Goods_Package_ID == entity.Goods_Package_ID) {
                                    
                                    __block NSMutableArray *newAryTwo = [weakSelf.dataResultOR[i] mutableCopy];
                                    
                                    [newAryTwo replaceObjectAtIndex:indexPath.row withObject:entity];
                                    
                                    [weakSelf.dataResultOR replaceObjectAtIndex:i withObject:newAryTwo];
                                }
                            }
                        }
                        
                        [cell.selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                        
                        [weakSelf.countArray removeObject:entity];
                        
                        [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                        
                        [weakSelf changeWisdomFooterViewBackgroundColor];
                        
                        [weakSelf.tableView reloadData];
                    }
                }];
            }
            break;
        }
        case 2:{
            __block NSMutableArray *newAry = [weakSelf.notSelectAllAry[indexPath.section] mutableCopy];
            
            STWisdomEntity *entity = newAry[indexPath.row];
            
            __block NSMutableArray *newIndexAry = [weakSelf.notSelectAllAry[indexPath.section] mutableCopy];
            
            NSString *buyCout = newIndexAry[indexPath.row];
            
            if([_notSelectAllAry[indexPath.section][indexPath.row] isSelect].intValue == 0){
                
                [self setChangeSelect:@{@"id":[_notSelectAllAry[indexPath.section][indexPath.row] memberID],@"isSelect":@"true"} finshed:^(BOOL isYes) {
                    
                    if (isYes) {
                        
                        entity.isSelect = @"1";
                        
                        [newAry addObject:entity];
                        
                        [weakSelf.notSelectAllAry  replaceObjectAtIndex:indexPath.section withObject:newAry];
                        
                        
                        [newIndexAry addObject:buyCout];
                        
                        [weakSelf.notSelectAllAry  replaceObjectAtIndex:indexPath.section withObject:newIndexAry];
                        
                        for (int i = 0; i< weakSelf.dataResultOR.count; i++) {
                            
                            for (STWisdomEntity *mode in weakSelf.dataResultOR[i]) {
                                
                                if (mode.Goods_Package_ID == entity.Goods_Package_ID) {
                                    
                                    __block NSMutableArray *newAryTwo = [weakSelf.dataResultOR[i] mutableCopy];
                                    
                                    [newAryTwo replaceObjectAtIndex:indexPath.row withObject:entity];
                                    
                                    [weakSelf.dataResultOR replaceObjectAtIndex:i withObject:newAryTwo];
                                }
                            }
                        }
                        
                        [cell.selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                        
                        [weakSelf.countArray addObject:entity];
                        
                        [weakSelf.wisdomFooterView.gouBtn setTitle:[NSString stringWithFormat:@"生成采购方案(%zi)",weakSelf.countArray.count] forState:UIControlStateNormal];
                        
                        [weakSelf changeWisdomFooterViewBackgroundColor];
                        
                        [weakSelf.tableView reloadData];
                    }
                }];
            }
            break;
        }
            
        default:
            break;
    }
}


//设置WisdomCollectionView的高度
-(void)setWisdomCollectionViewFrame:(STWisdomProcurementTableViewCell *)cell{
    
    [self disMissMasking];
    
    isSelect = NO;
    
    _wisdomCollectionView.hidden = NO;
    
    [_selectAry removeAllObjects];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    self.mIndexPath = indexPath;
    
    CGRect rect = [_tableView rectForRowAtIndexPath:indexPath];
    
    for (UIView *view in _tableView.subviews) {
        
        if ([view isEqual:_wisdomCollectionView]) {
            
            [view removeFromSuperview];
        }
    }
    [_tableView addSubview:_wisdomCollectionView];
    
    _wisdomCollectionView.frame = CGRectMake(kScreenWidth - 139, rect.origin.y + cell.size.height - 13.5 , 131, 80);
    
    if (letterIndex == 1) {
        
        _wisdomCollectionView.frame = CGRectMake(kScreenWidth - 154, rect.origin.y + cell.size.height - 13.5 , 131, 80);
    }
    //将string字符串转换为array数组
    NSArray  *array = [[_dataResultOR[indexPath.section][indexPath.row] buyNumListStr] componentsSeparatedByString:@","];
    
    [_selectAry addObject:array];
    
    [_wisdomCollectionView setSelectAry:_selectAry frame:_wisdomCollectionView.frame];
}

#pragma mark - STWisdomNotShopTableViewCellDelegate 人工采购
-(void)g_setNotChangeSelect:(STWisdomNotShopTableViewCell *)cell{
    
    [self  setWisdomCollectionView];
    
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    _isAllSelect = NO;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    STWisdomEntity *entity = [_dataResultOR[indexPath.section] dataAryTwo][indexPath.row];
    
    if ([[_dataResultOR[indexPath.section] dataAryTwo][indexPath.row] isSelect].intValue == 1) {
        
        [self setChangeSelect:@{@"id":[[_dataResultOR[indexPath.section] dataAryTwo][indexPath.row] memberID],@"isSelect":@"false"} finshed:^(BOOL isYes) {
            
            if (isYes) {
                
                entity.isSelect = @"0";
                
                [[weakSelf.dataResultOR[indexPath.section] dataAryTwo] replaceObjectAtIndex:indexPath.row withObject:entity];
                
                [weakSelf.countNotArray removeObject:entity];
                
                [cell.selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                
                
                [weakSelf.wisdomFooterView.iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%zi)",weakSelf.countNotArray.count] forState:UIControlStateNormal];
                
                if (weakSelf.countNotArray.count == weakSelf.allNotArray.count) {
                    
                    [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                    
                }else{
                    
                    [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                    
                }
                
                [weakSelf changeWisdomFooterViewBackgroundColor];
            }
        }];
    }else{
        
        [self setChangeSelect:@{@"id":[[_dataResultOR[indexPath.section] dataAryTwo][indexPath.row] memberID],@"isSelect":@"true"} finshed:^(BOOL isYes) {
            
            if (isYes) {
                
                entity.isSelect = @"1";
                
                [[weakSelf.dataResultOR[indexPath.section] dataAryTwo] replaceObjectAtIndex:indexPath.row withObject:entity];
                
                [weakSelf.countNotArray addObject:entity];
                
                
                [cell.selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                
                [weakSelf.wisdomFooterView.iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%zi)",weakSelf.countNotArray.count] forState:UIControlStateNormal];
                
                if (weakSelf.countNotArray.count == weakSelf.allNotArray.count) {
                    
                    [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                    
                }else{
                    
                    [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                    
                }
                
                [weakSelf changeWisdomFooterViewBackgroundColor];
                
            }
        }];
    }
}

//减数量
-(void)g_setNotSubtract:(STWisdomNotShopTableViewCell *)cell{
    
    //     __weak STWisdomProcurementViewController *weakSelf  = self;
    
    [self  setWisdomCollectionView];
    
    [self disMissMasking];
    
    isSearch = YES;
    
    isChange = YES;
    
    if ( [cell.textTextField.text intValue] <= 1) {
        
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        
    }else{
        
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        
        NSString *changeStr = [NSString stringWithFormat:@"%d",[cell.textTextField.text intValue] - 1];
        
        STWisdomEntity *entity = [_dataResultOR[indexPath.section] dataAryTwo][indexPath.row];
        
        entity.buyCount = changeStr;
        
        [[_dataResultOR[indexPath.section] dataAryTwo] replaceObjectAtIndex:indexPath.row withObject:entity];
        
        cell.textTextField.text = changeStr;
        
        [self setChangePurchaseCountForPsn:@{@"psn":[[_dataResultOR[indexPath.section] dataAryTwo][indexPath.row] psn],@"num":changeStr} indexPath:indexPath finshed:^(BOOL isYes) {
            if (isYes) {
                
                return ;
                
            }
        }];
    }
}
//加数量
-(void)g_setNotAdd:(STWisdomNotShopTableViewCell *)cell{
    
    [self  setWisdomCollectionView];
    
    //    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    [self disMissMasking];
    
    isSearch = YES;
    
    isChange = YES;
    
    if ( [cell.textTextField.text intValue] >= 99999) {
        
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于库存数"];
        
    }else{
        
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        
        NSString *changeStr = [NSString stringWithFormat:@"%d",[cell.textTextField.text intValue] + 1];
        
        STWisdomEntity *entity = [_dataResultOR[indexPath.section] dataAryTwo][indexPath.row];
        
        entity.buyCount = changeStr;
        
        [[_dataResultOR[indexPath.section] dataAryTwo] replaceObjectAtIndex:indexPath.row withObject:entity];
        
        cell.textTextField.text = changeStr;
        
        [self setChangePurchaseCountForPsn:@{@"psn":[[_dataResultOR[indexPath.section] dataAryTwo][indexPath.row] psn],@"num":changeStr} indexPath:indexPath finshed:^(BOOL isYes) {
            
            if (isYes) {
                
                return ;
                
            }
        }];
    }
}
//填写数量
-(void)g_setNotTextFieldDidBeginEditing:(STWisdomNotShopTableViewCell *)cell{
    
    [self  setWisdomCollectionView];
    
    [self disMissMasking];
    
    isSearch = YES;
    
    isChange = YES;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    self.mIndexPath = indexPath;
}
-(void)g_setNotFinished{
    
//   __weak STWisdomProcurementViewController *weakSelf  = self;
    
    [self disMissMasking];
    
    __block  STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[_tableView cellForRowAtIndexPath:self.mIndexPath];
    
    STWisdomEntity *entity = [_dataResultOR[self.mIndexPath.section] dataAryTwo][self.mIndexPath.row];
    
    entity.buyCount = cell.textTextField.text;
    
    [[_dataResultOR[self.mIndexPath.section] dataAryTwo] replaceObjectAtIndex:self.mIndexPath.row withObject:entity];
    
    //    [_tableView reloadData];
    
    
    [self setChangePurchaseCountForPsn:@{@"psn":[[_dataResultOR[self.mIndexPath.section] dataAryTwo][self.mIndexPath.row] psn],@"num":cell.textTextField.text} indexPath:self.mIndexPath finshed:^(BOOL isYes) {
        if (isYes) {
            return ;
            
        }
    }];
}
//下拉数量
-(void)g_setNotList:(STWisdomNotShopTableViewCell *)cell{
    
    [self disMissMasking];
    
    [self hideenOpenView];
    
    isChange = YES;
    
    isSearch = YES;
    
    if (isSelect) {
        
        [self setNotWisdomCollectionViewFrame:cell];
        
    }else{
        
        isSelect = YES;
        
        _wisdomCollectionView.hidden = YES;
        
    }
}

//设置WisdomCollectionView的高度
-(void)setNotWisdomCollectionViewFrame:(STWisdomNotShopTableViewCell *)cell{
    
    [self disMissMasking];
    
    isSelect = NO;
    
    _wisdomCollectionView.hidden = NO;
    
    [_selectAry removeAllObjects];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    self.mIndexPath = indexPath;
    
    CGRect rect = [_tableView rectForRowAtIndexPath:indexPath];
    
    for (UIView *view in _tableView.subviews) {
        
        if ([view isEqual:_wisdomCollectionView]) {
            
            [view removeFromSuperview];
        }
    }
    
    [_tableView addSubview:_wisdomCollectionView];
    
    _wisdomCollectionView.frame = CGRectMake(kScreenWidth - 139, rect.origin.y + cell.size.height - 13.5 , 131, 80);
    
    //将string字符串转换为array数组
    NSArray  *array = [[[_dataResultOR[self.mIndexPath.section] dataAryTwo][self.mIndexPath.row] buyNumListStr] componentsSeparatedByString:@","];
    
    [_selectAry addObject:array];
    
    [_wisdomCollectionView setSelectAry:_selectAry frame:_wisdomCollectionView.frame];
    
}

#pragma  mark- STWisdomShopTableViewCellDelegate 加入计划
-(void)g_setPlanSelect:(STWisdomShopTableViewCell *)cell{
    
    [self disMissMasking];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    [self cancelDeletePurchaseForPsn:@{@"psn":[_dataResultOR[indexPath.section][indexPath.row] psn]} indexPath:indexPath];
    
}

#pragma  mark -- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self performSelector:@selector(labHidden) withObject:self afterDelay:2];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.isWisdomFilterView = YES;
    
    [UIView animateWithDuration:.2 animations:^{
        
        self.wisdomFilterView.frame = CGRectMake(0, 144, kScreenWidth, 0);
        
        [self.wisdomFilterView setWisdomFilterViewHieght:0];
        
         [_wisdomBtnView selectFilterBtn:_selectFilterBtnTitle];
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _wisdomCollectionView.hidden = YES;
    
    isSelect = YES;
    
    isChange = NO;
    
    if (topIndex == 0) {
        
        if(isOK){
            
            if (scrollView.contentOffset.y > self.offsetY && scrollView.contentOffset.y > 0) {//向上滑动
                
                _openView.hidden = YES;
                
                _searchView.hidden = YES;
                
                _scanView.hidden = YES;
                
                _searchLab.hidden = YES;
                
                _scanLab.hidden = YES;
                
                _closeLab.hidden =YES;
                
            }else if (scrollView.contentOffset.y < self.offsetY ){//向下滑动
                
                _openView.hidden = NO;
                
                _searchView.hidden = NO;
                
                _scanView.hidden = NO;
                
            }
            
            self.offsetY = scrollView.contentOffset.y;//将当前位移变成缓存位移
            
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self performSelector:@selector(labHidden) withObject:self afterDelay:2];
    
}
#pragma mark- 中间字母隐藏
-(void)labHidden{
    
    _letterLab.hidden = YES;
}

#pragma mark- 拨打电话
-(void)setCallTell:(NSString *)tel{
    
    [self disMissMasking];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你要拨打电话吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",tel]]];
        //        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]]];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - btnMothed
//隐藏bgView
-(void)bgViewHidden{
    
    self.selectListImgV.hidden = YES;
    
    isSelectList = YES;
    
    bgView.hidden = YES;
    
    [UIView animateWithDuration:.3 animations:^{
        
        isOpen = YES;
        
        if (topIndex == 0) {
            
            _openView.hidden = NO;
            
            _searchView.hidden = NO;
            
            _scanView.hidden = NO;
            
            _searchLab.hidden = NO;
            
            _scanLab.hidden =  NO;
            
            _closeLab.hidden =  NO;
        }
        
        
        _openView.transform = CGAffineTransformIdentity;
        
        _openView.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
        
        _openView.alpha = 1;
        
        _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    }];
}
#pragma mark - 点击加号按钮动画
-(void)addSelect{
    
    [self disMissMasking];
    
    [self  setWisdomCollectionView];
    
    if (isOpen) {
        
        isOpen = NO;
        
        bgView.hidden = NO;
        
        _openView.hidden = NO;
        
        _searchView.hidden = NO;
        
        _scanView.hidden = NO;
        
        _searchLab.hidden = NO;
        
        _scanLab.hidden = NO;
        
        _closeLab.hidden = NO;
        
        [UIView animateWithDuration:.3 animations:^{
            
            _openView.transform = CGAffineTransformMakeRotation(M_PI/4);
            
            _openView.backgroundColor = [UIColor blackColor];
            
            _openView.alpha = .5;
            
            _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 250, 50, 50);
            
            _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 185, 50, 50);
            
            _searchLab.frame = CGRectMake(kScreenWidth - 142, kScreenHeight - 234.5, 70, 20);
            
            _scanLab.frame =  CGRectMake(kScreenWidth - 142, kScreenHeight - 169.5, 70, 20);
            
            _closeLab.frame =  CGRectMake(kScreenWidth - 115, kScreenHeight - 102.5, 40, 20);
        }];
    }
    
    else{
        
        isOpen = YES;
        
        bgView.hidden = YES;
        
        [UIView animateWithDuration:.3 animations:^{
            
            _openView.transform = CGAffineTransformIdentity;
            
            _openView.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
            
            _openView.alpha = 1;
            
            _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
            
            _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
            
            _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
            
            _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
            
            _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        }];
    }
}

//点击搜索按钮
-(void)searchAdd{
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    STWisdomSearchViewController *searchVC = [STWisdomSearchViewController new];
    
//    searchVC.hidesBottomBarWhenPushed = YES;
    
    searchVC.codeStr = @"";
    
    searchVC.dataResult = [NSMutableArray new];
    
    searchVC.backBlock = ^{
        
        [weakSelf.dataResultOR removeAllObjects];
        
        [weakSelf.countArray removeAllObjects];
        
        [weakSelf.countNotArray removeAllObjects];
        
        [weakSelf.wisdomFooterView.iphoneBtn setTitle:@"发送(0)" forState:UIControlStateNormal];
        
        [weakSelf.wisdomFooterView.gouBtn setTitle:@"生成采购方案(0)" forState:UIControlStateNormal];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
    [UIView animateWithDuration:.3 animations:^{
        
        bgView.hidden = YES;
        
        isOpen = YES;
        
        _openView.transform = CGAffineTransformIdentity;
        
        _openView.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
        
        _openView.alpha = 1;
        
        _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    }];
}

//点击扫描按钮
-(void)scanAdd{
    
    NSDictionary *dict =@{@"scanSelected":@"2",@"storeid":@""};
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"scanSelected"];
    
    [[STCommon sharedSTSTCommon]toScanViewWith:self];
    
    [UIView animateWithDuration:.3 animations:^{
        
        bgView.hidden = YES;
        
        isOpen = YES;
        
        _openView.transform = CGAffineTransformIdentity;
        
        _openView.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
        
        _openView.alpha = 1;
        
        _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    }];
}

//条码扫描成功后刷新数据
-(void)wisdomRefreshing{
    
    [self.dataResultOR removeAllObjects];
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header beginRefreshing];
}

//条码扫描失败后刷新数据
-(void)failBlockwisdomRefreshing{
    
    isFailCode = YES;
    
}

#pragma mark-分享到QQ和微信
-(void)shareApp:(UIButton *)btn{
    
    [self purchaseHome_TabManualShare:@{@"supplierName":[_dataResultOR[btn.tag - btn_Tag]supplierName]} finshed:^(NSDictionary *paramsData,NSError *error) {
        
        if (!error) {
            
            [[STCommon sharedSTSTCommon] setShare:@{@"title":paramsData[@"title"],@"image":@"hudST_logo",@"url":paramsData[@"url"],@"descr":paramsData[@"descr"]} shareView:self Finished:^(BOOL isSuccessful) {
                
            }];
        }
    }];
}
#pragma mark-选择整个公司的产品
-(void)selectMothed:(UIButton *)btn{
    
    [self setWisdomCollectionView];
    
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    _isAllSelect = NO;
    
    if ([[STCommon sharedSTSTCommon] setSelectName:[_dataResultOR[btn.tag - selectBtn_tag]supplierName] tagArray:_sectionAry]) {
        
        NSMutableArray *idAry = [NSMutableArray new];
        
        for (int i = 0; i < [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count; i++) {
            
            STWisdomEntity *entity = [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo][i];
            
            [idAry addObject:entity.memberID];
        }
        
        NSString *tempString = [idAry componentsJoinedByString:@","];//分隔符逗号
        
        [self setChangeSelect:@{@"id":tempString,@"isSelect":@"false"} finshed:^(BOOL isYes) {
            
            if (isYes) {
                
                [weakSelf.sectionAry removeObject:[weakSelf.dataResultOR[btn.tag - selectBtn_tag]supplierName]];
                
                for (int i = 0; i < [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count; i++) {
                    
                    STWisdomEntity *entity = [weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo][i];
                    
                    if (entity.isSelect.intValue == 1) {
                        
                        [weakSelf.countNotArray removeObject:entity];
                    }
                    
                    entity.isSelect = @"0";
                    
                    [[weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo] replaceObjectAtIndex:i withObject:entity];
                    
                    STWisdomNotShopTableViewCell *cell = weakSelf.cellAry[btn.tag - selectBtn_tag][i];
                    
                    [cell.selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                }
            }
            
            [btn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
            
            //            [weakSelf.tableView reloadData];
            
            
            [weakSelf.sectionNumAry removeAllObjects];
            
            for (int i = 0; i < [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count; i++) {
                
                STWisdomEntity *entity = [weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo][i];
                
                if (entity.isSelect.intValue == 1) {
                    
                    [weakSelf.sectionNumAry addObject:entity];
                    
                }
            }
            
            if ([weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count != weakSelf.sectionNumAry.count) {
                
                [btn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                
            }else{
                
                [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
            }
            
            [weakSelf.wisdomFooterView.iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%zi)",weakSelf.countNotArray.count] forState:UIControlStateNormal];
            
            if (weakSelf.countNotArray.count == weakSelf.allNotArray.count) {
                
                [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                
            }else{
                
                [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                
            }
            
            [weakSelf changeWisdomFooterViewBackgroundColor];
            
        }];
        
    }else{
        
        NSMutableArray *idAry = [NSMutableArray new];
        
        for (int i = 0; i < [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count; i++) {
            
            STWisdomEntity *entity = [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo][i];
            
            [idAry addObject:entity.memberID];
        }
        
        NSString *tempString = [idAry componentsJoinedByString:@","];//分隔符逗号
        
        [self setChangeSelect:@{@"id":tempString,@"isSelect":@"true"} finshed:^(BOOL isYes) {
            
            if (isYes) {
                
                [weakSelf.sectionAry addObject:[weakSelf.dataResultOR[btn.tag - selectBtn_tag]supplierName]];
                
                for (int i = 0; i < [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count; i++) {
                    
                    STWisdomEntity *entity = [weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo][i];
                    
                    if (entity.isSelect.intValue == 0) {
                        
                        [weakSelf.countNotArray addObject:entity];
                        
                    }
                    
                    entity.isSelect = @"1";
                    
                    [[weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo] replaceObjectAtIndex:i withObject:entity];
                    
                    
                    STWisdomNotShopTableViewCell *cell = weakSelf.cellAry[btn.tag - selectBtn_tag][i];
                    
                    [cell.selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                }
                
                //                [weakSelf.tableView reloadData];
                
                [weakSelf.sectionNumAry removeAllObjects];
                
                for (int i = 0; i < [_dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count; i++) {
                    
                    STWisdomEntity *entity = [weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo][i];
                    
                    if (entity.isSelect.intValue == 1) {
                        
                        [weakSelf.sectionNumAry addObject:entity];
                        
                    }
                }
                
                if ([weakSelf.dataResultOR[btn.tag - selectBtn_tag] dataAryTwo].count != weakSelf.sectionNumAry.count) {
                    
                    [btn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                    
                }else{
                    
                    [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                }
                
                [weakSelf.wisdomFooterView.iphoneBtn setTitle:[NSString stringWithFormat:@"发送(%zi)",weakSelf.countNotArray.count] forState:UIControlStateNormal];
                
                if (weakSelf.countNotArray.count == weakSelf.allNotArray.count) {
                    
                    [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                    
                }else{
                    
                    [weakSelf.wisdomFooterView.allSelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                    
                }
                
                [weakSelf changeWisdomFooterViewBackgroundColor];
                
            }
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.navigationController.navigationBar.hidden = YES;
    
    _wisdomFooterView.backgroundColor = RGB(119, 119, 119);
    
    if (_type == 3) {
        
        _wisdomFooterView.backgroundColor = RGB(255, 255, 255);
        
        _wisdomFooterView.iphoneBtn.backgroundColor = RGB(119, 119, 119);
    }
    
    if (isFailCode) {
        
        _wisdomFooterView.backgroundColor = RGB(249, 83, 32);
        
        isFailCode = NO;
    }
    
    if (isHelpBackBlock) {
        
        if (_dataResultOR.count != 0) {
            
            if (topIndex == 0) {
                
                _wisdomFooterView.backgroundColor = RGB(249, 83, 32);
                
            }else if (topIndex == 1){
                
                _wisdomFooterView.backgroundColor = RGB(77, 183, 98);
                
            }else if (topIndex == 2){
                
                _wisdomFooterView.iphoneBtn.backgroundColor = RGB(77, 183, 98);
                
            }
        }
        
        isHelpBackBlock = NO;
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self disMissMasking];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark-- UITapGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    [self disMissMasking];
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        
        return NO;
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self disMissMasking];
}
//移除蒙版
- (void)disMissMasking{
    
    if (_btnMaskView) {
        
        [_btnMaskView removeFromSuperview];
        
        _btnMaskView = nil;
    }
    
    if (_deleteMaskView) {
        
        [_deleteMaskView removeFromSuperview];
        
        _deleteMaskView = nil;
    }
    
    if (_addMaskView) {
        
        [_addMaskView removeFromSuperview];
        
        _addMaskView = nil;
    }
    
    if (topIndex == 2) {
        
        if (_shareMaskView) {
            
            [_shareMaskView removeFromSuperview];
            
            _shareMaskView = nil;
            
        }
    }
}
#pragma mark - 隐藏下拉菜单
-(void)setWisdomCollectionView{
    isSelect = YES;
    _wisdomCollectionView.hidden = YES;
}
#pragma mark - 指导图隐藏
-(void)toGuideFigure{
    
    if (!isHidden) {
        
        _openView.userInteractionEnabled = YES;
        
        _scanView.userInteractionEnabled = YES;
        
        _searchView.userInteractionEnabled = YES;
        
        isOpen = YES;
        
        _addMaskView.hidden = NO;
        
        _deleteMaskView.hidden = NO;
        
        _btnMaskView.hidden = NO;
        
        _openView.hidden = NO;
        
        _searchView.hidden = NO;
        
        _scanView.hidden = NO;
        
        _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
        
        _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
        
        _openView.transform = CGAffineTransformIdentity;
        
        _openView.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
        
        _openView.alpha = 1;
    }
}
//加号按钮隐藏
-(void)hideenOpenView{
    
    _openView.hidden = YES;
    
    _searchView.hidden = YES;
    
    _scanView.hidden = YES;
    
    _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    
    _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    
    _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    
    bgView.hidden = YES;
}
//指导图显示
-(void)selectedLaftView{
    
    _openView.userInteractionEnabled = YES;
    
    _scanView.userInteractionEnabled = YES;
    
    _searchView.userInteractionEnabled = YES;
    
    isOpen = YES;
    
    _wisdomToLeftView.hidden = YES;
    
    _addMaskView.hidden = NO;
    
    _deleteMaskView.hidden = NO;
    
    _btnMaskView.hidden = NO;
    
    _openView.hidden = NO;
    
    _searchView.hidden = NO;
    
    _scanView.hidden = NO;
    
    _searchView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
    
    _scanView.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 120, 50, 50);
    
    _searchLab.frame = CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    
    _scanLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    
    _closeLab.frame =  CGRectMake(kScreenWidth - 62.5, kScreenHeight - 100, 0, 0);
    
    _openView.transform = CGAffineTransformIdentity;
    
    _openView.backgroundColor = [UIColor fromHexValue:0xea5413 alpha:1];
    
    _openView.alpha = 1;
    
    if (_wisdomToLeftView) {
        
        [_wisdomToLeftView removeFromSuperview];
        
        _wisdomToLeftView = nil;
    }
}
#pragma mark - 判断改变WisdomFooterViewBackgroundColor
-(void)changeWisdomFooterViewBackgroundColor{
    
    if (topIndex == 2) {
        
        if (_countNotArray.count != 0) {
            
            _wisdomFooterView.iphoneBtn.backgroundColor = RGB(77, 183, 98);
            
        }else{
            
            _wisdomFooterView.iphoneBtn.backgroundColor = RGB(119, 119, 119);
            
        }
    }
    
    if (topIndex == 0) {
        
        if (_countArray.count != 0) {
            
            _wisdomFooterView.backgroundColor = RGB(249, 83, 32);
            
        }else{
            
            _wisdomFooterView.backgroundColor = RGB(119, 119, 119);
            
        }
    }
}
-(void)setShareAppBack{
    
    __weak STWisdomProcurementViewController *weakSelf  = self;
    
    if (isShare) {
        
        [self setShareOfSuccess:@{@"id":jsonStr} finshed:^(BOOL isSuccess) {
            
            isShare = NO;
            
            if (isSuccess) {
                
                [weakSelf artificialPurchasing];
                
            }else{
                
                [ZHProgressHUD showInfoWithText:@"分享失败"];
            }
        }];
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHARE_Notification object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


