//
//  STStorewideBgView.h
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStorewideBgView : UIView

-(instancetype)initWithFrame:(CGRect)frame typeDict:(NSDictionary *)typeDict;
-(void)viewWillAppear;
-(void)storewideTextFieldResignFirstResponder;
@end
