//
//  STWisdomNotShopTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomNotShopTableViewCell.h"

@interface STWisdomNotShopTableViewCell ()<UITextFieldDelegate>{
    NSString *oldStr;
}

@property(strong,nonatomic)NSIndexPath *oldIndexPath;
@end

@implementation STWisdomNotShopTableViewCell
-(void)setWisdomNotShop:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath{
  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _oldIndexPath = indexPath;
    
    __weak STWisdomNotShopTableViewCell *weakSelf = self;
    
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
    _textTextField.tag = indexPath.section * 1000 + indexPath.row;
    
    _nameLab.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] DrugsBase_DrugName]];
    
     _textTextField.text = [NSString stringWithFormat:@"%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] buyCount]];
    
    if ([[arr[indexPath.section] dataAryTwo][indexPath.row] isSelect].intValue == 1) {
        [_selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    
    if (![[[arr[indexPath.section] dataAryTwo][indexPath.row] DrugsBase_Specification] isEqualToString:@""]) {
        
      _standardLab.text = [[arr[indexPath.section] dataAryTwo][indexPath.row] DrugsBase_Specification];
    }else{
       _standardLab.text = @"规格:-";
    }
    
    if (![[[arr[indexPath.section] dataAryTwo][indexPath.row] DrugsBase_Manufacturer] isEqualToString:@""]) {
        
        _companyLab.text = [[arr[indexPath.section] dataAryTwo][indexPath.row] DrugsBase_Manufacturer];
    }else{
       _companyLab.text = @"厂家:-";
    }
    
    if (![[NSString stringWithFormat:@"%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] myStock]] isEqualToString:@""]) {
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"库存:%d",[[arr[indexPath.section] dataAryTwo][indexPath.row] myStock].intValue] type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.repertoryLab.attributedText = string;
        }];
    }else{
       _repertoryLab.text = @"库存:-";
    }
    
    if (![[NSString stringWithFormat:@"%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] SalesVolume]] isEqualToString:@""]) {
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"月销量:%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] SalesVolume]] type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.salesLab.attributedText = string;
        }];
    }else{
       _salesLab.text = @"月销量:-";
    }
    
    if (![[NSString stringWithFormat:@"%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] HistoryPrice]] isEqualToString:@""]) {
        //历史价格
        NSString *HistoryPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[[arr[indexPath.section] dataAryTwo][indexPath.row] HistoryPrice]floatValue]]];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"6"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"历史采购价:¥%@",HistoryPrice] type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.historyLab.attributedText = string;
        }];
    }else{
      _historyLab.text = @"历史采购价:-";
    }
 
    if (![[NSString stringWithFormat:@"%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] LastTimeString]] isEqualToString:@""]) {
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"5"},@{@"color":RGB(119, 119, 119),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"最近采购:%@",[[arr[indexPath.section] dataAryTwo][indexPath.row] LastTimeString]] type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.dateLab.attributedText = string;
        }];
    }else{
      _dateLab.text = @"最近采购:------";
    }
    
    if ([[arr[indexPath.section] dataAryTwo][indexPath.row] isSelect].intValue == 1) {
        
        [_selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    
    if ([[[arr[indexPath.section] dataAryTwo][indexPath.row] Barcode] isEqualToString:@""]) {
        _notLab.text = @"条码为空";
    }else{
        if ([[[arr[indexPath.section] dataAryTwo][indexPath.row] Goods_Package_ID] intValue] == 0) {
          _notLab.text = @"未找到该商品";
        }else{
         _notLab.text = @"未找到该商品";
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
       self.textTextField.delegate = self;
}

- (IBAction)selectMothed:(UIButton *)sender {
    STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[[sender superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setNotChangeSelect:)]) {
        [_delegate g_setNotChangeSelect:cell];
    }
}

- (IBAction)subtractSelected:(UIButton *)sender {
    STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[[[sender superview]superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setNotSubtract:)]) {
        [_delegate g_setNotSubtract:cell];
    }
}
- (IBAction)addSelected:(UIButton *)sender {
    STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[[[sender superview]superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setNotAdd:)]) {
        [_delegate g_setNotAdd:cell];
    }
}
- (IBAction)listSelected:(UIButton *)sender {
    STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[[[sender superview]superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_setNotList:)]) {
        [_delegate g_setNotList:cell];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    STWisdomNotShopTableViewCell *cell = (STWisdomNotShopTableViewCell *)[[[textField superview]superview]superview];
//    if (_delegate && [_delegate respondsToSelector:@selector(g_setNotTextFieldDidBeginEditing:)]) {
//        [_delegate g_setNotTextFieldDidBeginEditing:cell];
//    }
    oldStr = textField.text;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    if ([_textTextField.text intValue] > 99999) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于99999"];
        _textTextField.text = @"";
    }else if ([_textTextField.text intValue] < 1) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        _textTextField.text = @"";
    }else{
        
        if (_delegate && [_delegate respondsToSelector:@selector(g_setNotFinished:)]) {
            [_delegate g_setNotFinished:_oldIndexPath];
        }
    }
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
    [_textTextField resignFirstResponder];
}
-(void)cancel{
    [_textTextField resignFirstResponder];
    _textTextField.text = oldStr;
}
- (void)textFieldDidChange:(UITextField *)textField{
    if ([_textTextField.text intValue] > 99999) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能大于99999"];
        _textTextField.text = oldStr;
    }else if([_textTextField.text isEqualToString:@""]){
        return;
    }else if ([_textTextField.text intValue] < 1) {
        [ZHProgressHUD showInfoWithText:@"购买数量不能小于1"];
        _textTextField.text = @"1";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
