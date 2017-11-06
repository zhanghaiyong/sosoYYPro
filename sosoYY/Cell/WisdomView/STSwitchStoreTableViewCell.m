//
//  STSwitchStoreTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/7/10.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STSwitchStoreTableViewCell.h"

@implementation STSwitchStoreTableViewCell
-(void)setSwitchStore:(NSMutableArray *)dataAry indexPath:(NSIndexPath *)indexPath title:(NSString *)title selectAry:(NSMutableArray *)selectAry{
    
    __weak STSwitchStoreTableViewCell *weakSelf = self;
    
    _lousImg.hidden = ([[dataAry[indexPath.row] islous] integerValue] == 1) ? NO : YES;
    
    if ([[dataAry[indexPath.row] islous] integerValue] == 1) {
        
        _lousImg.hidden = NO;
        _nameLab.frame = CGRectMake(115, 5, _nameLab.frame.size.width, _nameLab.frame.size.height);
    }else {
        _lousImg.hidden = YES;
        _nameLab.frame = CGRectMake(70, 5, _nameLab.frame.size.width, _nameLab.frame.size.height);
    }
    
    _deliveryLab.layer.masksToBounds = YES;
    _deliveryLab.layer.borderColor = [UIColor fromHexValue:0x4DB762 alpha:1].CGColor;
    _deliveryLab.layer.borderWidth = .5;
    
    _PackageLab.layer.masksToBounds = YES;
    _PackageLab.layer.borderColor = [UIColor fromHexValue:0x009FF9 alpha:1].CGColor;
    _PackageLab.layer.borderWidth = .5;
    
    _invoiceLab.layer.masksToBounds = YES;
    _invoiceLab.layer.borderColor = [UIColor fromHexValue:0xFFA72D alpha:1].CGColor;
    _invoiceLab.layer.borderWidth = .5;
    
    _lineLab.frame = CGRectMake(0, 109.5, kScreenWidth, .5);
    _duanLine.frame = CGRectMake(15, 80, kScreenWidth - 15, .5);
    
    NSString *storeName = [NSString stringWithFormat:@"%@", [dataAry[indexPath.row] storeName]];
    NSString *storeNameLength = [NSString stringWithFormat:@"%zi",storeName.length];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"15",@"num":storeNameLength},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"10"}]  andChengeString:[NSString stringWithFormat:@"%@%@",[dataAry[indexPath.row] storeName],[dataAry[indexPath.row] enterpriseName]] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.nameLab.attributedText = string;
    }];
    
    
    _deliveryLab.text = [NSString stringWithFormat:@"满%@发货",[dataAry[indexPath.row] lowestdeliveryAmount]];
    
    _PackageLab.text = [NSString stringWithFormat:@"满%@包邮",[dataAry[indexPath.row] lowestFreeShippingAmount]];
    
    
    if (![[dataAry[indexPath.row] sxrq] isEqualToString:@""]) {
        
        NSString *numStr = [NSString stringWithFormat:@"最小购买数:%@ 库存:%@ 效期:%@",[dataAry[indexPath.row] MinBuyNum],[dataAry[indexPath.row] Stock],[dataAry[indexPath.row] sxrq]];
        
        NSString *numStr2 = [NSString stringWithFormat:@"效期:%@",[dataAry[indexPath.row] sxrq]];
        
        NSString *LengthStr = [NSString stringWithFormat:@"%zi",numStr.length - numStr2.length];
        
        if (![[STCommon sharedSTSTCommon] setIntervalSinceNow:[dataAry[indexPath.row] sxrq]]) {
            
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":LengthStr},@{@"color":RGB(241, 77, 67),@"font":@"12"}]  andChengeString: numStr type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.numLab.attributedText = string;
            }];
        }else{
            
            _numLab.text = [NSString stringWithFormat:@"最小购买数:%@ 库存:%@ 效期:%@",[dataAry[indexPath.row] MinBuyNum],[dataAry[indexPath.row] Stock],[dataAry[indexPath.row] sxrq]];
        }
        
    }else{
        if ([dataAry[indexPath.row] IsJxq].intValue != 0) {
            
            NSString *numStr = [NSString stringWithFormat:@"最小购买数:%@ 库存:%@ 近效期",[dataAry[indexPath.row] MinBuyNum],[dataAry[indexPath.row] Stock]];
            
            NSString *numStr2 = @"近效期";
            
            NSString *LengthStr = [NSString stringWithFormat:@"%zi",numStr.length - numStr2.length];
           
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":LengthStr},@{@"color":RGB(241, 77, 67),@"font":@"12"}]  andChengeString: numStr type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.numLab.attributedText = string;
            }];
        }else{
            _numLab.text = [NSString stringWithFormat:@"最小购买数:%@ 库存:%@ 效期:---",[dataAry[indexPath.row] MinBuyNum],[dataAry[indexPath.row] Stock]];
        }
    }
    
    NSString *info = [NSString stringWithFormat:@"%@", [dataAry[indexPath.row] info]];
    NSString *infoLength = nil;
    
    if ([info containsString:@"达到包邮金额"]) {
        self.logoLab.text = @"包邮";
        self.logoLab.backgroundColor = RGB(77, 183, 98);
        infoLength = [NSString stringWithFormat:@"%zi",info.length - 14];

        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":@"5"},@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":infoLength},@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12"}]  andChengeString:info type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.infoLab.attributedText = string;
        }];

    }else if ([info containsString:@"还差包邮"]) {
    
        NSString *showInfo = [info stringByReplacingOccurrencesOfString:@"包邮" withString:@""];
        infoLength = [NSString stringWithFormat:@"%zi",showInfo.length - 2];
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":@"2"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":infoLength}]  andChengeString:showInfo type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.infoLab.attributedText = string;
        }];
        weakSelf.logoLab.hidden = NO;
        self.logoLab.text = @"包邮";
        self.logoLab.backgroundColor = [UIColor fromHexValue:0xFFA800];
        
    }else if ([info containsString:@"还差发货"]) {
        NSString *showInfo = [info stringByReplacingOccurrencesOfString:@"发货" withString:@""];
        infoLength = [NSString stringWithFormat:@"%zi",showInfo.length - 2];
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":@"2"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":infoLength}]  andChengeString:showInfo type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.infoLab.attributedText = string;
        }];
        weakSelf.logoLab.hidden = NO;
        self.logoLab.text = @"起发";
        self.logoLab.backgroundColor = [UIColor fromHexValue:0xFF3333];
    }
    
