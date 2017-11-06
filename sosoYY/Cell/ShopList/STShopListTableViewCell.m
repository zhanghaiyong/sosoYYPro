//
//  STShopListTableViewCell.m
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopListTableViewCell.h"

@implementation STShopListTableViewCell
-(void)setShopList:(NSArray *)arr indexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    _lineLab.frame = CGRectMake(0, 29, kScreenWidth, .5);
    switch (type) {
        case 0:
//            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 5.0f;
            self.titleLab.text = arr[indexPath.row];
            break;
        case 1:
            self.titleLab.text = arr[indexPath.row];
            break;
        default:
            break;
    }
    if (indexPath.row == 1) {
        _lineLab.hidden = YES;
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
