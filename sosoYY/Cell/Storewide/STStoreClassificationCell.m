//
//  STStoreClassificationCell.m
//  sosoYY
//
//  Created by soso-mac on 2016/12/1.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "STStoreClassificationCell.h"

@implementation STStoreClassificationCell
-(void)setStoreClassification:(NSMutableArray *)arr indexpath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == 0) {
        _nameLab.text = [NSString stringWithFormat:@"全部分类(%@)",[arr[0] CountAll]];
    }else{
      _nameLab.text = [NSString stringWithFormat:@"%@(%@)",[arr[indexPath.row] CateName],[arr[indexPath.row] CateCountAll]];
    }
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
