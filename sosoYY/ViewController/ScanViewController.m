//
//  ScanViewController.m
//  novel-design
//
//  Created by soso on 16/2/13.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "ScanViewController.h"
#import "SYQRCodeViewController.h"
#import "ScanSearchViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "STProductDetailsViewController.h"
#import "STListViewController.h"
#import "STStorewideViewController.h"
#import "STWisdomSearchViewController.h"
@interface ScanViewController ()<UIWebViewDelegate>
{
    SYQRCodeViewController *qrcodevc;
}
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
     [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if (qrcodevc == nil) {
        
        __weak ScanViewController *weakSelf = self;
        
        qrcodevc = [[SYQRCodeViewController alloc] init];
        qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:qrString,@"code", nil];
            
            [aqrvc dismissViewControllerAnimated:NO completion:^{
                 if([[kScanSelected objectForKey:@"scanSelected"] isEqualToString:@"2"]){
                     
                     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:qrString,@"barnum",@"1",@"pageIndex",@"2",@"sort", nil];
                     
                     [[STCommon sharedSTSTCommon] setGetProductListBarCode:dict finshed:^(id result,STProductListEntity *toEntity, NSError *toError) {
                         if (!toError) {
                             STWisdomSearchViewController *searchVC = [STWisdomSearchViewController new];
//                             searchVC.hidesBottomBarWhenPushed = YES;
                             searchVC.dataResult = result;
                             searchVC.codeStr = qrString;
                             searchVC.toEntity = toEntity;
                             searchVC.backTopBlock = ^(void){
                                 if (weakSelf.backBlock) {
                                     weakSelf.backBlock();
                                 }
                                 [weakSelf.navigationController popViewControllerAnimated:NO];
                             };
                             [weakSelf.navigationController pushViewController:searchVC animated:YES];
                         }else{
                             [weakSelf.view makeToastActivity:@"请求失败"];
                         }
                     }];
                 }else{
                    [weakSelf handleColorChange:dic];
                 }
            }];
        };
        qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
            [aqrvc dismissViewControllerAnimated:NO completion:^{
                if (weakSelf.FailBlock) {
                    weakSelf.FailBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        };
        
        qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
            //向通知中心do传递空code字符串，则代表用户在摄像头调用了返回按钮
            
            [aqrvc dismissViewControllerAnimated:NO completion:^{
                if (weakSelf.FailBlock) {
                    weakSelf.FailBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        };
        
        [self presentViewController:qrcodevc animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
     [[UIApplication sharedApplication].keyWindow hideToastActivity];
}


-(void)handleColorChange:(NSDictionary*)userInfo {

    self.webView = [[CustomWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces = NO;
    self.webView.delegate=self;
    
    NSString *str = [userInfo objectForKey:@"code"];
    str = [str stringByAppendingString:@"&from=original"];
    
    if(str.length>0&&![str isEqualToString:@"&from=original"]){//条形码扫描成功后执行
        NSURL *debugURL=[NSURL URLWithString:[requestScanCode stringByAppendingString:str]];
        NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
        [_webView loadRequest:request];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id page2 = segue.destinationViewController;
    // 对page2中的变量设置值
    [page2 setValue:sender forKey:@"searchString"];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *keyWork = [url absoluteString];
    
    if ([keyWork rangeOfString:[NSString stringWithFormat:@"%s/search/searchDetail?keyWords=",requestHost]].location != NSNotFound) {
        NSRange range = [keyWork rangeOfString:@"="];
        keyWork = [keyWork substringWithRange:NSMakeRange(range.location + 1,keyWork.length - (range.location + 1))];
        
        NSRange range2 = [keyWork rangeOfString:@"&"];
        
        keyWork = [keyWork substringWithRange:NSMakeRange(0,range2.location)];
        
        keyWork = [keyWork stringByRemovingPercentEncoding];
        
        if ([[kScanSelected objectForKey:@"scanSelected"] isEqualToString:@"1"]){
            STStorewideViewController *StorewideVC = [STStorewideViewController new];
//            StorewideVC.hidesBottomBarWhenPushed = YES;
            
            StorewideVC.backTopBlock = ^(void){
                
                [self.navigationController popViewControllerAnimated:NO];
            };
            StorewideVC.typeDict = @{@"storeid":[kScanSelected objectForKey:@"storeid"],@"storecateid":@"",@"sort":@"1",@"IsBest":@"",@"StorekeyWords":keyWork,@"CateId":@""};
            [self.navigationController pushViewController:StorewideVC animated:YES];
        }else if([[kScanSelected objectForKey:@"scanSelected"] isEqualToString:@"0"]){
            STListViewController *listVC = [STListViewController new];
//            listVC.hidesBottomBarWhenPushed = YES;
            
            listVC.backTopBlock = ^(void){
            
             [self.navigationController popViewControllerAnimated:NO];
            };
            
            listVC.typeDict = @{@"keyWork": keyWork,@"isShop":@NO,@"typeStr":@"",@"selected":@""};
            [self.navigationController pushViewController:listVC animated:YES];
        }
        return NO;
    }
    return [self.webView webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
     [[UIApplication sharedApplication].keyWindow hideToastActivity];
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak ScanViewController * viewC=self;
    self.jsContext[@"CloseWin"]=^(){
        
        //NSArray *args=[JSContext currentArguments];
        
        [viewC.navigationController popViewControllerAnimated:YES];
        
    };
    return [self.webView webViewDidFinishLoad:webView];
}


@end
