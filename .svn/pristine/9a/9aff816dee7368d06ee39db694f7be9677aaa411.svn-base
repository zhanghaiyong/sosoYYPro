//
//  STArtificialPurchasingView.m
//  sosoYY
//
//  Created by soso-mac on 2017/7/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STArtificialPurchasingView.h"
#import "STWisdomNotShopTableViewCell.h"
#import "STWisdomFooterView.h"
#import "STWisdomCollectionView.h"
#import "STWisdomHeadererView.h"
#import "MaskingView.h"
#import "STWisdomNotView.h"




#define selectBtn_tag 100
#define btn_Tag 10000

@interface STArtificialPurchasingView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,STWisdomNotShopTableViewCellDelegate>   {
    
    __block BOOL isShare;//分享返回
    
    __block NSString *jsonStr;//把数组变为json的数据
    
    __block BOOL isSelect;//判断是否点击数字下拉菜单
    
    __block UIImageView *imgV;//有无数据
    
    __block UILabel *lab;//有无数据
    
    __block BOOL isOK;//是否请求成功
}
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)STWisdomFooterView *wisdomFooterView;
@property(strong,nonatomic)STWisdomCollectionView *wisdomCollectionView;
@property(strong,nonatomic)UIView *centrView;
@property(strong,nonatomic)MaskingView *shareMaskView;
@property(strong,nonatomic)STWisdomNotView *notView;

@property(strong,nonatomic)NSMutableArray *dataResultOR;
@property(strong,nonatomic)NSMutableArray *sectionAry;
@property(strong,nonatomic)NSMutableArray *selectAry;
@property(strong,nonatomic)NSMutableArray *sectionNumAry;
@property(strong,nonatomic)NSMutableArray *allNotArray;
@property(strong,nonatomic)NSMutableArray *countNotArray;
@property(strong,nonatomic)NSMutableArray *cellAry;

@property(strong,nonatomic)NSIndexPath *mIndexPath;

@property(assign,nonatomic) BOOL isAllSelect;//全选
@end

@implementation STArtificialPurchasingView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setShareAppBack) name:SHARE_Notification object:nil];
        
        _sectionAry = [NSMutableArray new];
        
        _sectionNumAry = [NSMutableArray new];
        
        _dataResultOR = [NSMutableArray new];
        
        _selectAry = [NSMutableArray new];
        
        _allNotArray = [NSMutableArray new];
        
        _countNotArray = [NSMutableArray new];
        
        _cellAry = [NSMutableArray new];
        
        isSelect = YES;
        
        isOK = NO;
        
        [self myAddSubView];
        
        self.tableView.mj_header.automaticallyChangeAlpha = YES;
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self httpDownloadArtificialPurchasing];
        }];
        
        [self.tableView.mj_header beginRefreshing];
        
    }
    return self;
}
-(void)myAddSubView{
    
    __weak STArtificialPurchasingView *weakSelf  = self;
    
    self.backgroundColor = [UIColor whiteColor];
    
#pragma mark - 人工采购
    _notView = [STWisdomNotView new];
    _notView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    [_notView setError:@"因条码错误等原因造成的匹配失败的商品可在ERP中添加或修改为正确的条码信息,系统将自动同步."];
//    [_notView setError:@"1.条码为空:ERP条码信息缺失./n 2.条码格式错误:条码位数错误或包含特殊字符./n 3.未找到该商品:在条码不为空并格式正确的前提下未找到该条码商品;有该商品,但是客户不满足该商品购买条件;不在店铺能购买的经营区域"];
    
    [self addSubview:_notView];
    
    
    UIView *footerVuew = [UIView new];
    footerVuew.frame = CGRectMake(0, 0, kScreenWidth, 70);
    
#pragma mark - tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, self.frame.size.height - 100)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.sectionIndexColor = RGB(51, 51, 51);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.tableFooterView =  footerVuew;
    _tableView.userInteractionEnabled = YES;
    [self addSubview:_tableView];
    
    
    UISwipeGestureRecognizer *disTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(disMissMasking)];
    disTap.delegate = self;
    [self.tableView addGestureRecognizer:disTap];
    
    
#pragma mark - 低部按钮
    _wisdomFooterView = [STWisdomFooterView new];
    _wisdomFooterView.backgroundColor = RGB(255, 255, 255);
    _wisdomFooterView.iphoneBtn.backgroundColor = RGB(119, 119, 119);
    _wisdomFooterView.frame = CGRectMake(0, self.frame.size.height - 50, kScreenWidth, 50);
    [_wisdomFooterView setSTWisdomFooterView:2 index:@"0"];
    _wisdomFooterView.STWisdomBlock = ^(NSInteger tag){
        
        [weakSelf  setWisdomCollectionView];
        
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
                    
                    [[STCommon sharedSTSTCommon] setShare:@{@"title":paramsData[@"title"],@"image":@"hudST_logo",@"url":paramsData[@"url"],@"descr":paramsData[@"descr"]} shareView:weakSelf.controller Finished:^(BOOL isSuccessful) {
                        
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
                            
                            UIButton *btn = [weakSelf viewWithTag:selectBtn_tag + i];
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
                            UIButton *btn = [weakSelf viewWithTag:selectBtn_tag + i];
                            [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                        }
                    }
                }];
            }
        }else{
            
            [ZHProgressHUD showInfoWithText:@"暂无数据"];
        }
    };
    [self addSubview:_wisdomFooterView];
    
