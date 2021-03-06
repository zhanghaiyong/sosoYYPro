//
//  BlankNoteDetailViewController.m
//  sosoYY
//
//  Created by zhy on 2017/8/25.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "BlankNoteDetailViewController.h"
#import "CheckContractViewCtrl.h"
#import "STOrderDetailsViewController.h"
@interface BlankNoteDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet CustomWebView *customWebView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation BlankNoteDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSString stringWithFormat:@"%@",self.array.firstObject] rangeOfString:@"BlankNote_hasPayBack"].location != NSNotFound) {
        self.titleLab.text = @"已还款";
    }else if ([[NSString stringWithFormat:@"%@",self.array.firstObject] rangeOfString:@"BlankNote_payBacking"].location != NSNotFound) {
        self.titleLab.text = @"还款中";
    }
    
     [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%@?loanId=%@",requestHost,self.array.firstObject,self.array.lastObject]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customWebView.scrollView.bounces = NO;
    self.customWebView.delegate = self;
    [self.customWebView loadRequest:request];
    
}

#pragma mark UIwebVIewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    __weak BlankNoteDetailViewController *weakSelf = self;
    
    //查看订单
    self.jsContext[@"goOrderDetail"] = ^() {
        
        NSArray *arry = [JSContext currentArguments];
        FxLog(@"szfsd = %@",arry);
        dispatch_async(dispatch_get_main_queue(), ^{
            STOrderDetailsViewController *paymentVC = [STOrderDetailsViewController new];
            paymentVC.titleStr = @"订单详情";
            paymentVC.orderListInto = YES;
            paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/OrderDetail?Oid=%@",requestHost,arry.firstObject];
            paymentVC.orderId = [NSString stringWithFormat:@"%@",arry.firstObject];
            paymentVC.QQ = [NSString stringWithFormat:@"%@",arry.lastObject];
            [weakSelf.navigationController pushViewController:paymentVC animated:YES];
        });
    };
    
    //查看合同
    self.jsContext[@"goViewContract"] = ^() {
        
        NSArray *arry = [JSContext currentArguments];
        FxLog(@"szfsd = %@",arry);
        
        if (arry.count == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CheckContractViewCtrl *checkContractVC = [[CheckContractViewCtrl alloc]init];
                checkContractVC.urlStr = [NSString stringWithFormat:@"%@",arry.firstObject];
                [weakSelf.navigationController pushViewController:checkContractVC animated:YES];
                
            });
        }
    };
}

- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
