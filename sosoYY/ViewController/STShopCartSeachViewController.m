//
//  STShopCartSeachViewController.m
//  sosoYY
//
//  Created by soso-mac on 2017/8/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STShopCartSeachViewController.h"
#import "STShopCartSearchArtificialTableViewCell.h"
#import "STShopCartSeachTableViewCell.h"
#import "STWisdomSearchViewController.h"
#import "STShopCartSeachBottomView.h"
#import "STSwitchStoreView.h"
#import "STWisdomCollectionView.h"
#import "ImportView.h"
#import "STShopCartSearchAddView.h"
#import "STShopCartSearchUndoView.h"

@interface STShopCartSeachViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,STShopCartSeachTableViewCellDelegate,STShopCartSearchArtificialTableViewCellDelegate>{
    __block BOOL isOK;
    __block BOOL isSelect;//判断是否点击数字下拉菜单
    NSTimer *orTime;
    int orTimeCount;
}
@property (weak, nonatomic) IBOutlet UIView *seachView;
@property (weak, nonatomic) IBOutlet UITextField *seachTextField;
@property(strong,nonatomic)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;
@property (weak, nonatomic) IBOutlet UIButton *allSearchBtn;
@property(strong,nonatomic)STSwitchStoreView *wisdomStoreView;
@property(strong,nonatomic)STSwitchStoreView *artificialStoreView;

@property(strong,nonatomic)NSMutableArray *wisdomDataResult;
@property(strong,nonatomic)NSMutableArray *artificialDataResult;

@property(strong,nonatomic)NSMutableArray *wisdomCellResult;

@property(strong,nonatomic)STWisdomCollectionView *wisdomCollectionView;
@property(strong,nonatomic)ImportView *importView;
@property(strong,nonatomic)STShopCartSearchUndoView *shopCartSearchUndoView;
@property(strong,nonatomic)STShopCartSearchAddView *shopCartSearchAddView;
@property(strong,nonatomic)STShopCartSeachBottomView *shopCartSeachBottomView;


@property(strong,nonatomic)STShopCartSeachEntity *entity;
@property(strong,nonatomic)STShopCartSeachTableViewCell *cell;
@property(strong,nonatomic)NSIndexPath *indexPath;
@property(assign,nonatomic)CGFloat offsetY;

@end

