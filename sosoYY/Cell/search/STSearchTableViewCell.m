//
//  STSearchTableViewCell.m
//  my
//
//  Created by soso-mac on 2016/12/7.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STSearchTableViewCell.h"

@implementation STSearchTableViewCell

-(void)setSearchDataResult:(NSMutableArray *)dataResult selectedDict:(NSMutableDictionary *)selectedDict indexPath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.contentView.backgroundColor = [UIColor fromHexValue:0xebebeb alpha:1];
  
    _titleLab.text = [dataResult[indexPath.row] CateName];
    
    if ([selectedDict[@"Group"] intValue] == indexPath.section) {
        if ([selectedDict[@"selected"] intValue] == indexPath.row) {
            self.contentView.backgroundColor = [UIColor fromHexValue:0xffffff alpha:1];
            _titleLab.textColor =  [UIColor fromHexValue:0xea5413 alpha:1];
        }
    }
}
-(void)setSearchListTitleAry:(NSMutableArray *)titleAry indexPath:(NSIndexPath *)indexPath{
//   _titleLab.text = titleAry[indexPath.row];
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
