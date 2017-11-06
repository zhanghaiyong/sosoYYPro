//
//  ShopCartCell.m
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//

#define DELAY_TIME 1
#import "ShopCartCell.h"
#import "ChangeCountParams.h"
#import "GoodSelectParams.h"
#import "DeleteGoodsParams.h"
@interface ShopCartCell ()

@property (nonatomic,strong)ChangeCountParams *changeCountP;
@property (nonatomic,strong)GoodSelectParams *goodSelectP;
@property (nonatomic,strong)DeleteGoodsParams *deleteGoodP;
@end

@implementation ShopCartCell


//修改数量
-(ChangeCountParams *)changeCountP {
    
    if (_changeCountP == nil) {
        
        self.changeCountP = [[ChangeCountParams alloc]init];
        self.changeCountP.addpricebuystate = @"0";
    }
    return _changeCountP;
}

//是否选中
-(GoodSelectParams *)goodSelectP {
    
    if (_goodSelectP == nil) {
        
        self.goodSelectP = [[GoodSelectParams alloc]init];
        
    }
    return _goodSelectP;
}

-(void)setOrderProductInfo:(OrderProductInfoModel *)OrderProductInfo {
    
    _OrderProductInfo = OrderProductInfo;
    self.changeCountP.pid = [NSString stringWithFormat:@"%@",self.OrderProductInfo.Pid];
    self.goodSelectP.recordid = [NSString stringWithFormat:@"%@",self.OrderProductInfo.RecordId];
    self.deleteGoodP.pid = [NSString stringWithFormat:@"%@",self.OrderProductInfo.Pid];
}

//删除商品
-(DeleteGoodsParams *)deleteGoodP {
    
    if (_deleteGoodP == nil) {
        
        self.deleteGoodP = [[DeleteGoodsParams alloc]init];
        
    }
    return _deleteGoodP;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.countLabel.delegate = self;
    self.countLabel.inputAccessoryView = [self addToolbar];
    
}

- (UIToolbar *)addToolbar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldDone)];
    [bar setTintColor:[UIColor blackColor]];
    toolbar.items = @[nextButton, prevButton, space, bar];
    return toolbar;
}


- (IBAction)buttonToDetail:(id)sender {
    
    self.detailBlock();
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (IBAction)selectAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.selected == YES) {
        
//        self.selectBtn.selected = NO;
        self.goodSelectP.Checked = @"0";
        
    }else {
        
//        self.selectBtn.selected = YES;
        self.goodSelectP.Checked = @"1";
    }
    
    [self goodCheckedSelect];
    
}

