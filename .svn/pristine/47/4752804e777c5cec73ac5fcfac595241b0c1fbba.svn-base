//
//  STWisdomAddBCountuyView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomAddBCountuyView.h"

@interface STWisdomAddBCountuyView ()<UITextFieldDelegate>
@property(strong,nonatomic)NSString *buyCount;
@property(strong,nonatomic)NSString *oldCount;
@property(strong,nonatomic)NSString *stockCount;
@property(strong,nonatomic)NSString *pid;
@property(strong,nonatomic)NSString *sellType;
@property(assign,nonatomic)CGFloat count;
@property(strong,nonatomic)STStorewideEntity *entity;
@property(strong,nonatomic)NSIndexPath *indexpath;
@property(strong,nonatomic)NSString *Product_Pcs_Small;//中包装
@property(strong,nonatomic)NSString *Product_Pcs;//建装

@end

@implementation STWisdomAddBCountuyView
-(void)setWisdomAddBCountuy:(STStorewideEntity *)entity indexpath:(NSIndexPath *)indexpath{
    
    _entity = entity;
    _indexpath = indexpath;
    
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.0f;
    
    _subtractBtn.layer.masksToBounds = YES;
    _subtractBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _subtractBtn.layer.borderWidth = .5;
    
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _addBtn.layer.borderWidth = .5;
    
    _textTextField.delegate = self;
    //    _textTextField.inputAccessoryView = [self addToolbar];
    _textTextField.layer.masksToBounds = YES;
    _textTextField.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _textTextField.layer.borderWidth = .5;
      [_textTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _cancelBtn.layer.borderWidth = .5;
    
    _finishedBtn.layer.masksToBounds = YES;
    _finishedBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _finishedBtn.layer.borderWidth = .5;
    
    _pid = [NSString stringWithFormat:@"%@",entity.Pid];
    _buyCount = [NSString stringWithFormat:@"%@",entity.MinBuyNum];
    _oldCount = [NSString stringWithFormat:@"%@",entity.MinBuyNum];
    _stockCount = [NSString stringWithFormat:@"%@",entity.stock];
    _sellType = entity.sellType;
    _count = _oldCount.floatValue;
    
    _Product_Pcs_Small = [NSString stringWithFormat:@"%.2f",_entity.Product_Pcs_Small.floatValue];
    _Product_Pcs = [NSString stringWithFormat:@"%.2f",_entity.Product_Pcs.floatValue];
    
    _textTextField.text = _oldCount;
    _repertoryLab.text = [NSString stringWithFormat:@"库存:%@%@",_stockCount,entity.goods_Unit];
    _lowestBuyLab.text = [NSString stringWithFormat:@"最低购买数:%@%@",_oldCount,entity.goods_Unit];
}
- (UIToolbar *)addToolbar{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    UIBarButtonItem *finished = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finished)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIToolbar *toobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToobarHeight)];
    toobar.backgroundColor = [UIColor whiteColor];
    toobar.layer.borderColor  = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    toobar.layer.borderWidth = .5;
    toobar.layer.masksToBounds = YES;
    toobar.tintColor = [UIColor fromHexValue:0x555555 alpha:1];
    toobar.items = [NSArray arrayWithObjects:cancel,spaceItem,finished ,nil];
    return toobar;
}
- (IBAction)subtractSelectBtn:(UIButton *)sender {
     [_textTextField resignFirstResponder];
    switch ([self.sellType intValue]) {
        case 1:
            
            _count -= 1;
            
            if (_count < [self.entity.MinBuyNum floatValue]) {
                _count += 1;
            }
            
            break;
        case 2:
            
            if (_Product_Pcs_Small.floatValue > 0) {
                
                _count -= _Product_Pcs_Small.floatValue;
            }else {
                
                _count -= 1;
            }
            
            if (_count < _Product_Pcs_Small.floatValue && _count < self.entity.MinBuyNum.floatValue) {
                _count = _Product_Pcs_Small.floatValue;
            }
            break;
            
        case 3:
            
            _count -= _Product_Pcs.floatValue;
            if (_count < _Product_Pcs.floatValue && _count < self.entity.MinBuyNum.floatValue) {
                _count += _Product_Pcs.floatValue;
            }
            
            break;
            
        default:
            break;
    }
    if (_oldCount.floatValue >= _textTextField.text.floatValue) {
        [ZHProgressHUD showInfoWithText:@"不能小于最低购买数"];
    }else{
        
        _textTextField.text = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",_count]];
        _buyCount = _textTextField.text;
    }
}
- (IBAction)addSelectBtn:(UIButton *)sender {
     [_textTextField resignFirstResponder];
    switch (_sellType.intValue) {
        case 1:
            _count += 1;
            break;
        case 2:{
            __weak STWisdomAddBCountuyView *weakSelf = self;
            
            if (_Product_Pcs_Small.floatValue > 0) {
                
                _count += _Product_Pcs_Small.floatValue;
                
                [STCommon isRemainderD1:_count withD2:[NSString stringWithFormat:@"%.2f",_Product_Pcs_Small.floatValue].floatValue Block:^(BOOL isRemainder, int multiple) {
                    if (!isRemainder) {
                        weakSelf.count = multiple * weakSelf.Product_Pcs_Small.floatValue;
                    }
                }];
            }else {
                _count += 1;
            }
            
            break;
        }
        case 3:
            _count += _Product_Pcs.floatValue;
            break;
            
        default:
            break;
    }
    
    _count = [self addRepeatCount:_count];
    
    if (_stockCount.floatValue <= _textTextField.text.floatValue) {
        [ZHProgressHUD showInfoWithText:@"不能大于库存数"];
    }else{
        _textTextField.text = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",_count]];
        _buyCount = _textTextField.text;
    }
}

