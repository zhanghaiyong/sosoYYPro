//
//  STStorewideBgTableViewCell.m
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideBgTableViewCell.h"
#import "STCommon.h"


@implementation STStorewideBgTableViewCell
-(void)setStoreBgDataResult:(NSMutableArray *)dataResult andIndexPath:(NSIndexPath *)indexPath{
     [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    __weak STStorewideBgTableViewCell *weakSelf = self;
    
    if ([[dataResult[indexPath.row] IsStandard] intValue] == 1) {
        [_imgeV st_setImageWithURLString:[dataResult[indexPath.row] ImageUrl] placeholderImage:@"stance"];
    }else{
        [_imgeV st_setImageWithURLString:[dataResult[indexPath.row] ImageUrl_NoStandard_Top1] placeholderImage:@"stance"];
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
   

    if ([[dataResult[indexPath.row] IsKong] intValue] == 0) {
        _allianceLab.text = @"";
    }else{
        _allianceLab.text = @"首推联盟";
    }
    if ([[dataResult[indexPath.row] ShopPrice] intValue] == -1) {
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},] andChengeString:@"价格:登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.priceLab.attributedText = string;
        }];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"统一零售价:登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.unifyLab.attributedText = string;
        }];
        
    }else{
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[[dataResult[indexPath.row] ShopPrice] floatValue]] type:0 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.priceLab.attributedText = string;
            }];
    
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"统一零售价:¥%.2f",[[dataResult[indexPath.row] MarketPrice]floatValue]] type:0 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.unifyLab.attributedText = string;
            }];
    }
        
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[[dataResult[indexPath.row] GrossMargin] intValue]] type:0 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.profitLab.attributedText = string;
        }];
 
    
    if([[dataResult[indexPath.row] Addr_Control] intValue] == 1){
        _promotionLab.layer.borderWidth = 1.0f;
        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
    }else{
         _promotionLab.hidden = YES;
    }
    
    if ([[dataResult[indexPath.row] IsKong] intValue] == 0) {
        _unifyLab.text = @"";
        _profitLab.text = @"";
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
