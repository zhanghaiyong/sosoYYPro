//
//  STWisdomToSearchNavView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/28.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomToSearchNavView.h"



@interface STWisdomToSearchNavView ()<UITextFieldDelegate>

@end

@implementation STWisdomToSearchNavView

#pragma mark --btn - Mothed
- (IBAction)backSelected:(id)sender {
    if (_BackBlock) {
        _BackBlock();
    }
}

- (IBAction)searchSelected:(id)sender {
    [_searchTextField resignFirstResponder];
    if (_WisdomAddSearchTextBlock) {
        _WisdomAddSearchTextBlock(_searchTextField.text);
    }
}
- (IBAction)scanSelected:(id)sender {
    if (_ScanBlock) {
        _ScanBlock();
    }
}

-(void)setSearchTextField{
    _searchTextField.delegate = self;
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (_WisdomAddSearchAssociateTextBlock) {
        _WisdomAddSearchAssociateTextBlock(_searchTextField.text);
    }
}

@end
