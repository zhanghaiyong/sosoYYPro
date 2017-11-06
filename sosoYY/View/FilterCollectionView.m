//
//  FilterCollectionView.m
//  sosoYY
//
//  Created by zhy on 2017/8/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "FilterCollectionView.h"
#import "FilterHeaderView.h"
#import "FilterCell.h"
@interface FilterCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{

    UIButton *clearbtn;
    UIButton *finishbtn;
    
}
@property(strong,nonatomic)UICollectionViewFlowLayout *wisdomFlowL;
@property (strong, nonatomic)UICollectionView *wisdomCollectionView;
@property (nonatomic,strong)NSMutableArray *filters;
@property (nonatomic,copy)NSArray *dataSource;

@end

@implementation FilterCollectionView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.filters = [NSMutableArray array];
        self.dataSource = [NSArray arrayWithArray:dataSource];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self setUp];
        
    }
    return self;
}

- (void)setUp {

    _wisdomFlowL = [UICollectionViewFlowLayout new];
    [_wisdomFlowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _wisdomCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_wisdomFlowL];
    _wisdomCollectionView.backgroundColor = [UIColor whiteColor];
    _wisdomCollectionView.delegate = self;
    _wisdomCollectionView.dataSource = self;

    
    [_wisdomCollectionView registerNib:[UINib nibWithNibName:[FilterCell.class description] bundle:nil] forCellWithReuseIdentifier:@"filterCell"];
    
    
    [_wisdomCollectionView registerNib:[UINib nibWithNibName:[FilterHeaderView.class description] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"filterHeader"];
    
    [self addSubview:_wisdomCollectionView];
    
    
    clearbtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [clearbtn setTitle:@"清除筛选" forState:UIControlStateNormal];
    clearbtn.backgroundColor = [UIColor fromHexValue:0xFAFAFA];
    clearbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [clearbtn setTitleColor:[UIColor fromHexValue:0x777777] forState:UIControlStateNormal];
    [clearbtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearbtn];
    
    finishbtn = [[UIButton alloc]initWithFrame:CGRectZero];
    finishbtn.backgroundColor = [UIColor fromHexValue:0xEA5413];
    finishbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishbtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [finishbtn setTitle:@"完成" forState:UIControlStateNormal];
    [self addSubview:finishbtn];
    
}

- (void)finishAction {

    if (_finishBlock) {
        _finishBlock(self.filters);
    }
    
    if (_hideFilterView) {
        _hideFilterView();
    }
}

- (void)clearAction {

  [self.filters removeAllObjects];
  [finishbtn setTitle:@"完成" forState:UIControlStateNormal];
    NSIndexSet *set1 = [NSIndexSet indexSetWithIndex:0];
    [_wisdomCollectionView reloadSections:set1];
    NSIndexSet *set2 = [NSIndexSet indexSetWithIndex:1];
    [_wisdomCollectionView reloadSections:set2];
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    _wisdomCollectionView.frame = CGRectMake(0, 0, self.width, 225);
    clearbtn.frame = CGRectMake(0, _wisdomCollectionView.bottom, self.width/2, 50);
    finishbtn.frame = CGRectMake(clearbtn.right, _wisdomCollectionView.bottom, self.width/2, 50);
}

#pragma mark --UICollectionView dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSArray *array = self.dataSource[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterCell *MyCell = (FilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
    
    NSArray *array = self.dataSource[indexPath.section];
    [MyCell.filterBtn setTitle:array[indexPath.item] forState:UIControlStateNormal];
    MyCell.filterBtn.selected = NO;
    MyCell.filterBtn.layer.borderColor = [UIColor fromHexValue:0xCCCCCC].CGColor;
    
    if (indexPath.section == 0) {
        MyCell.filterBtn.tag = (indexPath.item+1)*100;
    }else {
    
        NSArray *array = self.dataSource[indexPath.section-1];
        NSInteger count = array.count;
        MyCell.filterBtn.tag = (count+1+indexPath.item)*100;
    }
    
    MyCell.filterBtnBlock = ^(UIButton *button) {
      
        //已经选中
        if (button.selected) {
            button.selected = NO;
            button.layer.borderColor = [UIColor fromHexValue:0xCCCCCC].CGColor;
            //移除数据
            [self.filters removeObject:[NSString stringWithFormat:@"%ld",button.tag]];
        }else {
            button.selected = YES;
            button.layer.borderColor = [UIColor fromHexValue:0xEA5413].CGColor;
            //添加数据
            [self.filters addObject:[NSString stringWithFormat:@"%ld",button.tag]];
        }
        
        [finishbtn setTitle:[NSString stringWithFormat:@"完成(%ld)",self.filters.count] forState:UIControlStateNormal];
    };
    
    return MyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-40)/3,30);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 10, 15, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if(kind == UICollectionElementKindSectionHeader) {
        FilterHeaderView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"filterHeader" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.headLab.text = @"商品筛选";
        }else {
        
            headerView.headLab.text = @"店铺筛选";
        }
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(kScreenWidth,30);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (_hideFilterView) {
        _hideFilterView();
    }
}

@end
