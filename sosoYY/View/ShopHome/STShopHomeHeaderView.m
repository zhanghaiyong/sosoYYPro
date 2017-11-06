//
//  STShopHomeHeaderView.m
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopHomeHeaderView.h"

@interface STShopHomeHeaderView (){
    NSInteger indexCount;
}
@property (weak, nonatomic) IBOutlet UILabel *moreLab;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@end

@implementation STShopHomeHeaderView
-(void)setShopHomeHeaderView:(NSInteger)index{
    indexCount = index;
    if (index <= 6) {
        _moreLab.hidden = YES;
        _rightImageV.hidden = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)popularityBtn:(UIButton *)sender {
    if (indexCount > 6) {
        if (self.popularityBlock) {
            self.popularityBlock(@"0");
        }
    }
}
@end