@implementation STShopCartSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _seachView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _seachView.layer.borderWidth = 1.0f;
    _allSearchBtn.layer.masksToBounds = YES;
    _allSearchBtn.layer.cornerRadius = 5.0f;
    _seachTextField.delegate = self;
    _allSearchBtn.hidden = YES;
    _promptLab.text = @"搜索采购计划(智慧采购,人工采购)中的商品";
    
    [_seachTextField becomeFirstResponder];
    
    _wisdomDataResult = [NSMutableArray new];
    
    _artificialDataResult = [NSMutableArray new];
    
    _wisdomCellResult = [NSMutableArray new];
    
    isSelect = YES;
    isOK = NO;
    [self addSubView];
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
#pragma kark -- 人工采购
    _artificialStoreView = [[[NSBundle mainBundle]loadNibNamed:@"STSwitchStoreView" owner:self options:nil]lastObject];
    _artificialStoreView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _artificialStoreView.hidden = YES;
    [_artificialStoreView setSwitchStoreViewTitle:@"选择店铺"];
    _artificialStoreView.SwitchStoreViewBlock = ^(int type, NSDictionary *dict, NSIndexPath *indexPath) {
        weakSelf.artificialStoreView.hidden = YES;
        
        [weakSelf.artificialStoreView setSwitchStoreColseView];
        switch (type) {
            case 0:{
                return;
                break;
            }
            case 1:{
                
                [weakSelf  addPurchaseCartProduct:@{@"num":dict[@"buyCount"],@"pid":dict[@"Pid"]} finshed:^(STShopCartSeachEntity *entity,NSString *mesg,NSString *code,NSError *error) {
                    
                    if (!error) {
                        if ([code intValue] == 1) {
                            
                            [weakSelf httpShopCartSeach:weakSelf.seachTextField.text];
                            [ZHProgressHUD showSuccessWithText:@"切换店铺成功！"];
                            
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
    [self.view addSubview:_artificialStoreView];
    
    
#pragma kark -- 智慧采购
    _wisdomStoreView = [[[NSBundle mainBundle]loadNibNamed:@"STSwitchStoreView" owner:self options:nil]lastObject];
    _wisdomStoreView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _wisdomStoreView.hidden = YES;
    [_wisdomStoreView setSwitchStoreViewTitle:@"选择其他店铺"];
    _wisdomStoreView.SwitchStoreViewBlock = ^(int type, NSDictionary *dict, NSIndexPath *indexPath) {
        weakSelf.wisdomStoreView.hidden = YES;
        [weakSelf.wisdomStoreView setSwitchStoreColseView];
        switch (type) {
            case 0:
                break;
            case 1:{
                NSDictionary *params = @{@"Pid":dict[@"Pid"],@"Goods_Package_ID":dict[@"Goods_Package_ID"],@"buyCount":dict[@"buyCount"]};
                [KSMNetworkRequest getRequest:requestSelectOtherStorePorduct params:params success:^(id responseObj) {
                    
                    if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
                        
                        [ZHProgressHUD dismiss];
                        
                        [weakSelf httpShopCartSeach:weakSelf.seachTextField.text];
                        
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
    [self.view addSubview:_wisdomStoreView];
    
    
#pragma mark - 下拉数量单
    _wisdomCollectionView = [[STWisdomCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 0, 0, 0)];
    _wisdomCollectionView.layer.masksToBounds = YES;
    _wisdomCollectionView.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _wisdomCollectionView.layer.borderWidth = .5;
    _wisdomCollectionView.layer.cornerRadius = 3.0f;
    _wisdomCollectionView.WisdomCollectionViewBlock = ^(NSString *text){
        
        [KSMNetworkRequest getRequest:requestWisdomChangeGoodsCount params:@{@"pid":weakSelf.entity.pid,@"num":text} success:^(id responseObj) {
            
            isSelect = YES;
            
            weakSelf.wisdomCollectionView.hidden = YES;
            
            if ([[responseObj objectForKey:@"code"] integerValue] == 1) {
                
                if (weakSelf.entity.PromotionTypes.integerValue == 1) {
                    
                    NSDictionary *addDict = weakSelf.entity.purchasetAddPricePromotionsList[0];
                    
                    if (text.floatValue < [addDict[@"firstProudctStartNum"] floatValue]) {
                        weakSelf.entity.pmid = @"0";
                    }
                }
                
                
                
                weakSelf.entity.buyCount = [STCommon setHasSuffix:[NSString stringWithFormat:@"%@",text]];
                
                [weakSelf.wisdomDataResult replaceObjectAtIndex:weakSelf.indexPath.row withObject:weakSelf.entity];
                
                [weakSelf.wisdomCellResult replaceObjectAtIndex:weakSelf.indexPath.row withObject: [weakSelf setWisdomCellEntity:weakSelf.entity tableView:weakSelf.tableView]];
                
                [weakSelf.tableView reloadData];
                
            }else {
                
                [ZHProgressHUD showErrorWithText:@"网络错误，请重试！"];
            }
            
            
        } failure:^(NSError *error) {
            
            [ZHProgressHUD showErrorWithText:@"网络错误，请重试！"];
        }];
    };
    
    
    self.wisdomCollectionView.WisdomBtnBlock = ^(UIButton *btn) {
        
#pragma mark 其他店铺选择
        if (btn.tag == 100) {
            
            [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
            
            [KSMNetworkRequest  getSwitchStoreUrl:requestGetOtherStorePorductList params:@{@"StoreId":weakSelf.entity.store_Id,@"Goods_Package_ID":weakSelf.entity.Goods_Package_ID} finshed:^(id dataResult, NSError *error) {
                
                isSelect = YES;
                weakSelf.wisdomCollectionView.hidden = YES;
                
                weakSelf.wisdomStoreView.hidden = NO;
                [weakSelf.wisdomStoreView setSwitchStoreViewResult:dataResult indexPath:weakSelf.indexPath];
                
                [[UIApplication sharedApplication].keyWindow hideToastActivity];
            }];
        }else {
            
            NSString *alertTitle = @"";
            NSString *alertStr = @"";
            NSString *errorMSg = @"";
            NSString *url = @"";
            NSDictionary *params = nil;
            NSString *undoMsg = @"";
            
#pragma mark 删除商品 淘汰商品
            if ([btn.currentTitle isEqualToString:@"删除商品"]) {
                
                alertTitle = @"温馨提示";
                alertStr = @"确认删除该商品?";
                url = requestWisdomDeleteGood;
                params = @{@"pid":weakSelf.entity.pid};
                errorMSg = @"删除失败";
            }else {
                alertTitle = @"确认淘汰该商品?";
                alertStr = @"淘汰后商品将不再出现在采购清单当中,手动恢复请点击右上角按钮进入淘汰商品清单中加入采购清单";
                url = requestDeletePurchaseEliminate;
                params = @{@"id":weakSelf.entity.memberID};
                errorMSg = @"淘汰失败";
                undoMsg = @"该商品已被移入淘汰商品列表";
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertStr preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
                
                [KSMNetworkRequest WisdomShopCartWeekOutProduce:url params:params finished:^(BOOL finish) {
                    
                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                    
                    if (finish) {
                        
                        isSelect = YES;
                        weakSelf.wisdomCollectionView.hidden = YES;
                        
                        [weakSelf.wisdomDataResult removeObjectAtIndex:weakSelf.indexPath.row];
                        
                        [weakSelf.wisdomCellResult removeObjectAtIndex:weakSelf.indexPath.row];
                        
                        if (weakSelf.wisdomDataResult.count > 1) {
                            
                            [weakSelf.tableView deleteRowsAtIndexPaths:@[weakSelf.indexPath] withRowAnimation:UITableViewRowAnimationRight];
                            
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            
                        }else{
                            
                            //                        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:weakSelf.indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                            //
                            //                        [weakSelf.tableView reloadData];
                            [weakSelf httpShopCartSeach:weakSelf.seachTextField.text];
                        }
                        
                        if (_entity.source.integerValue > 0) {//手动添加
                            
                        }else{
                            [weakSelf showUndoView:undoMsg];
                        }
                        
                    }else {
                        [ZHProgressHUD showErrorWithText:errorMSg];
                    }
                }];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    };
    _wisdomCollectionView.hidden = YES;
    
#pragma mark - 改变数量
    _importView = [[[NSBundle mainBundle] loadNibNamed:@"ImportView" owner:self options:nil] lastObject];
    _importView.layer.masksToBounds = YES;
    _importView.layer.cornerRadius = 3.0f;
    _importView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _importView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_importView];
    
#pragma mark -- 换购
    _shopCartSearchAddView = [STShopCartSearchAddView new];
    _shopCartSearchAddView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    _shopCartSearchAddView.moveBlock = ^{
        
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.shopCartSearchAddView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        }];
    };
    
    _shopCartSearchAddView.sureBlock = ^(NSInteger selectIndex) {
        
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.shopCartSearchAddView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        }];
        
        if (selectIndex == 1) {
            [KSMNetworkRequest setChangeSelectUrl:requestChangeSelect params:@{@"id":weakSelf.entity.memberID,@"isSelect":@"true",@"forCart":@"1"} finshed:^(BOOL isYes) {
                if (isYes) {
                    
                    //添加加价购
                    if (weakSelf.entity.PromotionTypes.integerValue == 1) {
                        
                        for (NSDictionary *addDict in weakSelf.entity.purchasetAddPricePromotionsList) {
                            weakSelf.entity.pmid = [NSString stringWithFormat:@"%@",addDict[@"pmid"]];
                        }
                    }
                    [weakSelf.wisdomDataResult replaceObjectAtIndex:weakSelf.indexPath.row withObject:weakSelf.entity];
                    
                    [weakSelf.wisdomCellResult replaceObjectAtIndex:weakSelf.indexPath.row withObject:[weakSelf setWisdomCellEntity:weakSelf.entity tableView:weakSelf.tableView]];
                    
                    [weakSelf.tableView reloadData];
                }
            }];
            
        }else{
            
            [KSMNetworkRequest setChangeSelectUrl:requestChangeSelect params:@{@"id":weakSelf.entity.memberID,@"isSelect":@"true",@"forCart":@"1"} finshed:^(BOOL isYes) {
                if (isYes) {
                    
                    weakSelf.entity.pmid = @"0";
                    
                    [weakSelf.wisdomDataResult replaceObjectAtIndex:weakSelf.indexPath.row withObject:weakSelf.entity];
                    
                    [weakSelf.wisdomCellResult replaceObjectAtIndex:weakSelf.indexPath.row withObject:[weakSelf setWisdomCellEntity:weakSelf.entity tableView:weakSelf.tableView]];
                    
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_shopCartSearchAddView];
    
    
#pragma mark - 撤销
    _shopCartSearchUndoView = [STShopCartSearchUndoView new];
    _shopCartSearchUndoView.frame = CGRectMake(kScreenWidth, kScreenHeight - 90, kScreenWidth, 40);
    _shopCartSearchUndoView.undoBlock = ^{
        [weakSelf undoClick];
    };
    [self.view addSubview:_shopCartSearchUndoView];
}
- (void)showUndoView:(NSString *)alert {
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    _shopCartSearchUndoView.undoMsg.text  = alert;
    
    orTimeCount = 5;
    
    orTime = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:orTime forMode:NSRunLoopCommonModes];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        weakSelf.shopCartSearchUndoView.frame = CGRectMake(0, kScreenHeight-90, kScreenWidth, 40);
        
    }];
}

/**
 *  倒计时逻辑
 */
-(void)timerFired:(NSTimer *)timer {
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    if (orTimeCount == 0) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.shopCartSearchUndoView.frame = CGRectMake(kScreenWidth, kScreenHeight - 90, kScreenWidth, 40);
        }];
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    }
    orTimeCount--;
}

#pragma mark 撤销
- (void)undoClick {
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    [KSMNetworkRequest getCancelDeletePurchaseEliminateForIdUrl:requestCancelDeletePurchaseEliminateForId params:@{@"id":weakSelf.entity.memberID} finshed:^(BOOL isYes, NSError *error) {
        //撤销成功
        if (isYes) {
            
            [orTime invalidate];
            orTime = nil;
            
            [_wisdomDataResult insertObject:weakSelf.entity atIndex: weakSelf.indexPath.row];
            
            [weakSelf.wisdomCellResult insertObject:weakSelf.cell atIndex:weakSelf.indexPath.row];
            
            [weakSelf.tableView reloadData];
            
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.shopCartSearchUndoView.frame = CGRectMake(kScreenWidth, kScreenHeight - 90, kScreenWidth, 40);
            }];
        }
    }];
}
#pragma mark -- 添加tableView
-(void)addSubView{
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight)style:UITableViewStylePlain];
    _tableView.userInteractionEnabled = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isOK = NO;
        [weakSelf httpShopCartSeach:_seachTextField.text];
    }];
    
#pragma mark -- 底部按钮
    _shopCartSeachBottomView = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachBottomView" owner:self options:nil]lastObject];
    _shopCartSeachBottomView.frame = CGRectMake(0, kScreenHeight - kTabBarHeight, kScreenWidth, kTabBarHeight);
    _shopCartSeachBottomView.hidden = YES;
    _shopCartSeachBottomView.ShopCartSeachBottomBlock = ^{
        
        STWisdomSearchViewController *searchVC = [STWisdomSearchViewController new];
        searchVC.codeStr = @"";
        searchVC.keywords = weakSelf.seachTextField.text;
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    };
    
    [self.view addSubview:_shopCartSeachBottomView];
    
}
#pragma mark -  智慧采购购物车内搜索
-(void)httpShopCartSeach:(NSString *)text{
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [KSMNetworkRequest getPurchaseCartSearchUrl:requestPurchaseCartSearch params:@{@"keyWord":text} finshed:^(id wisdomDataResult,id artificialDataResult,NSError *error) {
            
            weakSelf.wisdomDataResult = wisdomDataResult;
            
            weakSelf.artificialDataResult = artificialDataResult;
            
            [weakSelf setChangeWisdomDataResult];
            
            if (weakSelf.wisdomDataResult.count == 0 && weakSelf.artificialDataResult.count == 0) {
                
                [[UIApplication sharedApplication].keyWindow hideToastActivity];
            }
            
            if (weakSelf.artificialDataResult.count > 0 || weakSelf.wisdomDataResult.count > 0) {
                weakSelf.tableView.frame =  CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - kTabBarHeight);
                weakSelf.tableView.hidden = NO;
                weakSelf.shopCartSeachBottomView.hidden = NO;
                weakSelf.promptLab.hidden = YES;
                weakSelf.allSearchBtn.hidden = YES;
                
            }else{
                weakSelf.tableView.frame =  CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight);
                weakSelf.tableView.hidden = YES;
                weakSelf.shopCartSeachBottomView.hidden = YES;
                weakSelf.promptLab.hidden = NO;
                weakSelf.promptLab.text = @"智慧采购中未搜索到该商品";
                weakSelf.allSearchBtn.hidden = NO;
            }
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    
                    [weakSelf.tableView.mj_header endRefreshing];
                    [weakSelf.tableView.mj_footer endRefreshing];
                    [[UIApplication sharedApplication].keyWindow hideToastActivity];
                });
                isOK = YES;
            }else{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                
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
        }
    }];
}
#pragma mark -  智慧采购凑单加购物车接口
-(void)addPurchaseCartProduct:(NSDictionary *)params finshed:(void(^)(STShopCartSeachEntity *entity,NSString *mesg,NSString *code,NSError *error))finshed{
    [KSMNetworkRequest getPurchaseCartUrl:requestAddPurchaseProduct params:params finshed:^(STShopCartSeachEntity *entity,NSString *mesg,NSString *code, NSError *error) {
        finshed(entity,mesg,code,error);
    }];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_wisdomDataResult.count > 0 && _artificialDataResult.count > 0) {
        
        return 2;
    }else if(_wisdomDataResult.count > 0 || _artificialDataResult.count > 0){
        return 1;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_wisdomDataResult.count > 0 && _artificialDataResult.count > 0) {
        if (section == 0) {
            return _wisdomDataResult.count;
        }else{
            return _artificialDataResult.count;
        }
        
    }else{
        if (_wisdomDataResult.count > 0) {
            
            return _wisdomDataResult.count;
            
        }else if (_artificialDataResult.count > 0){
            
            return _artificialDataResult.count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_wisdomDataResult.count > 0 && _artificialDataResult.count > 0) {
        
        if (indexPath.section == 0) {
            
            STShopCartSeachEntity *entity = _wisdomDataResult[indexPath.row];
            STShopCartSeachTableViewCell *cell = _wisdomCellResult[indexPath.row];
            [cell setShopCartSeach:entity indexPath:indexPath];
            return cell;
        }else{
            STShopCartSeachEntity *entity = _artificialDataResult[indexPath.row];
            STShopCartSearchArtificialTableViewCell *cell = [self setArtificialCellEntity:entity tableView:tableView];
            [cell setShopCartSearchArtificial:entity indexPath:indexPath];
            return cell;
        }
        
    }else{
        if (_wisdomDataResult.count > 0) {
            STShopCartSeachEntity *entity = _wisdomDataResult[indexPath.row];
            STShopCartSeachTableViewCell *cell = _wisdomCellResult[indexPath.row];
            [cell setShopCartSeach:entity indexPath:indexPath];
            return cell;
        }else if (_artificialDataResult.count > 0){
            STShopCartSeachEntity *entity = _artificialDataResult[indexPath.row];
            STShopCartSearchArtificialTableViewCell *cell = [self setArtificialCellEntity:entity tableView:tableView];
            [cell setShopCartSearchArtificial:entity indexPath:indexPath];
            return cell;
        }
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    
    UILabel *titel = [UILabel new];
    titel.frame = CGRectMake(10, 0, kScreenWidth - 60, 40);
    titel.textColor = RGB(51, 51, 51);
    
    if (_wisdomDataResult.count > 0 && _artificialDataResult.count > 0) {
        if (section == 0) {
            titel.text = @"智慧采购";
        }else{
            titel.text = @"人工采购";
        }
        
    }else{
        if (_wisdomDataResult.count > 0) {
            
            titel.text = @"智慧采购";
            
        }else if (_artificialDataResult.count > 0){
            
            titel.text = @"人工采购";
        }
    }
    
    titel.font = [UIFont systemFontOfSize:16];
    [headView addSubview:titel];
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    line.frame = CGRectMake(0, 39, kScreenWidth, .5);
    [headView addSubview:line];
    
    return headView;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- STShopCartSeachTableViewCellDelegate
-(void)g_SelectMothed:(STShopCartSeachTableViewCell *)cell{
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    STShopCartSeachEntity *entity = _wisdomDataResult[indexPath.row];
    
    [KSMNetworkRequest setChangeSelectUrl:requestChangeSelect params:@{@"id":entity.memberID,@"isSelect":entity.isSelect.intValue == 1 ?@"false":@"true",@"forCart":@"0"} finshed:^(BOOL isYes) {
        if (isYes) {
            
            entity.isSelect = entity.isSelect.intValue == 1? @"0":@"1";
            if (entity.PromotionTypes.integerValue == 1) {
                
                if (entity.pmid.integerValue > 0) {
                    
                    [KSMNetworkRequest getRequest:requestChangePromotionTypes params:@{@"pid":entity.pid,@"pmid":@"0"} success:^(id responseObj) {
                        
                        entity.pmid = @"0";
                        
                        [weakSelf.wisdomDataResult replaceObjectAtIndex:indexPath.row withObject:entity];
                        
                        [weakSelf.wisdomCellResult replaceObjectAtIndex:indexPath.row withObject:[weakSelf setWisdomCellEntity:entity tableView:weakSelf.tableView]];
                        
                        [weakSelf.tableView reloadData];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }else{
                    
                    [weakSelf.wisdomDataResult replaceObjectAtIndex:indexPath.row withObject:entity];
                    
                    [weakSelf.wisdomCellResult replaceObjectAtIndex:indexPath.row withObject:[weakSelf setWisdomCellEntity:entity tableView:weakSelf.tableView]];
                    
                    [weakSelf.tableView reloadData];
                }
            }else{//非加价购
                
                [weakSelf.wisdomDataResult replaceObjectAtIndex:indexPath.row withObject:entity];
                
                [weakSelf.wisdomCellResult replaceObjectAtIndex:indexPath.row withObject:[weakSelf setWisdomCellEntity:entity tableView:weakSelf.tableView]];
                
                [weakSelf.tableView reloadData];
            }
        }
    }];
}
-(void)g_ChangeNumMothed:(STShopCartSeachTableViewCell *)cell{
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    __block STShopCartSeachEntity *entity = _wisdomDataResult[indexPath.row];
    
    LiModel *goodModel = [self setChangeImportView:entity];
    
    _importView.hidden = NO;
    _importView.goodModel = goodModel;
    _importView.deleteImportBlock = ^{
        weakSelf.importView.hidden = YES;
    };
    
    _importView.WisdomAdd_reduceBlock = ^(double count) {
        
        weakSelf.importView.hidden = YES;
        
        NSLog(@"%@",entity.PromotionTypes);
        //添加加价购
        if (entity.PromotionTypes.integerValue == 1) {
            
            NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
            
            if ([addDict[@"addPriceType"] integerValue] == 0) {
                
                if (count < [addDict[@"firstProudctStartNum"]floatValue] && entity.pmid.integerValue > 0) {
                    NSDictionary *params = @{@"pid":entity.pid,@"pmid":@"0"};
                    [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
                        entity.pmid = @"0";
                    } failure:^(NSError *error) {
                        FxLog(@"error = %@",error);
                    }];
                }
            }else if ([addDict[@"addPriceType"] integerValue] == 1 ) {
                
                if (count < [addDict[@"firstProudctPerNum"]floatValue] && entity.pmid.integerValue > 0) {
                    NSDictionary *params = @{@"pid":entity.pid,@"pmid":@"0"};
                    [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
                        entity.pmid = @"0";
                    } failure:^(NSError *error) {
                        FxLog(@"error = %@",error);
                    }];
                }
            }
        }
        //            //添加加价购
        //            if (weakSelf.entity.PromotionTypes.integerValue == 1) {
        //
        //                NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
        //
        //                if (count < [addDict[@"firstProudctStartNum"] floatValue]) {
        //
        //                    entity.pmid = @"0";
        //                }
        //            }
        
        
        entity.buyCount = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];
        
        [weakSelf.wisdomDataResult replaceObjectAtIndex:indexPath.row withObject:entity];
        
        
        [weakSelf.wisdomCellResult replaceObjectAtIndex:indexPath.row withObject:[weakSelf setWisdomCellEntity:entity tableView:weakSelf.tableView]];
        
        [weakSelf.tableView reloadData];
        
    };
}
-(void)g_ListMothed:(STShopCartSeachTableViewCell *)cell{
    
    if (isSelect) {
        
        [self setLisWisdomCollectionViewFrame:cell];
        
    }else{
        
        isSelect = YES;
        
        _wisdomCollectionView.hidden = YES;
    }
}
//设置WisdomCollectionView的高度
-(void)setLisWisdomCollectionViewFrame:(STShopCartSeachTableViewCell *)cell{
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    STShopCartSeachEntity *entity = _wisdomDataResult[indexPath.row];
    
    _entity = entity;
    _indexPath = indexPath;
    _cell = cell;
    
    if (_artificialDataResult.count == 0) {
        //在最底部
        if (indexPath.row == _wisdomDataResult.count-1 && self.tableView.contentSize.height > self.tableView.height-70) {
            [UIView animateWithDuration:0.4 animations:^{
                
                self.tableView.contentOffset = CGPointMake(0, self.offsetY+90);
            }];
        }
    }
    
    isSelect = NO;
    _wisdomCollectionView.hidden = NO;
    
    //判断是否是手动添加
    if ([entity.source integerValue] > 0) {
        weakSelf.wisdomCollectionView.titles = @[@"从其他店铺选择",@"删除商品"];
    }else {
        weakSelf.wisdomCollectionView.titles = @[@"从其他店铺选择",@"淘汰商品"];
    }
    
    CGRect rect = [_tableView rectForRowAtIndexPath:indexPath];
    
    for (UIView *view in _tableView.subviews) {
        
        if ([view isEqual:_wisdomCollectionView]) {
            
            [view removeFromSuperview];
        }
    }
    [_tableView addSubview:_wisdomCollectionView];
    
    _wisdomCollectionView.frame = CGRectMake(kScreenWidth - 158, rect.origin.y + cell.listBtn.frame.origin.y + 31 , 150, 110);
    
    NSArray *array = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",entity.buyNumList[0]],[NSString stringWithFormat:@"%@",entity.buyNumList[1]],[NSString stringWithFormat:@"%@",entity.buyNumList[2]], nil];
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:array];
    
    [weakSelf.wisdomCollectionView setSelectAry:list frame:_wisdomCollectionView.frame];
}

