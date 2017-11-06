//
//  ImportView.m
//  sosoYY
//
//  Created by zhy on 2017/5/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "ImportView.h"
#import "WisdomChangeCountParams.h"

@interface ImportView ()

@property (nonatomic,strong)WisdomChangeCountParams *changeCountP;

@end

@implementation ImportView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.countTF.delegate = self;
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
    
    self.contentLabel.text = [NSString stringWithFormat:@"最小采购数:%@,库存:%@",goodModel.minBuy,goodModel.stock];
    self.countTF.text = [NSString stringWithFormat:@"%@",goodModel.buyCount];
    self.changeCountP.pid = [NSString stringWithFormat:@"%@",goodModel.pid];
}


- (IBAction)reduceAction:(id)sender {
    
    double count = [self.countTF.text doubleValue];
    
    switch ([self.goodModel.sellType intValue]) {
        case 1:
            
            count -= 1;
            if (count < [self.goodModel.minBuy doubleValue]) {
                
                count = [self.goodModel.minBuy doubleValue];
                [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"不能低于最低采购数【%@】%@",[STCommon setHasSuffix:self.goodModel.minBuy],self.goodModel.Goods_Unit]];
            }
            //大于库存
            if (count > [self.goodModel.stock doubleValue]) {
                
                count = [self.goodModel.stock doubleValue];
                [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"库存紧张,最大可采购数量%@%@哦",[STCommon setHasSuffix:self.goodModel.stock],self.goodModel.Goods_Unit]];
            }
            
            break;
        case 2:
            
            if ([self.goodModel.Product_Pcs_Small doubleValue] > 0) {
                
                count -= [self.goodModel.Product_Pcs_Small doubleValue];
            }else {
                
                count -= 1;
            }
            
            if (count < [self.goodModel.Product_Pcs_Small doubleValue] && count < [self.goodModel.minBuy doubleValue]) {
                
                count = [self.goodModel.Product_Pcs_Small doubleValue];
                
                [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"不能低于最低采购数【%@】%@",[STCommon setHasSuffix:self.goodModel.minBuy],self.goodModel.Goods_Unit]];
                
            }
            break;
            
        case 3:
            
            count -= [self.goodModel.Product_Pcs intValue];
            if (count < [self.goodModel.Product_Pcs intValue] && count < [self.goodModel.minBuy intValue]) {
                
                count += [self.goodModel.Product_Pcs doubleValue];
                
                [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"不能低于最低采购数【%@】%@",[STCommon setHasSuffix:self.goodModel.minBuy],self.goodModel.Goods_Unit]];
            }
            
            break;
            
        default:
            break;
    }
    
    self.countTF.text = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];
    self.changeCountP.num = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];

}

- (IBAction)cancleAction:(id)sender {
    
    if (_deleteImportBlock) {
        _deleteImportBlock();
    }
}

- (IBAction)sureAction:(id)sender {
    
    if ([self InputJudge:self.countTF.text.doubleValue]) {
        
        [self changeCount];
        
        [self.countTF resignFirstResponder];
    }else {
    
        [self.countTF resignFirstResponder];
    }
}

- (IBAction)addAction:(id)sender {
    
    __block double count = [self.countTF.text doubleValue];
    
    switch ([self.goodModel.sellType intValue]) {
        case 1:
            
            count += 1;
            
            break;
        case 2:
            
            if ([self.goodModel.Product_Pcs_Small doubleValue] > 0) {
                
                count += [self.goodModel.Product_Pcs_Small doubleValue];
                
                //计算是不是中包装的倍数
                [STCommon isRemainderD1:count withD2:self.goodModel.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {
                    
                    if (!isRemainder) {
                        
                        count = multiple*[self.goodModel.Product_Pcs_Small doubleValue];
                    }
                }];
                
            }else {
                
                count += 1;
            }
            
            break;
            
        case 3:
            

            if ([self.goodModel.Product_Pcs doubleValue] > 0) {
                
                count += [self.goodModel.Product_Pcs doubleValue];
                
                //计算是不是件装的倍数
                [STCommon isRemainderD1:count withD2:self.goodModel.Product_Pcs.doubleValue Block:^(BOOL isRemainder, int multiple) {
                    
                    if (!isRemainder) {
                        
                        count = multiple*[self.goodModel.Product_Pcs doubleValue];
                    }
                }];
                
            }else {
                
                count += 1;
            }
            
            break;
            
        default:
            break;
    }
    
    count = [self add_repeatCount:count];
    
    self.countTF.text = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];
    
    self.changeCountP.num = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];
    
}

- (double)add_repeatCount:(double)count {
    
    if (count > [self.goodModel.stock doubleValue] ) {
        
        
        [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"库存紧张,最大可采购数量%@%@哦",[STCommon setHasSuffix:self.goodModel.stock],self.goodModel.Goods_Unit]];

        switch ([self.goodModel.sellType intValue]) {
            case 1:
                
                count -= 1;
                
                break;
            case 2:
                
                count -= [self.goodModel.Product_Pcs_Small doubleValue];
                
                break;
                
            case 3:
                
                count -= [self.goodModel.Product_Pcs doubleValue];
                
                break;
                
            default:
                break;
        }
        
        return count;
        
    }else if (count < [self.goodModel.minBuy doubleValue]) {
        
        count = [self.goodModel.minBuy doubleValue];
    }
    
    return count;
}


