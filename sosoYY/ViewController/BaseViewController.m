//
//  BaseViewController.m
//  sosoYY
//
//  Created by zhy on 16/11/22.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc {
    
    FxLog(@"%@未发生内存泄露",NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


@end
