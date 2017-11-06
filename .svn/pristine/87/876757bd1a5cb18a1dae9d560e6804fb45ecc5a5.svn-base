//
//  STWisdomSearchTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomSearchTableViewCell.h"

@implementation STWisdomSearchTableViewCell
-(void)setWisdomSearchDataResult:(NSMutableArray *)dataResult andIndexPath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    __weak STWisdomSearchTableViewCell *weakSelf = self;
    
    if ([[dataResult[indexPath.row] promotionTypes] rangeOfString:@"1"].location != NSNotFound || [[dataResult[indexPath.row] PricePromotionsTypes] rangeOfString:@"2"].location != NSNotFound) {//加价购
        _promotionLab.layer.borderWidth = 1.0f;
        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
    }else{
        _promotionLab.hidden = YES;
    }
    
    if ([[dataResult[indexPath.row] isHighMargin] intValue] == 1) {
        _allianceLab.text = @"首推联盟";
    }else{
        _allianceLab.layer.borderColor = [UIColor fromHexValue:0x777777 alpha:1].CGColor;
        _allianceLab.layer.borderWidth = 1.0;
        _allianceLab.backgroundColor = [UIColor whiteColor];
        _allianceLab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
        _allianceLab.text = [NSString stringWithFormat:@"%@个商家",[dataResult[indexPath.row] sellerCount]];
        if (_allianceLab.text.intValue < 2) {
            _allianceLab.hidden = YES;
        }
    }
    
    if ([[dataResult[indexPath.row] IsStandard] intValue] == 1) {
        [_imageV st_setImageWithURLString:[dataResult[indexPath.row] imageUrl] placeholderImage:@"stance"];
    }else{
        [_imageV st_setImageWithURLString:[dataResult[indexPath.row] ImageUrl_NoStandard_Top1] placeholderImage:@"stance"];
    }
    
    if ([[[STCommon sharedSTSTCommon] setWhetherStringEmpty:[dataResult[indexPath.row] drugsBase_ProName]] isEqualToString:@""]) {
        _nameLab.text = [dataResult[indexPath.row] drugsBase_DrugName];
    }else{
        if (![[[STCommon sharedSTSTCommon] setWhetherStringEmpty:[dataResult[indexPath.row] drugsBase_ProName]] isEqualToString:@""]) {
            _nameLab.text = [NSString stringWithFormat:@"%@(%@)",[dataResult[indexPath.row] drugsBase_DrugName],[dataResult[indexPath.row] drugsBase_ProName]];
        }else{
            _nameLab.text = [dataResult[indexPath.row] drugsBase_ProName];
        }
    }
    
    _numLab.text = [dataResult[indexPath.row] drugsBase_Specification];
    _companyLab.text = [dataResult[indexPath.row] drugsBase_Manufacturer];
    
    if ([_numLab.text isEqualToString:@""] && [_companyLab.text isEqualToString:@""]) {
        _imageV.hidden = YES;
    }
    
    if ([[dataResult[indexPath.row] mAddr_control] intValue] == 1) {
        _addBuy.backgroundColor = RGB(153, 153, 153);
        [_addBuy setImage:[UIImage imageNamed:@"addTure"] forState:UIControlStateNormal];
        [_addBuy setTitle:@"已加入计划" forState:UIControlStateNormal];
        _addBuy.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
   NSString  *minShopPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] minShopPrice] floatValue]]];
    
      NSString  *maxShopPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] maxShopPrice] floatValue]]];
    
    
    if (maxShopPrice.floatValue > minShopPrice.floatValue) {
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"价格:¥%@-%@",minShopPrice,maxShopPrice] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.priceLab.attributedText = string;
        }];
    }else{
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"价格:¥%@",minShopPrice] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.priceLab.attributedText = string;
        }];
    }
}
- (IBAction)selectedAddBuy:(UIButton *)sender {
    STWisdomSearchTableViewCell *cell = (STWisdomSearchTableViewCell *)[[sender superview]superview];
    if (_delegate && [_delegate respondsToSelector:@selector(g_setSearchSelectBuy:)]) {
        [_delegate g_setSearchSelectBuy:cell];
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
