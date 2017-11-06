//
//  STWisdomAddListFilterView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomAddListFilterView.h"
#import "STStorewideFilterCell.h"
#import "STStorewideFilterHeadView.h"
#import "STStorewideFilterFootView.h"


@interface STWisdomAddListFilterView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,STStorewideFilterFootViewDelegte>{
    NSArray *titleAry;
}
@property(strong,nonatomic)UICollectionView *filterCollectionV;
@property(strong,nonatomic)UICollectionViewFlowLayout *filterFlowL;
@property(strong,nonatomic)NSMutableDictionary *productDict;
@property(strong,nonatomic)NSMutableDictionary *selectedDict;
@end


@implementation STWisdomAddListFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.userInteractionEnabled = YES;
        _productDict = [NSMutableDictionary new];
        _selectedDict = [NSMutableDictionary new];
        
        [_productDict setObject:@"0" forKey:@"producttype"];
        [_productDict setObject:@"0" forKey:@"cuxiao"];
        [_productDict setObject:@"" forKey:@"GrossMarginRange"];
        [_productDict setObject:@"" forKey:@"PriceRange"];
        
        [_selectedDict setObject:@"0" forKey:@"producttype"];
        [_selectedDict setObject:@"0" forKey:@"cuxiao"];
        [_selectedDict setObject:@"0" forKey:@"GrossMarginRange"];
        [_selectedDict setObject:@"0" forKey:@"PriceRange"];
        
        titleAry = @[@[@"不限",@"普药",@"首推联盟"],@[@"不限",@"加价购",@"包邮",@"特价"],@[@"不限",@"0-20%",@"20-40%",@"40-60%",@"60-80%",@"80-100%"],@[@"不限",@"0-20",@"20-40",@"40-60",@"60-80",@"80-100",@"100以上"]];
        [self addTheCollectionView];
    }
    return self;
}
-(void)addTheCollectionView{
    _filterFlowL = [UICollectionViewFlowLayout new];
    _filterFlowL.minimumInteritemSpacing = 1.f;
    [_filterFlowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _filterCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:_filterFlowL];
    _filterCollectionV.userInteractionEnabled = YES;
    _filterCollectionV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _filterCollectionV.delegate = self;
    _filterCollectionV.dataSource = self;
    
    [_filterCollectionV registerClass:[STStorewideFilterCell class] forCellWithReuseIdentifier:@"FilterCell"];
    
    [_filterCollectionV registerClass:[STStorewideFilterHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeadView"];
    
    [_filterCollectionV registerClass:[STStorewideFilterFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FilterFootView"];
    
    [self addSubview:_filterCollectionV];
}

#pragma mark --UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return titleAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [titleAry[section]count];
}
//每个单元格的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    STStorewideFilterCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    [MyCell setFilterIndexPath:indexPath andTitleAry:titleAry selectedDict:_selectedDict];
    return MyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.frame.size.width/3 - 15, 30);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(self.frame.size.width,78);
    }else{
        return CGSizeMake(self.frame.size.width,30);
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeadView" forIndexPath:indexPath];
        
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        
        if (indexPath.section == 0) {
            STStorewideFilterHeadView *headerView = [STStorewideFilterHeadView new];
            headerView.frame = CGRectMake(0, 0, self.frame.size.width, 78);
            [headerView setFilterTitle:@[@"筛选条件\n\n商品类型",@"促销",@"毛利率",@"零售价格"][indexPath.section] andIndex:indexPath.section];
            [reusableView addSubview:headerView];
        }else{
            for (UIView *view in reusableView.subviews) {
                [view removeFromSuperview];
            }
            
            STStorewideFilterHeadView *headerView = [STStorewideFilterHeadView new];
            headerView.frame = CGRectMake(0, 0, self.frame.size.width, 30);
            [headerView setFilterTitle:@[@"商品类型",@"促销",@"毛利率",@"零售价格"][indexPath.section] andIndex:indexPath.section];
            [reusableView addSubview:headerView];
        }
        return reusableView;
        
        
    }else if(kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FilterFootView" forIndexPath:indexPath];
        
        STStorewideFilterFootView *footerView = [STStorewideFilterFootView new];
        footerView.frame = CGRectMake(0, 0, self.frame.size.width, 60);
        footerView.delegate = self;
        [footerView setAddBtn];
        [reusableView addSubview:footerView];
        return reusableView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return CGSizeMake(self.frame.size.width,60);
    }
    return  CGSizeMake(self.frame.size.width,0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    STStorewideFilterCell *cell = (STStorewideFilterCell *)[_filterCollectionV cellForItemAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [_productDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"producttype"];
            [_selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"producttype"];
            break;
        case 1:
            [_productDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"cuxiao"];
            [_selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"cuxiao"];
            break;
        case 2:
            if (indexPath.row == 0) {
                [_productDict setObject:@"" forKey:@"GrossMarginRange"];
            }else{
                [_productDict setObject:[[STCommon sharedSTSTCommon] setchengStr:cell.titleLab.text] forKey:@"GrossMarginRange"];
            }
            [_selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"GrossMarginRange"];
            break;
        case 3:
            if (indexPath.row == 0) {
                [_productDict setObject:@"" forKey:@"PriceRange"];
            }else{
                [_productDict setObject:[[STCommon sharedSTSTCommon] setchengStr:cell.titleLab.text] forKey:@"PriceRange"];
            }
            [_selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"PriceRange"];
            break;
        default:
            break;
    }
    //    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
    //    [_filterCollectionV reloadSections:indexSet];
    [_filterCollectionV reloadData];
}

#pragma mark --STStorewideFilterFootViewDelegte
-(void)g_setStorewideFilterFinished{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wisdomAddListeProducttype" object:self userInfo:_productDict];
}


@end
