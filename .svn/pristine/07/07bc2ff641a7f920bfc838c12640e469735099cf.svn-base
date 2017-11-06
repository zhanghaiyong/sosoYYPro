//
//  CouponViewController.m
//  sosoYY
//
//  Created by zhy on 2017/10/23.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "CouponViewController.h"
#import "CustomWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface CouponViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet CustomWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation CouponViewController

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];

    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
     [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.uiContainerViewControl=self;
    self.webView.delegate = self;
    NSURL *debugURL=[NSURL URLWithString:self.loadUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
    [self.webView loadRequest:request];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    __weak CouponViewController *weakSelf = self;
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //返回
    self.jsContext[@"couponsback"]=^(){

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    };
}

@end