#pragma mark 点击去换购
-(void)g_GoMothed:(STShopCartSeachTableViewCell *)cell{
    
    __weak STShopCartSeachViewController *weakSelf = self;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    STShopCartSeachEntity *entity = _wisdomDataResult[indexPath.row];
    
    _entity = entity;
    _indexPath = indexPath;
    
    weakSelf.shopCartSearchAddView.entity = entity;
    
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.shopCartSearchAddView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
    }];
}

#pragma mark - STShopCartSearchArtificialTableViewCellDelegate
-(void)g_AddMothed:(STShopCartSearchArtificialTableViewCell *)cell{
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    STShopCartSeachEntity *entity = _artificialDataResult[indexPath.row];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    NSDictionary *params = @{@"StoreId":@"0",@"Goods_Package_ID":entity.Goods_Package_ID};
    
    [KSMNetworkRequest  getSwitchStoreUrl:requestGetOtherStorePorductList params:params finshed:^(id dataResult, NSError *error) {
        _artificialStoreView.hidden = NO;
        [_artificialStoreView setSwitchStoreViewResult:dataResult indexPath:indexPath];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

#pragma  mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _wisdomCollectionView.hidden = YES;
    
    isSelect = YES;
    
    self.offsetY = scrollView.contentOffset.y;
}

//搜索
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _seachTextField.text = @"";
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_seachTextField resignFirstResponder];
    
    _tableView.hidden = NO;
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

- (IBAction)seachMothed:(UIButton *)sender {
    
    _tableView.hidden = NO;
    
    [_seachTextField resignFirstResponder];
    
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)back:(id)sender {
    if (_ShopCartBlock) {
        _ShopCartBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)allSearchMothed:(id)sender {
    
    STWisdomSearchViewController *searchVC = [STWisdomSearchViewController new];
    searchVC.codeStr = @"";
    searchVC.keywords = _seachTextField.text;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(STShopCartSeachTableViewCell *)setWisdomCellEntity:(STShopCartSeachEntity *)entity tableView:(UITableView *)tableView{
    static NSString *cellName = @"cellName";
    STShopCartSeachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    //手动添加
    if (entity.source.integerValue > 0) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:1];
        
        //手动添加特价
        if (entity.PricePromotionsTypes.integerValue == 1) {
            
            NSDictionary *purchasetSpecialPricePromotions = entity.purchasetSpecialPricePromotions;
            
            switch ([purchasetSpecialPricePromotions[@"limittype"] intValue]) {
                case 0:{//不限购
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:2];
                    break;
                }
                case 1:{//每人限购
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:3];
                }
                case 2:{//每人每天限购
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:3];
                    break;
                }
                default:
                    break;
            }
        }
        
        //手动添加加价购
        if (entity.PromotionTypes.integerValue == 1) {
            
            NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
            
            switch ([addDict[@"addPriceType"] intValue]) {
                case 0:{//满多少加多少
                    
                    if (entity.pmid.intValue > 0) {
                        
                        NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
                        
                        if (entity.buyCount.floatValue < [addDict[@"firstProudctStartNum"] floatValue]) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:5];
                        }else{
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:6];
                        }
                    }else{
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:5];
                    }
                    
                    break;
                }
                case 1:{
                    
                    if (entity.pmid.intValue > 0) {
                        NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
                        
                        if (entity.buyCount.floatValue < [addDict[@"firstProudctPerNum"] floatValue]) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:5];
                        }else{
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:6];
                        }
                    }else{
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:5];
                    }
                    break;
                }
                    
                default:
                    break;
            }
        }
        __block BOOL isORRemainder = false;
        
        [STCommon isRemainderD1:entity.buyCount.doubleValue withD2:entity.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {
            
            isORRemainder = isRemainder;
        }];
        
        
        __block BOOL isJZRemainder = false;
        
        [STCommon isRemainderD1:entity.buyCount.doubleValue withD2:entity.Product_Pcs.doubleValue Block:^(BOOL isRemainder, int multiple) {
            
            isJZRemainder = isRemainder;
        }];
        
        //超出库存
        if ([entity.buyCount doubleValue] > [entity.stock doubleValue] && entity.stock.doubleValue > 0) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:4];
            
        }else if ([entity.buyCount doubleValue] < [entity.minBuy doubleValue]) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:4];
            //输入的不是中包装的倍数
        }else if ([entity.sellType doubleValue] == 2 && !isORRemainder) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:4];
            //输入的不是件装的倍数
        }else if ([entity.sellType doubleValue] == 3 && !isJZRemainder) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:4];
        }
    }else{//正常
        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:0];
        //特价
        if (entity.PricePromotionsTypes.integerValue == 1) {
            
            NSDictionary *purchasetSpecialPricePromotions = entity.purchasetSpecialPricePromotions;
            
            
            switch ([purchasetSpecialPricePromotions[@"limittype"] intValue]) {
                case 0:{//不限购
                    
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:7];
                    break;
                }
                case 1:{//每人限购
                    
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:8];
                    break;
                }
                case 2:{//每人每天限购
                    
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:8];
                    break;
                }
                default:
                    break;
            }
        }
        //加价购
        if (entity.PromotionTypes.integerValue == 1) {
            
            
            NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
            
            switch ([addDict[@"addPriceType"] intValue]) {
                case 0:{//满多少加多少
                    
                    if (entity.pmid.intValue > 0) {
                        //                        NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
                        
                        //                        if (entity.buyCount.floatValue < [addDict[@"firstProudctStartNum"] floatValue]) {
                        //                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:10];
                        //                        }else{
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:11];
                        //                        }
                    }else{
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:10];
                    }
                    break;
                }
                case 1:{
                    if (entity.pmid.intValue > 0) {
                        NSDictionary *addDict = entity.purchasetAddPricePromotionsList[0];
                        
                        if (entity.buyCount.floatValue < [addDict[@"firstProudctStartNum"] floatValue]) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:10];
                        }else{
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:11];
                        }
                    }else{
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:10];
                    }
                    break;
                }
                default:
                    break;
            }
        }
        
        __block BOOL isORRemainder = false;
        
        __block BOOL isJZRemainder = false;
        
        [STCommon isRemainderD1:entity.buyCount.doubleValue withD2:entity.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {
            
            isORRemainder = isRemainder;
        }];
        
        [STCommon isRemainderD1:entity.buyCount.doubleValue withD2:entity.Product_Pcs.doubleValue Block:^(BOOL isRemainder, int multiple) {
            
            isJZRemainder = isRemainder;
        }];
        
        //超出库存
        if ([entity.buyCount doubleValue] > [entity.stock doubleValue] && entity.stock.doubleValue > 0) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:9];
            
        }else if ([entity.buyCount doubleValue] < [entity.minBuy doubleValue]) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:9];
            //输入的不是中包装的倍数
        }else if ([entity.sellType doubleValue] == 2 && !isORRemainder) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:9];
            //输入的不是件装的倍数
        }else if ([entity.sellType doubleValue] == 3 && !isJZRemainder) {
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSeachTableViewCell" owner:self options:nil]objectAtIndex:9];
        }
    }
    cell.delegate = self;
    return cell;
}

