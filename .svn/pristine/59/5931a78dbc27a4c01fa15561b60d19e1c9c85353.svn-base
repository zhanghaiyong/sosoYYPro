//
//  STShopHomeViewCell.m
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopHomeViewCell.h"

@implementation STShopHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTopHomeIndexPath:(NSIndexPath *)indexPath andTitleAry:(NSMutableArray *)titleAry logIn:(NSString *)logIn type:(NSInteger)type{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    self.layer.borderWidth = .25;
    __weak STShopHomeViewCell *weakSelf = self;
    
    self.backgroundColor = [UIColor whiteColor];
    
    switch (type) {
        case 0:{//精品
            if (titleAry.count %2 == 0) {
                if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"]) {
                    _allianceLab.hidden = NO;
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.profitLab.attributedText = string;
                    }];
                }else{
                    _allianceLab.hidden = YES;
                    _profitLab.text = @"";
                }
                
                if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                    _promotionLab.layer.borderWidth = 1.0f;
                    _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                    _promotionLab.hidden = NO;
                }else{
                    _promotionLab.hidden = YES;
                }
                
                [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                
                _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                
                if ([logIn intValue] == 1) {
                    if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }else{
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.priceLab.attributedText = string;
                    }];
                }
                
            }else{
                if (indexPath.row == titleAry.count) {
                    _allianceLab.hidden = YES;
                    _promotionLab.hidden = YES;
                    [_imageV st_setImageWithURLString:@""  placeholderImage:@""];
                    _nameLab.text = @"";
                    _numLab.text = @"";
                    _companyLab.text = @"";
                    _priceLab.text = @"";
                    _profitLab.text = @"";
                }else{
                    if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                        _allianceLab.hidden = NO;
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.profitLab.attributedText = string;
                        }];
                    }else{
                        _allianceLab.hidden = YES;
                        _profitLab.text = @"";
                    }
                    
                    if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                        _promotionLab.layer.borderWidth = 1.0f;
                        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                        _promotionLab.hidden = NO;
                    }else{
                        _promotionLab.hidden = YES;
                    }
                    
                    [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                    
                    _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                    _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                    _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                    
                    if ([logIn intValue] == 1) {
                        if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }else{
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }
            }
            break;
        }
        case 1:{//人气
            if (titleAry.count %2 == 0) {
                if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                    _allianceLab.hidden = NO;
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.profitLab.attributedText = string;
                    }];
                }else{
                    _allianceLab.hidden = YES;
                    _profitLab.text = @"";
                }
                
                if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                    _promotionLab.layer.borderWidth = 1.0f;
                    _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                    _promotionLab.hidden = NO;
                }else{
                    _promotionLab.hidden = YES;
                }
                
                [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                
                _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                
                if ([logIn intValue] == 1) {
                    if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }else{
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.priceLab.attributedText = string;
                    }];
                }
            }else{
                if (indexPath.row == titleAry.count) {
                    _allianceLab.hidden = YES;
                    _promotionLab.hidden = YES;
                    [_imageV st_setImageWithURLString:@""  placeholderImage:@""];
                    _nameLab.text = @"";
                    _numLab.text = @"";
                    _companyLab.text = @"";
                    _priceLab.text = @"";
                    _profitLab.text = @"";
                }else{
                    if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                        _allianceLab.hidden = NO;
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.profitLab.attributedText = string;
                        }];
                    }else{
                        _allianceLab.hidden = YES;
                        _profitLab.text = @"";
                    }
                    
                    if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                        _promotionLab.layer.borderWidth = 1.0f;
                        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                        _promotionLab.hidden = NO;
                    }else{
                        _promotionLab.hidden = YES;
                    }
                    
                    [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                    
                    _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                    _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                    _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                    
                    if ([logIn intValue] == 1) {
                        if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }else{
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }
            }
            break;
        }
        case 2:{//热销
            if (titleAry.count %2 == 0) {
                if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                    _allianceLab.hidden = NO;
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.profitLab.attributedText = string;
                    }];
                }else{
                    _allianceLab.hidden = YES;
                    _profitLab.text = @"";
                }
                
                if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                    _promotionLab.layer.borderWidth = 1.0f;
                    _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                    _promotionLab.hidden = NO;
                }else{
                    _promotionLab.hidden = YES;
                }
                [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                
                _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                
                if ([logIn intValue] == 1) {
                    if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }else{
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.priceLab.attributedText = string;
                    }];
                }
            }else{
                if (indexPath.row == titleAry.count) {
                    _allianceLab.hidden = YES;
                    _promotionLab.hidden = YES;
                    [_imageV st_setImageWithURLString:@""  placeholderImage:@""];
                    _nameLab.text = @"";
                    _numLab.text = @"";
                    _companyLab.text = @"";
                    _priceLab.text = @"";
                    _profitLab.text = @"";
                }else{
                    if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                        _allianceLab.hidden = NO;
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.profitLab.attributedText = string;
                        }];
                    }else{
                        _allianceLab.hidden = YES;
                        _profitLab.text = @"";
                    }
                    
                    if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                        _promotionLab.layer.borderWidth = 1.0f;
                        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                        _promotionLab.hidden = NO;
                    }else{
                        _promotionLab.hidden = YES;
                    }
                    [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                    
                    _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                    _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                    _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                    
                    if ([logIn intValue] == 1) {
                        if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }else{
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }
            }
            break;
        }
        case 3:{//上新
            if (titleAry.count %2 == 0){
                if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                    _allianceLab.hidden = NO;
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.profitLab.attributedText = string;
                    }];
                }else{
                    _allianceLab.hidden = YES;
                    _profitLab.text = @"";
                }
                
                if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                    _promotionLab.layer.borderWidth = 1.0f;
                    _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                    _promotionLab.hidden = NO;
                }else{
                    _promotionLab.hidden = YES;
                }
                
                [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                
                _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                
                if ([logIn intValue] == 1) {
                    if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }else{
                    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                        weakSelf.priceLab.attributedText = string;
                    }];
                }
            }else{
                if (indexPath.row == titleAry.count) {
                    _allianceLab.hidden = YES;
                    _promotionLab.hidden = YES;
                    [_imageV st_setImageWithURLString:@""  placeholderImage:@""];
                    _nameLab.text = @"";
                    _numLab.text = @"";
                    _companyLab.text = @"";
                    _priceLab.text = @"";
                    _profitLab.text = @"";
                }else{
                    if ([[NSString stringWithFormat:@"%@",titleAry[indexPath.row][@"isKong"]] isEqualToString:@"True"] ) {
                        _allianceLab.hidden = NO;
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"毛利率:%d%%",[titleAry[indexPath.row][@"GrossMargin"] intValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.profitLab.attributedText = string;
                        }];
                    }else{
                        _allianceLab.hidden = YES;
                        _profitLab.text = @"";
                    }
                    
                    if ([titleAry[indexPath.row][@"IsSalesPromotion"] intValue] == 1) {
                        _promotionLab.layer.borderWidth = 1.0f;
                        _promotionLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                        _promotionLab.hidden = NO;
                    }else{
                        _promotionLab.hidden = YES;
                    }
                    
                    [_imageV st_setImageWithURLString:titleAry[indexPath.row][@"ImageUrl"]  placeholderImage:@"stance"];
                    
                    _nameLab.text = titleAry[indexPath.row][@"DrugsBase_DrugName"];
                    _numLab.text = titleAry[indexPath.row][@"DrugsBase_Specification"];
                    _companyLab.text = titleAry[indexPath.row][@"DrugsBase_Manufacturer"];
                    
                    if ([logIn intValue] == 1) {
                        if ([titleAry[indexPath.row][@"SpePrice"]floatValue] > 0) {
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"SpePrice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }else{
                            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"价格:¥%.2f",[titleAry[indexPath.row][@"shopprice"]floatValue]]type:0 andFinished:^(NSMutableAttributedString *string) {
                                weakSelf.priceLab.attributedText = string;
                            }];
                        }
                    }else{
                        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}] andChengeString:@"价格: 登录可见" type:0 andFinished:^(NSMutableAttributedString *string) {
                            weakSelf.priceLab.attributedText = string;
                        }];
                    }
                }
            }
            break;
        }
        default:
            break;
    }
}

@end