- (IBAction)reduceAction:(id)sender {
    
    
    self.alpButton.userInteractionEnabled = NO;
    
    double count = [self.countLabel.text doubleValue];
    
    switch ([self.OrderProductInfo.SellType intValue]) {
        case 1:
            
            if (count > [self.OrderProductInfo.MinBuyNum doubleValue]) {
                //按公斤
                if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                    
                    count -= [self.OrderProductInfo.BagCount doubleValue];
                    
                }else { //按盒
                    
                    count -= 1;
                }
            }else {
                
                NSString *alertStr;
                
                if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                    
                    alertStr = [NSString stringWithFormat:@"不能低于最小购买数【%.2f】%@",[self.OrderProductInfo.MinBuyNum doubleValue],self.OrderProductInfo.Goods_Unit];
                    count = [self.OrderProductInfo.MinBuyNum doubleValue];
                }else {
                    
                    alertStr = [NSString stringWithFormat:@"不能低于最小购买数【%d】%@",[self.OrderProductInfo.MinBuyNum intValue],self.OrderProductInfo.Goods_Unit];
                    count = [self.OrderProductInfo.MinBuyNum intValue];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            break;
        case 2:
            
            if (count > [self.OrderProductInfo.Product_Pcs_Small doubleValue] && count > [self.OrderProductInfo.MinBuyNum doubleValue]) {
                
                count -= [self.OrderProductInfo.Product_Pcs_Small doubleValue];
                
            }else {
                
                NSString *alertStr;
                if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                    
                    alertStr = [NSString stringWithFormat:@"不能低于最小购买数【%.2f】%@",[self.OrderProductInfo.MinBuyNum doubleValue],self.OrderProductInfo.Goods_Unit];
                    count = [self.OrderProductInfo.MinBuyNum doubleValue];
                }else {
                    
                    alertStr = [NSString stringWithFormat:@"不能低于最小购买数【%d】%@",[self.OrderProductInfo.MinBuyNum intValue],self.OrderProductInfo.Goods_Unit];
                    count = [self.OrderProductInfo.MinBuyNum intValue];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            break;
            
        case 3:
            
            if (count > [self.OrderProductInfo.Product_Pcs doubleValue] && count > [self.OrderProductInfo.MinBuyNum doubleValue]) {
                
                count -= [self.OrderProductInfo.Product_Pcs doubleValue];
                
            } else {
                
                
                NSString *alertStr;
                if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                    
                    alertStr = [NSString stringWithFormat:@"不能低于最小购买数【%.2f】%@",[self.OrderProductInfo.MinBuyNum doubleValue],self.OrderProductInfo.Goods_Unit];
                    count = [self.OrderProductInfo.MinBuyNum doubleValue];
                }else {
                    
                    alertStr = [NSString stringWithFormat:@"不能低于最小购买数【%d】%@",[self.OrderProductInfo.MinBuyNum intValue],self.OrderProductInfo.Goods_Unit];
                    count = [self.OrderProductInfo.MinBuyNum intValue];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            
            break;
            
        default:
            break;
    }
    
    if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
        
        self.countLabel.text = [NSString stringWithFormat:@"%.2f",count];
        
    }else {
        
        self.countLabel.text = [NSString stringWithFormat:@"%d",(int)count];
    }
    
    self.changeCountP.buyCount = [NSString stringWithFormat:@"%.2f",count];
    self.add_reduceBlock(self.changeCountP.buyCount.doubleValue);
    [self changeCountMethod];
}

- (IBAction)addAction:(id)sender {
    
    
    self.alpButton.userInteractionEnabled = NO;
    
    double count = [self.countLabel.text doubleValue];
    
    if (count >= [self.OrderProductInfo.stock doubleValue]) {
        
        NSString *alertStr;
        if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
            
            alertStr = [NSString stringWithFormat:@"库存紧张,最多只能买%.2f%@哦",[self.OrderProductInfo.stock doubleValue],self.OrderProductInfo.Goods_Unit];
        }else {
            
            alertStr = [NSString stringWithFormat:@"库存紧张,最多只能买%d%@哦",[self.OrderProductInfo.stock intValue],self.OrderProductInfo.Goods_Unit];
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        self.changeCountP.buyCount = [NSString stringWithFormat:@"%.2f",count];
        self.add_reduceBlock(self.changeCountP.buyCount.doubleValue);
        [self changeCountMethod];
        
        return;
    }
    
    switch ([self.OrderProductInfo.SellType intValue]) {
        case 1:
            
            if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                
                count += [self.OrderProductInfo.BagCount doubleValue];
                
            }else {
                
                count += 1;
            }
            
            break;
        case 2:
            
            count += [self.OrderProductInfo.Product_Pcs_Small doubleValue];
            
            break;
            
        case 3:
            
            count += [self.OrderProductInfo.Product_Pcs doubleValue];
            
            break;
            
        default:
            break;
    }
    
    if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
        
        self.countLabel.text = [NSString stringWithFormat:@"%.2f",count];
        
    }else {
        
        self.countLabel.text = [NSString stringWithFormat:@"%d",(int)count];
    }
    
    self.changeCountP.buyCount = [NSString stringWithFormat:@"%.2f",count];
    self.add_reduceBlock(self.changeCountP.buyCount.doubleValue);
    [self changeCountMethod];
}

- (void)toProDetailMethod:(toProDetailBlock)block {
    
    _detailBlock = block;
}

- (void)deleteProMethod:(deleteProBlock)block {
    
    _deleteBlock = block;
}

- (void)add_reduceCountMethod:(add_reduceCountBlock)block {
    
    _add_reduceBlock = block;
}

- (void)cellSelectGoodMethod:(CellSelectBlock)block {
    
    _cellSelectBlock = block;
}

- (void)JJGSwitchMethod:(JJGSwitchBlock)block {
    
    _JJGBlock = block;
}

