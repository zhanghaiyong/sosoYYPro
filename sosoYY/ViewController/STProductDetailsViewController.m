 //
//  STProductDetailsViewController.m
//  sosoYY
//
//  Created by soso-mac on 2016/12/2.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "STProductDetailsViewController.h"
#import "AppDelegate.h"
#import "STStorewideViewController.h"
#import "STStoreClassificationController.h"
#import "STShopHomeViewController.h"
#import "STListViewController.h"
#import "STMethodPaymentViewController.h"
@interface STProductDetailsViewController ()<UIWebViewDelegate>{
    NSString *myControlStr;
    NSDictionary *dictionary;
}
@property (strong, nonatomic) CustomWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation STProductDetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self addTabNavView];
    
    [self addTabBarView];

    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    
    _webView = [[CustomWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURL *debugURL = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:debugURL];
    [self.webView loadRequest:request];

    //自动检测网页上的电话号码，单击禁止拨打
    //    [_webView setDetectsPhoneNumbers:NO];

}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [self setJsMothed:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL result=[self.webView webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSURL *url = [request URL];
    NSString *strId = [url absoluteString];
    if ([strId rangeOfString:@"store?storeid="].location != NSNotFound) {
        NSRange range = [strId rangeOfString:@"="];
        strId = [strId substringWithRange:NSMakeRange(range.location + 1,strId.length - (range.location + 1))];
        STShopHomeViewController *shopHomeVC = [STShopHomeViewController new];
//        shopHomeVC.hidesBottomBarWhenPushed = YES;
        shopHomeVC.typeDict = @{@"storeid":strId};
        [self.navigationController pushViewController:shopHomeVC animated:YES];
        return NO;
    }
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication].keyWindow hideToastActivity];
    [self setJsMothed:webView];
}
-(void)setJsMothed:(UIWebView *)webView{
//    [self.webView webViewDidFinishLoad:webView];
    __weak  STProductDetailsViewController *weakSelf = self;
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.jsContext[@"CloseWin"]=^(){
        NSArray *args=[JSContext currentArguments];
        if(args.count>0){
            
            NSArray *args=[JSContext currentArguments];
            
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",args[0]],@"selectIndex",@"0",@"frome", nil];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                    
                    [weakSelf performSelector:@selector(myByyControl) withObject:weakSelf afterDelay:.5];
        
                });
           
            if (args.count>1) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    myControlStr = [NSString stringWithFormat:@"%@",args[1]];
                    
                    [weakSelf performSelector:@selector(myControl) withObject:weakSelf afterDelay:.5];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.backBlock) {
                    weakSelf.backBlock(@"0");
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    self.jsContext[@"StoreProductAssort"]=^(){
        NSArray *args=[JSContext currentArguments];
        NSString *storeid = [NSString stringWithFormat:@"%@",args[0]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            STStoreClassificationController *StoreClassVC = [STStoreClassificationController new];
            StoreClassVC.storeid = storeid;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:StoreClassVC animated:YES];
            });
        });
    };
    
    self.jsContext[@"InStoreSearchProduct"]=^(){
        NSArray *args=[JSContext currentArguments];
        if (args.count > 1) {
            NSString *storeid = [NSString stringWithFormat:@"%@",args[0]];
            NSString *typteStr = [NSString stringWithFormat:@"%@",args[1]];
            if ([typteStr isEqualToString:@"best"]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    STStorewideViewController *StorewideVC = [STStorewideViewController new];
                    StorewideVC.typeDict = @{@"storeid":storeid,@"storecateid":@"",@"sort":@"default",@"IsBest":@"1",@"StorekeyWords":@"",@"CateId":@""};
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController pushViewController:StorewideVC animated:YES];
                    });
                });
            }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    STStorewideViewController *StorewideVC = [STStorewideViewController new];
                    StorewideVC.typeDict = @{@"storeid":storeid,@"storecateid":@"",@"sort":@"10",@"IsBest":@"",@"StorekeyWords":@"",@"CateId":@""};
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController pushViewController:StorewideVC animated:YES];
                    });
                });
            }
        }else{
            NSString *storeid = [NSString stringWithFormat:@"%@",args[0]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                STStorewideViewController *StorewideVC = [STStorewideViewController new];
                StorewideVC.typeDict = @{@"storeid":storeid,@"storecateid":@"",@"sort":@"default",@"IsBest":@"",@"StorekeyWords":@"",@"CateId":@""};
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController pushViewController:StorewideVC animated:YES];
                });
            });
        }
    };
    
    self.jsContext[@"goHomeLogin"]=^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:@{@"selectIndex":@"4",@"frome":@"0"}];
        });
    };
    
    //二维码
    self.jsContext[@"JsToLoacleFunction"]=^(){
        //        [weakSelf.navigationController  popToRootViewControllerAnimated:NO];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"selectIndex",@"0",@"frome", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:dic];
    };
    
    //打开qq
    self.jsContext[@"OpenQQ"]=^(){
        NSArray *args=[JSContext currentArguments];
        NSString *qq = [NSString stringWithFormat:@"%@",args[0]];
        [weakSelf setOpenQQ:qq];
    };
    //打电话
    self.jsContext[@"CallTell"]=^(){
        NSArray *args=[JSContext currentArguments];
        NSString *tel = [NSString stringWithFormat:@"%@",args[0]];
        [weakSelf setCallTell:tel];
    };
    //产品详情页
    self.jsContext[@"cartGotoProductBuy"]=^(){
        NSArray *array=[JSContext currentArguments];
        if(array.count>0){
            STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
//            detailsVC.hidesBottomBarWhenPushed = YES;
            NSString *urlStr = requsetProductBuy;
            //fromcategories=2 表示数据跳转来自购物车
            urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@&fromcategories=2",array[0]]];
            urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            detailsVC.urlStr = urlStr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:detailsVC animated:YES];
            });
        }
    };
    //点击更多
    self.jsContext[@"GoProductList"]=^(){
        NSArray *args=[JSContext currentArguments];
        if(args.count > 0){
            NSString *typeStr= [NSString stringWithFormat:@"%@",args[0]];
            NSString *tagStr= [NSString stringWithFormat:@"%@",args[1]];
            
            STListViewController *listVC = [STListViewController new];
//            listVC.hidesBottomBarWhenPushed = YES;
            if ([tagStr isEqual:@"1"]) {
                listVC.typeDict = @{@"typeStr":typeStr,@"isShop":@NO,@"keyWork":@"",@"selected":@"P"};
            }else{
                listVC.typeDict = @{@"typeStr":typeStr,@"isShop":@NO,@"keyWork":@"",@"selected":@"T"};
            }
            [weakSelf.navigationController pushViewController:listVC animated:YES];
        }
    };
    
    
    self.jsContext[@"returnCouponList"] = ^(){//优惠券
       NSArray *args=[JSContext currentArguments];

            if (weakSelf.paymentBackBlock) {
                weakSelf.paymentBackBlock(args);
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    
    self.jsContext[@"IOS_returnaddress"] = ^(){//地址
        
        NSArray *args=[JSContext currentArguments];
        
        if (weakSelf.paymentBackBlock) {
            weakSelf.paymentBackBlock(args);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    
    
    self.jsContext[@"toConfirmOrder"] = ^(){//地址返回
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    };
    
}


-(void)myByyControl{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:dictionary];
}
-(void)myControl{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToURL" object:[NSString stringWithFormat:@"%s%@",requestHost,myControlStr]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
-(void)setOpenQQ:(NSString *)qq{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你要打开QQ吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq]]];
        }else{
            [ZHProgressHUD showInfoWithText:@"请先安装QQ"];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setCallTell:(NSString *)tel{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你要拨打电话吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",tel]]];
        //        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)back{
    
    if (_backBlock) {
        _backBlock(@"0");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
