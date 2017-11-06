//
//  STSearchTabelHeaderView.m
//  my
//
//  Created by soso-mac on 2016/12/29.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STSearchTabelHeaderView.h"

@implementation STSearchTabelHeaderView

-(void)setSearchTabelHeaderView:(id)result imges:(NSArray *)imges section:(NSInteger)section{
    _nameLab.text = [result[section] GroupCateName];
    _ImageView.image = [UIImage imageNamed:imges[section]];
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(3, 39, kScreenWidth, 0.5);
    line.backgroundColor = [UIColor fromHexValue:0xcccccc alpha:1];
    [self addSubview:line];
}

@end
