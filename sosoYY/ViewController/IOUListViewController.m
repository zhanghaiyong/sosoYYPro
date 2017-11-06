//
//  BindCardViewController.m
//  sosoYY
//
//  Created by zhy on 2017/8/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "IOUListViewController.h"
#import "BindCardViewController.h"
#import "BlankNoteDetailViewController.h"
@interface IOUListViewController ()<UIWebViewDelegate>
{

    NSDictionary *BindCardInfo;
}
@property (nonatomic, strong) JSContext *jsContext;
@property (weak, nonatomic) IBOutlet UIButton *bindORChangCardBtn;
@property (weak, nonatomic) IBOutlet CustomWebView *customWebView;

@end

@implementation IOUListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self getBindCardInfo];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    
    NSURL *debugURL=[NSURL URLWithString:BlankNoteListUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customWebView.delegate = self;
    [self.customWebView loadRequest:request];
}

- (void)getBindCardInfo {

    __weak IOUListViewController *weakSelf = self;
    [KSMNetworkRequest getRequest:requestGetBindCardInfo params:nil success:^(id responseObj) {
        
        NSLog(@"responseObj = %@",responseObj);
        if ([responseObj[@"success"] integerValue] == 1) {
            
            BindCardInfo = responseObj[@"data"];
            
            if ([BindCardInfo[@"lousstatus"] integerValue] == 1) {
                weakSelf.bindORChangCardBtn.userInteractionEnabled = YES;
                //去更换卡
                if ([BindCardInfo[@"CardNo"] isKindOfClass:[NSNull class]] ) {
                    [weakSelf.bindORChangCardBtn setTitle:@"绑定卡" forState:UIControlStateNormal];
                }else if ([BindCardInfo[@"CardNo"] length] == 0) {
                    [weakSelf.bindORChangCardBtn setTitle:@"绑定卡" forState:UIControlStateNormal];
                    //绑定卡
                }else {
                    [weakSelf.bindORChangCardBtn setTitle:@"更换卡" forState:UIControlStateNormal];
                }
            }else {
            
                weakSelf.bindORChangCardBtn.userInteractionEnabled = NO;
                [weakSelf.bindORChangCardBtn setTitle:@"" forState:UIControlStateNormal];
            }
        }else {
        
            [ZHProgressHUD showInfoWithText:responseObj[@"info"]];
        }
        
    } failure:^(NSError *error) {
        
        [ZHProgressHUD showErrorWithText:@"网络错误，请重试！"];
        
    }];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    __weak IOUListViewController *weakself = self;
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    NSURL *url = webView.request.URL;
    NSLog(@"url = %@",url);
    
    //跳到详情
    self.jsContext[@"lousDetails"] = ^() {
        NSArray *args=[JSContext currentArguments];
        FxLog(@"args = %@",args);
        dispatch_async(dispatch_get_main_queue(), ^{
            BlankNoteDetailViewController *blankNoteDetail = [[BlankNoteDetailViewController alloc]init];
            blankNoteDetail.array = args;
            [weakself.navigationController pushViewController:blankNoteDetail animated:YES];
        });
    };
}

- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bindOrChangClick:(id)sender {

    BindCardViewController *bindCardVC = [[BindCardViewController alloc]init];
    NSString *urlStr = @"";
    
    if ([BindCardInfo[@"CardNo"] isKindOfClass:[NSNull class]] ) {
        urlStr = BindCardInfo[@"BindCardUrl"];
    }else if ([BindCardInfo[@"CardNo"] length] == 0) {
        urlStr = BindCardInfo[@"BindCardUrl"];
        //绑定卡
    }else {
        urlStr = BindCardInfo[@"ChangeCardUrl"];
    }
    bindCardVC.urlStr = urlStr;
    [self.navigationController pushViewController:bindCardVC animated:YES];
    
}

@end