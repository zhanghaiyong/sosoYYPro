//
//  STShopHomePromotionCell.m
//  my
//
//  Created by soso-mac on 2016/12/16.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopHomePromotionCell.h"
@implementation STShopHomePromotionCell
-(void)setTopHomePromotionIndexPath:(NSIndexPath *)indexPath andTitleAry:(NSMutableArray *)titleAry logIn:(NSString *)logIn{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    self.layer.borderWidth = .25;
    
      __weak STShopHomePromotionCell *weakSelf = self;
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (titleAry.count %2 == 0) {
        if ([titleAry[indexPath.row][@"type"] intValue] == 2) {//加价购
            _oldPriceLab.text = @"";
            _newePriceLab.text = @"";
            _lineLab.hidden = YES;
            
            if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"]) {
                _allianceLab.hidden = NO;
            }else{
                _allianceLab.hidden = YES;
            }
            
            [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
            _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
            
            _profitLab.text = [NSString stringWithFormat:@"+%@元  可换购本品%d%@",titleAry[indexPath.row][@"AddPriceBuyModel"][@"addPrice"],[titleAry[indexPath.row][@"AddPriceBuyModel"][@"secondProudctNum"] intValue],titleAry[indexPath.row][@"Goods_Unit"]];
            
        }else{//特价
            _profitLab.text = @"";
            
            if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"]) {
                _allianceLab.hidden = NO;
            }else{
                _allianceLab.hidden = YES;
            }
            
            [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
            _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
            if ([logIn intValue] == 1) {
                _oldPriceLab.text = [NSString stringWithFormat:@"原价:¥%.2f",[titleAry[indexPath.row][@"shopprice"] floatValue]];
                _newePriceLab.text = [NSString stringWithFormat:@"特价:¥%.2f",[titleAry[indexPath.row][@"SpecialPriceModel"][@"speprice"]floatValue]];
                
                CGSize contentSize = [_oldPriceLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                _lineLab.frame = CGRectMake(8, 169, contentSize.width , .8);
                _lineLab.hidden = NO;
            }else{
              _lineLab.hidden = YES;
                
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"原价: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.oldPriceLab.attributedText = string;
                }];
                
                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"特价: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                    weakSelf.newePriceLab.attributedText = string;
                }];
            }
        }
    }else{
        if (indexPath.row == titleAry.count) {
            _allianceLab.hidden = YES;
            [_imageV st_setImageWithURLString:@""  placeholderImage:@""];
            _nameLab.text = @"";
            _profitLab.text = @"";
            _oldPriceLab.text = @"";
            _newePriceLab.text = @"";
            _lineLab.hidden = YES;
        }else{
            if ([titleAry[indexPath.row][@"type"] intValue] == 2) {//加价购
                _oldPriceLab.text = @"";
                _newePriceLab.text = @"";
               _lineLab.hidden = YES;
                
                if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                    _allianceLab.hidden = NO;
                }else{
                    _allianceLab.hidden = YES;
                }
                
                [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                
                _profitLab.text = [NSString stringWithFormat:@"+%@元  可换购本品%d%@",titleAry[indexPath.row][@"AddPriceBuyModel"][@"addPrice"],[titleAry[indexPath.row][@"AddPriceBuyModel"][@"secondProudctNum"] intValue],titleAry[indexPath.row][@"Goods_Unit"]];
            }else{//特价
                _profitLab.text = @"";
                
                if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"]) {
                    _allianceLab.hidden = NO;
                }else{
                    _allianceLab.hidden = YES;
                }
                
                [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                
                if ([logIn intValue] == 1) {
                    _oldPriceLab.text = [NSString stringWithFormat:@"原价:¥%.2f",[titleAry[indexPath.row][@"shopprice"] floatValue]];
                    _newePriceLab.text = [NSString stringWithFormat:@"特价:¥%.2f",[titleAry[indexPath.row][@"SpecialPriceModel"][@"speprice"]floatValue]];
                    
                    CGSize contentSize = [_oldPriceLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                    _lineLab.frame = CGRectMake(8, 169, contentSize.width , .8);
                    _lineLab.hidden = NO;
                }else{
                    _lineLab.hidden = YES;
                    
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"原价: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.oldPriceLab.attributedText = string;
                    }];
                    
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"特价: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.newePriceLab.attributedText = string;
                    }];
                }
            }
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
