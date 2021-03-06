//
//  WhatIOUViewController.m
//  sosoYY
//
//  Created by zhy on 2017/8/25.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "WhatIOUViewController.h"
#import "IOUListViewController.h"

@interface WhatIOUViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet CustomWebView *customWebView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation WhatIOUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    self.title = @"什么是白条";
    NSURL *url = [NSURL URLWithString:requestWhatIsIOU];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customWebView.scrollView.bounces = NO;
    self.customWebView.delegate = self;
    [self.customWebView loadRequest:request];
    
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    __weak WhatIOUViewController *weakself = self;
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.jsContext[@"blacknote"] = ^() {
        NSArray *args=[JSContext currentArguments];
        FxLog(@"args = %@",args);
        
        /*
         1：跳转到申请
         2：跳转到重新申请
         3：跳转到正在审核
         4：跳转到设置
         */
        
        if ([[NSString stringWithFormat:@"%@",args.firstObject] isEqualToString:@"4"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                IOUListViewController *IOUListVc = [[IOUListViewController alloc]init];
                IOUListVc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:IOUListVc animated:YES];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
