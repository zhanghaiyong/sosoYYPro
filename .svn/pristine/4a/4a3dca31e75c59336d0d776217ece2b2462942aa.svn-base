//
//  STWisdomShopTableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/2/9.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STWisdomShopTableViewCell;

@protocol STWisdomShopTableViewCellDelegate <NSObject>
//加入计划
-(void)g_setPlanSelect:(STWisdomShopTableViewCell *)cell;
@end

@interface STWisdomShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *standardLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *repertoryLab;
@property (weak, nonatomic) IBOutlet UILabel *salesLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *historyLab;
@property (weak, nonatomic) IBOutlet UILabel *PriceLab;
@property (weak, nonatomic) IBOutlet UIButton *planBtn;
@property (assign, nonatomic)id<STWisdomShopTableViewCellDelegate>delegate;
-(void)setWisdomShop:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath;
@end