- (IBAction)cancelSelectBtn:(UIButton *)sender {
    if (_WisdomBuyCountBlock) {
        _WisdomBuyCountBlock(0,@{@"num":_buyCount,@"pid":_pid,@"psn":@""},_indexpath);
    }
    _textTextField.text = _oldCount;
    _count = _oldCount.floatValue;
    [_textTextField resignFirstResponder];
}
- (IBAction)finishedSelectBtn:(UIButton *)sender {
    
    if ( [_oldCount intValue] > [_textTextField.text intValue]) {
        [ZHProgressHUD showInfoWithText:@"不能小于最低购买数"];
        _textTextField.text = @"";
    }else if([_stockCount intValue] < [_textTextField.text intValue]){
        [ZHProgressHUD showInfoWithText:@"不能大于库存数"];
        _textTextField.text = @"";
    }else{
        
        if ([self inputText:_textTextField.text.floatValue]) {
            _count = _oldCount.floatValue;
            _buyCount = _textTextField.text;
            if (_WisdomBuyCountBlock) {
                _WisdomBuyCountBlock(1,@{@"num":_buyCount,@"pid":_pid},_indexpath);
            }
        }
    }
    [_textTextField resignFirstResponder];
}
- (IBAction)deleteSelectBtn:(UIButton *)sender {
    if (_WisdomBuyCountBlock) {
        _WisdomBuyCountBlock(0,@{@"num":_buyCount,@"pid":_pid},_indexpath);
    }
    _count = _oldCount.floatValue;
    [_textTextField resignFirstResponder];
}
-(void)finished{
    if ( [_oldCount intValue] > [_textTextField.text intValue]) {
        [ZHProgressHUD showInfoWithText:@"不能小于最低购买数"];
        _textTextField.text = @"";
    }else if([_stockCount intValue] < [_textTextField.text intValue]){
        [ZHProgressHUD showInfoWithText:@"不能大于库存数"];
        _textTextField.text = @"";
    }else{
        _buyCount = _textTextField.text;
        [_textTextField resignFirstResponder];
    }
}
-(void)cancel{
    [_textTextField resignFirstResponder];
    _textTextField.text = _oldCount;
    _count = _oldCount.floatValue;
}
#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _textTextField.text = @"";
}


- (void)textFieldDidChange:(UITextField *)textField{
     _count = _textTextField.text.floatValue;
     NSLog(@"_textTextField.text.floatValue ==%f",_textTextField.text.floatValue);
}

- (BOOL)inputText:(CGFloat)count {
    
    if (self.textTextField.text.length != 0) {
        
        __block BOOL isYes;
        
        [STCommon isRemainderD1:count withD2:[NSString stringWithFormat:@"%.2f",_Product_Pcs_Small.floatValue].floatValue Block:^(BOOL isRemainder, int multiple) {
            isYes = isRemainder;
        }];
        
        if(count > 0) {
            
            if (count > _stockCount.floatValue) {
                
                self.textTextField.text = [NSString stringWithFormat:@"%@",self.entity.MinBuyNum];
                
                [ZHProgressHUD showInfoWithText:[NSString stringWithFormat:@"库存紧张,最多只能采购%@%@哦",[STCommon setHasSuffix:_stockCount],self.entity.goods_Unit]];
                return NO;
            }else if (_sellType.intValue == 2 && !isYes && _Product_Pcs_Small.floatValue > 0) {
                
                self.textTextField.text = [NSString stringWithFormat:@"%@",self.entity.MinBuyNum];
                
                [ZHProgressHUD showInfoWithText:[NSString stringWithFormat:@"购买数量必须是中包装【%@】的整数倍",[STCommon setHasSuffix:self.entity.Product_Pcs_Small]]];
                
                return NO;
            }else if(count < self.entity.MinBuyNum.floatValue){
                
                self.textTextField.text = [NSString stringWithFormat:@"%@",self.entity.MinBuyNum];
                
                [ZHProgressHUD showInfoWithText:[NSString stringWithFormat:@"不能低于最低采购数【%@】%@",[STCommon setHasSuffix:self.entity.MinBuyNum],self.entity.goods_Unit]];
                
            }else{
                return YES;
            }
        }else {
            
            [ZHProgressHUD showInfoWithText:@"请输入大于零的购买数量"];
            
            self.textTextField.text = [NSString stringWithFormat:@"%@",self.entity.MinBuyNum];
            return NO;
        }
        
        return NO;
    }else{
        return NO;
    }
}


- (CGFloat)addRepeatCount:(CGFloat)count {
    
    if (count > _stockCount.floatValue ) {
        
        [ZHProgressHUD showInfoWithText:[NSString stringWithFormat:@"库存紧张,最大可采购数量%@%@哦",[STCommon setHasSuffix:_stockCount],self.entity.goods_Unit]];
        
        switch (_sellType.intValue) {
            case 1:
                
                count -= 1;
                
                break;
            case 2:
                
                count -= _Product_Pcs_Small.floatValue;
                
                break;
                
            case 3:
                
                count -= _Product_Pcs.floatValue;
                
                break;
                
            default:
                break;
        }
        
        return count;
        
    }else if (count < _oldCount.floatValue) {
        
        count = _oldCount.floatValue;
    }
    
    return count;
}

@end
