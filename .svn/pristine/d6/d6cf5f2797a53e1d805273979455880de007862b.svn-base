//
//  ReceiptViewController.m
//  sosoYY
//
//  Created by zhy on 2017/7/28.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "ReceiptViewController.h"

@interface ReceiptViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ReceiptViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电子发票";
    [self setShareThree];
    [self loadRequest];
}

- (void)loadRequest {
    
    self.webView.hidden = YES;
    self.reloadButton.userInteractionEnabled = NO;
    NSURL *url = [NSURL URLWithString:self.urlStr];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
}

#pragma mark UIWebVIewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {

    self.webView.hidden = NO;
    [[UIApplication sharedApplication].keyWindow showLoadingView: @"loading"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    self.webView.hidden = YES;
    self.reloadButton.userInteractionEnabled = YES;
}

//返回
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
- (IBAction)shareReceipt:(id)sender {
    
    [[STCommon sharedSTSTCommon] setShare:@{@"title":@"电子发票",@"image":@"hudST_logo",@"url":self.urlStr,@"descr":@"使用电脑打开,可打印为纸质版发票!"} shareView:self Finished:^(BOOL isSuccessful) {
        
        if (isSuccessful) {
            
        }else {
            
        }
    }];
}

//重新加载数据
- (IBAction)reloadData:(UIButton *)sender {
    
    [self loadRequest];
}

@end
