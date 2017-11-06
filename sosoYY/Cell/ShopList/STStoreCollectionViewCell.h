//
//  STStoreCollectionViewCell.h
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStoreCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLabl;
-(void)setStoreCollection:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath;
@end
