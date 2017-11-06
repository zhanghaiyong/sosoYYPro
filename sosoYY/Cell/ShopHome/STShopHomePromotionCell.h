//
//  STShopHomePromotionCell.h
//  my
//
//  Created by soso-mac on 2016/12/16.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShopHomePromotionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *allianceLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *profitLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *newePriceLab;
@property (weak, nonatomic)IBOutlet  UILabel *lineLab;

-(void)setTopHomePromotionIndexPath:(NSIndexPath *)indexPath andTitleAry:(NSMutableArray *)titleAry logIn:(NSString *)logIn;
@end
