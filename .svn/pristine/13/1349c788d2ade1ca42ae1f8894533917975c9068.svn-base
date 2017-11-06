//
//  STWisdomWeedOutViewController.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomWeedOutViewController.h"
#import "STWisdomShopTableViewCell.h"
#import "STWisdomFooterView.h"
#import "STProductDetailsViewController.h"
#import "STSwitchStoreView.h"
@interface STWisdomWeedOutViewController ()<UITableViewDelegate,UITableViewDataSource,STWisdomShopTableViewCellDelegate>{
    __block BOOL isOK;
    UILabel *_lab;
}
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataResult;
@property(strong,nonatomic)STWisdomFooterView *wisdomFooterView;
@property(strong,nonatomic)STSwitchStoreView *switchStoreView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(strong,nonatomic)NSString *psnStr;
@end

@implementation STWisdomWeedOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isOK = NO;
    _dateLabel.text = [NSString stringWithFormat:@"更新日期:%@",[[STCommon sharedSTSTCommon] setDate]];
    [self addSubView];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self httpDownloadRequestEliminateList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//数据请求
-(void)httpDownloadRequestEliminateList{
    __weak STWisdomWeedOutViewController *weakSelf = self;
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [KSMNetworkRequest getEliminateListUrl:requestEliminateList params:nil finshed:^(id dataResult, NSError *error) {
            if (!error) {
                weakSelf.dataResult = dataResult;
            }else{
                [ZHProgressHUD showInfoWithText:@"暂无数据"];
                _lab.hidden = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.dataResult.count != 0) {
                    weakSelf.wisdomFooterView.backgroundColor = RGB(77, 183, 98);
                    _lab.hidden = YES;
                }else{
                    _lab.hidden = NO;
                }
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
        }
    }];
}

