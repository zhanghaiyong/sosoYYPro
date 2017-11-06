//
//  STStorewideFilterCell.m
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideFilterCell.h"


@implementation STStorewideFilterCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        _titleLab = [UILabel new];
        _titleLab.frame = CGRectMake(0, 0, self.frame.size.width, 30);
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor fromHexValue:0x555555 alpha:1];
        [self.contentView addSubview:_titleLab];
    }
    return self;
}
-(void)setFilterIndexPath:(NSIndexPath *)indexPath andTitleAry:(NSArray *)titleAry selectedDict:(NSMutableDictionary *)selectedDict{
    _titleLab.text = titleAry[indexPath.section][indexPath.row];

    switch (indexPath.section) {
        case 0:
            if ([selectedDict[@"producttype"] intValue] == indexPath.row) {
                self.titleLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
                self.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                self.layer.borderWidth = 1.0f;
            }else{
                self.backgroundColor = [UIColor whiteColor];
                self.layer.borderColor = [UIColor whiteColor].CGColor;
                self.layer.borderWidth = 1.0f;
                self.titleLab.textColor = [UIColor fromHexValue:0x555555 alpha:1];
            }
            break;
        case 1:
            if ([selectedDict[@"cuxiao"] intValue] == indexPath.row) {
                self.titleLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
                self.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                self.layer.borderWidth = 1.0f;
            }else{
                self.backgroundColor = [UIColor whiteColor];
                self.layer.borderColor = [UIColor whiteColor].CGColor;
                self.layer.borderWidth = 1.0f;
                self.titleLab.textColor = [UIColor fromHexValue:0x555555 alpha:1];
            }
            break;
        case 2:
            if ([selectedDict[@"GrossMarginRange"] intValue] == indexPath.row) {
                self.titleLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
                self.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                self.layer.borderWidth = 1.0f;
            }else{
                self.backgroundColor = [UIColor whiteColor];
                self.layer.borderColor = [UIColor whiteColor].CGColor;
                self.layer.borderWidth = 1.0f;
                self.titleLab.textColor = [UIColor fromHexValue:0x555555 alpha:1];
            }
            break;
        case 3:
            if ([selectedDict[@"PriceRange"] intValue] == indexPath.row) {
                self.titleLab.textColor = [UIColor fromHexValue:0xea5413 alpha:1];
                self.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                self.layer.borderWidth = 1.0f;
            }else{
                self.backgroundColor = [UIColor whiteColor];
                self.layer.borderColor = [UIColor whiteColor].CGColor;
                self.layer.borderWidth = 1.0f;
                self.titleLab.textColor = [UIColor fromHexValue:0x555555 alpha:1];
            }
            break;
        default:
            break;
    }
}
@end
