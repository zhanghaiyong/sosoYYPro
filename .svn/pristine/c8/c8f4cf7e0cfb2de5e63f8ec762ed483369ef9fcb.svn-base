//
//  STShopInfoHeaderView.h
//  my
//
//  Created by soso-mac on 2016/12/19.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STShopInfoHeaderViewDelegate <NSObject>

-(void)g_setInfoLogin:(void(^)(BOOL isLogin))finshed;

@end

@interface STShopInfoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *concernLab;
@property (weak, nonatomic) IBOutlet UIImageView *concernImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property(assign,nonatomic)id<STShopInfoHeaderViewDelegate>delegate;
-(void)setShopInfoHeader:(id)dataResult;
@end
