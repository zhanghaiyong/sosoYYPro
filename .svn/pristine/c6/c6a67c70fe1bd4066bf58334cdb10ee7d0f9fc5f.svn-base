//
//  STListNavView.h
//  my
//
//  Created by soso-mac on 2016/11/22.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STListNavViewDelegate <NSObject>

-(void)g_setListShopHidden;
-(void)g_setSearchSelectedText:(NSString *)text;
-(void)g_setSearchAssociateText:(NSString *)text;
-(void)g_setSearchFieldDidBeginEditing;
@end

@interface STListNavView : UIView

@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (assign, nonatomic)  id <STListNavViewDelegate>delegate;
-(void)setChaneShopBtnTitle:(NSString *)title;
-(void)setSearchTextField;
@end
