
//
//  STListFilterView.m
//  my
//
//  Created by soso-mac on 2016/11/21.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STListFilterView.h"
#import "STListFilterViewCell.h"
#import "STListFilterHeadView.h"
#import "STlistFilterFootView.h"


@interface STListFilterView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,STlistFilterFootViewDelegte>{
    NSArray *titleAry;
}
@property(strong,nonatomic)UICollectionView *filterCollectionV;
@property(strong,nonatomic)UICollectionViewFlowLayout *filterFlowL;
@property(strong,nonatomic)NSMutableDictionary *productDict;
@property(strong,nonatomic)NSMutableDictionary *selectedDict;
@end

@implementation STListFilterView

-(instancetype)initWithFrame:(CGRect)frame typeDict:(NSDictionary *)typeDict{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.userInteractionEnabled = YES;
        _productDict = [NSMutableDictionary new];
        _selectedDict = [NSMutableDictionary new];

         [_productDict setObject:@"0" forKey:@"producttype"];
         [_productDict setObject:@"0" forKey:@"cuxiao"];
        [_productDict setObject:@"0" forKey:@"GrossMarginRange"];
        [_productDict setObject:@"0" forKey:@"PriceRange"];
        
        [_selectedDict setObject:@"0" forKey:@"producttype"];
        [_selectedDict setObject:@"0" forKey:@"cuxiao"];
        [_selectedDict setObject:@"0" forKey:@"GrossMarginRange"];
        [_selectedDict setObject:@"0" forKey:@"PriceRange"];
        
        
        if ([typeDict[@"selected"] isEqualToString:@"T"]) {
             [_productDict setObject:@"2" forKey:@"producttype"];
            [_selectedDict setObject:@"2" forKey:@"producttype"];
        }else if ([typeDict[@"selected"] isEqualToString:@"J"]){
             [_productDict setObject:@"1" forKey:@"cuxiao"];
             [_selectedDict setObject:@"1" forKey:@"cuxiao"];
        }else if ([typeDict[@"selected"] isEqualToString:@"C"]){
            [_productDict setObject:@"3" forKey:@"cuxiao"];
            [_selectedDict setObject:@"3" forKey:@"cuxiao"];
        }else if ([typeDict[@"selected"] isEqualToString:@"P"]){
            [_productDict setObject:@"1" forKey:@"producttype"];
            [_selectedDict setObject:@"1" forKey:@"producttype"];
        }else if ([typeDict[@"selected"] isEqualToString:@"Y"]){
            [_productDict setObject:@"2" forKey:@"cuxiao"];
            [_selectedDict setObject:@"2" forKey:@"cuxiao"];
        }
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
    _filterCollectionV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _filterCollectionV.delegate = self;
    _filterCollectionV.dataSource = self;
    _filterCollectionV.userInteractionEnabled = YES;
    [_filterCollectionV registerClass:[STListFilterViewCell class] forCellWithReuseIdentifier:@"FilterCell"];
    
    [_filterCollectionV registerClass:[STListFilterHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterHeadView"];
    
     [_filterCollectionV registerClass:[STlistFilterFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FilterFootView"];
    
    [self addSubview:_filterCollectionV];
    
//    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self                                                                                    action:@selector(handleSwipe:)];
//    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [_filterCollectionV addGestureRecognizer:recognizer];
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
    STListFilterViewCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    [MyCell setFilterIndexPath:indexPath andTitleAry:titleAry productDict:_selectedDict];
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
        STListFilterHeadView *headerView = [STListFilterHeadView new];
        headerView.frame = CGRectMake(0, 0, self.frame.size.width, 78);
        [headerView setFilterTitle:@[@"筛选条件\n\n商品类型",@"促销",@"毛利率",@"零售价格"][indexPath.section] andIndex:indexPath.section];
        [reusableView addSubview:headerView];
        }else{
        STListFilterHeadView *headerView = [STListFilterHeadView new];
        headerView.frame = CGRectMake(0, 0, self.frame.size.width, 30);
        [headerView setFilterTitle:@[@"商品类型",@"促销",@"毛利率",@"零售价格"][indexPath.section] andIndex:indexPath.section];
        [reusableView addSubview:headerView];
        }
        return reusableView;
    }else if(kind == UICollectionElementKindSectionFooter){
            UICollectionReusableView *reusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FilterFootView" forIndexPath:indexPath];
        
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        
            STlistFilterFootView *footerView = [STlistFilterFootView new];
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
    STListFilterViewCell *cell = (STListFilterViewCell *)[_filterCollectionV cellForItemAtIndexPath:indexPath];
    
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
                [_productDict setObject:@"0" forKey:@"GrossMarginRange"];
            }else{
                [_productDict setObject:[[STCommon sharedSTSTCommon] setchengStr:cell.titleLab.text] forKey:@"GrossMarginRange"];
            }
             [_selectedDict setObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"GrossMarginRange"];
            break;
        case 3:
            if (indexPath.row == 0) {
                [_productDict setObject:@"0" forKey:@"PriceRange"];
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

#pragma mark -- STlistFilterFootViewDelegte

-(void)g_setFinished{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"producttype" object:self userInfo:_productDict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenListFilterView" object:nil];
}

@end
