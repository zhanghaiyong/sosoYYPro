//
//  STShopCartSearchAddView.m
//  sosoYY
//
//  Created by soso-mac on 2017/8/10.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STShopCartSearchAddView.h"
#import "STShopCartSearchAddTableViewCell.h"


@interface STShopCartSearchAddView ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *addPriceAry;
@property(strong,nonatomic)PurchasetAddPricePromotionsModel *model;
@end

@implementation STShopCartSearchAddView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        _addPriceAry = [NSMutableArray new];
        
        [self addSubView];
    }
    return self;
}
-(void)setEntity:(STShopCartSeachEntity *)entity{
    
    _entity = entity;
    
    [_addPriceAry removeAllObjects];
    
    for (NSDictionary *dict in entity.purchasetAddPricePromotionsList) {
        
        PurchasetAddPricePromotionsModel *model = [PurchasetAddPricePromotionsModel new];
        
        model.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
        model.pmid = [NSString stringWithFormat:@"%@",dict[@"pmid"]];
        model.addPrice = [NSString stringWithFormat:@"%@",dict[@"addPrice"]];
        model.firstProudctStartNum = [NSString stringWithFormat:@"%@",dict[@"firstProudctStartNum"]];
        model.firstProudctPerNum = [NSString stringWithFormat:@"%@",dict[@"firstProudctPerNum"]];
        model.secondProudctNum = [NSString stringWithFormat:@"%@",dict[@"secondProudctNum"]];
        model.pid = [NSString stringWithFormat:@"%@",dict[@"pid"]];
        model.DrugsBase_DrugName = [NSString stringWithFormat:@"%@",dict[@"DrugsBase_DrugName"]];
        model.DrugsBase_ProName = [NSString stringWithFormat:@"%@",dict[@"DrugsBase_ProName"]];
        model.DrugsBase_Specification = [NSString stringWithFormat:@"%@",dict[@"DrugsBase_Specification"]];
        model.DrugsBase_Manufacturer = [NSString stringWithFormat:@"%@",dict[@"DrugsBase_Manufacturer"]];
        model.Stock = [NSString stringWithFormat:@"%@",dict[@"Stock"]];
        model.sxrq = [NSString stringWithFormat:@"%@",dict[@"sxrq"]];
        model.Goods_Unit = [NSString stringWithFormat:@"%@",dict[@"Goods_Unit"]];
        model.IsJxq = [NSString stringWithFormat:@"%@",dict[@"IsJxq"]];
        model.addPriceType = [NSString stringWithFormat:@"%@",dict[@"addPriceType"]];
        
        if (entity.pmid.integerValue > 0) {
            
            switch ([model.addPriceType integerValue]) {
                case 0:
                    
                    if ([entity.buyCount doubleValue] < [model.firstProudctStartNum doubleValue]) {
                        
                        model.isSelect = @"0";
                    }else {
                        
                        model.isSelect = @"1";
                    }
                    break;
                case 1:
                    if ([entity.buyCount doubleValue] < [model.firstProudctPerNum doubleValue]) {
                        
                        model.isSelect = @"0";
                    }else {
                        
                        model.isSelect = @"1";
                    }
                    break;
                    
                default:
                    break;
            }
        }else {
            
            model.isSelect = @"0";
        }
        
        //
        //
        //
        //        if (entity.pmid.integerValue == 0) {
        //             model.isSelect = @"0";
        //        }else{
        //          model.isSelect = @"1";
        //        }
        [_addPriceAry addObject:model];
    };
    
    [_tableView reloadData];
}
-(void)addSubView{
    
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 185);
    [self addSubview:bgView];
    
    UITapGestureRecognizer *moveTap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveSelfView)];
    [bgView addGestureRecognizer:moveTap];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 183, kScreenWidth, 183)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 103;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.bounces = NO;
    self.tableView.separatorColor = [UIColor fromHexValue:0xE5E5E5];
    [self addSubview:_tableView];
}
#pragma mark --- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addPriceAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *StoreClass = @"StoreClass";
    STShopCartSearchAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreClass];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"STShopCartSearchAddTableViewCell" owner:self options:nil]lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    PurchasetAddPricePromotionsModel *model = _addPriceAry[indexPath.row];
    [cell setShopCartSearchAdd:_entity PurchasetAddPricePromotionsModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.width, view.height)];
    label.text = @"换购商品";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor fromHexValue:0x555555];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(view.width-40, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(moveSelfView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, view.width, 1)];
    line.backgroundColor = [UIColor fromHexValue:0xE5E5E5];
    [view addSubview:line];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [sender setTitle:@"确定" forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor fromHexValue:0xEA5413];
    [sender addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    return sender;
}

#pragma mark --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSString stringWithFormat:@"%@",_entity.isSelect] isEqualToString:@"1"]) {
        
        PurchasetAddPricePromotionsModel *model = _addPriceAry[indexPath.row];
        
        _model = model;
        
        switch ([model.addPriceType integerValue]) {
            case 0:
                
                if ([_entity.buyCount doubleValue] >= [model.firstProudctStartNum doubleValue] && [model.Stock doubleValue] >= [model.secondProudctNum doubleValue]) {
                    
                    if ([[NSString stringWithFormat:@"%@",model.isSelect] isEqualToString:@"1"]) {
                        
                        model.isSelect = @"0";
                    }else{
                        model.isSelect = @"1";
                    }
                    
                    [_addPriceAry replaceObjectAtIndex:indexPath.row withObject:model];
                    
                    [self.tableView reloadData];
                    
                }else {
                    
                    [ZHProgressHUD showInfoWithText:@"未满足换购条件"];
                }
                
                break;
            case 1:
                
                if ([_entity.buyCount doubleValue] >= [model.firstProudctPerNum doubleValue] && [model.Stock doubleValue] >= [model.secondProudctNum doubleValue]) {
                    
                    if ([[NSString stringWithFormat:@"%@",model.isSelect] isEqualToString:@"1"]) {
                        model.isSelect = @"0";
                    }else{
                        model.isSelect = @"1";
                    }
                    
                    [_addPriceAry replaceObjectAtIndex:indexPath.row withObject:model];
                    
                    [self.tableView reloadData];
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
    
    __weak STShopCartSearchAddView *weakSelf = self;
    
    NSDictionary *params;
    if ([_model.isSelect isEqualToString:@"0"]) {
        params =  @{@"pid":_entity.pid,@"pmid":@"0"};
    }else {
        
        params = @{@"pid":_entity.pid,@"pmid":_model.pmid};
    }
    
    [KSMNetworkRequest getRequest:requestChangePromotionTypes params:params success:^(id responseObj) {
        
        NSDictionary *dic = (NSDictionary *)responseObj;
        
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            
            if (weakSelf.sureBlock) {
                weakSelf.sureBlock(weakSelf.model.isSelect.integerValue);
            }
            
        }else {
            
            [ZHProgressHUD showErrorWithText:@"网络错误，请重试" dismissWithDelay:2];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)moveSelfView{
    if (_moveBlock) {
        _moveBlock();
    }
}
@end
