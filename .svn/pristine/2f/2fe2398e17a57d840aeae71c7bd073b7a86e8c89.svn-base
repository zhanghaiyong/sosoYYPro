//
//  STListBtnView.h
//  my
//
//  Created by soso-mac on 2016/11/21.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STListBtnViewDelegate <NSObject>
@optional
-(void)g_setSelectBtnTag:(NSInteger)tag andSelected:(BOOL)isSelected;
@required
@end

@interface STListBtnView : UIView
@property(assign,nonatomic)id<STListBtnViewDelegate>delegate;
-(void)setsynthesizeBtnTitle:(NSString *)text;
@end
