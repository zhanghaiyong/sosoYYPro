//
//  STWisdomAddListBtnView.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol STWisdomAddListBtnViewDelegate <NSObject>
@optional
-(void)g_setWisdomAddListBtnTag:(NSInteger)tag andSelected:(BOOL)isSelected;
@required
@end

@interface STWisdomAddListBtnView : UIView
@property(assign,nonatomic)id<STWisdomAddListBtnViewDelegate>delegate;
@end
