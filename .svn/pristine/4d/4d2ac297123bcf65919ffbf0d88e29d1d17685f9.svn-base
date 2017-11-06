//
//  STWisdomAddListUITableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/6.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomAddListUITableViewCell.h"

@implementation STWisdomAddListUITableViewCell
-(void)setWisdomAddList:(NSArray *)dataResult indexPath:(NSIndexPath *)indexPath{
  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    __weak STWisdomAddListUITableViewCell *weakSelf = self;
    
//    if ([[dataResult[indexPath.row] IsStandard] intValue] == 1) {
//        [_imgeV st_setImageWithURLString:[dataResult[indexPath.row] ImageUrl] placeholderImage:@"stance"];
//    }else{
//        [_imgeV st_setImageWithURLString:[dataResult[indexPath.row] ImageUrl_NoStandard_Top1] placeholderImage:@"stance"];
//    }
    
    
    if ([dataResult[indexPath.row] isBuy].intValue == 1) {
        _addBuyBtn.backgroundColor = RGB(153, 153, 153);
        [_addBuyBtn setTitle:@"已购买" forState:UIControlStateNormal];
    }
    
    if ([[[STCommon sharedSTSTCommon] setWhetherStringEmpty:[dataResult[indexPath.row] DrugsBase_ProName]] isEqualToString:@""]) {
        _nameLab.text = [dataResult[indexPath.row] DrugsBase_DrugName];
    }else{
        if (![[[STCommon sharedSTSTCommon] setWhetherStringEmpty:[dataResult[indexPath.row] DrugsBase_ProName]] isEqualToString:@""]) {
            _nameLab.text = [NSString stringWithFormat:@"%@(%@)",[dataResult[indexPath.row] DrugsBase_DrugName],[dataResult[indexPath.row] DrugsBase_ProName]];
        }else{
            _nameLab.text = [dataResult[indexPath.row] DrugsBase_ProName];
        }
    }
    
    
    _companyLab.text = [dataResult[indexPath.row] DrugsBase_Manufacturer];
    
    _numLab.text = [dataResult[indexPath.row] DrugsBase_Specification];
    
    if (![[dataResult[indexPath.row] sxrq] isEqualToString:@""]) {
       _dateLab.text = [NSString stringWithFormat:@"效期:%@",[dataResult[indexPath.row] sxrq]];
        if (![[STCommon sharedSTSTCommon] setIntervalSinceNow:[dataResult[indexPath.row] sxrq]]) {
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":RGB(241, 77, 67),@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"效期:%@",[dataResult[indexPath.row] sxrq]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.dateLab.attributedText = string;
            }];
        }
    }else{
        if ([dataResult[indexPath.row] IsJxq].intValue != 0) {
          _dateLab.text = @"近效期";
            _dateLab.textColor = RGB(241, 77, 67);
        }else{
         _dateLab.text = @"效期:---";
        }
    }
    
    if ([[dataResult[indexPath.row] IsKong] intValue] == 0) {
        _allianceLab.text = @"";
    }else{
        _allianceLab.text = @"首推联盟";
    }

    
    if([[dataResult[indexPath.row] cuxiaotype] intValue] == 1){
        _promotionLab.text = @"加价购";
        _promotionLab.layer.borderWidth = 1.0f;
        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
        _lineLab.hidden = YES;
        _oldPriceLab.hidden = YES;
        
        NSString *ShopPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] ShopPrice] floatValue]]];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"¥%@",ShopPrice] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.priceLab.attributedText = string;
        }];
        
         NSString *addPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] AddPriceBuy][@"addPrice"] floatValue]]];
        
        if ([[dataResult[indexPath.row] AddPriceBuy][@"firstpid"] integerValue] == [[dataResult[indexPath.row] AddPriceBuy][@"secondpid"] integerValue]) {
            _tradeBuy.hidden = YES;
            if ([[dataResult[indexPath.row] AddPriceBuy][@"addPriceType"] integerValue] == 0) {
             _addLab.text = [NSString stringWithFormat:@"满%zi%@另加%@元换购本商品%zi%@",[[dataResult[indexPath.row] AddPriceBuy][@"firstProudctStartNum"] integerValue],[dataResult[indexPath.row] goods_Unit],addPrice,[[dataResult[indexPath.row] AddPriceBuy][@"secondProudctNum"] integerValue],[dataResult[indexPath.row] goods_Unit]];
            }else{
              _addLab.text = [NSString stringWithFormat:@"每满%zi%@另加%@元换购本商品%zi%@",[[dataResult[indexPath.row] AddPriceBuy][@"firstProudctPerNum"] integerValue],[dataResult[indexPath.row] goods_Unit],addPrice,[[dataResult[indexPath.row] AddPriceBuy][@"secondProudctNum"] integerValue],[dataResult[indexPath.row] goods_Unit]];
            }
        }else{
            NSString *addPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] AddPriceBuy][@"addPrice"] floatValue]]];
            
            if ([[dataResult[indexPath.row] AddPriceBuy][@"addPriceType"] integerValue] == 0) {
                   _addLab.text = [NSString stringWithFormat:@"满%zi%@另加%@元换购其他商品%zi%@",[[dataResult[indexPath.row] AddPriceBuy][@"firstProudctStartNum"] integerValue],[dataResult[indexPath.row] goods_Unit],addPrice,[[dataResult[indexPath.row] AddPriceBuy][@"secondProudctNum"] integerValue],[dataResult[indexPath.row] goods_Unit]];
            }else{
              _addLab.text = [NSString stringWithFormat:@"每满%zi%@另加%@元换购其他商品%zi%@",[[dataResult[indexPath.row] AddPriceBuy][@"firstProudctPerNum"] integerValue],[dataResult[indexPath.row] goods_Unit],addPrice,[[dataResult[indexPath.row] AddPriceBuy][@"secondProudctNum"] integerValue],[dataResult[indexPath.row] goods_Unit]];
            }
        }
    }else if([[dataResult[indexPath.row] cuxiaotype] intValue] == 2){
        _promotionLab.text = @"特价";
        _promotionLab.layer.borderWidth = 1.0f;
        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
        _tradeBuy.hidden = YES;
        
        if ([[dataResult[indexPath.row] SpecialPrice][@"limittype"] intValue] == 0) {
            _addLab.hidden = YES;
        }else if ([[dataResult[indexPath.row] SpecialPrice][@"limittype"] intValue] == 1){
            _addLab.text = [NSString stringWithFormat:@"每人限购%@%@",[dataResult[indexPath.row] SpecialPrice][@"limitnumber"],[dataResult[indexPath.row] goods_Unit]];
        }else if ([[dataResult[indexPath.row] SpecialPrice][@"limittype"] intValue] == 2){
           _addLab.text = [NSString stringWithFormat:@"每人每天限购%@%@",[dataResult[indexPath.row] SpecialPrice][@"limitnumber"],[dataResult[indexPath.row] goods_Unit]];
        }
        
         NSString *SpecialPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] SpecialPrice][@"speprice"] floatValue]]];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"¥%@",SpecialPrice] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.priceLab.attributedText = string;
        }];
        
          NSString *ShopPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] ShopPrice] floatValue]]];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"¥%@",ShopPrice] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.oldPriceLab.attributedText = string;
        }];
        
        CGSize contentSize = [_oldPriceLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        _lineLab.frame = CGRectMake(kScreenWidth - contentSize.width - 10, _oldPriceLab.frame.origin.y + 10, contentSize.width + 3 , 1);
        _lineLab.hidden = NO;
    }else{
        _promotionLab.text = @"";
        _addLab.text = @"";
        _tradeBuy.hidden = YES;
        _lineLab.hidden = YES;
        _oldPriceLab.hidden = YES;
        
        
         NSString *ShopPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataResult[indexPath.row] ShopPrice] floatValue]]];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"¥%@",ShopPrice] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.priceLab.attributedText = string;
        }];
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
- (IBAction)selectBuy:(UIButton *)sender {
    STWisdomAddListUITableViewCell *cell = (STWisdomAddListUITableViewCell *)[[sender superview]superview];
    if (_delegate && [_delegate respondsToSelector:@selector(g_setSelectBuy:)]) {
        [_delegate g_setSelectBuy:cell];
    }
}
- (IBAction)tradeBuy:(UIButton *)sender {
    STWisdomAddListUITableViewCell *cell = (STWisdomAddListUITableViewCell *)[[sender superview]superview];
    if (_delegate && [_delegate respondsToSelector:@selector(g_setTradeBuy:)]) {
        [_delegate g_setTradeBuy:cell];
    }
}


@end
