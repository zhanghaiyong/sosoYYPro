//
//  STStoreTableViewCell.h
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface STStoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *addPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *redemptionLab;
@property (weak, nonatomic) IBOutlet UIImageView *nextImgV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *pinkageLab;
@property (weak, nonatomic) IBOutlet UILabel *invoiceLab;
@property (weak, nonatomic) IBOutlet UIImageView *iouImg;

-(void)setStoreDataResult:(NSMutableArray *)dataResult andIndexPath:(NSIndexPath *)indexPath;
@end