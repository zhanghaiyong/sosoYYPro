//
//  WisdomCell.h
//  sosoYY
//
//  Created by zhy on 17/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiModel.h"

@interface WisdomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MyViewH;

@property(nonatomic,strong)LiModel *goodModel;
//@property (weak, nonatomic) IBOutlet UILabel *myStock;

//商品名称
@property (weak, nonatomic) IBOutlet UILabel *GoodName;
//商品规格
@property (weak, nonatomic) IBOutlet UILabel *GoodSPEC;
//库存
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
//月销
@property (weak, nonatomic) IBOutlet UILabel *SalesVolume;
////参考价
//@property (weak, nonatomic) IBOutlet UILabel *historyPrice;
////最近采购
//@property (weak, nonatomic) IBOutlet UILabel *LastTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sprcialIdentyW;

//有效期
@property (weak, nonatomic) IBOutlet UILabel *GoodTime;

//价钱
@property (weak, nonatomic) IBOutlet UILabel *GoodPrice;
//采购数量
@property (weak, nonatomic) IBOutlet UIButton *countButton;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

    
@property (nonatomic,strong)NSString *selectNumOflist;

//推荐采购数量
@property (nonatomic,copy)void(^showCollectionBlock)(void);

//选择主商品
@property (nonatomic,copy)void(^selectGoodBlock)(BOOL selectStatus);

@property (weak, nonatomic) IBOutlet UILabel *Good__Price;
@property (weak, nonatomic) IBOutlet UIView  *middleLine;

#pragma mark 提示
//提示文字
@property (weak, nonatomic) IBOutlet UILabel  *AlertLabel;
//提示view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AlertH;
//特价//限购标签
@property (weak ,nonatomic) IBOutlet UILabel  *flagLabel;
//标签宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagLabelW;
//换购按钮
@property (weak ,nonatomic) IBOutlet NSLayoutConstraint *exchangeBtnW;

//增加减少block
@property (nonatomic,copy)void(^WisdomAdd_reduceBlock)(double count);

//提示文字
@property (weak, nonatomic) IBOutlet UILabel  *otherAlertLabel;
//提示view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherAlertLabelH;

//手动添加的宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleAddW;

//换购商品底层view高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exchangeViewH;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
//换购商品名称
@property (weak ,nonatomic)IBOutlet UILabel *exchangeGoodName;
//换购商品公司名称
@property (weak ,nonatomic)IBOutlet UILabel *exchangeProduceName;
//换购商品规格
@property (weak ,nonatomic)IBOutlet UILabel *exchangeGoodSPEC;
//换购商品效期
@property (weak ,nonatomic)IBOutlet UILabel *exchangeTime;
//换购商品数量
@property (weak ,nonatomic)IBOutlet UILabel *exchangeGoodCount;
//显示换购商品
@property (nonatomic,copy)void(^showExchangeViewBlock)(void);
@property (nonatomic,copy)void(^showImportViewBlock)(void);
@end
