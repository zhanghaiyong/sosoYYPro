//
//  STPaymentDetailsImgTableViewCell.m
//  sosoYY
//
//  Created by soso-mac on 2017/5/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STPaymentDetailsImgTableViewCell.h"

@implementation STPaymentDetailsImgTableViewCell
-(void)setPaymentDetailsImg:(NSMutableArray *)ary indexPath:(NSIndexPath *)indexPath{
    
    _numLab.text = [NSString stringWithFormat:@"共%zi个商品",ary.count];
    
    if (ary.count >= 3) {
        
        [_imgVA st_setImageWithURLString:[ary[0] SmallImageUrl] placeholderImage:@"stance"];
        
        [_imgVB st_setImageWithURLString:[ary[1] SmallImageUrl] placeholderImage:@"stance"];
        
        [_imgVC st_setImageWithURLString:[ary[2] SmallImageUrl] placeholderImage:@"stance"];
        
        
    }else if(ary.count > 1 && ary.count < 3){
        
        
        [_imgVA st_setImageWithURLString:[ary[0] SmallImageUrl] placeholderImage:@"stance"];
        
        [_imgVB st_setImageWithURLString:[ary[1] SmallImageUrl] placeholderImage:@"stance"];
        
        _imgVC.hidden = YES;
        
    }else if(ary.count > 0 && ary.count < 2){
        
        [_imgVA st_setImageWithURLString:[ary[0] SmallImageUrl] placeholderImage:@"stance"];
        
        _imgVC.hidden = YES;
        
        _imgVB.hidden = YES;
        
    }
    
    UITapGestureRecognizer *tapA = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorImgVA)];
    [_imgVA addGestureRecognizer:tapA];
    
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorImgVB)];
    [_imgVB addGestureRecognizer:tapB];
    
    UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorImgVC)];
    [_imgVC addGestureRecognizer:tapC];
}


-(void)selectorImgVA{
    if (_selectorImgVBlock) {
        _selectorImgVBlock(0);
    }
}

-(void)selectorImgVB{
    if (_selectorImgVBlock) {
        _selectorImgVBlock(1);
    }
}

-(void)selectorImgVC{
    if (_selectorImgVBlock) {
        _selectorImgVBlock(2);
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