#pragma mark - 下拉数量单
    _wisdomCollectionView = [[STWisdomCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 0, 0, 0)];
    _wisdomCollectionView.titles = nil;
    _wisdomCollectionView.layer.masksToBounds = YES;
    _wisdomCollectionView.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _wisdomCollectionView.layer.borderWidth = .5;
    _wisdomCollectionView.layer.cornerRadius = 3.0f;
    _wisdomCollectionView.WisdomCollectionViewBlock = ^(NSString *text){
        
        STWisdomEntity *entity = [weakSelf.dataResultOR[weakSelf.mIndexPath.section] dataAryTwo][weakSelf.mIndexPath.row];
        
        entity.buyCount = text;
        
        [[weakSelf.dataResultOR[weakSelf.mIndexPath.section] dataAryTwo] replaceObjectAtIndex:weakSelf.mIndexPath.row withObject:entity];
        
        STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[weakSelf.tableView cellForRowAtIndexPath:weakSelf.mIndexPath];
        
        cell.textTextField.text = text;
        
        isSelect = YES;
        weakSelf.wisdomCollectionView.hidden = YES;
        
        [weakSelf setChangePurchaseCountForPsn:@{@"psn":[[weakSelf.dataResultOR[weakSelf.mIndexPath.section] dataAryTwo][weakSelf.mIndexPath.row] psn],@"num":text} indexPath:weakSelf.mIndexPath finshed:^(BOOL isYes) {
            
            if (isYes) {
                return ;
            }
        }];
    };
    
    _wisdomCollectionView.hidden = YES;
    
    
    
    _centrView = [UIView new];
    _centrView.hidden = YES;
    _centrView.frame = CGRectMake(kScreenWidth/2 - 75, kScreenHeight/2 - 75, 150, 150);
    [self addSubview:_centrView];
    
    
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
    
    
    NSString *shareTwoTitle = @" 复制采购清单,发送给好友  ";
    CGRect shareRect = [shareTwoTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    _shareMaskView = [[MaskingView alloc]initWithFrame:CGRectMake(kScreenWidth - shareRect.size.width - 40, self.frame.size.height - 90, shareRect.size.width, 40) direction:RIGHT_BOTTOM];
    _shareMaskView.alertString = shareTwoTitle;
    _shareMaskView.hidden = YES;
    [self addSubview:_shareMaskView];
    
}
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  148;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_dataResultOR.count != 0) {
        return _dataResultOR.count;
    }else{
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([[_dataResultOR[section]dataAryTwo] count] != 0) {
        
        return [[_dataResultOR[section]dataAryTwo] count];
        
    }else{
        
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    STWisdomNotShopTableViewCell *cell =_cellAry[indexPath.section][indexPath.row];
    
    if ([[_dataResultOR[indexPath.section]dataAryTwo] count] != 0) {
        
        [cell setWisdomNotShop:_dataResultOR indexPath:indexPath];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [UIView new];
    
    headView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    
    headView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    
    
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
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    line.frame = CGRectMake(0, 39, kScreenWidth, .5);
    [headView addSubview:line];
    
    
    return headView;
}



#pragma mark- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    //
    //    [self g_setNotChangeSelect:cell];
}


#pragma mark - STWisdomNotShopTableViewCellDelegate 人工采购
-(void)g_setNotChangeSelect:(STWisdomNotShopTableViewCell *)cell{
    
    [self  setWisdomCollectionView];
    
    __weak STArtificialPurchasingView *weakSelf  = self;
    
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
                
                 [weakSelf.sectionAry removeObject:[weakSelf.dataResultOR[indexPath.section]supplierName]];
                
                [weakSelf changeWisdomFooterViewBackgroundColor];
                
                [weakSelf.tableView reloadData];
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
                
                [weakSelf.sectionAry addObject:[weakSelf.dataResultOR[indexPath.section]supplierName]];
                
                [weakSelf changeWisdomFooterViewBackgroundColor];
               [weakSelf.tableView reloadData];
            }
        }];
    }
}

