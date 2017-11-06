//
//  STWisdomCollectionView.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/23.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomCollectionView.h"
#import "STWisdomProcurementCollectionCell.h"
#import "STWisdomCollectionFooterView.h"

@interface STWisdomCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UICollectionViewFlowLayout *wisdomFlowL;
@property (strong, nonatomic)UICollectionView *wisdomCollectionView;
@property(strong,nonatomic)NSMutableArray *selectAry;
@end

@implementation STWisdomCollectionView

-(void)setTitles:(NSArray *)titles {

    _titles = titles;
    _selectAry = [NSMutableArray new];
    _wisdomFlowL = [UICollectionViewFlowLayout new];
    [_wisdomFlowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _wisdomCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 127, 80)collectionViewLayout:_wisdomFlowL];
    _wisdomCollectionView.backgroundColor = [UIColor whiteColor];
    _wisdomCollectionView.delegate = self;
    _wisdomCollectionView.dataSource = self;
    _wisdomCollectionView.layer.masksToBounds = YES;
    _wisdomCollectionView.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _wisdomCollectionView.layer.borderWidth = .5;
    [_wisdomCollectionView registerNib:[UINib nibWithNibName:[STWisdomProcurementCollectionCell.class description] bundle:nil] forCellWithReuseIdentifier:@"STWisdomProcurementCollectionCell"];
    
    if (titles.count > 0) {
        [_wisdomCollectionView registerNib:[UINib nibWithNibName:[STWisdomCollectionFooterView.class description] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"STWisdomCollectionFooterView"];
    }else{
        [_wisdomCollectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"STWisdomCollectionFooterView"];
    }
    
    [self addSubview:_wisdomCollectionView];
}

#pragma mark --UICollectionView dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_selectAry.count != 0) {
        return [_selectAry[0] count] ;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    STWisdomProcurementCollectionCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STWisdomProcurementCollectionCell" forIndexPath:indexPath];
    [MyCell setWisdom:_selectAry indexPath:indexPath];
    
    return MyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.frame.size.width-20)/3,30);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
     if(kind == UICollectionElementKindSectionFooter){
        STWisdomCollectionFooterView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"STWisdomCollectionFooterView" forIndexPath:indexPath];

         for (int i = 0; i<self.titles.count; i++) {
             
             UIButton *sender = (UIButton *)[reusableView viewWithTag:(i+1)*100];
             [sender setTitle:self.titles[i] forState:UIControlStateNormal];
         }
         reusableView.WisdomCollectionBlock = ^(UIButton *btn) {
             if (_WisdomBtnBlock) {
                 _WisdomBtnBlock(btn);
             }
         };
        return reusableView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.titles.count > 0) {
        return CGSizeMake(self.frame.size.width,5+30*self.titles.count);
    }
    return CGSizeMake(self.frame.size.width,0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    STWisdomProcurementCollectionCell *cell = (STWisdomProcurementCollectionCell *)[_wisdomCollectionView cellForItemAtIndexPath:indexPath];
    if (_WisdomCollectionViewBlock) {
        _WisdomCollectionViewBlock(cell.nameLab.text);
    }
}
-(void)setSelectAry:(NSMutableArray *)ary frame:(CGRect)frame{
    _wisdomCollectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _selectAry = ary;
    [_wisdomCollectionView reloadData];
}
@end
