//
//  STListFilterViewCell.h
//  my
//
//  Created by soso-mac on 2016/11/21.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STListFilterViewCell : UICollectionViewCell
@property(strong,nonatomic)UILabel *titleLab;
-(void)setFilterIndexPath:(NSIndexPath *)indexPath andTitleAry:(NSArray *)titleAry productDict:(NSDictionary *)dict;
@end
