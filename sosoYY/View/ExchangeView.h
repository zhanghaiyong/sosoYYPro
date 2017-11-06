//
//  ExchangeView.h
//  sosoYY
//
//  Created by zhy on 17/3/6.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiModel.h"

@interface ExchangeView : UIView

@property (nonatomic,strong)LiModel *liModel;
@property (nonatomic,strong)NSString *pmid;
@property (nonatomic ,copy)void(^removeExchangeView)(ExchangeView *view);

@property (nonatomic,copy)void(^selectExchangeGoodBlock)(BOOL isCancle);

@end
