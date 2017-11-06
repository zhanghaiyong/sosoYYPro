//
//  STShopHomeTopView.m
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopHomeTopView.h"

@interface STShopHomeTopView (){
   __block BOOL isConcern;
    NSInteger indexCount;
}

@property (strong, nonatomic)NSMutableDictionary *dataDict;
@end

@implementation STShopHomeTopView

-(void)dealloc {
    NSLog(@"topView销毁了");
}

-(void)setNewsList:(NSArray *)newsList {
    
    __weak STShopHomeTopView *weakSelf = self;
    _newsList = newsList;
    if (newsList.count > 0) {
        self.newsListViewH.constant = 40;
        if (_noticeView == nil) {
            _noticeView = [[NoticeView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 39.2) newsList:newsList];
            _noticeView.tapNoticeTabBack = ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(showNotice)]) {
                    [weakSelf.delegate showNotice];
                }
            };
            [self.newsListView addSubview:_noticeView];
        }
    }else {
        self.newsListViewH.constant = 0;
    }
}

-(void)setShopHomeTop:(id)dataResult index:(NSInteger)index favoriteStore:(NSString *)favoriteStore{
    indexCount = index;
    _leftLine.frame = CGRectMake(self.frame.size.width/3, 5, .5, 40);
    _rightLine.frame = CGRectMake(self.frame.size.width/3 * 2, 5, .5, 40);
    __weak STShopHomeTopView *weakSelf = self;
    _dataDict = dataResult;
    _concernLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(concernSelected)];
    [_concernLab addGestureRecognizer:tap];
    if ([favoriteStore intValue] == 1) {
        _concernLab.text = @"   已关注";
        _concernLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
        _concernImgV.image = [UIImage imageNamed:@"attention"];
        isConcern = YES;
    }else{
        _concernLab.text = @"   未关注";
        _concernLab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
        _concernImgV.image = [UIImage imageNamed:@"notAttention"];
        isConcern = NO;
    }
    
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.cornerRadius = 3.0f;
    if (![dataResult[@"Logo"] isKindOfClass:[NSNull class]]) {
    
        [_imageV st_setImageWithURLString:dataResult[@"Logo"]  placeholderImage:@"stance"];
    }else {
        _imageV.image = [UIImage imageNamed:@"stance"];
    }
    
    if (![dataResult[@"Name"] isKindOfClass:[NSNull class]]) {
        _nameLab.text = dataResult[@"Name"];
    }else {
        _nameLab.text = @"---";
    }
    
    if (![dataResult[@"ManagerName"] isKindOfClass:[NSNull class]]) {
        _companyLab.text = dataResult[@"ManagerName"];
    }else {
        _companyLab.text = @"---";
    }
    
    //是否支持白条
    if ([dataResult[@"islous"] integerValue] == 1) {
        self.IOUImg.hidden = NO;
    }else {
        self.IOUImg.hidden = YES;
    }
    
    if ([dataResult[@"TaxPolicy"] intValue] == 0) {
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:@"税票服务\n货票同行" type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.tallageLab.attributedText = string;
        }];
    }else if ([dataResult[@"TaxPolicy"] intValue] == 1){
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:@"税票服务\n下批货开票"type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.tallageLab.attributedText = string;
        }];
    }else if ([dataResult[@"TaxPolicy"] intValue] == 2){
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:@"税票服务\n月底开票"type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.tallageLab.attributedText = string;
        }];
    }else if ([dataResult[@"TaxPolicy"] intValue] == 3){
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:@"税票服务\n电子发票"type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.tallageLab.attributedText = string;
        }];
    }else if ([dataResult[@"TaxPolicy"] intValue] == 4){
        [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:@"税票服务\n----"type:1 andFinished:^(NSMutableAttributedString *string) {
            weakSelf.tallageLab.attributedText = string;
        }];
    }
    
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"6"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"最低发货金额\n¥%@",dataResult[@"LowestdeliveryAmount"]]type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.pricLab.attributedText = string;
    }];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"4"},@{@"color":[UIColor fromHexValue:0x777777 alpha:1],@"font":@"14"}] andChengeString:[NSString stringWithFormat:@"包邮金额\n¥%@",dataResult[@"LowestFreeShippingAmount"]]type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.posLab.attributedText = string;
    }];
    if (index <= 6) {
        _moreLab.hidden = YES;
        _rightImgeV.hidden = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)concernSelected{
    __weak STShopHomeTopView *weakSelf = self;
    if (_delegate && [_delegate respondsToSelector:@selector(g_setLogin:)]) {
        [_delegate g_setLogin:^(BOOL isLogin) {
            if (isLogin) {
                if (isConcern) {
                     [weakSelf httpDoloadDelFavorite:weakSelf.dataDict[@"StoreId"]];
                }else{
                  [weakSelf httpDoloadToFavorite:weakSelf.dataDict[@"StoreId"]];
                }
            }
        }];
    }
}
-(void)httpDoloadToFavorite:(NSString *)storeid{
    __weak STShopHomeTopView *weakSelf = self;
    [KSMNetworkRequest getShopAddStoreToFavoriteUrl:requestShopAddStoreToFavorite
                                             params:@{@"storeid":storeid} finshed:^(id dataResult,NSError *error) {
                                                 weakSelf.concernLab.text = @"   已关注";
                                                 weakSelf.concernLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
                                                 weakSelf.concernImgV.image = [UIImage imageNamed:@"attention"];
                                                 isConcern = YES;
                                                 if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(g_setChangeFavoriteStore:)]) {
                                                     [weakSelf.delegate g_setChangeFavoriteStore:@"1"];
                                                 }
                                            }];
}

-(void)httpDoloadDelFavorite:(NSString *)storeid{
    __weak STShopHomeTopView *weakSelf = self;
    [KSMNetworkRequest getShopAddStoreDelFavoriteUrl:requestShopDelFavorite
                                              params:@{@"storeid":storeid} finshed:^(id dataResult,NSError *error) {
                                                  weakSelf.concernLab.text = @"   未关注";
                                                  weakSelf.concernLab.textColor = [UIColor fromHexValue:0x777777 alpha:1];
                                                  weakSelf.concernImgV.image = [UIImage imageNamed:@"notAttention"];
                                                  isConcern = NO;
                                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(g_setChangeFavoriteStore:)]) {
                                                      [weakSelf.delegate g_setChangeFavoriteStore:@"0"];
                                                  }
                                              }];
}
- (IBAction)recommendSelected:(UIButton *)sender {
    if (indexCount > 6) {
        if (self.moreBlock) {
            self.moreBlock(@"0");
        }
    }
}

@end