#pragma mark UITextField Delegate
- (void)textFieldDone{
    
    [self.countLabel resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.alpButton.userInteractionEnabled = NO;
}

-  (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.alpButton.userInteractionEnabled = YES;
    
    [self.countLabel resignFirstResponder];
    double count = [self.countLabel.text doubleValue];
    
    if (self.countLabel.text.length != 0) {
        
        if(count > 0) {
            
            if (count > [self.OrderProductInfo.stock doubleValue]) {
                
                NSString *alertStr;
                if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                    
                    alertStr = [NSString stringWithFormat:@"库存紧张,最多只能买%.2f%@哦",[self.OrderProductInfo.stock doubleValue],self.OrderProductInfo.Goods_Unit];
                    self.countLabel.text = [NSString stringWithFormat:@"%.2f",[self.oldCount doubleValue]];
                }else {
                    
                    alertStr = [NSString stringWithFormat:@"库存紧张,最多只能买%d%@哦",[self.OrderProductInfo.stock intValue],self.OrderProductInfo.Goods_Unit];
                    self.countLabel.text = [NSString stringWithFormat:@"%d",[self.oldCount intValue]];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                //输入的不是中包装的倍数
            }else if ([self.OrderProductInfo.SellType doubleValue] == 2 && fmod(count,[self.OrderProductInfo.Product_Pcs_Small doubleValue]) != 0) {
                
                NSString *alertStr;
                if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                    
                    alertStr = [NSString stringWithFormat:@"购买数量必须是中包装【%.2f】的整数倍",[self.OrderProductInfo.Product_Pcs_Small doubleValue]];
                    self.countLabel.text = [NSString stringWithFormat:@"%.2f",[self.oldCount doubleValue]];
                }else {
                    
                    alertStr = [NSString stringWithFormat:@"购买数量必须是中包装【%d】的整数倍",[self.OrderProductInfo.Product_Pcs_Small intValue]];
                    self.countLabel.text = [NSString stringWithFormat:@"%d",[self.oldCount intValue]];
                }
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                
            }else if ([self.OrderProductInfo.SellType doubleValue] == 3 && fmod(count,[self.OrderProductInfo.Product_Pcs doubleValue]) != 0) {
                
                NSString *alertStr;
                if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                    
                    alertStr = [NSString stringWithFormat:@"购买数量必须是件装【%.2f】的整数倍",[self.OrderProductInfo.Product_Pcs doubleValue]];
                    self.countLabel.text = [NSString stringWithFormat:@"%.2f",[self.oldCount doubleValue]];
                }else {
                    
                    alertStr = [NSString stringWithFormat:@"购买数量必须是件装【%d】的整数倍",[self.OrderProductInfo.Product_Pcs intValue]];
                    self.countLabel.text = [NSString stringWithFormat:@"%d",[self.oldCount intValue]];
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }else if ([self.OrderProductInfo.SellType doubleValue] == 1 && [self.OrderProductInfo.BagCount doubleValue] > 0) {
                
                if (fmod(count,[self.OrderProductInfo.BagCount doubleValue]) != 0) {
                    
                    self.countLabel.text = [NSString stringWithFormat:@"%.2f",[self.oldCount doubleValue]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"购买数量必须是最小包装【%.2f】的整数倍",[self.OrderProductInfo.BagCount doubleValue]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }else {
                    
                    self.changeCountP.buyCount = [NSString stringWithFormat:@"%.2f",[self.countLabel.text doubleValue]];
                    self.add_reduceBlock(self.changeCountP.buyCount.doubleValue);
                    [self changeCountMethod];
                }
                
            }else {
                
                self.changeCountP.buyCount = [NSString stringWithFormat:@"%.2f",[self.countLabel.text doubleValue]];
                self.add_reduceBlock(self.changeCountP.buyCount.doubleValue);
                [self changeCountMethod];
            }
        }else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请输入大于零的购买数量" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
                
                self.countLabel.text = [NSString stringWithFormat:@"%.2f",[self.oldCount doubleValue]];
                
            }else {
                
                self.countLabel.text = [NSString stringWithFormat:@"%d",[self.oldCount intValue]];
            }
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请输入大于零的购买数量" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        if ([self.OrderProductInfo.BagCount doubleValue] > 0) {
            
            self.countLabel.text = [NSString stringWithFormat:@"%.2f",[self.oldCount doubleValue]];
        }else {
            
            self.countLabel.text = [NSString stringWithFormat:@"%d",[self.oldCount intValue]];
        }
    }
}

//删除商品
- (IBAction)deleteProAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"❗️" message:@"您确定把该商品移出购物车吗?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 300;
    [alert show];
    
}

//加价购开关
- (IBAction)jjgAction:(id)sender {
    
    UISwitch *swH = (UISwitch *)sender;
    
    int count = [self.countLabel.text intValue];
    self.changeCountP.buyCount = [NSString stringWithFormat:@"%d",count];
    self.changeCountP.addpricebuystate = self.switchCtrl.on ? @"1" : @"0";
    [self changeCountMethod];
    self.JJGBlock(swH.isOn ? YES : NO);
}

//修改数量
- (void)changeCountMethod {
    
    FxLog(@"ChangeGoodsCountParams = %@",self.changeCountP.mj_keyValues);
    
    [KSMNetworkRequest getRequest:requestChangeGoodsCount params:self.changeCountP.mj_keyValues success:^(id responseObj) {
        FxLog(@"ChangeGoodsCountCuccess = %@",responseObj);
        
//        self.add_reduceBlock(self.changeCountP.buyCount.doubleValue);
        
        self.alpButton.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        
        FxLog(@"ChangeGoodsCountErroe = %@",error.description);
        self.alpButton.userInteractionEnabled = YES;
    }];
}

//商品选中状态
- (void)goodCheckedSelect {
    
    FxLog(@"goodCheckedParams = %@",self.goodSelectP.mj_keyValues);
    
    [KSMNetworkRequest postRequest:requestProducChecked params:self.goodSelectP.mj_keyValues success:^(id responseObj) {
        
        FxLog(@"goodCheckedCuccess = %@",responseObj);
        self.cellSelectBlock(self.goodSelectP.Checked);
        
    } failure:^(NSError *error) {
        
        FxLog(@"goodCheckedErroe = %@",error.description);
    }];
}

#pragma  mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 300) {
        
        if (buttonIndex == 1) {
            
            FxLog(@"deleteGoodsParams = %@",self.deleteGoodP.mj_keyValues);
            
            [KSMNetworkRequest postRequest:requestDelProduct params:self.deleteGoodP.mj_keyValues success:^(id responseObj) {
                
                self.deleteBlock();
                
                FxLog(@"deleteGoodsSuccess = %@",responseObj);
                
            } failure:^(NSError *error) {
                
                FxLog(@"deleteGoodsErroe = %@",error.description);
            }];
        }
    }
}


@end
