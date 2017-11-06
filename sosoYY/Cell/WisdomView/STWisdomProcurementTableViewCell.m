//
//  STWisdomProcurementTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomProcurementTableViewCell.h"

@interface STWisdomProcurementTableViewCell ()<UITextFieldDelegate>{
    NSString *oldStr;
}
@end
@implementation STWisdomProcurementTableViewCell
-(void)setWisdom:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath textTextFieldAry:(NSMutableArray *)textAry{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    __weak STWisdomProcurementTableViewCell *weakSelf = self;
    
    _subtractBtn.layer.masksToBounds = YES;
    _subtractBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _subtractBtn.layer.borderWidth = .5;
    
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _addBtn.layer.borderWidth = .5;
    
    _listBtn.layer.masksToBounds = YES;
    _listBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _listBtn.layer.borderWidth = .5;
    
    _textTextField.layer.masksToBounds = YES;
    _textTextField.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _textTextField.layer.borderWidth = .5;
    
    _addLab.layer.masksToBounds = YES;
    _addLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
    _addLab.layer.borderWidth = .5;
    
    _zhicaiLab.layer.masksToBounds = YES;
    _zhicaiLab.layer.borderColor = RGB(0, 154, 52).CGColor;
    _zhicaiLab.layer.borderWidth = .5;
    
    
    _textTextField.text = [NSString stringWithFormat:@"%@",textAry[indexPath.section][indexPath.row]];
    
     _nameLab.text = [NSString stringWithFormat:@"%@",[arr[indexPath.section][indexPath.row] DrugsBase_DrugName]];
    
    if ([arr[indexPath.section][indexPath.row] YesterdayNoStock].intValue == 1) {
    
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"15",@"num":@"6"},@{@"color":RGB(85, 85, 85),@"font":@"15"}]  andChengeString:[NSString stringWithFormat:@"(昨日断货)%@",[arr[indexPath.section][indexPath.row] DrugsBase_DrugName]] type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.nameLab.attributedText = string;
        }];
    }
   
    
    if ([arr[indexPath.section][indexPath.row] isSelect].intValue == 1) {
        [_selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }else{
     [_selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    if (![[arr[indexPath.section][indexPath.row] DrugsBase_Specification] isEqualToString:@""]) {
        
      _standardLab.text = [arr[indexPath.section][indexPath.row] DrugsBase_Specification];
        
    }else{
        _standardLab.text = @"规格:-";
    }
    
    if (![[arr[indexPath.section][indexPath.row] DrugsBase_Manufacturer] isEqualToString:@""]) {
        _companyLab.text = [arr[indexPath.section][indexPath.row] DrugsBase_Manufacturer];
    }else{
       _companyLab.text = @"厂家:-";
    }
    
    
    
    if ([arr[indexPath.section][indexPath.row] speprice].intValue > 0) {
        _zhicaiLab.hidden = NO;
        _linelab.hidden = NO;
        _PriceLab.hidden = YES;
        
        //最小价格
        NSString *minStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] minPrice]floatValue]]];
        
        _oldLab.text = [NSString stringWithFormat:@"¥%@",minStr];
        
        CGSize contentSize = [_oldLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        if ([[arr[indexPath.section][indexPath.row] psn] isEqualToString:@""]) {
            _repertoryLab.text = @"库存:-";
            _salesLab.text = @"月销量:-";
            _dateLab.text = @"最近采购:------";
            
            _historyLab.hidden = YES;
            
            //智采价
            NSString *spepriceStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] speprice]floatValue]]];
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"¥%@",spepriceStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.spepriceLabel.attributedText = string;
            }];
            
                CGSize spepriceSize = [_spepriceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            _spepriceLabel.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width, 73, spepriceSize.width, 20);
            
            _zhicaiLab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width - 45 - 2, 74, 45, 18);
            
            _oldLab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width - 45 - contentSize.width - 6, 73, contentSize.width, 20);
            
              _linelab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width - 45 - contentSize.width - 4 , 83, contentSize.width, 1);
            
        }else{
            
            _addLab.hidden = YES;
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"库存:%d",[[arr[indexPath.section][indexPath.row] myStock] intValue]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.repertoryLab.attributedText = string;
            }];
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"月销量:%@",[arr[indexPath.section][indexPath.row] SalesVolume]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.salesLab.attributedText = string;
            }];
            if (![[arr[indexPath.section][indexPath.row] LastTimeString] isEqualToString:@""]) {
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"4"},@{@"color":RGB(119, 119, 119),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"最近采购:%@",[arr[indexPath.section][indexPath.row] LastTimeString]] type:1 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.historyLab.attributedText = string;
                }];
            }else{
              _historyLab.text = @"最近采购:------";
            }
         
            
            //历史价格
            NSString *HistoryPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] HistoryPrice]floatValue]]];
            CGFloat history = [HistoryPrice floatValue];
            
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"5"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"历史采购价:¥%@",HistoryPrice] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.dateLab.attributedText = string;
            }];
            //智采价
            NSString *spepriceStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] speprice]floatValue]]];
            CGFloat speprice = [spepriceStr floatValue];
            
            if (history > speprice) {
                
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"¥%@",spepriceStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.spepriceLabel.attributedText = string;
                }];
            }else {
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":@"1"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"¥%@",spepriceStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.spepriceLabel.attributedText = string;
                }];
            }
            
            CGSize spepriceSize = [_spepriceLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            _spepriceLabel.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width, 73, spepriceSize.width, 20);
            
            _zhicaiLab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width - 45 - 2, 74, 45, 18);
            
            _oldLab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width - 45 - contentSize.width - 6, 73, contentSize.width, 20);
            
            _linelab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width - 45 - contentSize.width - 4  , 83, contentSize.width , 1);
        }
    }else{
        _linelab.hidden = YES;
        _zhicaiLab.hidden = YES;
        _spepriceLabel.hidden = YES;
        _oldLab.hidden = YES;
        
        
        if ([[arr[indexPath.section][indexPath.row] psn] isEqualToString:@""]) {
            _repertoryLab.text = @"库存:-";
            _salesLab.text = @"月销量:-";
            _dateLab.text = @"最近采购:------";
            
            _historyLab.hidden = YES;
            
            //最小价格
            NSString *minStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] minPrice]floatValue]]];
            CGFloat minPrice = [minStr floatValue];
            
            //最大价格
            NSString *maxStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] maxPrice]floatValue]]];
            CGFloat maxPrice = [maxStr floatValue];
            
            if (minPrice != maxPrice) {
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":@"1"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.PriceLab.attributedText = string;
                }];
            }else{
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":@"1"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"¥%@",minStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.PriceLab.attributedText = string;
                }];
            }
        }else{
            _addLab.hidden = YES;
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"库存:%d",[[arr[indexPath.section][indexPath.row] myStock] intValue]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.repertoryLab.attributedText = string;
            }];
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"月销量:%@",[arr[indexPath.section][indexPath.row] SalesVolume]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.salesLab.attributedText = string;
            }];
            
            if (![[arr[indexPath.section][indexPath.row] LastTimeString] isEqualToString:@""]) {
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"4"},@{@"color":RGB(119, 119, 119),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"最近采购:%@",[arr[indexPath.section][indexPath.row] LastTimeString]] type:1 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.historyLab.attributedText = string;
                }];
            }else{
                _historyLab.text = @"最近采购:------";
            }
            
        

            //历史价格
            NSString *HistoryPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] HistoryPrice]floatValue]]];
            CGFloat history = [HistoryPrice floatValue];
            
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"5"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"历史采购价:¥%@",HistoryPrice] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.dateLab.attributedText = string;
            }];
            
            
            //最小价格
            NSString *minStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] minPrice]floatValue]]];
            CGFloat minPrice = [minStr floatValue];
            //
            //        //最大价格
            NSString *maxStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section][indexPath.row] maxPrice]floatValue]]];
            CGFloat maxPrice = [maxStr floatValue];
            
            if (minPrice == maxPrice) {
                if (history < minPrice) {
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":@"1"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"¥%@",minStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.PriceLab.attributedText = string;
                    }];
                }else{
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"¥%@",minStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.PriceLab.attributedText = string;
                    }];
                }
            }else{
                if (history > minPrice) {
                    if (history > maxPrice) {
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.PriceLab.attributedText = string;
                        }];
                    }else if (history == maxPrice){
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.PriceLab.attributedText = string;
                        }];
                    }else if (history < maxPrice){
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.PriceLab.attributedText = string;
                        }];
                    }
                }else if (history == minPrice){
                    if (history > maxPrice) {
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.PriceLab.attributedText = string;
                        }];
                    }else if (history == maxPrice){
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.PriceLab.attributedText = string;
                        }];
                    }else if (history < maxPrice){
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.PriceLab.attributedText = string;
                        }];
                    }
                }else if (history < minPrice){
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":@"1"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.PriceLab.attributedText = string;
                    }];
                }
            }
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textTextField.delegate = self;
    self.textTextField.inputAccessoryView = [self addToolbar];
    //    [_textTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)subtractSelected:(UIButton *)sender {
    STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[[[sender superview]superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setSubtract:)]) {
        [_delegate g_setSubtract:cell];
    }
}
- (IBAction)addSelected:(UIButton *)sender {
    STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[[[sender superview]superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setAdd:)]) {
        [_delegate g_setAdd:cell];
    }
}
- (IBAction)listSelected:(UIButton *)sender {
    STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[[[sender superview]superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setList:)]) {
        [_delegate g_setList:cell];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[[[textField superview]superview]superview];
    if (_delegate && [_delegate respondsToSelector:@selector(g_setTextFieldDidBeginEditing:)]) {
        [_delegate g_setTextFieldDidBeginEditing:cell];
    }
    oldStr = textField.text;
    textField.text = @"";
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

-(void)finished{
    if ([_textTextField.text intValue] > 99999) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于99999"];
        _textTextField.text = @"";
    }else if ([_textTextField.text intValue] < 1) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        _textTextField.text = @"";
    }else{
        [_textTextField resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(g_setfinished)]) {
            [_delegate g_setfinished];
        }
    }
}
-(void)cancel{
    [_textTextField resignFirstResponder];
    _textTextField.text = oldStr;
}
- (void)textFieldDidChange:(UITextField *)textField{
    if ([_textTextField.text intValue] > 99999) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于99999"];
        _textTextField.text = @"";
    }else if([_textTextField.text isEqualToString:@""]){
        return;
    }else if ([_textTextField.text intValue] < 1) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        _textTextField.text = @"";
    }
}
- (IBAction)selectedMethod:(UIButton *)sender {
    STWisdomProcurementTableViewCell *cell = (STWisdomProcurementTableViewCell *)[[sender superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setChangeSelect:)]) {
        [_delegate g_setChangeSelect:cell];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