////加入计划
//-(void)cancelPurchaseEliminateForPsn:(NSDictionary *)params indexPath:(NSIndexPath *)indexPath{
//    __weak STWisdomWeedOutViewController *weakSelf = self;
//    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
//
//    [KSMNetworkRequest getChangePurchaseCountUrl:requestCancelPurchaseEliminateForPsn
//                                          params:params finshed:^(id dataResult,NSError *error) {
//                                              if (!error) {
//
//                                                  if (![params[@"psn"] isEqualToString:@""]) {
//
//                                                      if (weakSelf.dataResult.count > indexPath.section) {
//
//                                                          [weakSelf.dataResult removeObjectAtIndex:indexPath.section];
//
//                                                            [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
//                                                      }
//
//
//                                                      if (weakSelf.dataResult.count ==0) {
//                                                          if (_WeedOutBackBlock) {
//                                                              _WeedOutBackBlock();
//                                                          }
//                                                          [self.navigationController popViewControllerAnimated:YES];
//                                                      }
//                                                  }else{
//                                                      [weakSelf.dataResult removeAllObjects];
//                                                      [weakSelf.tableView reloadData];
//
//                                                      if (_WeedOutBackBlock) {
//                                                          _WeedOutBackBlock();
//                                                      }
//                                                      [self.navigationController popViewControllerAnimated:YES];
//                                                  }
//                                                  [ZHProgressHUD showInfoWithText:@"加入成功"];
//                                              }else{
//                                                  [ZHProgressHUD showInfoWithText:@"加入失败"];
//                                              }
//                                              [[UIApplication sharedApplication].keyWindow hideToastActivity];
//
//                                              if (weakSelf.dataResult.count == 0) {
//                                                  weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
//                                              }
//                                          }];
//}
-(void)addPurchaseProduct:(NSDictionary *)params finshed:(void(^)(STStorewideEntity *entity,NSString *mesg,NSString *code,NSError *error))finshed{
    [KSMNetworkRequest getAddPurchaseProductUrl:requestAddPurchaseProduct params:params finshed:^(STStorewideEntity *entity,NSString *mesg,NSString *code, NSError *error) {
        finshed(entity,mesg,code,error);
    }];
}
-(void)addSubView{
    __weak STWisdomWeedOutViewController *weakSelf = self;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - kNavBarHeight)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor fromHexValue:0xE5E5E5 alpha:1];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    
    
    _switchStoreView = [[[NSBundle mainBundle]loadNibNamed:@"STSwitchStoreView" owner:self options:nil]lastObject];
    _switchStoreView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _switchStoreView.hidden = YES;
    [_switchStoreView setSwitchStoreViewTitle:@"选择店铺"];
    _switchStoreView.SwitchStoreViewBlock = ^(int type, NSDictionary *dict, NSIndexPath *indexPath) {
        
          weakSelf.switchStoreView.hidden = YES;
        
        [weakSelf.switchStoreView setSwitchStoreColseView];
        
        switch (type) {
            case 0:{
                return ;
                break;
            }
            case 1:{
            
                [weakSelf  addPurchaseProduct:@{@"num":dict[@"buyCount"],@"pid":dict[@"Pid"],@"psn":weakSelf.psnStr} finshed:^(STStorewideEntity *entity,NSString *mesg,NSString *code,NSError *error) {
                    
                    if (!error) {
                        if ([code intValue] == 1) {
                            
                            [ZHProgressHUD showInfoWithText:@"操作成功"];
                            
                            [weakSelf.dataResult removeObjectAtIndex:indexPath.row];
                            
                            /** 2. TableView中 删除一个cell. */
                            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            
                            if (weakSelf.dataResult.count == 0) {
                                
                                if (weakSelf.WeedOutBackBlock) {
                                    
                                    weakSelf.WeedOutBackBlock();
                                }
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }

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
    
    [self.view addSubview:_switchStoreView];
    
    
    //    _wisdomFooterView = [STWisdomFooterView new];
    //    _wisdomFooterView.backgroundColor = RGB(119, 119, 119);
    //    _wisdomFooterView.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    //    [weakSelf.wisdomFooterView setSTWisdomFooterView:1 index:@"0"];
    //    weakSelf.wisdomFooterView.backgroundColor = RGB(119, 119, 119);
    //
    //    _wisdomFooterView.STWisdomBlock = ^(NSInteger tag){
    //        if (weakSelf.dataResult.count != 0) {
    //            [weakSelf cancelPurchaseEliminateForPsn:@{@"psn":@""} indexPath:nil];
    //        }else{
    //            [ZHProgressHUD showInfoWithText:@"暂无数据"];
    //        }
    //    };
    //    [self.view addSubview:_wisdomFooterView];
    
    
    _lab = [UILabel new];
    _lab.frame = CGRectMake(0, kScreenHeight/2, kScreenWidth, 30);
    _lab.text = @"暂无数据";
    _lab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.hidden = YES;
    [self.view addSubview:_lab];
}

#pragma mark --UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellNameB = @"cellNameB";
    STWisdomShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameB];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomShopTableViewCell" owner:self options:nil]lastObject];
        cell.delegate = self;
    }
    if (_dataResult.count != 0) {
        [cell setWisdomShop:_dataResult indexPath:indexPath];
    }
    return cell;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
    //    detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,[_dataResult[indexPath.section][indexPath.row] pid]];
    //    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 不同的行, 可以设置不同的编辑样式, 编辑样式是一个枚举类型
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //   点击 删除 按钮的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 判断编辑状态是删除时.
        
        // 1. 更新数据源(数组): 根据indexPaht.row作为数组下标, 从数组中删除数据.
        [self.dataResult removeObjectAtIndex:indexPath.row];
        
        // 2. TableView中 删除一个cell.
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    
    // 点击 +号 图标的操作.
    if (editingStyle == UITableViewCellEditingStyleInsert) { // 判断编辑状态是插入时.
        // 1. 更新数据源:向数组中添加数据.
        [self.dataResult insertObject:@"abcd" atIndex:indexPath.row];
        
        // 2. TableView中插入一个cell.
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
*/
#pragma mark --STWisdomShopTableViewCellDelegate
-(void)g_setPlanSelect:(STWisdomShopTableViewCell *)cell{
    
    __weak STWisdomWeedOutViewController *weakSelf = self;
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSDictionary *params = @{@"StoreId":@"0",@"Goods_Package_ID":[_dataResult[indexPath.row] Goods_Package_ID]};
    
    if ([[_dataResult[indexPath.row] Goods_Package_ID] integerValue] == 0) {
        
        [ZHProgressHUD showInfoWithText:@"此产品已下架"];
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        
    }else{
        [KSMNetworkRequest  getSwitchStoreUrl:requestGetOtherStorePorductList params:params finshed:^(id dataResult, NSError *error) {
            
            weakSelf.psnStr = [_dataResult[indexPath.row] psn];
            
            _switchStoreView.hidden = NO;
            [_switchStoreView setSwitchStoreViewResult:dataResult indexPath:indexPath];
            
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }];
    }
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
- (IBAction)back:(id)sender {
    if (_WeedOutBackBlock) {
        _WeedOutBackBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
