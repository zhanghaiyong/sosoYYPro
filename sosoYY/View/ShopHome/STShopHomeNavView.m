//
//  STShopHomeNavView.m
//  sosoYY
//
//  Created by soso-mac on 2017/6/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STShopHomeNavView.h"

@implementation STShopHomeNavView

- (IBAction)back:(id)sender {
    if (_backBlock) {
        _backBlock();
    }
}

- (IBAction)scanSelected:(id)sender {
    if (_scanSelectedBlock) {
        _scanSelectedBlock();
    }
}

- (IBAction)searchSelected:(id)sender {
    if (_searchSelectedBlock) {
        _searchSelectedBlock();
    }
}


@end
