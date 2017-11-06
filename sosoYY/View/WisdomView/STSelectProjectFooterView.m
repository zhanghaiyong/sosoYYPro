//
//  STSelectProjectFooterView.m
//  sosoYY
//
//  Created by soso-mac on 2017/1/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STSelectProjectFooterView.h"

@implementation STSelectProjectFooterView
-(void)setSelectProjectFooter{
    _selectBtn.layer.masksToBounds = YES;
    _selectBtn.layer.borderWidth = .5;
    _selectBtn.layer.borderColor = [UIColor fromHexValue:0xe5e5e5 alpha:1].CGColor;
    _selectBtn.layer.cornerRadius = 5.0f;
}
- (IBAction)selectBtn:(id)sender {
    if (_STSelectProjectFooterBlock) {
        _STSelectProjectFooterBlock(1);
    }
}

@end
