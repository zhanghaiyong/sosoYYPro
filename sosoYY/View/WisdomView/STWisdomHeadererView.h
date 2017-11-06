//
//  STWisdomHeadererView.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/20.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomHeadererView : UIView
@property(copy,nonatomic)void(^WisdomTopBtnBlock)(NSInteger tag);
-(void)setNumStr:(NSString *)numStr type:(NSInteger)type;
@end
