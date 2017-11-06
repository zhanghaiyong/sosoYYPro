//
//  STStoreTableViewCell.m
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStoreTableViewCell.h"
#import "STStoreCollectionViewCell.h"


@interface STStoreTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UICollectionViewFlowLayout *flowL;
@property(strong,nonatomic)NSMutableArray *dataAry;
@end

@implementation STStoreTableViewCell
-(void)setStoreDataResult:(NSMutableArray *)dataResult andIndexPath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (dataResult.count != 0) {
        _dataAry = [dataResult[indexPath.row] TopProducts];

        _flowL = [UICollectionViewFlowLayout new];
        _flowL.minimumInteritemSpacing = .5f;
        [_flowL setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView.collectionViewLayout = _flowL;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:[STStoreCollectionViewCell.class description] bundle:nil] forCellWithReuseIdentifier:@"StoreCell"];
        
        _iouImg.hidden = ([[dataResult[indexPath.row] islous] integerValue] == 1) ? NO : YES;
        
        [_imgV st_setImageWithURLString:[dataResult[indexPath.row] Logo] placeholderImage:@"stance"];
        _nameLab.text = [dataResult[indexPath.row] storeName];
        _numLab.text =[NSString stringWithFormat:@"商品数量:%@",[dataResult[indexPath.row] ProductsCount]];
        
        if ([[dataResult[indexPath.row] LowestFreeShippingAmount] floatValue] !=0) {
            _pinkageLab.text = [NSString stringWithFormat:@"满%@包邮",[dataResult[indexPath.row] LowestFreeShippingAmount]];
        }else{
            _pinkageLab.text = @"包邮";
        }
        
        if ([[dataResult[indexPath.row] TaxPolicy] intValue] == 0) {
            _invoiceLab.text = @"货票同行";
        }else if ([[dataResult[indexPath.row] TaxPolicy] intValue] == 1){
            _invoiceLab.text = @"下批货开票";
        }else if ([[dataResult[indexPath.row] TaxPolicy] intValue] == 2){
            _invoiceLab.text = @"月底开票";
        }else if ([[dataResult[indexPath.row] TaxPolicy] intValue] == 3){
            _invoiceLab.text = @"电子发票";
        }else if ([[dataResult[indexPath.row] TaxPolicy] intValue] == 4){
            _invoiceLab.text = @"----";
        }
        
        if ([[dataResult[indexPath.row] addPrice] floatValue] == 0) {
            _addPriceLab.hidden = YES;
            _redemptionLab.hidden = YES;
        }else{
            _redemptionLab.text = [NSString stringWithFormat:@"%.2f元超值大换购",[[dataResult[indexPath.row] addPrice]floatValue]];
        }
        _addPriceLab.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
        _addPriceLab.layer.borderWidth = 1.0f;

        [_collectionView reloadData];
    }
}

#pragma mark --UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataAry.count;
}
//每个单元格的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    STStoreCollectionViewCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreCell" forIndexPath:indexPath];
    [MyCell setStoreCollection:_dataAry indexPath:indexPath];
    return MyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.frame.size.width - 5)/3 - 1, 100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[_dataAry[indexPath.row] pid],@"pid",@"2",@"isShop", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Details" object:nil userInfo:dict];
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
