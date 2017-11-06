//
//  STWisdomProcurementCollectionCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomProcurementCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
-(void)setWisdom:(NSMutableArray *)dataArr indexPath:(NSIndexPath *)indexPath;
@end
