//
//  STWisdomSearchTableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STWisdomSearchTableViewCell;
@protocol STWisdomSearchTableViewCellDelegate <NSObject>

-(void)g_setSearchSelectBuy:(STWisdomSearchTableViewCell *)cell;

@end


@interface STWisdomSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *promotionLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *allianceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *addBuy;
@property (assign, nonatomic)id<STWisdomSearchTableViewCellDelegate>delegate;

-(void)setWisdomSearchDataResult:(NSMutableArray *)dataResult andIndexPath:(NSIndexPath *)indexPath;
@end
