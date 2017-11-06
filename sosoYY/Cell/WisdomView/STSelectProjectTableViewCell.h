//
//  STSelectProjectTableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSelectProjectTableViewCell;
@protocol STSelectProjectTableViewCellDelegate <NSObject>
//减少数字
-(void)g_setSelectBtn:(STSelectProjectTableViewCell *)cell;
@end

@interface STSelectProjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *saveMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timesavingLab;
@property (weak, nonatomic) IBOutlet UILabel *shopNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *productNumLab;
@property (weak, nonatomic) IBOutlet UILabel *postageLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UILabel *moneyCout;
@property (weak, nonatomic) IBOutlet UILabel *timeCount;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;
@property (assign, nonatomic)id<STSelectProjectTableViewCellDelegate>delegate;


-(void)setSelectProject:(NSArray *)arr indexPath:(NSIndexPath *)indexPath selectStr:(NSString *)str;
@end
