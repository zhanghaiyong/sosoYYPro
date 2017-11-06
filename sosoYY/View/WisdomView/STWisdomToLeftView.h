//
//  STWisdomToLeftView.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/29.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomToLeftView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImgeV;
@property (copy, nonatomic) void(^WisdomToLeftViewBlock)(void);
-(void)setWisdomToLeftView;
@end
