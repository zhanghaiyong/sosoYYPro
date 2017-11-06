//
//  ActivityViewController.m
//  sosoYY
//
//  Created by zhy on 2017/10/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()
@property (weak, nonatomic) IBOutlet CustomWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = self.titleStr;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.uiContainerViewControl=self;
    NSURL *debugURL=[NSURL URLWithString:requestCouponList];
    NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
    [self.webView loadRequest:request];
}


- (IBAction)backAction:(id)sender {
    
}

@end
