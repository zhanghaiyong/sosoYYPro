//
//  STShopInfoCell.m
//  my
//
//  Created by soso-mac on 2016/12/19.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopInfoCell.h"
#import "STCommon.h"

@implementation STShopInfoCell
-(void)setShopInfo:(id)arr indexPath:(NSIndexPath *)indexPath{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    __weak  STShopInfoCell *weakSelf  =  self;
    
    switch (indexPath.row) {
        case 0:{
            _nameLab.text = [NSString stringWithFormat:@"公司名称:%@",arr[indexPath.row]];
            break;
        }
        case 1:{
              _nameLab.text = [NSString stringWithFormat:@"联系人:%@",arr[indexPath.row]];
            break;
        }
        case 2:{
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"3"},@{@"color":[UIColor fromHexValue:0x337ab7 alpha:1],@"font":@"14",@"num":@"3"}] andChengeString:[NSString stringWithFormat:@"座机:%@",arr[indexPath.row]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.nameLab.attributedText = string;
            }];
            break;
        }
        case 3:{
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"3"},@{@"color":[UIColor fromHexValue:0x337ab7 alpha:1],@"font":@"14",@"num":@"3"}] andChengeString:[NSString stringWithFormat:@"电话:%@",arr[indexPath.row]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.nameLab.attributedText = string;
            }];
            break;
        }
        case 4:{
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x333333 alpha:1],@"font":@"14",@"num":@"5"},@{@"color":[UIColor fromHexValue:0x337ab7 alpha:1],@"font":@"14",@"num":@"5"}] andChengeString:[NSString stringWithFormat:@"联系QQ:%@",arr[indexPath.row]] type:1 andFinished:^(NSMutableAttributedString *string) {
                weakSelf.nameLab.attributedText = string;
            }];
            break;
        }
        case 5:{
              _nameLab.text = [NSString stringWithFormat:@"地址:%@",arr[indexPath.row]];
            break;
        }
        default:
            break;
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