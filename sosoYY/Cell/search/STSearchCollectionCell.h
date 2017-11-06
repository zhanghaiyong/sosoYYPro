//
//  STSearchCollectionCell.h
//  my
//
//  Created by soso-mac on 2016/12/7.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSearchCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
-(void)setSearch:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath;
@end
