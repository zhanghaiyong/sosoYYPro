//
//  STStoreCollectionViewCell.m
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStoreCollectionViewCell.h"

@implementation STStoreCollectionViewCell
-(void)setStoreCollection:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath{
    [_imgV st_setImageWithURLString:[arr[indexPath.row] imageNmae] placeholderImage:@"stance"];
    if ([[arr[indexPath.row] shopprice] intValue] == -1) {
      _priceLab.text = @"登录可见";
    }else{
        _priceLab.text = [NSString stringWithFormat:@"¥%.2f",[[arr[indexPath.row] shopprice] floatValue]];
    }
     _nameLabl.text = [arr[indexPath.row] DrugsBase_DrugName];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
