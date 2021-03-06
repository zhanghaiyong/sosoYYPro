//
//  IOUSignViewController.m
//  sosoYY
//
//  Created by zhy on 2017/8/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "IOUSignViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface IOUSignViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *customWebView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation IOUSignViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    NSURL *debugURL=[NSURL URLWithString:self.url];
    NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customWebView.delegate = self;
    [self.customWebView loadRequest:request];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    __weak IOUSignViewController *weakSelf = self;
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //监听返回
    self.jsContext[@"signContractBack"] = ^() {
        
        NSArray *arry = [JSContext currentArguments];
        FxLog(@"szfsd = %@",arry);
        
        if (arry.count == 3 ) {
            
            if ([[NSString stringWithFormat:@"%@",arry.lastObject] isEqualToString:@"1"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.callBackUrl) {
                        weakSelf.callBackUrl([NSString stringWithFormat:@"%@",arry[1]]);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else if ([[NSString stringWithFormat:@"%@",arry.lastObject] isEqualToString:@"2"]) {
                
                [ZHProgressHUD showErrorWithText:@"签署失败"];
            }else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                [ZHProgressHUD showErrorWithText:@"未完成签署流程"];
            }
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    };
}



@end
