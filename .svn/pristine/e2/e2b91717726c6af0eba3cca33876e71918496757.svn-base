//
//  STStorewideFilterHeadView.m
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideFilterHeadView.h"
@implementation STStorewideFilterHeadView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}
-(void)setFilterTitle:(NSString *)title andIndex:(NSInteger)index{
    _titleLab = [[UILabel alloc]init];
    _titleLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _titleLab.userInteractionEnabled = YES;
    _titleLab.frame = CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height);
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.numberOfLines = 0;
    _titleLab.text = title;
    _titleLab.tag = index;
    _titleLab.textColor = [UIColor fromHexValue:0x333333 alpha:1];
    _titleLab.font = [UIFont systemFontOfSize:18];
    [self addSubview:_titleLab];
}

@end
