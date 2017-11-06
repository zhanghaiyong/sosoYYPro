//
//  STShopHomeViewCell.h
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShopHomeViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *allianceLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *promotionLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *profitLab;
-(void)setTopHomeIndexPath:(NSIndexPath *)indexPath andTitleAry:(NSMutableArray *)titleAry logIn:(NSString *)logIn type:(NSInteger)type;
@end
