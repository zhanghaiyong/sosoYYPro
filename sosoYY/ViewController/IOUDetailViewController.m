//
//  IOUDetailViewController.m
//  sosoYY
//
//  Created by zhy on 2017/8/23.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "IOUDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "IOUSignViewController.h"
#import "STMethodPaymentViewController.h"
#import "BindCardViewController.h"
#import "CheckContractViewCtrl.h"
#import "STOrderDetailsViewController.h"
@interface IOUDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet CustomWebView *customWebView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation IOUDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.tabBarController.tabBar.hidden = YES;
     [self.customWebView reload];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    NSURL *debugURL=[NSURL URLWithString:[NSString stringWithFormat:@"%s/BlankNote/WaitConfirmLoanDetail?loanId=%@",requestHost,self.data]];
    NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    __weak IOUDetailViewController *weakSelf = self;

    //查看订单
    self.jsContext[@"goOrderDetail"] = ^() {
        
        NSArray *arry = [JSContext currentArguments];
        FxLog(@"szfsd = %@",arry);
        dispatch_async(dispatch_get_main_queue(), ^{
            STOrderDetailsViewController *paymentVC = [STOrderDetailsViewController new];
            paymentVC.titleStr = @"订单详情";
            paymentVC.orderListInto = YES;
            paymentVC.urlStr = [NSString stringWithFormat:@"%s/Ucenter/MasterOrderDetail?masterOid=%@&actionFrom=WaitConfirmLoanDetail",requestHost,arry.firstObject];
            paymentVC.orderId = [NSString stringWithFormat:@"%@",arry.firstObject];
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
    
    //去签名
    self.jsContext[@"gosign"] = ^() {
        
        NSArray *arry = [JSContext currentArguments];
        dispatch_async(dispatch_get_main_queue(), ^{
            IOUSignViewController *IOUSignVC = [[IOUSignViewController alloc]init];
            IOUSignVC.url = [NSString stringWithFormat:@"%@",arry[0]];
            
            IOUSignVC.callBackUrl = ^(NSString *backUrl) {
                [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
                backUrl = [NSString encodeString:backUrl];
                NSString *urlSrt = [NSString stringWithFormat:@"%s/BlankNote/WaitConfirmLoanDetail?loanId=%@&viewPdfUrl=%@",requestHost,weakSelf.data,backUrl];
                NSURL *debugURL=[NSURL URLWithString:urlSrt];
                NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
                [weakSelf.customWebView loadRequest:request];
            };
            
            [weakSelf.navigationController pushViewController:IOUSignVC animated:YES];
        });
    };
    
    //同意
    self.jsContext[@"agreePay"] = ^() {
        
        NSArray *arry = [JSContext currentArguments];
        FxLog(@"szfsd = %@",arry);
        if (arry.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:STMethodPaymentViewController.class]) {
                        STMethodPaymentViewController *MethodPayment =(STMethodPaymentViewController *)vc;
                        MethodPayment.masterOid = [NSString stringWithFormat:@"%@",arry[0]];
                        MethodPayment.isShowAlert = YES;
                       [weakSelf.navigationController popToViewController:MethodPayment animated:YES];
                        break;
                    }
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToOrderList" object:weakSelf userInfo:@{@"flag":@"waitReceive"}];
            });
        }
    };
    
    //不同意
    self.jsContext[@"disagreePay"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToOrderList" object:weakSelf userInfo:@{@"flag":@"waitPay"}];
        });
    };
    
    self.jsContext[@"openBindBank"] = ^() {
        NSArray *arry = [JSContext currentArguments];
        FxLog(@"openBindBank = %@",arry);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.customWebView reload];
            BindCardViewController *bindCardVC = [[BindCardViewController alloc]init];
            bindCardVC.urlStr = [NSString stringWithFormat:@"%@",arry.firstObject];
            [weakSelf.navigationController pushViewController:bindCardVC animated:YES];
        });
    };
    
    self.jsContext[@"goback"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];;
        });
    };
    FxLog(@"ZDGHHH = %@",webView.request.URL);
}

- (IBAction)backClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"返回将取消此次白条贷款，你确定吗？" preferredStyle:UIAlertControllerStyleAlert   ];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToOrderList" object:self userInfo:@{@"flag":@"waitPay"}];
        
        [KSMNetworkRequest postRequest:BlankIOUCancel params:@{@"loanId":self.data,@"oprate":@"2"} success:^(id responseObj) {
        } failure:^(NSError *error) {
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
