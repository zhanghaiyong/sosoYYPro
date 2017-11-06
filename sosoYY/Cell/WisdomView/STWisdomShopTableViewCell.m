//
//  STWisdomShopTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/2/9.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomShopTableViewCell.h"

@implementation STWisdomShopTableViewCell
-(void)setWisdomShop:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath{
  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
     __weak STWisdomShopTableViewCell *weakSelf = self;
    
    _nameLab.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] DrugsBase_DrugName]];
    _standardLab.text = [arr[indexPath.row] DrugsBase_Specification];
    _companyLab.text = [arr[indexPath.row] DrugsBase_Manufacturer];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}]  andChengeString:[NSString stringWithFormat:@"库存:%@",[arr[indexPath.row] stock]] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.repertoryLab.attributedText = string;
    }];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"4"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}]  andChengeString:[NSString stringWithFormat:@"月销量:%@",[arr[indexPath.row] SalesVolume]] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.salesLab.attributedText = string;
    }];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"7"},@{@"color":RGB(119, 119, 119),@"font":@"14"}]  andChengeString:[NSString stringWithFormat:@"最近采购日期:%@",[arr[indexPath.row] LastTime]] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.dateLab.attributedText = string;
    }];
    
    //历史价格
    NSString *HistoryPrice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.row] HistoryPrice]floatValue]]];
//    CGFloat history = [HistoryPrice floatValue];
    
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"5"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}]  andChengeString:[NSString stringWithFormat:@"历史采购价:¥%@",HistoryPrice] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.historyLab.attributedText = string;
    }];
    
    
    _PriceLab.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.row] minPrice]floatValue]]]];
    
    //最小价格
    NSString *minStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.row] minPrice]floatValue]]];
    CGFloat minPrice = [minStr floatValue];
    
    //最大价格
    NSString *maxStr = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[arr[indexPath.row] maxPrice]floatValue]]];
    CGFloat maxPrice = [maxStr floatValue];
    
    if (minPrice == maxPrice) {
        _PriceLab.text = [NSString stringWithFormat:@"¥%@",minStr];
    }else if(maxPrice > minPrice){
         _PriceLab.text = [NSString stringWithFormat:@"¥%@-%@",minStr,maxStr];
    }else if (maxPrice == 0 && minPrice == 0){
        _PriceLab.hidden = YES;
    }
    

//    
//    if (minPrice == maxPrice) {
//        if (history < minPrice) {
//            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14",@"num":@"1"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"}]  andChengeString:[NSString stringWithFormat:@"¥%@",minStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                weakSelf.PriceLab.attributedText = string;
//            }];
//        }else{
//            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"14"}]  andChengeString:[NSString stringWithFormat:@"¥%@",minStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                weakSelf.PriceLab.attributedText = string;
//            }];
//        }
//    }else{
//        if (history > minPrice) {
//            if (history > maxPrice) {
//                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                    weakSelf.PriceLab.attributedText = string;
//                }];
//            }else if (history == maxPrice){
//                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                    weakSelf.PriceLab.attributedText = string;
//                }];
//            }else if (history < maxPrice){
//                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                    weakSelf.PriceLab.attributedText = string;
//                }];
//            }
//        }else if (history == minPrice){
//            if (history > maxPrice) {
//                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                    weakSelf.PriceLab.attributedText = string;
//                }];
//            }else if (history == maxPrice){
//                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                    weakSelf.PriceLab.attributedText = string;
//                }];
//            }else if (history < maxPrice){
//                [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":@"1"},@{@"color":RGB(0, 154, 52),@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                    weakSelf.PriceLab.attributedText = string;
//                }];
//            }
//        }else if (history < minPrice){
//            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14",@"num":@"1"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)minStr.length]},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14",@"num":[NSString stringWithFormat:@"%lu",(unsigned long)maxStr.length + 1]}]  andChengeString:[NSString stringWithFormat:@"¥%@-%@",minStr ,maxStr] type:1 andFinished:^(NSMutableAttributedString *string) {
//                weakSelf.PriceLab.attributedText = string;
//            }];
//        }
//    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)planSelect:(UIButton *)sender {
    STWisdomShopTableViewCell *cell = (STWisdomShopTableViewCell *)[[sender superview]superview];
    if (_delegate && [_delegate respondsToSelector:@selector(g_setPlanSelect:)]) {
        [_delegate g_setPlanSelect:cell];
    }
}

@end
