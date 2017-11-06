//
//  FilterCollectionView.h
//  sosoYY
//
//  Created by zhy on 2017/8/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

@property (nonatomic,copy)void(^finishBlock)(NSArray *filters);
@property (nonatomic,copy)void(^hideFilterView)(void);

@end
