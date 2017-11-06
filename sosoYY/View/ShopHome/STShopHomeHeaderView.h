//
//  STShopHomeHeaderView.h
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShopHomeHeaderView : UICollectionReusableView
@property (copy, nonatomic) void(^popularityBlock)(id sender);
-(void)setShopHomeHeaderView:(NSInteger)index;
@end
