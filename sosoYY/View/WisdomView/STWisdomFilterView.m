//
//  STWisdomFilterView.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomFilterView.h"
#import "STWisdomFilterCollectionCell.h"

@interface STWisdomFilterView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,STWisdomFilterCollectionCellDelegate>{
    UILabel *line;
}
@property(strong,nonatomic)UICollectionViewFlowLayout *wisdomFlowL;
@property (strong, nonatomic)UICollectionView *wisdomCollectionView;
@property(strong,nonatomic)NSArray *selectAry;
@property(strong,nonatomic)NSMutableDictionary *selectDict;
@end

@implementation STWisdomFilterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectAry =@[@"全部",@"已选",@"未选"];
        _selectDict = [NSMutableDictionary new];
        [_selectDict setValue:@"1" forKey:@"index1"];
        [_selectDict setValue:@"0" forKey:@"index2"];
        [_selectDict setValue:@"0" forKey:@"index3"];
         [self addSubView];
    }
    return self;
}
-(void)setWisdomFilterViewHieght:(CGFloat)hieght{
    _wisdomCollectionView.frame = CGRectMake(0, 0, kScreenWidth, hieght);
    if (hieght == 40) {
       line.frame = CGRectMake(0, 40, kScreenWidth, 1);
    }else{
       line.frame = CGRectMake(0, 40, kScreenWidth, 0);
    }
}
-(void)addSubView{
    _wisdomFlowL = [UICollectionViewFlowLayout new];
    [_wisdomFlowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _wisdomCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)collectionViewLayout:_wisdomFlowL];
    _wisdomCollectionView.backgroundColor = [UIColor whiteColor];
    _wisdomCollectionView.delegate = self;
    _wisdomCollectionView.dataSource = self;
    [_wisdomCollectionView registerNib:[UINib nibWithNibName:[STWisdomFilterCollectionCell.class description] bundle:nil] forCellWithReuseIdentifier:@"STWisdomFilterCollectionCell"];
    
    [self addSubview:_wisdomCollectionView];
    
    
    line = [UILabel new];
    line.frame = CGRectMake(0, 40, kScreenWidth, .5);
    line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
    [self addSubview:line];
}
#pragma mark --UICollectionView dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _selectAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    STWisdomFilterCollectionCell *MyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STWisdomFilterCollectionCell" forIndexPath:indexPath];
    MyCell.delegate = self;
    [MyCell setWisdomFilter:_selectAry selectedDict: _selectDict indexPath:indexPath];
    return MyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 40)/3 - 5,30);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark - STWisdomFilterCollectionCellDelegate
-(void)g_WisdomFilterCollection:(STWisdomFilterCollectionCell *)cell{
    
       NSIndexPath *indexPath = [_wisdomCollectionView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 0:
            [_selectDict setValue:@"1" forKey:@"index1"];
            [_selectDict setValue:@"0" forKey:@"index2"];
            [_selectDict setValue:@"0" forKey:@"index3"];
            break;
        case 1:
            [_selectDict setValue:@"0" forKey:@"index1"];
            [_selectDict setValue:@"1" forKey:@"index2"];
            [_selectDict setValue:@"0" forKey:@"index3"];
            break;
        case 2:
            [_selectDict setValue:@"0" forKey:@"index1"];
            [_selectDict setValue:@"0" forKey:@"index2"];
            [_selectDict setValue:@"1" forKey:@"index3"];
            break;
            
        default:
            break;
    }
    
    [_wisdomCollectionView reloadData];
    
 
    
    if (_WisdomFilterViewBlock != nil) {
        _WisdomFilterViewBlock(indexPath.row);
    }
}

@end
