//
//  STListTableViewCell.m
//  my
//
//  Created by soso-mac on 2016/11/21.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STListTableViewCell.h"
#import "STCommon.h"
@implementation STListTableViewCell
-(void)setProduceDataResult:(NSMutableArray *)dataResult andIndexPath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    __weak STListTableViewCell *weakSelf = self;
    if ([[dataResult[indexPath.row] promotionTypes] rangeOfString:@"1"].location != NSNotFound || [[dataResult[indexPath.row] PricePromotionsTypes] rangeOfString:@"2"].location != NSNotFound) {//加价购
        _promotionLab.layer.borderWidth = 1.0f;
        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
    }else{
        //        _promotionLab.layer.borderWidth = 1.0f;
        //        _promotionLab.layer.borderColor = [UIColor whiteColor].CGColor;
        _promotionLab.hidden = YES;
    }
    
    //    if ([[dataResult[indexPath.row] isExemptPostage] intValue] == 1) {//免邮
    //        _promotionLab.text = @"免邮";
    //        _promotionLab.layer.borderWidth = 1.0f;
    //        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
    //    }else{
    //        _promotionLab.layer.borderWidth = 1.0f;
    //        _promotionLab.layer.borderColor = [UIColor whiteColor].CGColor;
    //        _promotionLab.hidden = YES;
    //    }
    
    
    
    if ([[dataResult[indexPath.row] isHighMargin] intValue] == 1) {
        _allianceLab.text = @"首推联盟";
    }else{
        _allianceLab.layer.borderColor = [UIColor fromHexValue:0x777777 alpha:1].CGColor;
        _allianceLab.layer.borderWidth = 1.0;
        _allianceLab.backgroundColor = [UIColor whiteColor];
        _allianceLab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
        _allianceLab.text = [NSString stringWithFormat:@"%@个商家",[dataResult[indexPath.row] sellerCount]];
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
    
    if ([[dataResult[indexPath.row] minShopPrice] intValue] != -1) {
        if ([[dataResult[indexPath.row] isHighMargin] integerValue] == 1) {
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[[dataResult[indexPath.row] minShopPrice] floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.priceLab.attributedText = string;
            }];
        }else{
            if ([[dataResult[indexPath.row] sellerCount] integerValue] == 1) {
                
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[[dataResult[indexPath.row] minShopPrice] floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.priceLab.attributedText = string;
                }];
                
            }else {
                
                __block NSMutableAttributedString *attStr1 = nil;
                __block NSMutableAttributedString *attStr2 = nil;
                
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[[dataResult[indexPath.row] minShopPrice]floatValue]] type:0 andFinished:^(NSMutableAttributedString *string) {
                    attStr1 = string;
                }];
                
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"-%.2f",[[dataResult[indexPath.row] maxShopPrice]floatValue]] type:0 andFinished:^(NSMutableAttributedString *str) {
                    attStr2 = str;
                }];
                [attStr1 appendAttributedString:attStr2];
                weakSelf.priceLab.attributedText = attStr1;
            }
        }
    }else{
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.priceLab.attributedText = string;
        }];
    }
    if ([[dataResult[indexPath.row] isHighMargin] intValue] == 1) {
        if ([[dataResult[indexPath.row] minShopPrice] intValue] == -1){
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"统一零售价:登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.unifyLab.attributedText = string;
            }];
        }else{
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"统一零售价:¥%.2f",[[dataResult[indexPath.row] marketPrice]floatValue]] type:0 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.unifyLab.attributedText = string;
            }];
        }
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[[dataResult[indexPath.row] maxGrossMargin] intValue]] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.profitLab.attributedText = string;
        }];
    }else{
        _unifyLab.text = @"";
        _profitLab.text = @"";
    }
    
    //    四舍五入:round(x)
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
