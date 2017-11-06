//
//  STOrderSettlementHeadView.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STOrderSettlementHeadView.h"

@interface STOrderSettlementHeadView ()<UITextViewDelegate>
@property(strong,nonatomic)STPaymentDetailsEntity *entity;
@property(assign,nonatomic)BOOL isYes;//余额开关
@property(strong,nonatomic)NSString *couponsNum;//折扣价
@property(strong,nonatomic)NSString *numPirce;//实付款(要计算)
@property(strong,nonatomic)NSString *balance;//余额付款
@property(strong,nonatomic)NSString *AllProductAmountAndAllShipFee;//订单总额加邮费
@property(strong,nonatomic)NSString *couponsNumAndBalance;//折扣价加余额

@property(assign,nonatomic)BOOL isTextView;
@end

@implementation STOrderSettlementHeadView

-(void)setOrderSettlementHeadView:(STPaymentDetailsEntity *)entity{
    
    _yuLine.frame = CGRectMake(0, 40, kScreenWidth, .5);
    
    _youLine.frame = CGRectMake(0, 80, kScreenWidth, .5);
    
    _dingLine.frame = CGRectMake(0, 130, kScreenWidth, .5);
    
    _isTextView = YES;
    
    _couponsNum = @"0";
    
    _entity = entity;
    
    __weak STOrderSettlementHeadView *weakSelf = self;
    
    if (![entity.consignee isEqualToString:@""]) {
        _namePhoneLab.text = [NSString stringWithFormat:@"%@   %@",entity.consignee,entity.mobile];
        
        _adrassLab.text = [NSString stringWithFormat:@"%@%@%@%@",entity.ProvinceName,entity.CityName,entity.CountyName,entity.address];
        
    }else{
        
        _namePhoneLab.text = @"";
        
        _adrassLab.text = @"";
    }
    
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"16",@"num":@"3"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"优惠券   %@张可用",entity.CanUseCouponCount] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.orderNumberLab.attributedText = string;
    }];
    
    if (entity.CanUseCouponCount.integerValue > 0) {
        _selectLab.text = @"请选择";
    }else{
        _selectLab.text = @"";
    }
    
    
    _orderRemarkTextView.delegate = self;
    
    _orderRemarkTextView.layer.masksToBounds = YES;
    
    _orderRemarkTextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    _orderRemarkTextView.layer.borderWidth = .8f;
    
    _orderRemarkTextView.layer.cornerRadius = 3;
    
    if (![entity.buyerremark isEqualToString:@""] && entity.buyerremark != nil) {
        
        _orderRemarkTextView.text = entity.buyerremark;
        
    }else{
        _orderRemarkTextView.text = @"配送,发票,资质等要求,最多50字";
    }
    
    self.orderRemarkTextView.inputAccessoryView = [self addToolbar];
    
    
    //优惠券折扣是张数x金额
    _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
    
    
    _orderTotalLab.text = [NSString stringWithFormat:@"¥%.2f",entity.AllProductAmount.floatValue];
    
    _postageLab.text = [NSString stringWithFormat:@"+¥%.2f",entity.AllShipFee.floatValue];
    
    _AllProductAmountAndAllShipFee = [NSString stringWithFormat:@"%f",entity.AllProductAmount.floatValue + entity.AllShipFee.floatValue];
    
    _couponsNumAndBalance = [NSString stringWithFormat:@"%.2f",_couponsNum.floatValue + entity.MaxUseBalance.floatValue];
    
    if (entity.MaxUseBalance.floatValue > 0) {
        
        [_switchBtn setOn:YES animated:YES];
        
        _isYes = YES;
        
        
        if (_AllProductAmountAndAllShipFee.floatValue  > _couponsNumAndBalance.floatValue) {
            
            _numPirceLab.text = [NSString stringWithFormat:@"¥%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNumAndBalance.floatValue];
            
            _numPirce = [NSString stringWithFormat:@"%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNumAndBalance.floatValue];
            
            _balance = [NSString stringWithFormat:@"%f",entity.MaxUseBalance.floatValue];
            
        }else{
            
            _numPirceLab.text = @"0.00";
            
            _numPirce = @"0.00";
            
            _balance = [NSString stringWithFormat:@"%f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
        }
        
    }else{
        
        [_switchBtn setOn:NO animated:YES];
        
        _isYes = NO;
        
        _numPirceLab.text = [NSString stringWithFormat:@"¥%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
        
        _numPirce = [NSString stringWithFormat:@"%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
        
        _balance = @"0.00";
    }
    
    _balanceLab.text = [NSString stringWithFormat:@"-¥%.2f",_balance.floatValue];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"16",@"num":@"2"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"余额   可用¥%.2f,本次使用¥%.2f",[_entity.MaxUseBalance floatValue],_balance.floatValue] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.orderTimeLab.attributedText = string;
    }];
    
    if (_OrderSettlementHeadViewBlock != nil) {
        
        _OrderSettlementHeadViewBlock([NSString stringWithFormat:@"%.2f",_numPirce.floatValue],[NSString stringWithFormat:@"%.2f",_balance.floatValue]);
    }
}
- (IBAction)switchSelect:(UISwitch *)sender {
    
    __weak STOrderSettlementHeadView *weakSelf = self;
    
    _AllProductAmountAndAllShipFee = [NSString stringWithFormat:@"%f",_entity.AllProductAmount.floatValue + _entity.AllShipFee.floatValue];
    
    _couponsNumAndBalance = [NSString stringWithFormat:@"%.2f",_couponsNum.floatValue + _entity.MaxUseBalance.floatValue];
    
    
    if (_entity.MaxUseBalance.floatValue > 0) {//判断余额是否打开余额
        
        _isYes = sender.on;
        
        if (_isYes) {//打开余额
            
            if (_AllProductAmountAndAllShipFee.floatValue  > _couponsNumAndBalance.floatValue) {//订单总额加邮费大于折扣价加余额
                
                _numPirceLab.text = [NSString stringWithFormat:@"¥%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNumAndBalance.floatValue];
                
                _numPirce = [NSString stringWithFormat:@"%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNumAndBalance.floatValue];
                
                _balance = [NSString stringWithFormat:@"%f",_entity.MaxUseBalance.floatValue];
                
                _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
                
            }else{//先用优惠券在用余额
                
                if (_couponsNum.floatValue > _AllProductAmountAndAllShipFee.floatValue) {//直接用优惠券付款
                    
                    _numPirceLab.text = @"0.00";
                    
                    _numPirce = @"0.00";
                    
                    _balance = @"0.00";
                    
                    _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_AllProductAmountAndAllShipFee.floatValue];
                    
                    [_switchBtn setOn:NO animated:YES];
                    
                    _isYes = NO;
                    
                    [ZHProgressHUD showInfoWithText:@"优惠券金额已够用支付本次购买"];
                    
                }else{//混合付款先用优惠券
                    
                    _numPirceLab.text = @"0.00";
                    
                    _numPirce = @"0.00";
                    
                    _balance = [NSString stringWithFormat:@"%f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
                    
                    _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
                }
            }
            
        }else{//关闭余额
            
            //先用优惠券在用余额
            if (_couponsNum.floatValue > _AllProductAmountAndAllShipFee.floatValue) {//优惠券直接支付
                
                _numPirceLab.text = @"0.00";
                
                _numPirce = @"0.00";
                
                _balance = @"0.00";
                
                _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_AllProductAmountAndAllShipFee.floatValue];
                
            }else{//混合支付
                _numPirceLab.text = [NSString stringWithFormat:@"¥%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
                
                _numPirce = [NSString stringWithFormat:@"%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
                
                _balance = @"0.00";
                
                _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
            }
        }
        
        _balanceLab.text = [NSString stringWithFormat:@"-¥%.2f",_balance.floatValue];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"16",@"num":@"2"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"余额   可用¥%.2f,本次使用¥%.2f",[_entity.MaxUseBalance floatValue],_balance.floatValue] type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.orderTimeLab.attributedText = string;
        }];
        
        if (_OrderSettlementHeadViewBlock != nil) {
            _OrderSettlementHeadViewBlock([NSString stringWithFormat:@"%.2f",_numPirce.floatValue],[NSString stringWithFormat:@"%.2f",_balance.floatValue]);
        }
        
    }else{//余额为0
        
        [ZHProgressHUD showInfoWithText:@"没有可用余额"];
        
        [_switchBtn setOn:NO animated:YES];
        
        _isYes = NO;
    }
}
- (IBAction)selectCoupons:(UIButton *)sender {
    
    if (_entity.CanUseCouponCount.integerValue > 0) {
        if (_OrderCouponsNumBlock) {
            _OrderCouponsNumBlock();
        }
    }else{
        
        [ZHProgressHUD showInfoWithText:@"暂无可用优惠券"];
    }
}

-(void)setOrderCouponsMoney:(NSString *)money count:(NSString *)count{
    
    __weak STOrderSettlementHeadView *weakSelf = self;
    
    _couponsNum = [NSString stringWithFormat:@"%f",money.floatValue];
    
    if (_couponsNum.floatValue > 0) {
        
        _selectLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
    }else{
        _selectLab.text = @"请选择";
    }
    
    
    _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
    
    
    _AllProductAmountAndAllShipFee = [NSString stringWithFormat:@"%f",_entity.AllProductAmount.floatValue + _entity.AllShipFee.floatValue];
    
    _couponsNumAndBalance = [NSString stringWithFormat:@"%.2f",_couponsNum.floatValue + _entity.MaxUseBalance.floatValue];
    
    
    if (_isYes) {//余额打开
        
        if (_AllProductAmountAndAllShipFee.floatValue  > _couponsNumAndBalance.floatValue) {//订单总额加邮费大于折扣价加余额
            
            _numPirceLab.text = [NSString stringWithFormat:@"¥%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNumAndBalance.floatValue];
            
            _numPirce = [NSString stringWithFormat:@"%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNumAndBalance.floatValue];
            
            _balance = [NSString stringWithFormat:@"%f",_entity.MaxUseBalance.floatValue];
            
            _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
            
        }else{//先用优惠券在用余额
            if (_couponsNum.floatValue > _AllProductAmountAndAllShipFee.floatValue) {//直接用优惠券付款
                
                _numPirceLab.text = @"0.00";
                
                _numPirce = @"0.00";
                
                _balance = @"0.00";
                
                _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_AllProductAmountAndAllShipFee.floatValue];
                
                [_switchBtn setOn:NO animated:YES];
                
                _isYes = NO;
                
            }else{//混合付款先用优惠券
                
                _numPirceLab.text = @"0.00";
                
                _numPirce = @"0.00";
                
                _balance = [NSString stringWithFormat:@"%f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
                
                _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
            }
        }
        
    }else{//余额关闭
        
        //先用优惠券在用余额
        if (_couponsNum.floatValue > _AllProductAmountAndAllShipFee.floatValue) {//直接用优惠券付款
            
            _numPirceLab.text = @"0.00";
            
            _numPirce = @"0.00";
            
            _balance = @"0.00";
            
            _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_AllProductAmountAndAllShipFee.floatValue];
            
        }else{//混合付款先用优惠券
            
            _numPirceLab.text = [NSString stringWithFormat:@"¥%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
            
            _numPirce = [NSString stringWithFormat:@"%.2f",_AllProductAmountAndAllShipFee.floatValue - _couponsNum.floatValue];
            
            _balance = @"0.00";
            
            _discountLab.text = [NSString stringWithFormat:@"-¥%.2f",_couponsNum.floatValue];
        }
    }
    
    _balanceLab.text = [NSString stringWithFormat:@"-¥%.2f",_balance.floatValue];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"16",@"num":@"2"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"余额   可用¥%.2f,本次使用¥%.2f",[_entity.MaxUseBalance floatValue],_balance.floatValue] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.orderTimeLab.attributedText = string;
    }];
    
    if (_OrderSettlementHeadViewBlock != nil) {
        _OrderSettlementHeadViewBlock([NSString stringWithFormat:@"%.2f",_numPirce.floatValue],[NSString stringWithFormat:@"%.2f",_balance.floatValue]);
    }
    
}
- (IBAction)changeAdrass:(UIButton *)sender {
    if (_OrderchangeAdrassBlock) {
        _OrderchangeAdrassBlock();
    }
}
-(void)setOrderchangeAdrass:(NSArray *)adrass{
    
    _namePhoneLab.text = [NSString stringWithFormat:@"%@   %@",adrass[0],adrass[1]];
    
    _adrassLab.text = [NSString stringWithFormat:@"%@%@%@%@",adrass[2],adrass[3],adrass[4],adrass[5]];
}

#pragma mark - textViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (_isTextView) {
        _orderRemarkTextView.text = @"";
        _isTextView = NO;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextViewTextDidChange" object:self userInfo: @{@"view":_orderRemarkTextView,@"num":@"50"}];
}

- (UIToolbar *)addToolbar{
    
    UIBarButtonItem *finished = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finished)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIToolbar *toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToobarHeight)];
    toobar.backgroundColor = [UIColor whiteColor];
    toobar.layer.borderColor  = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    toobar.layer.borderWidth = .5;
    toobar.layer.masksToBounds = YES;
    toobar.tintColor = [UIColor fromHexValue:0x555555 alpha:1];
    toobar.items = [NSArray arrayWithObjects:spaceItem,finished ,nil];
    return toobar;
}

-(void)finished{
    if (_orderRemarkTextView.text.length <= 50) {
        
        [_orderRemarkTextView resignFirstResponder];
        
        if (_OrderRemarkTextViewBlock) {
            _OrderRemarkTextViewBlock(_orderRemarkTextView.text);
        }
        
    }else{
        [ZHProgressHUD showInfoWithText:@"最多只能输入50个字"];
    }
}

@end

