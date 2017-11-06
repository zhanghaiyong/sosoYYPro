//
//  STListNavView.m
//  my
//
//  Created by soso-mac on 2016/11/22.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STListNavView.h"

@interface STListNavView ()<UITextFieldDelegate>
@end

@implementation STListNavView

- (IBAction)backSelected:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backName" object:nil];
}
- (IBAction)commoditySelected:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(g_setListShopHidden)]) {
        [_delegate g_setListShopHidden];
    }
}

- (IBAction)searchSelected:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(g_setSearchSelectedText:)]) {
        [_delegate g_setSearchSelectedText:_searchTextField.text];
    }
    [_searchTextField resignFirstResponder];
}
- (IBAction)sanSelected:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scanName" object:nil];
}
-(void)setChaneShopBtnTitle:(NSString *)title{
    [self.shopBtn setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    
    _searchTextField.text = @"";
    if ([title isEqualToString:@"店铺"]) {
        _searchTextField.placeholder = @"请输入商铺名";
    }else{
        _searchTextField.placeholder = @"请输入药品通用名,商品名";
    }
}
-(void)setSearchTextField{
    _searchTextField.delegate = self;
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(g_setSearchFieldDidBeginEditing)]) {
        [_delegate g_setSearchFieldDidBeginEditing];
    }
}


- (void)textFieldDidChange:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(g_setSearchAssociateText:)]) {
        [_delegate g_setSearchAssociateText:textField.text];
    }
}
@end
