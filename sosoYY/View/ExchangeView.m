//
//  ChoseOtherStoreView.m
//  sosoYY
//
//  Created by zhy on 17/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#define CELLH 85

#import "PurchasetAddPricePromotionsModel.h"
#import "ExchangeView.h"
#import "ExchangeCell.h"
@interface ExchangeView ()<UITableViewDelegate,UITableViewDataSource>{

    NSInteger selectIndex;
}
@property (nonatomic,strong)UITableView *tableV;
@end

@implementation ExchangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView {
    
    selectIndex = -1;
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 0) style:UITableViewStylePlain];
    self.tableV.clipsToBounds = NO;
    self.tableV.bounces = NO;
    self.tableV.separatorInset = UIEdgeInsetsMake(0, -80, 0, -80);
    self.tableV.separatorColor = [UIColor fromHexValue:0xE5E5E5];
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.tableV];
}

- (void)setLiModel:(LiModel *)liModel {

    _liModel = liModel;
    
    if ([self.pmid integerValue] > 0) {
        
        for (PurchasetAddPricePromotionsModel *model in liModel.purchasetAddPricePromotionsList) {
            
            if ([self.pmid isEqualToString:model.pmid]) {
                
                switch ([model.addPriceType integerValue]) {
                    case 0:
                        
                        if ([liModel.buyCount doubleValue] < [model.firstProudctStartNum doubleValue]) {
                            
                            self.pmid = @"0";
                            
                            [self cancleJJG];
                        }else {
                        
                            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                self.tableV.frame = CGRectMake(0, self.height-(liModel.purchasetAddPricePromotionsList.count*CELLH+88), self.width, self.liModel.purchasetAddPricePromotionsList.count*CELLH+88);
                                
                                self.tableV.delegate = self;
                                self.tableV.dataSource = self;
                                
                            } completion:nil];
                        }
                        break;
                    case 1:
                        if ([liModel.buyCount doubleValue] < [model.firstProudctPerNum doubleValue]) {
                            
                            self.pmid = @"0";
                            [self cancleJJG];
                            
                        }else {
                        
                            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                self.tableV.frame = CGRectMake(0, self.height-(liModel.purchasetAddPricePromotionsList.count*CELLH+88), self.width, self.liModel.purchasetAddPricePromotionsList.count*CELLH+88);
                                
                                self.tableV.delegate = self;
                                self.tableV.dataSource = self;
                                
                            } completion:nil];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }else {
    
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.tableV.frame = CGRectMake(0, self.height-(liModel.purchasetAddPricePromotionsList.count*CELLH+88), self.width, self.liModel.purchasetAddPricePromotionsList.count*CELLH+88);
            
            self.tableV.delegate = self;
            self.tableV.dataSource = self;
            
        } completion:nil];
    }
}


#pragma mark UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.liModel.purchasetAddPricePromotionsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELLH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableV.width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = NO;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    label.text = @"换购商品";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor fromHexValue:0x555555];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(view.width-44, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moveSelfView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, view.width, 1)];
    line.backgroundColor = [UIColor fromHexValue:0xE5E5E5];
    [view addSubview:line];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableV.width, 44)];
    [sender setTitle:@"确定" forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor fromHexValue:0xEA5413];
    [sender addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    return sender;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"ExchangeCell";
    ExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeCell" owner:self options:nil] lastObject];
    }
    
    PurchasetAddPricePromotionsModel *model = self.liModel.purchasetAddPricePromotionsList[indexPath.row];
    
    
    //第一次进来
    if (selectIndex < 0) {
        
        if ([model.pmid isEqualToString:self.pmid]) {
            
            if ([self.liModel.isSelect isEqualToString:@"1"]) {
                cell.selectBtn.selected = YES;
                selectIndex = indexPath.row;
            }else {
            
                cell.selectBtn.selected = NO;
                selectIndex = -1;
            }
            
        }else {
        
            cell.selectBtn.selected = NO;
        }
        
    }else {
    
        if (selectIndex == indexPath.row) {
    
            cell.selectBtn.selected = YES;
        }else {
    
            cell.selectBtn.selected = NO;
        }
    }
    
    cell.exchangeName.text = model.DrugsBase_DrugName;
    cell.exchangePro.text = model.DrugsBase_Manufacturer;
    if (model.DrugsBase_Specification.length == 0) {
        
        cell.exchangeESPE.text = @"规格：---";
    }else {
    
        cell.exchangeESPE.text = model.DrugsBase_Specification;
    }
    
