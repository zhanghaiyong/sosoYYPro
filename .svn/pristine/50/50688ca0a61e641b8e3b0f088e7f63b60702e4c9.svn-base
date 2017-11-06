//
//  STProductSearchCell.m
//  sosoYY
//
//  Created by soso-mac on 2016/11/30.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "STProductSearchCell.h"

@implementation STProductSearchCell
-(void)setProductSearch:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    if (arr.count != 0) {
        self.nameLab.text = arr[indexPath.row];
    }
    _lineLab.frame = CGRectMake(0, 29, kScreenWidth, .5);
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
