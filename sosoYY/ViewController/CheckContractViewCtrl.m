//
//  CheckContractViewCtrl.m
//  sosoYY
//
//  Created by zhy on 2017/8/25.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "CheckContractViewCtrl.h"

@interface CheckContractViewCtrl ()<UIWebViewDelegate>
{
    
    NSMutableURLRequest *_request;
}
@property (weak, nonatomic) IBOutlet UIWebView *customWebView;

@end

@implementation CheckContractViewCtrl

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    NSURL *URL=[NSURL URLWithString:self.urlStr];
    
    
    _request = [NSMutableURLRequest requestWithURL:URL];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:_request delegate:self];
    
    
//    NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.customWebView.delegate = self;
//    [self.customWebView loadRequest:request];
    
}

#pragma mark UIwebVIewDelegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge previousFailureCount]== 0) {
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.customWebView loadRequest:_request];
    [connection cancel];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
}

- (IBAction)backClick:(id)sender {
    
     [[UIApplication sharedApplication].keyWindow hideToastActivity];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
