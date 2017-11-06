//
//  STWisdomNotShopTableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>


@class STWisdomNotShopTableViewCell;

@protocol STWisdomNotShopTableViewCellDelegate <NSObject>
//减少数字
-(void)g_setNotSubtract:(STWisdomNotShopTableViewCell *)cell;
//增加数字
-(void)g_setNotAdd:(STWisdomNotShopTableViewCell *)cell;
//list数字改变
-(void)g_setNotList:(STWisdomNotShopTableViewCell *)cell;
//手写改变数字
-(void)g_setNotTextFieldDidBeginEditing:(STWisdomNotShopTableViewCell *)cell;
//手写改变数字成功
-(void)g_setNotFinished:(NSIndexPath *)indexPath;
//是否勾选品种
-(void)g_setNotChangeSelect:(STWisdomNotShopTableViewCell *)cell;

@end

@interface STWisdomNotShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *standardLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *repertoryLab;
@property (weak, nonatomic) IBOutlet UILabel *salesLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *historyLab;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
@property (weak, nonatomic) IBOutlet UILabel *notLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (assign, nonatomic)id<STWisdomNotShopTableViewCellDelegate>delegate;
-(void)setWisdomNotShop:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath;
@end