-(STShopCartSearchArtificialTableViewCell *)setArtificialCellEntity:(STShopCartSeachEntity *)entity tableView:(UITableView *)tableView{
    
    if (entity.Goods_Package_ID.integerValue == 0) {
        
        static NSString *cellNameA = @"cellNameA";
        STShopCartSearchArtificialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameA];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSearchArtificialTableViewCell" owner:self options:nil]objectAtIndex:1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }else{
        
        static NSString *cellNameA = @"cellNameA";
        STShopCartSearchArtificialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameA];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSearchArtificialTableViewCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.delegate = self;
        }
        return cell;
    }
}
#pragma mark -- 改变cell显示
-(void)setChangeWisdomDataResult{
    
    [_wisdomCellResult removeAllObjects];
    
    if (_wisdomDataResult.count > 0 && _artificialDataResult.count > 0) {
        
        for (int i = 0; i < _wisdomDataResult .count; i++) {
            
            STShopCartSeachEntity *entity = _wisdomDataResult[i];
            
            [_wisdomCellResult addObject: [self setWisdomCellEntity:entity tableView:_tableView]];
        }
    }else{
        if (_wisdomDataResult.count > 0) {
            for (int i = 0; i < _wisdomDataResult .count; i++) {
                
                STShopCartSeachEntity *entity = _wisdomDataResult[i];
                [_wisdomCellResult addObject: [self setWisdomCellEntity:entity tableView:_tableView]];
            }
        }
    }
}

#pragma mark -- 改变ExchangeView显示
-(LiModel *)setChangeImportView:(STShopCartSeachEntity *)entity{
    
    LiModel *goodModel = [LiModel new];
    
    goodModel.minBuy = entity.minBuy;
    goodModel.stock = entity.stock;
    goodModel.buyCount = entity.buyCount;
    goodModel.pid = entity.pid;
    goodModel.sellType = entity.sellType;
    goodModel.Goods_Unit = entity.Goods_Unit;
    goodModel.Product_Pcs_Small = entity.Product_Pcs_Small;
    goodModel.Product_Pcs = entity.Product_Pcs;
    
    return goodModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (orTime) {
        [orTime invalidate];
        orTime = nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (orTime) {
        [orTime invalidate];
        orTime = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end