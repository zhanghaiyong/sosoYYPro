//
//  STWisdomAddListNavView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomAddListNavView.h"

@interface STWisdomAddListNavView ()<UITextFieldDelegate>

@end

@implementation STWisdomAddListNavView

#pragma mark --btn - Mothed
- (IBAction)backSelected:(id)sender {
    if (_BackBlock) {
        _BackBlock();
    }
}

- (IBAction)searchSelected:(id)sender {
    [_searchTextField resignFirstResponder];
    if (_WisdomAddListSearchTextBlock) {
        _WisdomAddListSearchTextBlock(_searchTextField.text);
    }
}

-(void)setSearchTextField{
    _searchTextField.delegate = self;
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (_WisdomAddListSearchAssociateTextBlock) {
        _WisdomAddListSearchAssociateTextBlock(_searchTextField.text);
    }
}


@end
