//
//  ShopCartCell.h
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//

//进入商品详情
typedef void(^toProDetailBlock)(void);
//删除商品
typedef void(^deleteProBlock)(void);
//添加/减少数量
typedef void(^add_reduceCountBlock)(double count);
typedef void(^CellSelectBlock)(NSString *select);
typedef void(^JJGSwitchBlock)(BOOL boo);

#import <UIKit/UIKit.h>
#import "OrderProductInfoModel.h"
@interface ShopCartCell : UITableViewCell<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)NSString *oldCount;

#pragma mark 加价购
//加价购提示view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GiftViewH;
//提示
@property (weak, nonatomic) IBOutlet UILabel *jjgLabel;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *jjgImg;
//名字
@property (weak, nonatomic) IBOutlet UILabel *jjgName;
//药铺
@property (weak, nonatomic) IBOutlet UILabel *jjgStore;
//规格
@property (weak, nonatomic) IBOutlet UILabel *jjgspecification;
//数量
@property (weak, nonatomic) IBOutlet UILabel *jjgCount;
//展示加价购商品View的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jjgH;
//加价购开关
@property (weak, nonatomic) IBOutlet UISwitch *switchCtrl;
- (IBAction)jjgAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *alpButton;
//商品数据
@property (nonatomic,strong)OrderProductInfoModel *OrderProductInfo;
//商品选择按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//商品数量
@property (weak, nonatomic) IBOutlet UITextField *countLabel;
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
//商品单位
@property (weak, nonatomic) IBOutlet UITextField *uintLabel;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
//店铺名称
@property (weak, nonatomic) IBOutlet UILabel *storeName;
//商品规格
@property (weak, nonatomic) IBOutlet UILabel *specification;
//商品单价
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

//查看商品详情Action
@property (nonatomic,copy)toProDetailBlock detailBlock;
//商品商品Action
@property (nonatomic,copy)deleteProBlock  deleteBlock;
//修改商品数量Action
@property (nonatomic,copy)add_reduceCountBlock  add_reduceBlock;
//选择商品Action
@property (nonatomic,copy)CellSelectBlock  cellSelectBlock;
//加价购Action
@property (nonatomic,copy)JJGSwitchBlock  JJGBlock;

- (void)add_reduceCountMethod:(add_reduceCountBlock)block;
- (void)cellSelectGoodMethod:(CellSelectBlock)block;
- (void)toProDetailMethod:(toProDetailBlock)block;
- (void)deleteProMethod:(deleteProBlock)block;
- (void)JJGSwitchMethod:(JJGSwitchBlock)block;

//特价
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SALEViewH;
@property (weak, nonatomic) IBOutlet UILabel *SALE_Alert;
//原价
@property (weak, nonatomic) IBOutlet UILabel *oriGoodsPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oriGoodsPriceH;
@property (weak, nonatomic) IBOutlet UIView *deleteOriPriceLine;


- (IBAction)selectAction:(id)sender;
- (IBAction)deleteProAction:(id)sender;

@end
