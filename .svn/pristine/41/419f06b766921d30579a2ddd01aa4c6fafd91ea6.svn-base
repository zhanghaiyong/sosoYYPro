//
//  STSelectProjectHeaderView.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STSelectProjectHeaderView.h"

@implementation STSelectProjectHeaderView

-(void)setSelectProject:(NSMutableArray *)arr index:(NSInteger)index{
    _projectNameLab.text = [NSString stringWithFormat:@"%@",[arr[index]SchemeName]];
     _numLab.text = [NSString stringWithFormat:@"%@个商品低于原采购价,\n为您节省",[arr[index]SuperiorityNum]];
     _timeLab.text = @"为您节省采购时间";
    __weak STSelectProjectHeaderView *weakSelf = self;
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12",@"num":@"1"},@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"20"}] andChengeString:[NSString stringWithFormat:@"¥ %.2f",[[arr[index]EconomizeMoney]floatValue]] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.numPirce.attributedText = string;
    }];
    NSString *timeCountStr =  [NSString stringWithFormat:@"%zi",[NSString stringWithFormat:@"%@ 小时",[arr[index]EconomizeTime]].length - 3];
    
    [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"20",@"num":timeCountStr},@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"12"}] andChengeString:[NSString stringWithFormat:@"%@小时",[arr[index]EconomizeTime]] type:1 andFinished:^(NSMutableAttributedString *string) {
        weakSelf.timeCount.attributedText = string;
    }];
    
    _line.frame = CGRectMake(0, 131, kScreenWidth, .5);
}

@end
