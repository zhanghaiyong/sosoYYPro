//
//  STWisdomNotView.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomNotView.h"

@implementation STWisdomNotView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgV = [UIImageView new];
        imgV.frame = CGRectMake(10, 10, 30, 30);
        imgV.image = [UIImage imageNamed:@"tanhao"];
        [self addSubview:imgV];
        _errorLab = [UILabel new];
        _errorLab.numberOfLines = 0;
        _errorLab.textColor = RGB(119, 119, 119);
        _errorLab.frame = CGRectMake(50, 0, kScreenWidth - 60, 50);
        _errorLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:_errorLab];
        
        UILabel *line = [UILabel new];
        line.frame = CGRectMake(0, 49.5, kScreenWidth, .5);
        line.backgroundColor = [UIColor fromHexValue:0xe5e5e5 alpha:1];
        [self addSubview:line];
    }
    return self;
}
-(void)setError:(NSString *)error{
_errorLab.text = error;
}

@end
