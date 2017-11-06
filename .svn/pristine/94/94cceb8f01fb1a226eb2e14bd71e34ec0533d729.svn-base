//
//  STWisdomAddSwapBuyView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/6.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomAddSwapBuyView.h"

@interface STWisdomAddSwapBuyView ()
@property(strong,nonatomic)STStorewideEntity *neweEntity;
@end

@implementation STWisdomAddSwapBuyView

-(void)setWisdomAddSwapBuy:(STStorewideEntity *)entity{
    _neweEntity = entity;
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.0f;
    
    __weak STWisdomAddSwapBuyView *weakSelf = self;
    
    _imageV.userInteractionEnabled = YES;
        [_imageV st_setImageWithURLString:entity.AddPriceBuy[@"secondimage"] placeholderImage:@"stance"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setToDetails)];
    [_imageV addGestureRecognizer:tap];
    
    if ([[[STCommon sharedSTSTCommon] setWhetherStringEmpty:entity.AddPriceBuy[@"secondDrugsBase_ProName"]] isEqualToString:@""]) {
        _nameLab.text = entity.AddPriceBuy[@"secondDrugsBase_DrugName"];
    }else{
        if (![[[STCommon sharedSTSTCommon] setWhetherStringEmpty:entity.AddPriceBuy[@"secondDrugsBase_ProName"]] isEqualToString:@""]) {
            _nameLab.text = [NSString stringWithFormat:@"%@(%@)",entity.AddPriceBuy[@"secondDrugsBase_DrugName"],entity.AddPriceBuy[@"secondDrugsBase_ProName"]];
        }else{
            _nameLab.text = entity.AddPriceBuy[@"secondDrugsBase_ProName"];
        }
    }
    
    _nameLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setToDetails)];
    [_nameLab addGestureRecognizer:tap2];
    _companyLab.text = entity.AddPriceBuy[@"secondDrugsBase_Manufacturer"];
    
    
    if (![entity.AddPriceBuy[@"secondsxrq"] isEqualToString:@""]) {
        _dateLab.text = [NSString stringWithFormat:@"效期:%@",entity.AddPriceBuy[@"secondsxrq"]];
        if (![[STCommon sharedSTSTCommon] setIntervalSinceNow:entity.AddPriceBuy[@"secondsxrq"]]) {
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(119, 119, 119),@"font":@"12",@"num":@"3"},@{@"color":RGB(241, 77, 67),@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"效期:%@",entity.AddPriceBuy[@"secondsxrq"]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.dateLab.attributedText = string;
            }];
        }
    }else{
        if ([entity.AddPriceBuy[@"SecondIsJxq"] intValue] != 0) {
            _dateLab.text = @"近效期";
            _dateLab.textColor = RGB(241, 77, 67);
        }else{
            _dateLab.text = @"效期:---";
        }
    }
    
    _numLab.text = entity.AddPriceBuy[@"secondDrugsBase_Specification"];
    
        if ([entity.AddPriceBuy[@"secondisHighMargin"] intValue] == 0) {
            _allianceLab.hidden = YES;
        }else{
            _allianceLab.text = @"首推联盟";
        }
    
    
    
    NSString *secondshopprice = [STCommon setHasSuffix:[NSString stringWithFormat:@"%.2f",[entity.AddPriceBuy[@"secondshopprice"] floatValue]]];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"14"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"¥%@",secondshopprice] type:0 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.priceLab.attributedText = string;
    }];
   
}
- (IBAction)deleteSelectBtn:(UIButton *)sender {
    if (_WisdomAddSwapBuyBlock) {
        _WisdomAddSwapBuyBlock();
    }
}
-(void)setToDetails{
//    if (_setToDetailsBlock) {
//        _setToDetailsBlock(_neweEntity.AddPriceBuy[@"secondpid"]);
//    }
}
@end
