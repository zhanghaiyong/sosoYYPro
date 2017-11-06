//
//  STWisdomProcurementTableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STWisdomProcurementTableViewCell;

@protocol STWisdomProcurementTableViewCellDelegate <NSObject>
//减少数字
-(void)g_setSubtract:(STWisdomProcurementTableViewCell *)cell;
//增加数字
-(void)g_setAdd:(STWisdomProcurementTableViewCell *)cell;
//list数字改变
-(void)g_setList:(STWisdomProcurementTableViewCell *)cell;
//手写改变数字
-(void)g_setTextFieldDidBeginEditing:(STWisdomProcurementTableViewCell *)cell;
//手写改变数字成功
-(void)g_setfinished;
//是否勾选品种
-(void)g_setChangeSelect:(STWisdomProcurementTableViewCell *)cell;

@end

@interface STWisdomProcurementTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *standardLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *repertoryLab;
@property (weak, nonatomic) IBOutlet UILabel *salesLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *historyLab;
@property (weak, nonatomic) IBOutlet UILabel *PriceLab;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UILabel *addLab;
@property (weak, nonatomic) IBOutlet UILabel *zhicaiLab;
@property (weak, nonatomic) IBOutlet UILabel *spepriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *linelab;
@property (weak, nonatomic) IBOutlet UILabel *oldLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (assign, nonatomic)id<STWisdomProcurementTableViewCellDelegate>delegate;

-(void)setWisdom:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath textTextFieldAry:(NSMutableArray *)textAry;
@end
