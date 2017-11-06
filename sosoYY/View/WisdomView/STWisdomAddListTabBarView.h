//
//  STWisdomAddListTabBarView.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomAddListTabBarView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
-(void)setWisdomAddListTabBarView:(STStorewideEntity *)entity;
@property(copy,nonatomic)void(^wisdomAddListTabBarViewBlock)(void);
@end
