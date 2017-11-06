//
//  WisdomCell.m
//  sosoYY
//
//  Created by zhy on 17/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "WisdomCell.h"
#import "WisdomChangeCountParams.h"
#import "STWisdomCollectionView.h"
#import "purchasetSpecialPricePromotionsModel.h"
#import "PurchasetAddPricePromotionsModel.h"
@interface WisdomCell ()
{
    __block BOOL Remainder;
    __block BOOL JZRemainder;
}
@property (nonatomic,strong)WisdomChangeCountParams *changeCountP;
@end

@implementation WisdomCell

-(void)setSelectNumOflist:(NSString *)selectNumOflist {
    
    _selectNumOflist = selectNumOflist;
    
    double count = [selectNumOflist doubleValue];
    
    [self InputJudge:count];
}

//修改数量
-(WisdomChangeCountParams *)changeCountP {
    
    if (_changeCountP == nil) {
        
        self.changeCountP = [[WisdomChangeCountParams alloc]init];
        
    }
    return _changeCountP;
}

-(void)setGoodModel:(LiModel *)goodModel {
    
    _goodModel = goodModel;
    self.changeCountP.pid = [NSString stringWithFormat:@"%@",goodModel.pid];
    
    //是加价购，并且选择了加价购商品
    if ([goodModel.PromotionTypes integerValue] == 1 && [goodModel.pmid integerValue] > 0) {
        
        for (PurchasetAddPricePromotionsModel *model in goodModel.purchasetAddPricePromotionsList) {
            
            //选择的加价购商品
            if ([goodModel.pmid isEqual:model.pmid]) {
                
                self.exchangeGoodName.text = model.DrugsBase_DrugName;
                
                if (model.DrugsBase_Specification.length == 0) {
                    
                    self.exchangeProduceName.text = @"规格：---";
                }else {
                    
                    self.exchangeProduceName.text = model.DrugsBase_Specification;
                }
                self.exchangeGoodSPEC.text = model.DrugsBase_Manufacturer;
                
                if (![model.sxrq isEqualToString:@""]) {
                    
                    UIColor *timeColor = [Uitils setIntervalSinceNow:model.sxrq] ? [UIColor fromHexValue:0x777777] : RGB(241, 77, 67);
                    self.exchangeTime.textColor = timeColor;
                    
                    self.exchangeTime.text = [NSString stringWithFormat:@"效期 %@",model.sxrq];
                }else {
                    
                    if ([model.IsJxq isEqualToString:@"1"]) {
                        self.exchangeTime.text = @"近效期";
                        self.exchangeTime.textColor = RGB(241, 77, 67);
                    }else{
                        self.exchangeTime.text = @"效期:---";
                        self.exchangeTime.textColor = [UIColor fromHexValue:0x777777];
                    }
                }
                
                if ([model.addPriceType integerValue] == 0) {
                    
                    self.exchangeGoodCount.text = [NSString stringWithFormat:@"X%@",model.secondProudctNum];
                    
                }else if ([model.addPriceType integerValue] == 1){
                    
                    self.exchangeGoodCount.text = [NSString stringWithFormat:@"X%d",[model.secondProudctNum intValue]*(int)([goodModel.buyCount intValue]/[model.firstProudctPerNum intValue])];
                }
            }
            break;
        }
    }
    
    //是加价购，并且选择了加价购商品
    if ([goodModel.PromotionTypes integerValue] == 1 && [goodModel.pmid integerValue] > 0) {
        
        self.exchangeViewH.constant = 85;
        //        if ([goodModel.isSelect isEqualToString:@"1"]) {
        //            self.exchangeBtn.hidden = NO;
        //        }else {
        //            self.exchangeBtn.hidden = YES;
        //        }
    }else {
        
        self.exchangeViewH.constant = 0;
    }
    
    [STCommon isRemainderD1:goodModel.buyCount.doubleValue withD2:goodModel.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {
        
        Remainder = isRemainder;
    }];
    
    [STCommon isRemainderD1:goodModel.buyCount.doubleValue withD2:goodModel.Product_Pcs.doubleValue Block:^(BOOL isRemainder, int multiple) {
        
        JZRemainder = isRemainder;
    }];
    
    //购买数低于最低购买数 || 购买数超出库存
    if ([goodModel.buyCount doubleValue] < [goodModel.minBuy doubleValue] || ([goodModel.buyCount doubleValue] > [goodModel.stock doubleValue] && [goodModel.stock doubleValue] > 0) || ([goodModel.sellType doubleValue] == 2 && [goodModel.Product_Pcs_Small doubleValue] > 0 && !Remainder) || [goodModel.stock doubleValue] == 0) {
        
        self.otherAlertLabelH.constant = 30;
        [self.countButton setTitleColor:[UIColor fromHexValue:0xCCCCCC] forState:UIControlStateNormal];
        self.flagLabelW.constant = 0;
        self.exchangeBtnW.constant = 0;
        self.Good__Price.hidden = YES;
        self.middleLine.hidden = YES;
        
        //超出库存
        if ([goodModel.buyCount doubleValue] > [goodModel.stock doubleValue]) {
            
            self.otherAlertLabel.text = [NSString stringWithFormat:@"采购数量超库存,最大可采购数量为%@%@",[STCommon setHasSuffix:goodModel.stock],goodModel.Goods_Unit];
            //不满最低采购
        }else if ([goodModel.buyCount doubleValue] < [goodModel.minBuy doubleValue]) {
            
            self.otherAlertLabel.text = [NSString stringWithFormat:@"不满最低采购数量，最低采购数量为%@%@",[STCommon setHasSuffix:goodModel.minBuy],goodModel.Goods_Unit];
            
            //输入的不是中包装的倍数
        }else if ([goodModel.sellType doubleValue] == 2 && !Remainder) {
            
            self.otherAlertLabel.text = [NSString stringWithFormat:@"不满中包装【%@】的整数倍",[STCommon setHasSuffix:goodModel.Product_Pcs_Small]];
            //输入的不是件装的倍数
        }else if ([goodModel.sellType doubleValue] == 3 && !JZRemainder) {
            
            self.otherAlertLabel.text = [NSString stringWithFormat:@"不满件装【%@】的整数倍",[STCommon setHasSuffix:goodModel.Product_Pcs_Small]];
        }
        
    }else {
        
        self.otherAlertLabelH.constant = 0;
        
        if ([goodModel.sellType doubleValue] == 2 && !Remainder && [goodModel.Product_Pcs_Small  doubleValue] != 0) {
            [self.countButton setTitleColor:[UIColor fromHexValue:0xCCCCCC] forState:UIControlStateNormal];
        }else {
            [self.countButton setTitleColor:[UIColor fromHexValue:0x555555] forState:UIControlStateNormal];
        }
        
        //原价计算
        self.GoodPrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:goodModel.Price]];
        self.Good__Price.hidden = YES;
        self.middleLine.hidden = YES;
    }
    
    //特价商品
    if ([goodModel.PricePromotionsTypes integerValue] == 1) {
        
        self.exchangeBtnW.constant = 0;
        
        purchasetSpecialPricePromotionsModel *purchasetSpecialPricePromotions = goodModel.purchasetSpecialPricePromotions;
        
        switch ([purchasetSpecialPricePromotions.limittype integerValue]) {
            case 0: //不限购
                
                if ([goodModel.PromotionTypes integerValue] == 0) {
                    self.AlertH.constant = 0;
                }
                
                self.sprcialIdentyW.constant = 30;
                
                self.middleLine.hidden = NO;
                self.Good__Price.hidden = NO;
                //原价
                self.Good__Price.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:purchasetSpecialPricePromotions.shopprice]];
                //特价
                self.GoodPrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:purchasetSpecialPricePromotions.speprice]];
                break;
                
            case 1: //每人限购
                
                self.AlertH.constant = 30;
                self.sprcialIdentyW.constant = 0;
                self.flagLabelW.constant = 58;
                self.flagLabel.text = @"特价限购";
                self.flagLabel.backgroundColor = [UIColor fromHexValue:0xFF4444];
                self.flagLabel.textColor = [UIColor whiteColor];
                
                //超过了限购的数量，按照原价出售 按照原价处理
                if ([purchasetSpecialPricePromotions.limitnumber integerValue] - [purchasetSpecialPricePromotions.TotalNumber integerValue] < [goodModel.buyCount integerValue]) {
                    
                    self.AlertLabel.textColor = [UIColor fromHexValue:0xFF3333];
                    self.AlertLabel.text = [NSString stringWithFormat:@"超出限购数量%@，将按原价结算",[STCommon setHasSuffix:purchasetSpecialPricePromotions.limitnumber]];
                    
                    self.Good__Price.hidden = YES;
                    self.middleLine.hidden = YES;
                    //原价计算
                    self.GoodPrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:goodModel.Price]];
                }else {
                    
                    self.AlertLabel.text = [NSString stringWithFormat:@"购买1-%@%@时享受优惠，超出数量以结算价为准",[STCommon setHasSuffix:purchasetSpecialPricePromotions.limitnumber],goodModel.Goods_Unit];
                    
                    self.middleLine.hidden = NO;
                    self.Good__Price.hidden = NO;
                    self.AlertLabel.textColor = [UIColor fromHexValue:0x777777];
                    //原价
                    self.Good__Price.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:purchasetSpecialPricePromotions.shopprice]];
                    
                    //特价
                    self.GoodPrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:purchasetSpecialPricePromotions.speprice]];
                }
                
                break;
                
            case 2: //每人每天限购
                
                self.AlertH.constant = 30;
                self.sprcialIdentyW.constant = 0;
                self.flagLabelW.constant = 58;
                self.flagLabel.text = @"特价限购";
                self.flagLabel.backgroundColor = [UIColor fromHexValue:0xFF4444];
                self.flagLabel.textColor = [UIColor whiteColor];
                
                //超过了限购的数量，按照原价出售
                if ([purchasetSpecialPricePromotions.limitnumber integerValue] - [purchasetSpecialPricePromotions.TodayNumber integerValue] < [goodModel.buyCount integerValue]) {
                    
                    self.AlertLabel.textColor = [UIColor fromHexValue:0xFF3333];
                    self.AlertLabel.text = [NSString stringWithFormat:@"超出限购数量%@，将按原价结算",[STCommon setHasSuffix:purchasetSpecialPricePromotions.limitnumber]];
                    
                    //原价计算
                    self.GoodPrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:goodModel.Price]];
                    self.Good__Price.hidden = YES;
                    self.middleLine.hidden = YES;
                    
                }else {
                    
                    self.AlertLabel.textColor = [UIColor fromHexValue:0x777777];
                    self.AlertLabel.text = [NSString stringWithFormat:@"购买1-%@%@时享受优惠，超出数量以结算价为准",[STCommon setHasSuffix:purchasetSpecialPricePromotions.limitnumber],goodModel.Goods_Unit];
                    
                    //原价
                    self.Good__Price.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:purchasetSpecialPricePromotions.shopprice]];
                    self.Good__Price.hidden = NO;
                    self.middleLine.hidden = NO;
                    //特价
                    self.GoodPrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:purchasetSpecialPricePromotions.speprice]];
                }
                
                break;
                
            default:
                break;
        }
    }else {
        
        if ([goodModel.PromotionTypes integerValue] == 0) {
            
            self.AlertH.constant = 0;
        }
        self.sprcialIdentyW.constant = 0;
        //原价计算
        self.GoodPrice.text = [NSString stringWithFormat:@"¥%@",[STCommon setHasSuffix:goodModel.Price]];
        self.Good__Price.hidden = YES;
        self.middleLine.hidden = YES;
    }
    
    //加价购商品
    if ([goodModel.PromotionTypes integerValue] == 1) {
        
        self.AlertH.constant = 30;
        self.exchangeBtnW.constant = 55;
        self.flagLabelW.constant = 46;
        self.flagLabel.text = @"加价购";
        self.flagLabel.backgroundColor = [UIColor whiteColor];
        self.flagLabel.textColor = [UIColor fromHexValue:0xEA5413];
        self.flagLabel.layer.borderColor = [UIColor fromHexValue:0xEA5413].CGColor;
        
        self.AlertLabel.textColor = [UIColor fromHexValue:0x777777];
        PurchasetAddPricePromotionsModel *purchasetAddPricePromotions = goodModel.purchasetAddPricePromotionsList[0];
        
        switch ([purchasetAddPricePromotions.addPriceType integerValue]) {
            case 0: //满多少，不叠加
                
                
                if ([goodModel.isSelect isEqualToString:@"1"]) {
                    
                    //当前数量大于加价购的标准
                    if ([goodModel.buyCount doubleValue] >= [purchasetAddPricePromotions.firstProudctStartNum intValue]) {
                        
                        //加价购和商品一样
                        if ([goodModel.pid isEqual:purchasetAddPricePromotions.pid]) {
                            self.AlertLabel.text = [NSString stringWithFormat:@"已购满%@%@,加价%@元可换购本品%@%@",purchasetAddPricePromotions.firstProudctStartNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                            
                        }else { //赠品是其他商品
                            self.AlertLabel.text = [NSString stringWithFormat:@"已购满%@%@,加价%@元可换购指定商品%@%@",purchasetAddPricePromotions.firstProudctStartNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                        }
                        //当前数量小于加价购的标准
                    }else {
                        //加价购和商品一样
                        if ([goodModel.pid isEqual:purchasetAddPricePromotions.pid]) {
                            self.AlertLabel.text = [NSString stringWithFormat:@"购满%@%@,加价%@元可换购本品%@%@",purchasetAddPricePromotions.firstProudctStartNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                        }else {//赠品是其他商品
                            self.AlertLabel.text = [NSString stringWithFormat:@"购满%@%@,加价%@元可换购指定商品%@%@",purchasetAddPricePromotions.firstProudctStartNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                        }
                    }
                }else {
                    //加价购和商品一样
                    if ([goodModel.pid isEqual:purchasetAddPricePromotions.pid]) {
                        self.AlertLabel.text = [NSString stringWithFormat:@"购满%@%@,加价%@元可换购本品%@%@",purchasetAddPricePromotions.firstProudctStartNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                        
                    }else {//赠品是其他商品
                        
                        self.AlertLabel.text = [NSString stringWithFormat:@"购满%@%@,加价%@元可换购指定商品%@%@",purchasetAddPricePromotions.firstProudctStartNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                    }
                }
                
                break;
            case 1:
                
                if ([goodModel.pid isEqual:purchasetAddPricePromotions.pid]) {
                    self.AlertLabel.text = [NSString stringWithFormat:@"每购满%@%@,加价%@元可换购本品%@%@",purchasetAddPricePromotions.firstProudctPerNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                }else {
                    
                    self.AlertLabel.text = [NSString stringWithFormat:@"每购满%@%@,加价%@元可换购指定商品%@%@",purchasetAddPricePromotions.firstProudctPerNum,goodModel.Goods_Unit,purchasetAddPricePromotions.addPrice,purchasetAddPricePromotions.secondProudctNum,purchasetAddPricePromotions.Goods_Unit];
                }
                
                break;
                
            default:
                break;
        }
    }else {
        
        if ([goodModel.PricePromotionsTypes integerValue] == 0) {
            self.AlertH.constant = 0;
        }
    }
    
    self.GoodName.text = goodModel.DrugsBase_DrugName;
    
    NSString *stocks = [NSString stringWithFormat:@"库存 %@",[STCommon setHasSuffix:goodModel.stock]];
    NSString *stocklength = [NSString stringWithFormat:@"%zi",stocks.length-2];
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12",@"num":@"2"},@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12",@"num":stocklength}] andChengeString:stocks type:1 andFinished:^(NSMutableAttributedString *string) {
        self.stockLabel.attributedText = string;
    }];
    
    //判断是否是手动添加
    if ([goodModel.source integerValue] > 0) {
        
        self.MyViewH.constant = 0;
        self.handleAddW.constant = 55;
        
    }else {
        
        self.MyViewH.constant = 30;
        self.handleAddW.constant = 0;
        
        //月销售
        NSString *SalesVolumesStr = [NSString stringWithFormat:@"%@",[STCommon setHasSuffix:goodModel.SalesVolume]];
        NSString *SalesVolumeLength = [NSString stringWithFormat:@"%zi",SalesVolumesStr.length];
        //库存
        NSString *myStockStr = [NSString stringWithFormat:@"%@", [STCommon setHasSuffix:goodModel.myStock]];
        NSString *myStockStrLength = [NSString stringWithFormat:@"%zi",myStockStr.length];
        //参考价
        NSString *HistoryPricesStr = [NSString stringWithFormat:@"￥%@",[STCommon setHasSuffix:goodModel.HistoryPrice]];
        NSString *HistoryPricesStrLength = [NSString stringWithFormat:@"%zi",HistoryPricesStr.length];
        //最近采购时间
        NSString *LastTimesStr = [NSString stringWithFormat:@"%@",goodModel.LastTimeString.length > 0 ? ([goodModel.source integerValue] > 0 ? @"-----" :goodModel.LastTimeString) : @"-----"];
        NSString *LastTimesStrLength = [NSString stringWithFormat:@"%zi",LastTimesStr.length];
        
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":RGB(175, 175, 175),@"font":@"12",@"num":@"3"},
                                                            @{@"color":RGB(102, 102, 102),@"font":@"12",@"num":SalesVolumeLength},
                                                            @{@"color":RGB(175, 175, 175),@"font":@"12",@"num":@"4"},
                                                            @{@"color":RGB(102, 102, 102),@"font":@"12",@"num":myStockStrLength},
                                                            @{@"color":RGB(175, 175, 175),@"font":@"12",@"num":@"5"},
                                                            @{@"color":RGB(102, 102, 102),@"font":@"12",@"num":HistoryPricesStrLength},
                                                            @{@"color":RGB(175, 175, 175),@"font":@"12",@"num":@"6"},
                                                            @{@"color":RGB(102, 102, 102),@"font":@"12",@"num":LastTimesStrLength}]  andChengeString:[NSString stringWithFormat:@"月销:%@ 库存:%@ 参考价:%@ 最近采购:%@",SalesVolumesStr,myStockStr,HistoryPricesStr,LastTimesStr] type:1 andFinished:^(NSMutableAttributedString *string) {
                                                                self.SalesVolume.attributedText = string;
                                                            }];
        
        /*
         //我的库存
         NSString *stocks = [NSString stringWithFormat:@"库存 %@",[STCommon setHasSuffix:goodModel.myStock]];
         NSString *stocklength = [NSString stringWithFormat:@"%zi",stocks.length-2];
         [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12",@"num":@"2"},@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12",@"num":stocklength}] andChengeString:stocks type:1 andFinished:^(NSMutableAttributedString *string) {
         self.myStock.attributedText = string;
         }];
         
         //月销售
         NSString *SalesVolumes = [NSString stringWithFormat:@"月销 %@",[STCommon setHasSuffix:goodModel.SalesVolume]];
         NSString *SalesVolumelength = [NSString stringWithFormat:@"%zi",SalesVolumes.length-2];
         [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12",@"num":@"2"},@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12",@"num":SalesVolumelength}] andChengeString:SalesVolumes type:1 andFinished:^(NSMutableAttributedString *string) {
         self.SalesVolume.attributedText = string;
         }];
         
         //参考价
         NSString *HistoryPrices = [NSString stringWithFormat:@"参考价￥%@",[STCommon setHasSuffix:goodModel.HistoryPrice]];
         NSString *HistoryPriceslength = [NSString stringWithFormat:@"%zi",HistoryPrices.length-3];
         [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12",@"num":@"3"},@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12",@"num":HistoryPriceslength}] andChengeString:HistoryPrices type:1 andFinished:^(NSMutableAttributedString *string) {
         self.historyPrice.attributedText = string;
         }];
         
         //最近采购时间
         NSString *LastTimes = [NSString stringWithFormat:@"最近采购 %@",goodModel.LastTimeString.length > 0 ? goodModel.LastTimeString : @"-----"];
         NSString *LastTimeslength = [NSString stringWithFormat:@"%zi",LastTimes.length-4];
         [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12",@"num":LastTimeslength}] andChengeString:LastTimes type:1 andFinished:^(NSMutableAttributedString *string) {
         self.LastTime.attributedText = string;
         }];
         */
        
    }
    
    if ( goodModel.DrugsBase_Specification.length == 0) {
        
        self.GoodSPEC.text = [NSString stringWithFormat:@"规格：--- | %@",goodModel.DrugsBase_Manufacturer];
    }else {
        
        self.GoodSPEC.text = [NSString stringWithFormat:@"%@ | %@",goodModel.DrugsBase_Specification,goodModel.DrugsBase_Manufacturer];;
    }
    
    if (![goodModel.sxrq isEqualToString:@""]) {
        
        //大于一年
        if ([Uitils setIntervalSinceNow:goodModel.sxrq]) {
            
            NSString *LastTimes = [NSString stringWithFormat:@"效期 %@",goodModel.sxrq];
            NSString *LastTimeslength = [NSString stringWithFormat:@"%zi",LastTimes.length-2];
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"12",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12",@"num":LastTimeslength}] andChengeString:LastTimes type:1 andFinished:^(NSMutableAttributedString *string) {
                self.GoodTime.attributedText = string;
            }];
        }else {
            
            self.GoodTime.textColor = RGB(241, 77, 67);
            self.GoodTime.text = [NSString stringWithFormat:@"效期 %@",goodModel.sxrq];
        }
        
    }else {
        
        if ([goodModel.IsJxq isEqualToString:@"1"]) {
            self.GoodTime.text = @"近效期";
            self.GoodTime.textColor = RGB(241, 77, 67);
        }else{
            self.GoodTime.text = @"效期:---";
            self.GoodTime.textColor = [UIColor fromHexValue:0x777777];
        }
    }
    [self.countButton setTitle:[NSString stringWithFormat:@"%@",goodModel.buyCount] forState:UIControlStateNormal];
    
    self.selectBtn.selected = [goodModel.isSelect isEqualToString:@"1" ] ? YES : NO;
}

