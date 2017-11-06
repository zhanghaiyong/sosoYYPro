//
//  STWisdomWeedOutView.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/6.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomWeedOutView : UIView
@property(copy,nonatomic)void(^WisdomWeedOutViewBlock)(void);
@property(strong,nonatomic)UILabel *numLab;
@end
