//
//  STSearchTabelHeaderView.h
//  my
//
//  Created by soso-mac on 2016/12/29.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSearchTabelHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
-(void)setSearchTabelHeaderView:(id)result imges:(NSArray *)imges section:(NSInteger)section;
@end
