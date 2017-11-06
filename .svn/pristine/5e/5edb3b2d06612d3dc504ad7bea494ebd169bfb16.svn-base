//
//  STWisdomAddListUITableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/6.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STWisdomAddListUITableViewCell;
@protocol STWisdomAddListUITableViewCellDelegate <NSObject>

-(void)g_setSelectBuy:(STWisdomAddListUITableViewCell *)cell;
-(void)g_setTradeBuy:(STWisdomAddListUITableViewCell *)cell;

@end


@interface STWisdomAddListUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *promotionLab;
@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *allianceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIButton *addBuyBtn;

@property (assign, nonatomic)id<STWisdomAddListUITableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *tradeBuy;

-(void)setWisdomAddList:(NSArray *)dataResult indexPath:(NSIndexPath *)indexPath;
@end