//减数量
-(void)g_setNotSubtract:(STWisdomNotShopTableViewCell *)cell{
    
    [self  setWisdomCollectionView];
    
    [self disMissMasking];
    
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
    
    [self disMissMasking];
    
    
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
    
}
-(void)g_setNotFinished:(NSIndexPath *)indexPath{
    
    [self disMissMasking];
    
    STWisdomEntity *entity = [_dataResultOR[indexPath.section] dataAryTwo][indexPath.row];
    
    
    STWisdomNotShopTableViewCell *cell =_cellAry[indexPath.section][indexPath.row];

    entity.buyCount = cell.textTextField.text;
    
    [[_dataResultOR[indexPath.section] dataAryTwo] replaceObjectAtIndex:indexPath.row withObject:entity];
    
    [self setChangePurchaseCountForPsn:@{@"psn":[[_dataResultOR[indexPath.section] dataAryTwo][indexPath.row] psn],@"num":cell.textTextField.text} indexPath:indexPath finshed:^(BOOL isYes) {
        
        if (isYes) {
            
            return ;
        }
    }];
}
//下拉数量
-(void)g_setNotList:(STWisdomNotShopTableViewCell *)cell{
    
    [self disMissMasking];
    
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


#pragma  mark -- UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setWisdomCollectionView];
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
#pragma mark - 隐藏下拉菜单
-(void)setWisdomCollectionView{
    isSelect = YES;
    _wisdomCollectionView.hidden = YES;
}
#pragma mark - 移除蒙版
- (void)disMissMasking{
    
    if (_shareMaskView) {
        
        [_shareMaskView removeFromSuperview];
        
        _shareMaskView = nil;
        
    }
}
#pragma mark - 判断改变WisdomFooterViewBackgroundColor
-(void)changeWisdomFooterViewBackgroundColor{
    if (_countNotArray.count != 0) {
        
        _wisdomFooterView.iphoneBtn.backgroundColor = RGB(77, 183, 98);
        
    }else{
        
        _wisdomFooterView.iphoneBtn.backgroundColor = RGB(119, 119, 119);
        
    }
}

#pragma mark-选择整个公司的产品
-(void)selectMothed:(UIButton *)btn{
    
    [self setWisdomCollectionView];
    
    __weak STArtificialPurchasingView *weakSelf  = self;
    
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

#pragma mark - 人工采购接口
-(void)httpDownloadArtificialPurchasing{
    
    __weak STArtificialPurchasingView *weakSelf = self;
    
//    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getArtificialPurchasingUrl:requestPurchaseHome_TabManual finshed:^(id dataResult,NSError *error) {
            
            [weakSelf.dataResultOR removeAllObjects];
            
            [weakSelf.allNotArray removeAllObjects];
            
            [weakSelf.countNotArray removeAllObjects];
            
            [weakSelf.cellAry removeAllObjects];
            
            if (!error) {
                
                weakSelf.dataResultOR = dataResult;
                
                for (int i = 0;i< weakSelf.dataResultOR.count;i++) {
                    
                    NSMutableArray *cellTwoAry = [NSMutableArray new];
                    
                    for (int j = 0;j < [weakSelf.dataResultOR[i]dataAryTwo].count;j++) {
                        
                        STWisdomEntity *entity = [weakSelf.dataResultOR[i]dataAryTwo][j];
                        
                        if (entity.isSelect.intValue == 1) {
                            
                            [weakSelf.countNotArray addObject:entity];
                        }
                        [weakSelf.allNotArray addObject:entity];
                        
                        
                         STWisdomNotShopTableViewCell *cell = [weakSelf.tableView dequeueReusableCellWithIdentifier:@"cellNameA"];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"STWisdomNotShopTableViewCell" owner:self options:nil]lastObject];
                            cell.delegate = self;
                        }
                        [cellTwoAry addObject:cell];
                    }
                    
                    [weakSelf.cellAry addObject:cellTwoAry];
                }
                
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
                
                lab.text = @"没有暂不匹配的商品";
                
                imgV.image = [UIImage imageNamed:@"notPiPei"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.dataResultOR.count != 0) {
                    
                    if (weakSelf.countNotArray.count != 0) {
                        weakSelf.wisdomFooterView.iphoneBtn.backgroundColor = RGB(77, 183, 98);
                    }else{
                        weakSelf.wisdomFooterView.iphoneBtn.backgroundColor = RGB(119, 119, 119);
                    }
                    
                    weakSelf.shareMaskView.hidden = NO;
                    
                }else{
                    
                    [ZHProgressHUD showInfoWithText:@"暂无数据"];
                    
                    _centrView.hidden = NO;
                    
                    lab.text = @"没有暂不匹配的商品";
                    
                    imgV.image = [UIImage imageNamed:@"notPiPei"];
                    
                }
                
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView.mj_header endRefreshing];
                
//                [[UIApplication sharedApplication].keyWindow hideToastActivity];
                
            });
            
            isOK = YES;
        }];
    });
    [[STCommon sharedSTSTCommon] setHideToastActivity:^(BOOL isYes) {
        
        if (isYes) {
            
            if (isOK) {
                
                return ;
            }
            
//            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            
            [weakSelf.tableView.mj_header endRefreshing];
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
-(void)setShareAppBack{
    
    __weak STArtificialPurchasingView *weakSelf  = self;
    
    if (isShare) {
        
        [self setShareOfSuccess:@{@"id":jsonStr} finshed:^(BOOL isSuccess) {
            
            isShare = NO;
            
            if (isSuccess) {
                
                if (weakSelf.ArtificialPurchasingNumBlock) {
                    weakSelf.ArtificialPurchasingNumBlock([NSString stringWithFormat:@"%zi",weakSelf.countNotArray.count]);
                }
                [weakSelf httpDownloadArtificialPurchasing];
                
            }else{
                
                [ZHProgressHUD showInfoWithText:@"分享失败"];
            }
        }];
    }
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHARE_Notification object:nil];
    
}
@end
