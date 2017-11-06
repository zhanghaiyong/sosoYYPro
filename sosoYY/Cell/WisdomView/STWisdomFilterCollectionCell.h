//
//  STWisdomFilterCollectionCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/5/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>


@class STWisdomFilterCollectionCell;

@protocol STWisdomFilterCollectionCellDelegate <NSObject>

-(void)g_WisdomFilterCollection:(STWisdomFilterCollectionCell *)cell;

@end



@interface STWisdomFilterCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property(assign,nonatomic)id<STWisdomFilterCollectionCellDelegate>delegate;
-(void)setWisdomFilter:(NSArray *)arr selectedDict:(NSMutableDictionary *)dict indexPath:(NSIndexPath *)indexPath;
@end
