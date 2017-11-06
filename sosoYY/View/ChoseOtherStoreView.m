//
//  ChoseOtherStoreView.m
//  sosoYY
//
//  Created by zhy on 17/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#define CELLH 126

#import "ChoseOtherStoreView.h"
#import "OtherStoreCell.h"
#import "OtherStoreModel.h"
@interface ChoseOtherStoreView ()<UITableViewDelegate,UITableViewDataSource>
{

    NSInteger selectIndex;
}
@property (nonatomic,strong)UITableView *tableV;
@end

@implementation ChoseOtherStoreView

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
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(8, self.height, self.width-16, 0) style:UITableViewStylePlain];
    self.tableV.layer.cornerRadius = 3;
    self.tableV.clipsToBounds = YES;
    self.tableV.bounces = NO;
    self.tableV.separatorInset = UIEdgeInsetsMake(0, -80, 0, -80);
    self.tableV.separatorColor = [UIColor fromHexValue:0xE5E5E5];
    [self addSubview:self.tableV];
    
}

-(void)setSourceData:(NSArray *)sourceData {

    _sourceData = sourceData;
    
    for (int i = 0; i<sourceData.count; i++) {
        
        OtherStoreModel *model = sourceData[i];
        if (model.Selected) {
            
            ((OtherStoreModel *)sourceData[i]).surplusmoney = [NSString stringWithFormat:@"%f",[((OtherStoreModel *)sourceData[i]).surplusmoney doubleValue] - ([model.price doubleValue]*[model.buyCount doubleValue])];
            break;
        }
    }
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGFloat h = self.sourceData.count*CELLH+44 > self.height/3*2 ? self.height/3*2 : self.sourceData.count*CELLH+44;
        self.tableV.frame = CGRectMake(8, self.height/2-h/2, self.width-16, h);
        
        self.tableV.delegate = self;
        self.tableV.dataSource = self;
        
    } completion:nil];
}

