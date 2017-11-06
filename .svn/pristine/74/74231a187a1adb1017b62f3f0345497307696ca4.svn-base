//
//  ShopCartHead.m
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "ShopCartHead.h"
#import "DeleteGoodsParams.h"


@interface ShopCartHead ()

@property (nonatomic,strong)DeleteGoodsParams *deleteGoodP;

@end
@implementation ShopCartHead

//删除商品
-(DeleteGoodsParams *)deleteGoodP {
    
    if (_deleteGoodP == nil) {
        
        self.deleteGoodP = [[DeleteGoodsParams alloc]init];
        self.deleteGoodP.storeid = [NSString stringWithFormat:@"%@",self.StoreInfo.StoreId];
    }
    return _deleteGoodP;
}

//进入店铺
- (IBAction)toStoreAction:(id)sender {
    
    self.intoStoreBlock();
}

- (IBAction)selectAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if (button.selected == YES) {
        
        self.selectBtn.selected = NO;
        
    }else {
        
        self.selectBtn.selected = YES;
    }
    
    self.headSelectBlock(self.selectBtn.selected);
}


- (IBAction)deleteStoreAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"❗️" message:@"您确定把该店铺的所有商品移出购物车吗?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 300;
    [alert show];
}

- (void)headSelect:(HeadSelectBlock) block {
    
    _headSelectBlock = block;
}

- (void)deleteStoreMethod:(DeleteStoreBlock)block {

    _deleteStoreBlock = block;
}

- (void)intoStoreMethod:(IntoStoreBlock)block {

    _intoStoreBlock = block;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 300) {
        
        if (buttonIndex == 1) {
            
            FxLog(@"deleteStoreParams = %@",self.deleteGoodP.mj_keyValues);
            
            [KSMNetworkRequest postRequest:requestDelProduct params:self.deleteGoodP.mj_keyValues success:^(id responseObj) {
                
                self.deleteStoreBlock();
                
                FxLog(@"deleteStoreCuccess = %@",responseObj);
                
            } failure:^(NSError *error) {
                
                FxLog(@"deleteStoreErroe = %@",error.description);
            }];
        }
    }
}

@end
