//
//  STWisdomHelpViewController.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomHelpViewController.h"

@interface STWisdomHelpViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation STWisdomHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self addTabNavView];
    
    [self addTabBarView];

    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURL *debugURL = [NSURL URLWithString:_strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:debugURL];
    [self.webView loadRequest:request];
}
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    [self setJsMothed:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    [self setJsMothed:webView];
}

-(void)setJsMothed:(UIWebView *)webView{
    __weak  STWisdomHelpViewController *weakSelf = self;
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.jsContext[@"CloseWin"]=^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.HelpBackBlock) {
                weakSelf.HelpBackBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
