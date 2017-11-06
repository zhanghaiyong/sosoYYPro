//
//  STStorewideNavView.h
//  my
//
//  Created by soso-mac on 2016/11/28.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STStorewideNavViewDelegate <NSObject>

@optional
-(void)g_setStorewideSearchText:(NSString *)text;
-(void)g_setStorewideSearchAssociateText:(NSString *)text;
@required
@end

@interface STStorewideNavView : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (assign, nonatomic)id<STStorewideNavViewDelegate>delegate;
-(void)setSearchTextField;
@end