#pragma mark UITextField Delegate
-  (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.countTF resignFirstResponder];
    
    if (textField.text.length == 0) {
        
        self.countTF.text = [NSString stringWithFormat:@"%@",self.goodModel.buyCount];
        return;
    }
    
    double count = [self.countTF.text doubleValue];
    [self InputJudge:count];
}


- (BOOL)InputJudge:(double)count {
    
   __block BOOL sellType1 = false;
   __block BOOL sellType2 = false;
   __block BOOL sellType3 = false;
    
    [STCommon isRemainderD1:count withD2:1 Block:^(BOOL isRemainder, int multiple) {
        
        sellType1 = isRemainder;
    }];
    
    [STCommon isRemainderD1:count withD2:self.goodModel.Product_Pcs_Small.doubleValue Block:^(BOOL isRemainder, int multiple) {
        
        sellType2 = isRemainder;
    }];
    
    [STCommon isRemainderD1:count withD2:self.goodModel.Product_Pcs.doubleValue Block:^(BOOL isRemainder, int multiple) {
        
        sellType3 = isRemainder;
    }];
    
    if(count > 0) {
   
        if (count > [self.goodModel.stock doubleValue]) {
            
//            self.countTF.text = [NSString stringWithFormat:@"%@",self.goodModel.buyCount];
            [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"库存紧张,最多只能采购%@%@哦",[STCommon setHasSuffix:self.goodModel.stock],self.goodModel.Goods_Unit]];
            return NO;
            
            //输入的不是中包装的倍数
        }else if ([self.goodModel.sellType doubleValue] == 2 && [self.goodModel.Product_Pcs_Small doubleValue] > 0 && !sellType2) {
            
//            self.countTF.text = [NSString stringWithFormat:@"%@",self.goodModel.buyCount];
            [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"购买数量必须是中包装【%@】的整数倍",[STCommon setHasSuffix:self.goodModel.Product_Pcs_Small]]];
            return NO;
            
        }else if ([self.goodModel.sellType doubleValue] == 3 && [self.goodModel.Product_Pcs doubleValue] > 0 && !sellType3) {
            
            //            self.countTF.text = [NSString stringWithFormat:@"%@",self.goodModel.buyCount];
            [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"购买数量必须是件装【%@】的整数倍",[STCommon setHasSuffix:self.goodModel.Product_Pcs]]];
            return NO;
            
        }else if ([self.goodModel.sellType doubleValue] == 1 && !sellType1) {
            
            //            self.countTF.text = [NSString stringWithFormat:@"%@",self.goodModel.buyCount];
            [ZHProgressHUD showErrorWithText:@"购买数量必须是1的整数倍"];
            return NO;
            
        }else if(count < [self.goodModel.minBuy doubleValue]){
            
//            self.countTF.text = [NSString stringWithFormat:@"%@",self.goodModel.buyCount];
            [ZHProgressHUD showErrorWithText:[NSString stringWithFormat:@"不能低于最低采购数【%@】%@",[STCommon setHasSuffix:self.goodModel.minBuy],self.goodModel.Goods_Unit]];
            return NO;
            
        }else {
        
            self.changeCountP.num = [STCommon setHasSuffix:[NSString stringWithFormat:@"%f",count]];
            return YES;
        }
    }else {
        
        
        [ZHProgressHUD showErrorWithText:@"请输入大于零的购买数量"];
        
//        self.countTF.text = [NSString stringWithFormat:@"%@",self.goodModel.buyCount];
        return NO;
    }
}

//修改数量
- (void)changeCount {
    
//    [ZHProgressHUD show];
    
    FxLog(@"changeCount = %@",self.changeCountP.mj_keyValues);
    
    [KSMNetworkRequest getRequest:requestWisdomChangeGoodsCount params:self.changeCountP.mj_keyValues success:^(id responseObj) {
        FxLog(@"changeCount = %@",responseObj);
        
//        [ZHProgressHUD dismiss];
        
        if ([[responseObj objectForKey:@"code"] integerValue] == 1) {
            
            if (_WisdomAdd_reduceBlock) {
                
                _WisdomAdd_reduceBlock([self.countTF.text doubleValue]);
            }
            
            [self cancleAction:nil];
            
        }else {
        
            [ZHProgressHUD showErrorWithText:@"网络错误，请重试！"];
        }
        
    } failure:^(NSError *error) {
        
        FxLog(@"changeCount = %@",error.description);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.countTF resignFirstResponder];
}

- (IBAction)deleteAction:(id)sender {
    
    if (_deleteImportBlock) {
        _deleteImportBlock();
    }
}

@end