#pragma mark UITableViewDelegate&&UITableViewDataSource
//组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.sourceData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return CELLH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableV.width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = NO;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, view.height)];
    label.text = @"选择其他店铺";
    label.textColor = [UIColor fromHexValue:0x555555];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(view.width-44, 0, 44, 44)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor fromHexValue:0xea5413] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:sureBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44, view.width, 1)];
    line.backgroundColor = [UIColor fromHexValue:0xE5E5E5];
    [view addSubview:line];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifer = @"OtherStoreCell";
    OtherStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OtherStoreCell" owner:self options:nil] lastObject];
    }
    
    OtherStoreModel *model = self.sourceData[indexPath.row];
    
    cell.circleView.hidden = [model.surplusmoney doubleValue] > 0 ? NO : YES;
        
    cell.storeName.text = model.storeName;
    cell.companyName.text = model.enterpriseName;
    
    
    if (![model.sxrq isEqualToString:@""]) {
        
        UIColor *timeColor = [Uitils setIntervalSinceNow:model.sxrq] ? [UIColor fromHexValue:0x777777] : RGB(241, 77, 67);
        cell.timeLabel.textColor = timeColor;
        
        cell.timeLabel.text = [NSString stringWithFormat:@"效期 %@",model.sxrq];
    }else {
        
        if ([model.IsJxq isEqualToString:@"1"]) {
            cell.timeLabel.text = @"近效期";
            cell.timeLabel.textColor = RGB(241, 77, 67);
        }else{
            cell.timeLabel.text = @"效期:---";
            cell.timeLabel.textColor = [UIColor fromHexValue:0x777777];
        }
    }
    
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:model.price]];
    cell.sendLabel.text = [NSString stringWithFormat:@" 满%@发货 ",model.lowestdeliveryAmount];
    cell.packageLabel.text = [NSString stringWithFormat:@" 满%@包邮 ",model.lowestFreeShippingAmount];
    
    switch ([model.tax_policy integerValue]) {
        case 0:
            cell.policyLabel.text = @" 货票同行 ";
            break;
        case 1:
            cell.policyLabel.text = @" 下批货开票 ";
            break;
        case 2:
            cell.policyLabel.text = @" 月底开票 ";
            break;
        case 3:
            cell.policyLabel.text = @" 电子发票 ";
            break;
            
        default:
            break;
    }
    
    if (model.Selected) {
        
            //不满发货
            if (([model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue]) < [model.lowestdeliveryAmount doubleValue]) {
                
                cell.alertLabel.text = [NSString stringWithFormat:@"该店铺已购买¥%.2f,还差%.2f达到发货金额",([model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue]),[model.lowestdeliveryAmount doubleValue]-([model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue])];
                //不满包邮
            }else if (([model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue]) < [model.lowestFreeShippingAmount doubleValue]) {
                
                cell.alertLabel.text = [NSString stringWithFormat:@"该店铺已购买¥%.2f,还差%.2f达到包邮金额",[model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue],[model.lowestFreeShippingAmount doubleValue]-([model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue])];
                //都满足
            }else if (([model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue]) > [model.lowestFreeShippingAmount doubleValue]) {
                
                cell.alertLabel.text = [NSString stringWithFormat:@"该店铺已购买¥%.2f,达到发货,包邮金额",([model.surplusmoney doubleValue]+[model.price doubleValue]*[model.buyCount doubleValue])];
            }
        
        selectIndex = indexPath.row;
        
        cell.selectStoreBtn.selected = YES;
        cell.cellBackView.hidden = NO;
        
    }else {
    
        cell.selectStoreBtn.selected = NO;
        
        cell.cellBackView.hidden = YES;
        
        //不满发货
        if ([model.surplusmoney doubleValue] < [model.lowestdeliveryAmount doubleValue]) {
            
            cell.alertLabel.text = [NSString stringWithFormat:@"该店铺已购买¥%.2f,还差%.2f达到发货金额",[model.surplusmoney doubleValue],[model.lowestdeliveryAmount doubleValue]-[model.surplusmoney doubleValue]];
        //不满包邮
        }else if ([model.surplusmoney doubleValue] < [model.lowestFreeShippingAmount doubleValue]) {
            
            cell.alertLabel.text = [NSString stringWithFormat:@"该店铺已购买¥%.2f,还差%.2f达到包邮金额",[model.surplusmoney doubleValue],[model.lowestFreeShippingAmount doubleValue]-[model.surplusmoney doubleValue]];
        //都满足
        }else if ([model.surplusmoney doubleValue] > [model.lowestFreeShippingAmount doubleValue]) {
            
            cell.alertLabel.text = [NSString stringWithFormat:@"该店铺已购买¥%.2f,达到发货,包邮金额",[model.surplusmoney doubleValue]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ((OtherStoreModel *)self.sourceData[selectIndex]).Selected = NO;
    ((OtherStoreModel *)self.sourceData[indexPath.row]).Selected = YES;

    [self.tableV reloadData];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (_removeOtherStoreView) {
        
        _removeOtherStoreView(self);
    }
}

- (void)sureAction {
        
        [ZHProgressHUD showWithtext:@"请稍候..."];
        
        OtherStoreModel *model = self.sourceData[selectIndex];
        
        NSDictionary *params = @{@"Pid":model.Pid,@"Goods_Package_ID":model.Goods_Package_ID};
        [KSMNetworkRequest getRequest:requestSelectOtherStorePorduct params:params success:^(id responseObj) {
            
            
            FxLog(@"选择其他店铺 = %@",responseObj);
            if ([[responseObj objectForKey:@"code"] integerValue] == 1) {
            
                [ZHProgressHUD dismiss];
                
                
                if (_selectOtherStoreBlock) {
                    
                    _selectOtherStoreBlock();
                }
                
                if (_removeOtherStoreView) {
                    
                    _removeOtherStoreView(self);
                }
                
            }else {
                
                [ZHProgressHUD showErrorWithText:@"网络错误，请重试" dismissWithDelay:2];
            }
            
        } failure:^(NSError *error) {
            
            [ZHProgressHUD dismiss];
            
        }];

}

@end