- (IBAction)CountAction:(id)sender {
    
    if (_showImportViewBlock) {
        _showImportViewBlock();
    }
}

- (IBAction)showCollectionAction:(id)sender {
    
    if (_showCollectionBlock) {
        _showCollectionBlock();
    }
}

//选择商品
- (IBAction)selectGoodAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.selected) {
        
        button.selected = NO;
    }else {
        
        button.selected = YES;
    }
    
    if (_selectGoodBlock) {
        _selectGoodBlock(button.selected);
    }
}

//去换购
-(IBAction)toExchangeAction:(id)sender {
    
    if (_showExchangeViewBlock) {
        _showExchangeViewBlock();
    }
}

- (void)InputJudge:(double)count {
    
    [STCommon isRemainderD1:count withD2:self.goodModel.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {
        
        Remainder = isRemainder;
    }];
    
    if (count > [self.goodModel.stock doubleValue]) {
        
        [self.countButton setTitle:[NSString stringWithFormat:@"%@",self.goodModel.buyCount] forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"库存紧张,最多只能采购%@%@哦",[STCommon setHasSuffix:self.goodModel.stock],self.goodModel.Goods_Unit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        //输入的不是中包装的倍数
    }else if ([self.goodModel.sellType doubleValue] == 2 && [self.goodModel.Product_Pcs_Small doubleValue] > 0 && !Remainder) {
        
        [self.countButton setTitle:[NSString stringWithFormat:@"%@",self.goodModel.buyCount] forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"购买数量必须是中包装【%@】的整数倍",[STCommon setHasSuffix:self.goodModel.Product_Pcs_Small]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }else if(count < [self.goodModel.minBuy doubleValue]){
        
        [self.countButton setTitle:[NSString stringWithFormat:@"%@",self.goodModel.buyCount] forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"不能低于最低采购数【%@】%@",[STCommon setHasSuffix:self.goodModel.minBuy],self.goodModel.Goods_Unit] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else {
        
        if (_WisdomAdd_reduceBlock) {
            
            _WisdomAdd_reduceBlock(count);
        }
        self.changeCountP.num = [NSString stringWithFormat:@"%.f",count];
        [self changeCount];
    }
}

//修改数量
- (void)changeCount {
    
    FxLog(@"changeCount = %@",self.changeCountP.mj_keyValues);
    
    [KSMNetworkRequest getRequest:requestWisdomChangeGoodsCount params:self.changeCountP.mj_keyValues success:^(id responseObj) {
        FxLog(@"changeCount = %@",responseObj);
        
    } failure:^(NSError *error) {
        
        FxLog(@"changeCount = %@",error.description);
    }];
}

@end