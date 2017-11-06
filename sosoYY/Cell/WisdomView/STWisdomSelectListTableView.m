//
//  STWisdomSelectListTableView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/6.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomSelectListTableView.h"

@implementation STWisdomSelectListTableView
-(void)setWisdomSelectList:(id)arr indexPath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0f;
    
    switch (indexPath.row) {
        case 0:
            self.imgV.image = [UIImage imageNamed:@"listA"];
            self.namelab.text = @"淘汰品种列表";
            break;
        case 1:
            self.imgV.image = [UIImage imageNamed:@"help"];
            self.namelab.text = @"帮助";
            break;
        default:
            break;
    }
    _lineLab.frame = CGRectMake(0, 39, kScreenWidth, .5);
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
