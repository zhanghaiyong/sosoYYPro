//
//  STWisdomFilterCollectionCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomFilterCollectionCell.h"

@implementation STWisdomFilterCollectionCell
-(void)setWisdomFilter:(NSArray *)arr selectedDict:(NSMutableDictionary *)dict indexPath:(NSIndexPath *)indexPath{

    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    
    switch (indexPath.row) {
        case 0:
            if ([dict[@"index1"] intValue] == 0) {
            
                self.layer.borderColor = [UIColor fromHexValue:0x555555 alpha:1].CGColor;
                self.layer.borderWidth = 1;
                
                [_titleBtn setTitleColor:[UIColor fromHexValue:0x555555 alpha:1] forState:UIControlStateNormal];
                [_titleBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
                [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }else{
                self.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                self.layer.borderWidth = 1;
                
                [_titleBtn setTitleColor:[UIColor fromHexValue:0xea5413 alpha:1] forState:UIControlStateNormal];
                [_titleBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                
                [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            }
            break;
            
        case 1:
            if ([dict[@"index2"] intValue] == 0) {
                self.layer.borderColor = [UIColor fromHexValue:0x555555 alpha:1].CGColor;
                self.layer.borderWidth = 1;
                
                [_titleBtn setTitleColor:[UIColor fromHexValue:0x555555 alpha:1] forState:UIControlStateNormal];
                [_titleBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
                [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }else{
                self.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                self.layer.borderWidth = 1;
                
               [_titleBtn setTitleColor:[UIColor fromHexValue:0xea5413 alpha:1] forState:UIControlStateNormal];
                [_titleBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                
                [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            }
            break;
            
        case 2:
            if ([dict[@"index3"] intValue] == 0) {
                self.layer.borderColor = [UIColor fromHexValue:0x555555 alpha:1].CGColor;
                self.layer.borderWidth = 1;
                
                [_titleBtn setTitleColor:[UIColor fromHexValue:0x555555 alpha:1] forState:UIControlStateNormal];
                [_titleBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
                [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }else{
                self.layer.borderColor = [UIColor fromHexValue:0xea5413 alpha:1].CGColor;
                self.layer.borderWidth = 1;
                
                [_titleBtn setTitleColor:[UIColor fromHexValue:0xea5413 alpha:1] forState:UIControlStateNormal];
                [_titleBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                
                [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            }
            break;
            
        default:
            break;
    }
    
    [_titleBtn setTitle:arr[indexPath.row] forState:UIControlStateNormal];
}
- (IBAction)selectedBtn:(UIButton *)sender {
    
    STWisdomFilterCollectionCell *cell = (STWisdomFilterCollectionCell *)[[sender superview]superview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(g_WisdomFilterCollection:)]) {
        [_delegate g_WisdomFilterCollection:cell];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