//    if (model.sxrq.length > 0) {
//        
//        UIColor *timeColor = [Uitils setIntervalSinceNow:model.sxrq] ? [UIColor fromHexValue:0x777777] : [UIColor redColor];
//        cell.exchangeTime.textColor = timeColor;
//        
//        cell.exchangeTime.text = [NSString stringWithFormat:@"效期 %@",model.sxrq];
//    }else {
//        
//        cell.exchangeTime.text = @"效期：-";
//    }
    
    if (![model.sxrq isEqualToString:@""]) {
        
        UIColor *timeColor = [Uitils setIntervalSinceNow:model.sxrq] ? [UIColor fromHexValue:0x777777] : RGB(241, 77, 67);
        cell.exchangeTime.textColor = timeColor;
        
        cell.exchangeTime.text = [NSString stringWithFormat:@"效期 %@",model.sxrq];
    }else {
        
        if ([model.IsJxq isEqualToString:@"1"]) {
            cell.exchangeTime.text = @"近效期";
            cell.exchangeTime.textColor = RGB(241, 77, 67);
        }else{
            cell.exchangeTime.text = @"效期:---";
            cell.exchangeTime.textColor = [UIColor fromHexValue:0x777777];
        }
    }
    
    cell.exchangePrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:model.addPrice]];
    
    if ([model.addPriceType integerValue] == 0) {
        
        
        cell.exchangeCount.text = [NSString stringWithFormat:@"X%@",model.secondProudctNum];
        
    }else if ([model.addPriceType integerValue] == 1){
        
        cell.exchangeCount.text = [NSString stringWithFormat:@"X%d",[model.secondProudctNum intValue]*(int)([self.liModel.buyCount intValue]/[model.firstProudctPerNum intValue])];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([self.liModel.isSelect isEqualToString:@"1"]) {
        PurchasetAddPricePromotionsModel *model = self.liModel.purchasetAddPricePromotionsList[indexPath.row];
        
        switch ([model.addPriceType integerValue]) {
            case 0:
                
                if ([self.liModel.buyCount doubleValue] >= [model.firstProudctStartNum doubleValue] && [model.Stock doubleValue] >= [model.secondProudctNum doubleValue]) {
                    
                    if (selectIndex == indexPath.row) {
                        
                        selectIndex = 200;
                        
                    }else {
                        
                        selectIndex = indexPath.row;
                    }
                    
                    [self.tableV reloadData];
                    
                }else {
                    
                    [ZHProgressHUD showInfoWithText:@"未满足换购条件"];
                }
                
                break;
            case 1:
                
                if ([self.liModel.buyCount doubleValue] >= [model.firstProudctPerNum doubleValue] && [model.Stock doubleValue] >= [model.secondProudctNum doubleValue]) {
                    
                    if (selectIndex == indexPath.row) {
                        
                        selectIndex = 200;
                    }else {
                        
                        selectIndex = indexPath.row;
                    }
                    
                    [self.tableV reloadData];
                }else {
                    [ZHProgressHUD showInfoWithText:@"未满足换购条件"];
                }
                break;
                
            default:
                break;
        }
    }else {
        [ZHProgressHUD showInfoWithText:@"未满足换购条件"];
    }
}

- (void)sureAction {
    
    if ([self.pmid integerValue] > 0) {
        
        //已选择过，取消
        if (selectIndex >= 200) {
            
            [self cancleJJG];
            
        }else {
        
            [self moveSelfView];
        }
    }else {
    
        if (selectIndex >= 0 && selectIndex < 200) {
            
            [self selectJJG];
        }else {
        
            [ZHProgressHUD showInfoWithText:@"请选换购商品！"];
        }
    }
}

- (void)selectJJG {

    PurchasetAddPricePromotionsModel *model = self.liModel.purchasetAddPricePromotionsList[selectIndex];
    NSDictionary * params = @{@"pid":self.liModel.pid,@"pmid":model.pmid};
    [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
        
        NSDictionary *dic = (NSDictionary *)responseObj;
        FxLog(@"params = %@",responseObj);
        
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            
            [ZHProgressHUD dismiss];
            
            if (_selectExchangeGoodBlock) {
                
                _selectExchangeGoodBlock(NO);
            }
            
            [self moveSelfView];
            
        }else {
            
            [ZHProgressHUD showErrorWithText:@"网络错误，请重试" dismissWithDelay:2];
        }
        
    } failure:^(NSError *error) {
        
        FxLog(@"error = %@",error);
        [ZHProgressHUD dismiss];
    }];
    
}

- (void)cancleJJG {

    NSDictionary *params = @{@"pid":self.liModel.pid,@"pmid":@"0"};
    [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] integerValue] == 200) {
            
            [ZHProgressHUD dismiss];
            
            if (selectIndex == -1) {
               
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    self.tableV.frame = CGRectMake(0, self.height-(self.liModel.purchasetAddPricePromotionsList.count*CELLH+88), self.width, self.liModel.purchasetAddPricePromotionsList.count*CELLH+88);
                    
                    self.tableV.delegate = self;
                    self.tableV.dataSource = self;
                    
                } completion:nil];
                
            }else {
            
                if (_selectExchangeGoodBlock) {
                    
                    _selectExchangeGoodBlock(YES);
                }
                
                [self moveSelfView];
            }
            
        }else {
            
            [ZHProgressHUD showErrorWithText:@"网络错误，请重试" dismissWithDelay:2];
        }
        
    } failure:^(NSError *error) {
        
        [ZHProgressHUD dismiss];
        FxLog(@"error = %@",error);
    }];
}

//移除view
- (void)moveSelfView {
    
    if (_removeExchangeView) {
        
        _removeExchangeView(self);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (_removeExchangeView) {
        
        _removeExchangeView(self);
    }
}

@end
