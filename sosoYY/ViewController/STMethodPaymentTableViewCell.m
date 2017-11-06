//
//  STMethodPaymentTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/26.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STMethodPaymentTableViewCell.h"

@implementation STMethodPaymentTableViewCell
-(void)setMethodPayment:(NSArray *)arr indexPath:(NSIndexPath *)indexPath{
    _imgV.image = [UIImage imageNamed:arr[indexPath.section][indexPath.row][@"img"]];
    _titleLab.text = arr[indexPath.section][indexPath.row][@"title"];
    _detaileLab.text = arr[indexPath.section][indexPath.row][@"detaile"];
    _lineLab.frame = CGRectMake(0, 59, kScreenWidth, .5);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
