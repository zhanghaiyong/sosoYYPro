//
//  STShopCartSearchArtificialTableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/8/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STShopCartSearchArtificialTableViewCell;

@protocol STShopCartSearchArtificialTableViewCellDelegate <NSObject>

@optional
//计入计划
-(void)g_AddMothed:(STShopCartSearchArtificialTableViewCell *)cell;
@required

@end

@interface STShopCartSearchArtificialTableViewCell : UITableViewCell
//药名
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
//规格
@property (weak, nonatomic) IBOutlet UILabel *specificationsLab;
//效期
@property (weak, nonatomic) IBOutlet UILabel *effectiveLab;
//日期

//加入计划
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property(assign,nonatomic)id<STShopCartSearchArtificialTableViewCellDelegate>delegate;
-(void)setShopCartSearchArtificial:(STShopCartSeachEntity *)entity indexPath:(NSIndexPath *)indexPath;
@end
