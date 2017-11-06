//
//  WisdomHead.h
//  sosoYY
//
//  Created by zhy on 17/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WisdomModel;
@interface WisdomHead : UIView<UIAlertViewDelegate>


//药店名称
@property (weak, nonatomic) IBOutlet UILabel *StoreName;
@property (nonatomic,assign)double sectionCash;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeNameW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lousImgW;

//店铺或者选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectbtn;
@property (weak, nonatomic) IBOutlet UILabel *identifyLabel;

@property (nonatomic,strong)WisdomModel *wisdomModel;
@property (nonatomic,assign)BOOL haveSelectGood;


@property (weak, nonatomic) IBOutlet UILabel *content;

//选择
@property (nonatomic,copy)void(^headSelectBlock)(BOOL headSelectStatus);

//凑单
@property (nonatomic,copy)void(^toCollectBlock)(void);


@end