//
//  STSearchCollectionCell.m
//  my
//
//  Created by soso-mac on 2016/12/7.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STSearchCollectionCell.h"
@implementation STSearchCollectionCell
-(void)setSearch:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = .25f;
    self.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;

    if (arr.count % 2 == 0) {
        _nameLab.text = [arr[indexPath.row] CateName];
        [_imageView st_setImageWithURLString:[arr[indexPath.row] ImagesUrl]  placeholderImage:@"stance"];
    }else{
        if (indexPath.row == arr.count) {
            _nameLab.text = @"";
            [_imageView st_setImageWithURLString:@""  placeholderImage:@""];
        }else{
            _nameLab.text = [arr[indexPath.row ] CateName];
            [_imageView st_setImageWithURLString:[arr[indexPath.row] ImagesUrl]  placeholderImage:@"stance"];
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
