//
//  STStorewideNavView.m
//  my
//
//  Created by soso-mac on 2016/11/28.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideNavView.h"

@interface STStorewideNavView ()<UITextFieldDelegate>

@end

@implementation STStorewideNavView

#pragma mark --btn - Mothed
- (IBAction)backSelected:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"storewideback" object:nil];
}
- (IBAction)searchSelected:(id)sender {
    [_searchTextField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(g_setStorewideSearchText:)]) {
        [_delegate g_setStorewideSearchText:_searchTextField.text];
    }
}
- (IBAction)scanSelected:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushScan" object:nil];
}
-(void)setSearchTextField{
    _searchTextField.delegate = self;
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(g_setStorewideSearchText:)]) {
        [_delegate g_setStorewideSearchAssociateText:textField.text];
    }
}
@end
