//
//  STShopCartSeachTableViewCell.h
//  sosoYY
//
//  Created by soso-mac on 2017/8/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STShopCartSeachTableViewCell;


@protocol STShopCartSeachTableViewCellDelegate <NSObject>

@optional
//选中
-(void)g_SelectMothed:(STShopCartSeachTableViewCell *)cell;
//改变数量
-(void)g_ChangeNumMothed:(STShopCartSeachTableViewCell *)cell;

//下拉菜单
-(void)g_ListMothed:(STShopCartSeachTableViewCell *)cell;

//去换购
-(void)g_GoMothed:(STShopCartSeachTableViewCell *)cell;
@required
@end


@interface STShopCartSeachTableViewCell : UITableViewCell
//选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//改变数字按钮
@property (weak, nonatomic) IBOutlet UIButton *numBtn;
//下啦按钮
@property (weak, nonatomic) IBOutlet UIButton *listBtn;
//药名
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
//规格
@property (weak, nonatomic) IBOutlet UILabel *specificationsLab;
//效期
@property (weak, nonatomic) IBOutlet UILabel *effectiveLab;
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
//我的内容
@property (weak, nonatomic) IBOutlet UILabel *myContentLab;
//特价限购内容
@property (weak, nonatomic) IBOutlet UILabel *specialContentLab;
//符合条件内容
@property (weak, nonatomic) IBOutlet UILabel *ontentLab;
//加价购内容
@property (weak, nonatomic) IBOutlet UILabel *addContentLab;


//去换购药名
@property (weak, nonatomic) IBOutlet UILabel *goNameLab;
//去换购规格
@property (weak, nonatomic) IBOutlet UILabel *goSpecificationsLab;
//去换购公司
@property (weak, nonatomic) IBOutlet UILabel *goComPly;
//去换购效期
@property (weak, nonatomic) IBOutlet UILabel *goEffectiveLab;
//去换购数量
@property (weak, nonatomic) IBOutlet UILabel *goNumLab;





@property (weak, nonatomic) IBOutlet UILabel *duanLine;


@property(assign,nonatomic)id<STShopCartSeachTableViewCellDelegate>delegate;

-(void)setShopCartSeach:(STShopCartSeachEntity *)entity indexPath:(NSIndexPath *)indexPath;
@end