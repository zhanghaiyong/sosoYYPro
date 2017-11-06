//
//  ImportView.h
//  sosoYY
//
//  Created by zhy on 2017/5/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiModel.h"
#import "STShopCartSeachEntity.h"
@interface ImportView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)LiModel *goodModel;

@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//增加减少block
@property (nonatomic,copy)void(^WisdomAdd_reduceBlock)(double count);

@property (nonatomic,copy)void (^deleteImportBlock)(void);

@end