//    if ([info rangeOfString:@"还差"].location != NSNotFound) {
//        
//        infoLength = [NSString stringWithFormat:@"%zi",info.length - 10];
//        
//        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":@"2"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":infoLength},@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12"}]  andChengeString:info type:1 andFinished:^(NSMutableAttributedString *string) {
//            weakSelf.infoLab.attributedText = string;
//        }];
//        
//    }else{
//        
//        infoLength = [NSString stringWithFormat:@"%zi",info.length - 14];
//        
//        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12",@"num":@"5"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12",@"num":infoLength},@{@"color":[UIColor fromHexValue:0x999999 alpha:1],@"font":@"12"}]  andChengeString:info type:1 andFinished:^(NSMutableAttributedString *string) {
//            weakSelf.infoLab.attributedText = string;
//        }];
//    }
    
    
    switch ([[dataAry[indexPath.row] tax_policy] integerValue]) {
        case 0:
            _invoiceLab.text = @"货票同行";
            break;
        case 1:
            _invoiceLab.text = @"下批开票";
            break;
        case 2:
            _invoiceLab.text = @"月底开票";
            break;
        case 3:
            _invoiceLab.text = @"电子发票";
            break;
            
        default:
            break;
    }
    
    if ([[dataAry[indexPath.row] speprice] floatValue] != 0) {
        
        _priceLab.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataAry[indexPath.row] speprice] floatValue]]]];
        
        _oldPriceLab.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataAry[indexPath.row] price] floatValue]]]];
        
        CGSize oldPriceSize = [_oldPriceLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
        _oldLine.frame = CGRectMake(12 + (50 - oldPriceSize.width)/2 , 46, oldPriceSize.width , 0.8);
        
        if ([[dataAry[indexPath.row] limittype] intValue] != 0) {
            
            _addPriceLab.backgroundColor = [UIColor fromHexValue:0xFF4444];
            _addPriceLab.text = @"特价限购";
            
        }else{
            _addPriceLab.backgroundColor = [UIColor fromHexValue:0xFF0000];
            _addPriceLab.text = @"特价";
            
        }
    }else{
        _oldPriceLab.hidden = YES;
        
        _oldLine.hidden = YES;
        
        _priceLab.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[[dataAry[indexPath.row] price] floatValue]]]];
        
        _priceLab.frame = CGRectMake(12, 30, 50, 20);
        
        if ([[dataAry[indexPath.row] PromotionTypes] intValue] == 1) {
            
            _priceLab.frame = CGRectMake(12, 50, 50, 20);
            _addPriceLab.text = @"加价购";
            _addPriceLab.backgroundColor = [UIColor fromHexValue:0xEA5413];
            
        }else{
            
            _addPriceLab.hidden = YES;
            
        }
    }
    
    if ([selectAry[indexPath.row]integerValue] == 1) {
        
        _selecrtImgV.image = [UIImage imageNamed:@"选中"];
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _duanLine.backgroundColor = [UIColor fromHexValue:0xe5e5e5];
    }else{
        
        _selecrtImgV.image = [UIImage imageNamed:@"未选中"];
    }
    
    NSString *surplusmoney = [NSString stringWithFormat:@"%.2f",[[dataAry[indexPath.row] surplusmoney] floatValue]];
    
    if (surplusmoney.floatValue > 0) {
        
        _dianLab.hidden = NO;
    }else{
        
        _dianLab.hidden = YES;
    }
    
    if (dataAry.count == 1) {
        
        _lineLab.hidden = YES;
    }else if (dataAry.count - 1 == indexPath.row){
        
        _lineLab.hidden = YES;
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
