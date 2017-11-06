//
//  STStorewideFilterCell.h
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStorewideFilterCell : UICollectionViewCell
@property(strong,nonatomic)UILabel *titleLab;
-(void)setFilterIndexPath:(NSIndexPath *)indexPath andTitleAry:(NSArray *)titleAry selectedDict:(NSMutableDictionary *)selectedDict;
@end
