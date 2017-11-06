//
//  STShopInfoHeaderView.m
//  my
//
//  Created by soso-mac on 2016/12/19.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopInfoHeaderView.h"

@interface STShopInfoHeaderView (){
  __block  BOOL isConcern;
}
@property (strong, nonatomic)NSMutableDictionary *dataDict;
@end

@implementation STShopInfoHeaderView

-(void)setShopInfoHeader:(id)dataResult{
    _dataDict = dataResult;
    _concernLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attentionSelected)];
    [_concernLab addGestureRecognizer:tap];
    
    if ([dataResult[@"isFavoriteStore"] isEqualToString:@"True"]) {
        _concernLab.layer.borderWidth = 1.0f;
        _concernLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
        _concernLab.text = @"   已关注";
        _concernLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
        _concernImgV.image = [UIImage imageNamed:@"attention"];
        isConcern = YES;
    }else{
        _concernLab.layer.borderWidth = 1.0f;
        _concernLab.layer.borderColor = [UIColor fromHexValue:0x777777 alpha:1].CGColor;
        _concernLab.text = @"   未关注";
        _concernLab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
        _concernImgV.image = [UIImage imageNamed:@"notAttention"];
        isConcern = NO;
    }

    
    _nameLab.text = dataResult[@"StoreInfo"][@"Name"];
    _numLab.text = [NSString stringWithFormat:@"商品数量:%@",dataResult[@"productNum"]];
}
- (void)attentionSelected{
    __weak STShopInfoHeaderView *weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(g_setInfoLogin:)]) {
        [_delegate g_setInfoLogin:^(BOOL isLogin) {
            if (isLogin) {
                if (isConcern) {
                    [weakSelf httpDoloadInfoDelFavorite:weakSelf.dataDict[@"PartUserInfo"][@"StoreId"]];
                }else{
                    [weakSelf httpDoloadInfoToFavorite:weakSelf.dataDict[@"PartUserInfo"][@"StoreId"]];
                }
            }
        }];
    }
}
-(void)httpDoloadInfoToFavorite:(NSString *)storeid{
    __weak STShopInfoHeaderView *weakSelf = self;
    [KSMNetworkRequest getShopAddStoreToFavoriteUrl:requestShopAddStoreToFavorite
                                             params:@{@"storeid":storeid} finshed:^(id dataResult,NSError *error) {
                                                 weakSelf.concernLab.layer.borderWidth = 1.0f;
                                                 weakSelf.concernLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                                                 weakSelf.concernLab.text = @"   已关注";
                                                 weakSelf.concernLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
                                                 weakSelf.concernImgV.image = [UIImage imageNamed:@"attention"];
                                                 isConcern = YES;
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Favorite" object:nil userInfo:@{@"Concern":@"1"}];
                                             }];
}

-(void)httpDoloadInfoDelFavorite:(NSString *)storeid{
    __weak STShopInfoHeaderView *weakSelf = self;
    [KSMNetworkRequest getShopAddStoreDelFavoriteUrl:requestShopDelFavorite
                                              params:@{@"storeid":storeid} finshed:^(id dataResult,NSError *error) {
                                                  weakSelf.concernLab.layer.borderWidth = 1.0f;
                                                  weakSelf.concernLab.layer.borderColor = [UIColor fromHexValue:0x777777 alpha:1].CGColor;
                                                  weakSelf.concernLab.text = @"   未关注";
                                                  weakSelf.concernLab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
                                                  weakSelf.concernImgV.image = [UIImage imageNamed:@"notAttention"];
                                                  isConcern = NO;
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Favorite" object:nil userInfo:@{@"Concern":@"0"}];
                                              }];
}


@end
