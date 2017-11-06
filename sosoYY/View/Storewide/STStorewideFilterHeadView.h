//
//  STStorewideFilterHeadView.h
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStorewideFilterHeadView : UICollectionReusableView
@property(strong,nonatomic)UILabel *titleLab;
-(void)setFilterTitle:(NSString *)title andIndex:(NSInteger)index;
@end
