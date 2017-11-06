//
//  BlankNoteCell.h
//  sosoYY
//
//  Created by zhy on 2017/8/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;
//药品名
@property (weak, nonatomic) IBOutlet UILabel *produceNameLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *produceNameLabW;
//加价购标签
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addPriceLabWidth;
//规格
@property (weak, nonatomic) IBOutlet UILabel *DrugsLab;
//购买数量
@property (weak, nonatomic) IBOutlet UILabel *buyCountLab;
//特价
@property (weak, nonatomic) IBOutlet UILabel *sepPriceLab;
//原价/加价购说明
@property (weak, nonatomic) IBOutlet UILabel *oriPriceLab;
//删除线
@property (weak, nonatomic) IBOutlet UIView *deleteLine;

@end
