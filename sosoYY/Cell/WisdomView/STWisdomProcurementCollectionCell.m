//
//  STWisdomProcurementCollectionCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomProcurementCollectionCell.h"

@implementation STWisdomProcurementCollectionCell
-(void)setWisdom:(NSMutableArray *)dataArr indexPath:(NSIndexPath *)indexPath{
    
    _nameLab.tag = 1000+indexPath.row;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    self.layer.borderWidth = .5;
    self.layer.cornerRadius = 3.0f;
    _nameLab.text = dataArr[0][indexPath.row];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
