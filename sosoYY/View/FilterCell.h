//
//  FilterCell.h
//  sosoYY
//
//  Created by zhy on 2017/8/4.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

@property (nonatomic,copy)void(^filterBtnBlock)(UIButton *button);

@end
