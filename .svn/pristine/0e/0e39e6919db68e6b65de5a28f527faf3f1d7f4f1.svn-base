//
//  STStorewideBtnView.h
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STStorewideBtnViewDelegate <NSObject>
@optional
-(void)g_setStorewideSelectBtnTag:(NSInteger)tag andSelected:(BOOL)isSelected;
@required
@end

@interface STStorewideBtnView : UIView
@property(assign,nonatomic)id<STStorewideBtnViewDelegate>delegate;
-(void)setsynthesizeBtnTitle:(NSString *)text;
@end
