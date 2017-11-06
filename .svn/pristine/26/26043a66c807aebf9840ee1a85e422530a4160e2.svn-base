//
//  CustomWebVIew.m
//  novel-design
//
//  Created by 杨千 on 16/3/9.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "CustomWebView.h"
#import "HomeViewController.h"


@interface CustomWebView (){
    BOOL _authenticated;
    NSURLConnection *_urlConnention;
}
@end


@implementation CustomWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.scrollView.showsVerticalScrollIndicator=NO;
        self.scrollView.showsHorizontalScrollIndicator=NO;
        self.scalesPageToFit = YES; //自动对网页页面进行缩放以适应屏幕大小
        self.scrollView.bounces = NO;
        //自动检测网页上的电话号码，单击禁止拨打
        self.dataDetectorTypes = UIDataDetectorTypeNone;

        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[Uitils getUserDefaultsForKey:@"cookie"]];
        if (cookies) {
            //设置cookie
            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (id cookie in cookies) {
                [cookieStorage setCookie:(NSHTTPCookie *)cookie];
            }
        }
    }
    return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    _nowRequest=request;

    BOOL result=false;
    
    FxLog(@"url = %@",request.URL);
    
    if([Uitils isNetWorkReach]){
        
        // 用于UIWebView加载httpsx
        if (!_authenticated) {
            
            _authenticated = NO;
            _urlConnention = [[NSURLConnection alloc]initWithRequest:_nowRequest delegate:self];
            [_urlConnention start];
            return NO;
        }
        
        result=true;

        if([[request.URL.absoluteString lowercaseString] rangeOfString:@"mqq://im/chat"].location==NSNotFound&&[[request.URL.absoluteString lowercaseString] rangeOfString:@"tel:"].location==NSNotFound&&[[request.URL.absoluteString lowercaseString] rangeOfString:@"95516"].location==NSNotFound){
          
        }
    }
    else {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"网络连接异常，是否重试？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self loadRequest:_nowRequest];
            
        }]];
        [self.uiContainerViewControl presentViewController:alert animated:YES completion:nil];

    }
    
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView  {
    [self setJsMothed:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if(error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"网络连接异常，是否重试？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self loadRequest:_nowRequest];
            
        }]];
        [self.uiContainerViewControl presentViewController:alert animated:YES completion:nil];
    }
}


-(void) registerGoHome:(UIViewController *)viewController{
    self.jsContext[@"goHomeLogin"]=^(){
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"selectIndex", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:dic];
      [viewController dismissViewControllerAnimated:YES completion:^{
       }
        ];
    };
}

-(void)setJsMothed:(UIWebView *)webView{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    if (webView.isLoading) {
    //        return;
    //    }
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        FxLog(@"异常信息：%@", exceptionValue);
    };
}

// 用于UIWebView加载https
#pragma mark === connectDelegate
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    FxLog(@"验证签名证书");
    
    if ([challenge previousFailureCount] == 0){
        _authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else{
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    FxLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [self loadRequest:_nowRequest];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnention cancel];
}

// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

@end
