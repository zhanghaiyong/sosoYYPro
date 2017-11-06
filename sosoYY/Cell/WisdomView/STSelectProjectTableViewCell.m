//
//  STSelectProjectTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STSelectProjectTableViewCell.h"

@implementation STSelectProjectTableViewCell
-(void)setSelectProject:(NSArray *)arr indexPath:(NSIndexPath *)indexPath selectStr:(NSString *)str{
  
    self.contentView.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    self.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5.0f;
    _lineLab.frame = CGRectMake(0, 59, kScreenWidth, .5);
    __weak STSelectProjectTableViewCell *weakSelf = self;
    
  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([[arr[indexPath.section] SchemeName] isEqualToString:@"推荐最优方案"]) {
        _imgV.image = [UIImage imageNamed:@"heart"];
        _bgImgV.image = [UIImage imageNamed:@"goodHeart"];
        _selectImgV.image = [UIImage imageNamed:@"selectOK"];
    }else{
        _selectImgV.image = [UIImage imageNamed:@"selectImgVOK"];
      _imgV.image = [UIImage imageNamed:@"minimum"];
        _bgImgV.image = [UIImage imageNamed:@"low"];
    }
    _nameLab.text = [arr[indexPath.section] SchemeName];
    _saveMoneyLab.text = @"为您节省";
    
    NSString *EconomizeMoney =  [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section] EconomizeMoney]floatValue]]];
    
    NSString *EconomizeMoneyCout = [NSString stringWithFormat:@"%lu",(unsigned long)EconomizeMoney.length];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(255, 255, 255),@"font":@"24",@"num":EconomizeMoneyCout},@{@"color":RGB(255, 255, 255),@"font":@"12",@"num":@"1"}]  andChengeString:[NSString stringWithFormat:@"%@",EconomizeMoney] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.moneyCout.attributedText = string;
    }];
    
    _timesavingLab.text = @"节省时间";
    
   NSString *EconomizeTime = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section] EconomizeTime]floatValue]]];
    NSString *EconomizeTimeCount = [NSString stringWithFormat:@"%lu",(unsigned long)EconomizeTime.length];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(255, 255, 255),@"font":@"24",@"num":EconomizeTimeCount},@{@"color":RGB(255, 255, 255),@"font":@"12",@"num":@"2"}]  andChengeString:[NSString stringWithFormat:@"%@",EconomizeTime] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.timeCount.attributedText = string;
    }];
    
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12"},@{@"color":RGB(85, 85, 85),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"采购店铺:%@",[arr[indexPath.section] StoresCount]] type:0 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.shopNumLab.attributedText = string;
    }];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12"},@{@"color":RGB(85, 85, 85),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"不符合采购条件商品:%@",[arr[indexPath.section] mismatching]] type:0 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.productNumLab.attributedText = string;
    }];
    
      NSString *Postage = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section] Postage] floatValue]]];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":RGB(85, 85, 85),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"邮费:¥%@",Postage] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.postageLab.attributedText = string;
    }];
    
    
      NSString *SurplusMoney = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.section] SurplusMoney] floatValue]]];
    

    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":RGB(234, 84, 19),@"font":@"12"}]  andChengeString:[NSString stringWithFormat:@"金额:¥%@",SurplusMoney] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.totalLab.attributedText = string;
    }];
    
    
    if (arr.count == 1) {
        
    }else{
        if ([str isEqualToString:[arr[indexPath.section] SchemeName]]) {
          
        }else{
            _bgImgV.image =[UIImage imageNamed:@""];
            _selectImgV.hidden = YES;
        }
    }
}
- (IBAction)selectBtn:(UIButton *)sender {
     STSelectProjectTableViewCell *cell = (STSelectProjectTableViewCell *)[[[[sender superview]superview]superview]superview];
    if (_delegate && [_delegate respondsToSelector:@selector(g_setSelectBtn:)]) {
        [_delegate g_setSelectBtn:cell];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
