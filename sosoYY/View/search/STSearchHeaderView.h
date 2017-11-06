//
//  STSearchHeaderView.h
//  my
//
//  Created by soso-mac on 2016/12/7.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface STSearchHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (copy, nonatomic) void(^prodRankBlock)(id sender);
-(void)setSearchHeaderView:(id)result;
@end
