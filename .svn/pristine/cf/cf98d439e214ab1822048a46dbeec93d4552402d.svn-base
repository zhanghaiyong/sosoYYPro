//
//  STPaymentDetailsTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STPaymentDetailsTableViewCell.h"

@implementation STPaymentDetailsTableViewCell
-(void)setPaymentDetails:(STPaymentDetailsEntity *)entity indexPath:(NSIndexPath *)indexPath oderType:(NSInteger)oderType{
    
    _imgV.layer.borderColor = [UIColor fromHexValue:0xe5e5e5].CGColor;
    _imgV.layer.borderWidth = 1.0f;
    
    _addLab.layer.borderColor = [UIColor fromHexValue:0xea5413].CGColor;
    _addLab.layer.borderWidth = 1.0f;
    _addLab.layer.masksToBounds = YES;
    _addLab.layer.cornerRadius = 3.0f;
    _addLab.hidden = YES;
    
    [_imgV st_setImageWithURLString:entity.SmallImageUrl placeholderImage:@"stance"];
    
    _nameLab.text = entity.PName;
    
    _standardLab.text = entity.DrugsBase_Specification;
    
    _companyLab.text = entity.DrugsBase_Manufacturer;
    
    _numLab.text = [NSString stringWithFormat:@"x%@",entity.BuyCount];
    
    _jiantouImgV.hidden = YES;
    
    _oldLab.text = [NSString stringWithFormat:@"¥%.2f",[entity.ShopPrice floatValue]];
    
    if ([entity.IsSpePrice intValue] == 1) {//特价
        
        _oldLab.text = [NSString stringWithFormat:@"¥%.2f",[entity.DiscountPrice floatValue]];
        
        _priceLab.text = [NSString stringWithFormat:@"¥%.2f",[entity.ShopPrice floatValue]];
        
        CGSize contentSize = [_oldLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        CGSize spepriceSize = [_priceLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        _oldLab.frame = CGRectMake(kScreenWidth - 8 - contentSize.width, 30, contentSize.width, 20);
        
        _priceLab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width - contentSize.width - 6, 30, spepriceSize.width, 20);
        
        _linelab.frame = CGRectMake(kScreenWidth - 8 - spepriceSize.width  - contentSize.width - 4 , 40, spepriceSize.width, 1);
        
    }else{
        CGSize contentSize = [_oldLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        _oldLab.frame = CGRectMake(kScreenWidth - 8 - contentSize.width, 30, contentSize.width, 20);
        
        _oldLab.textColor = [UIColor fromHexValue:0x555555];
        
        _priceLab.hidden = YES;
        _linelab.hidden = YES;
    }
    
    _bottmLine.frame = CGRectMake(0, 89, kScreenWidth, .5);
    
    if ([entity.IsAddPriceBuy intValue] == 1) {
        _bottmLine.hidden = YES;
    }
    
    if ([entity.IsAddPriceBuy intValue] == 2) {//加价购
        
        _jiantouImgV.hidden = NO;
        _addLab.hidden = NO;
        _addLab.font = [UIFont systemFontOfSize:12];
        _priceLab.hidden = YES;
        _linelab.hidden = YES;
        _oldLab.hidden = YES;
        
        [_imgV st_setImageWithURLString:entity.secondimage placeholderImage:@"stance"];
        
        _nameLab.text = entity.secondDrugsBase_DrugName;
        
        _numLab.text = [NSString stringWithFormat:@"x%@",entity.SecondNum];
        
        _standardLab.text = [NSString stringWithFormat:@"%@|%@",entity.secondDrugsBase_Specification,entity.secondDrugsBase_Manufacturer];
        
        _standardLab.frame = CGRectMake(78, 35, kScreenWidth - 90, 20);
        
        //满
        if (entity.addPriceType.integerValue == 0) {
            
            _companyLab.text = [NSString stringWithFormat:@"加价¥%.2f换购%@%@",[entity.addPrice floatValue],entity.secondProudctNum,entity.secondGoods_Unit];
        //每满
        }else {
           
            float price = [entity.addPrice floatValue]*[entity.SecondNum floatValue]/entity.secondProudctNum.integerValue;
            _companyLab.text = [NSString stringWithFormat:@"加价¥%.2f换购%@%@",price,[NSString stringWithFormat:@"%@",entity.SecondNum],entity.secondGoods_Unit];
        }
        
//        if (entity.firstpid.integerValue == entity.secondpid.integerValue) {
//            
//            if (entity.addPriceType.integerValue == 0) {
//                
//                _companyLab.text = [NSString stringWithFormat:@"满%zi%@另加%.2f元换购本商品%zi%@",entity.firstProudctStartNum.integerValue,entity.secondGoods_Unit,entity.addPrice.floatValue,entity.secondProudctNum.integerValue,entity.secondGoods_Unit];
//            }else{
//                
//                _companyLab.text = [NSString stringWithFormat:@"每满%zi%@另加%.2f元换购本商品%zi%@",entity.firstProudctPerNum.integerValue,entity.secondGoods_Unit,entity.addPrice.floatValue,entity.secondProudctNum.integerValue,entity.secondGoods_Unit];
//            }
//        }else{
//            
//            if (entity.addPriceType.integerValue == 0) {
//                _companyLab.text = [NSString stringWithFormat:@"满%zi%@另加%.2f元换购其他商品%zi%@",entity.firstProudctStartNum.integerValue,entity.secondGoods_Unit,entity.addPrice.floatValue,entity.secondProudctNum.integerValue,entity.secondGoods_Unit];
//            }else{
//                _companyLab.text = [NSString stringWithFormat:@"每满%zi%@另加%.2f元换购其他商品%zi%@",entity.firstProudctPerNum.integerValue,entity.secondGoods_Unit,entity.addPrice.floatValue,entity.secondProudctNum.integerValue,entity.secondGoods_Unit];
//            }
//        }
        
    }else{
        _nameLab.frame = CGRectMake(78, 14, 188, 20);
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
