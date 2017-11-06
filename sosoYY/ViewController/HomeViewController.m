
//
//  HomeViewController.m
//  novel-design
//
//  Created by 杨千 on 16/2/20.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "HomeViewController.h"
#import "STListViewController.h"
#import "STProductDetailsViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UMMobClick/MobClick.h>
#import <WebKit/WebKit.h>
#import "STProductDetailsViewController.h"
#import "ShareManagerCtrl.h"
#import "STShopHomeViewController.h"
#import "VersionView.h"
#import "CouponViewController.h"
#import "ActivityViewController.h"
@protocol JSObjcDelegate<JSExport>

- (void)searchResult:(NSString*)txt;

@end

@interface HomeViewController ()<UITextFieldDelegate,UIWebViewDelegate,UIScrollViewDelegate>{
    
    __block BOOL isShare;
}


@property (nonatomic,strong)NSString *requestUrl;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL isInit;
@property (nonatomic, strong) JSContext *jsContext;



@end

@implementation HomeViewController

- (NSString *)extracted {
    return requestIsUploadGps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isInit=false;
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    [self addTabNavView];
    
    [KSMNetworkRequest IsUploadGps:[self extracted] finished:^(BOOL finish) {
        
        if (finish) {
            [SharedApp startLocationFinshed:^(CLLocationDegrees latitude, CLLocationDegrees longitude, NSError *error) {
                if (!error) {
                    NSDictionary *params = @{@"longitude":[NSString stringWithFormat:@"%f",longitude],
                                             @"latitude":[NSString stringWithFormat:@"%f",latitude],
                                             @"appVersion":[HYSystem appVersion],
                                             @"deviceId":[HYSystem deviceUUID],
                                             @"deviceModel":[HYSystem getCurrentDeviceModel],
                                             @"deviceVendor":[HYSystem carrierName]};
                    [KSMNetworkRequest postRequest:requestUploadGps params:params success:^(id responseObj) {
                        NSLog(@"上传GGPS:%@",responseObj);
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }];
        }
    }];
    
    NSURL *debugURL=[NSURL URLWithString:requestIndex];
    NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
    [self.webView loadRequest:request];
    
    //检测更新
    [self CheckVersion];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noticeGoTab:)
                                                     name:Notice_GoTab
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareAppBack) name:inviteShareNOtifation object:nil];
        [self InitPage];
    }
    return self;
}

- (void)shareAppBack {
    
    if (isShare) {
        
        isShare = NO;
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"clickcancel()"];
        
        [KSMNetworkRequest postRequest:requestShareSuccess params:@{@"shareResult":@"1"} success:^(id responseObj) {
            
            FxLog(@"share result %@",responseObj);
            
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)CheckVersion {
    
    if([Uitils isNetWorkReach]){
        [KSMNetworkRequest postRequest:requestCheckVersion params:nil success:^(id responseObj) {
            
            FxLog(@"是否展示更新信息 %@",responseObj);
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            
            if (![currentVersion isEqualToString:[responseObj objectForKey:@"iosver"]]) {
                
                if ([[responseObj objectForKey:@"iosshow"] intValue] == 1) {
                    
                    __block VersionView *versionView = [[[NSBundle mainBundle] loadNibNamed:@"VersionView" owner:self options:nil] lastObject];
                    versionView.frame = self.view.bounds;
                    versionView.versionLabel.text = [NSString stringWithFormat:@"V%@",[responseObj objectForKey:@"iosver"]];
                    if (![[responseObj objectForKey:@"info"] isEqual:[NSNull null]]) {
                        versionView.content.text = [[responseObj objectForKey:@"info"] stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
                    }else {
                        versionView.content.text = @"修复部分BUG";
                    }
                    versionView.updateAPPBlock = ^{
                        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1135345334"];
                        [[UIApplication sharedApplication]openURL:url];
                    };
                    versionView.closeUpdateAlertBlock = ^{
                        
                        [versionView removeFromSuperview];
                        versionView = nil;
                    };
                    [[UIApplication sharedApplication].keyWindow addSubview:versionView];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"首页"];
    self.tabBarController.tabBar.hidden = NO;

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"首页"];
    
    [self.view hideToastActivity];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

-(void)noticeGoTab:(NSNotification*)sender {
    
    NSString *index = [sender.userInfo objectForKey:@"selectIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:[sender.userInfo objectForKey:@"frome"] forKey:@"frome"];
    [self performSelectorOnMainThread:@selector(SetTabSelectIndex:) withObject:index waitUntilDone:NO];
}

-(void)SetTabSelectIndex:(NSString*)index {
    
    self.tabBarController.selectedIndex=[index intValue];
    if ([index intValue] == 2) {
        self.tabBarItem.tag = 102;
        [self.tabBarController tabBar:self.tabBarController.tabBar didSelectItem:self.tabBarItem];
    }
}

-(void)InitPage {
    
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navigationView.clipsToBounds = YES;
    navigationView.backgroundColor = [UIColor fromHexValue:0xea5413];
//    [self.view addSubview:navigationView];
    
    //搜索按钮
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [searchButton setImage:[UIImage imageNamed:@"搜索A"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:searchButton];
    
    UIImage *img = [UIImage imageNamed:@"firstLogoA"];
    UIImageView *imgV = [UIImageView new];
    imgV.frame = CGRectMake(kScreenWidth/2 - img.size.width/2, 32, img.size.width, img.size.height);
    imgV.image = img;
    [navigationView addSubview:imgV];
    
//    //消息按钮
//    UIButton *newsButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-44, 20, 44, 44)];
//    [newsButton setImage:[UIImage imageNamed:@"消息A"] forState:UIControlStateNormal];
//    [newsButton addTarget:self action:@selector(newsClick) forControlEvents:UIControlEventTouchUpInside];
//    [navigationView addSubview:newsButton];
    
    _newsNumLab = [UILabel new];
    _newsNumLab.frame = CGRectMake(kScreenWidth - 20, 25, 18, 18);
    _newsNumLab.font = [UIFont systemFontOfSize:10];
    _newsNumLab.layer.masksToBounds = YES;
    _newsNumLab.layer.cornerRadius = 9.0f;
    _newsNumLab.layer.borderWidth = 1.0f;
    _newsNumLab.layer.borderColor = RGB(255, 13, 25).CGColor;
    _newsNumLab.backgroundColor = [UIColor whiteColor];
    _newsNumLab.textColor = RGB(255, 13, 25);
    _newsNumLab.text = @"1";
    _newsNumLab.hidden = YES;
    _newsNumLab.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:_newsNumLab];
    self.webView = [[CustomWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-49-20)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.uiContainerViewControl=self;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.view showLoadingView:@"loading"];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL result=[self.webView webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self setJsMothed:webView];
    self.isInit=YES;
    
    [self.view hideToastActivity];
}


-(void)setJsMothed:(UIWebView *)webView{
    __weak HomeViewController *weakSelf = self;
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    //分享-邀请好友
    self.jsContext[@"shareInvite"] = ^() {
        
        [weakSelf setShareTwo];
        
        NSArray *array = [JSContext currentArguments];
        FxLog(@"array = %@",array);
        
        if (array.count == 3) {
            
            isShare = YES;
            
            [[STCommon sharedSTSTCommon] setShare:@{@"title":[NSString stringWithFormat:@"%@",array[0]],@"image":@"hudST_logo",@"url":[NSString stringWithFormat:@"%@",array[2]],@"descr":[NSString stringWithFormat:@"%@",array[1]]} shareView:weakSelf Finished:^(BOOL isSuccessful) {
                
                if (isSuccessful) {
                
                    isShare = YES;
                }else {
                
                    isShare = NO;
                }
            }];
        }
    };
    
    //排行榜
    self.jsContext[@"JsToIOSProdRank"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        
        FxLog(@"args == %@",args);
        
        if (args.count > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
                NSString *urlString = requestCheckTop;
                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"cateid=%@&iskong=1&nearest=0",args[0]]];
                detailsVC.urlStr = urlString;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf tabBarControllerHidden];
                    [weakSelf.navigationController pushViewController:detailsVC animated:YES];
                });
            });
        }
    };
    
    self.jsContext[@"TagPharmSearch"]=^(){
        NSArray *args = [JSContext currentArguments];
        NSString *typeStr = args[0];
        if(args.count>0){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                STListViewController *listVC = [STListViewController new];
                listVC.typeDict = @{@"typeStr":typeStr,@"isShop":@NO,@"keyWork":@"",@"selected":@""};
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf tabBarControllerHidden];
                  [weakSelf.navigationController pushViewController:listVC animated:YES];
                });
            });
        }
    };
    
    //在探索输入框点击搜索按钮  //品牌街
    self.jsContext[@"CateSearch"]=^(){
        NSArray *args=[JSContext currentArguments];
        if(args.count>0){
            
            NSString *keyWord= [NSString stringWithFormat:@"%@",args[0]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                STListViewController *listVC = [STListViewController new];
                listVC.typeDict = @{@"keyWork": keyWord,@"isShop":@NO,@"typeStr":@"",@"selected":@""};
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf tabBarControllerHidden];
                    [weakSelf.navigationController pushViewController:listVC animated:YES];
                });
            });
        }
    };
    
    //标签跳转  品类世界  左上角(搜索按钮)  右上角
    self.jsContext[@"CloseWin"]=^(){
        
        NSArray *args=[JSContext currentArguments];
        if(args.count>0){
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",args[0]],@"selectIndex", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:dic];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    weakSelf.tabBarController.selectedIndex=(NSUInteger)args[0];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    //优惠券列表
    self.jsContext[@"gocouponlist"] = ^() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CouponViewController *CouponlistVC = [CouponViewController new];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf tabBarControllerHidden];
                CouponlistVC.loadUrl = requestCouponList;
                [weakSelf.navigationController pushViewController:CouponlistVC animated:YES];
            });
        });
    };
    
    //活动
    self.jsContext[@"Seminar"] = ^() {
        
        NSArray *args=[JSContext currentArguments];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ActivityViewController *ActivityVC = [ActivityViewController new];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf tabBarControllerHidden];
                ActivityVC.loadUrl = [NSString stringWithFormat:@"%@",args[0]];
                ActivityVC.titleStr = [NSString stringWithFormat:@"%@",args[1]];
                [weakSelf.navigationController pushViewController:ActivityVC animated:YES];
            });
        });
    };
    
    
    //跳转到指定的URL 五个BUtton中的 --- 首推联盟 加价购  逛商店
    self.jsContext[@"JumpToTabAndUrl"]=^(){
        
        NSArray *args=[JSContext currentArguments];
        
        if(args.count>0){
            
       __block NSString *typeStr= [NSString stringWithFormat:@"%@",args[1]];
            
            if ([typeStr isEqual:@"/Search/SearchDetail?producttype=2"]) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    STListViewController *listVC = [STListViewController new];
                    listVC.typeDict = @{@"typeStr":@"",@"isShop":@NO,@"keyWork":@"",@"selected":@"T"};
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf tabBarControllerHidden];
                       [weakSelf.navigationController pushViewController:listVC animated:YES];
                    });
                });
                
            }else if([typeStr isEqual:@"/Search/SearchDetail?cuxiao=1"]){
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    STListViewController *listVC = [STListViewController new];
                    listVC.typeDict = @{@"typeStr":@"",@"isShop":@NO,@"keyWork":@"",@"selected":@"J"};
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf tabBarControllerHidden];
                       [weakSelf.navigationController pushViewController:listVC animated:YES];
                    });
                });
                
            }else if([typeStr isEqual:@"/Search/SearchDetail?cuxiao=2"]){
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    STListViewController *listVC = [STListViewController new];
                    listVC.typeDict = @{@"typeStr":@"",@"isShop":@NO,@"keyWork":@"",@"selected":@"Y"};
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf tabBarControllerHidden];
                        [weakSelf.navigationController pushViewController:listVC animated:YES];
                    });
                });
                
            }else if([typeStr isEqual:@"/Store/StoreSearchResult"]){
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    STListViewController *listVC = [STListViewController new];
                    listVC.typeDict = @{@"typeStr":@"",@"isShop":@YES,@"keyWork":@"",@"selected":@""};
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf tabBarControllerHidden];
                      [weakSelf.navigationController pushViewController:listVC animated:YES];
                    });
                });
                
            }else if ([typeStr rangeOfString:@"Store?storeid="].location != NSNotFound) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSRange range = [typeStr rangeOfString:@"="];
                    typeStr = [typeStr substringWithRange:NSMakeRange(range.location + 1,typeStr.length - (range.location + 1))];
                    STShopHomeViewController *shopHomeVC = [STShopHomeViewController new];
                    shopHomeVC.typeDict = @{@"storeid":typeStr};
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf tabBarControllerHidden];
                       [weakSelf.navigationController pushViewController:shopHomeVC animated:YES];
                    });
                });
                
            }else if ([typeStr isEqual:@"/Search/SearchDetail?cuxiao=3"]){
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    STListViewController *listVC = [STListViewController new];
                    listVC.typeDict = @{@"typeStr":@"",@"isShop":@NO,@"keyWork":@"",@"selected":@"C"};
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf tabBarControllerHidden];
                        [weakSelf.navigationController pushViewController:listVC animated:YES];
                    });
                });
               
            }else{
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSString *temp=@requestHost;
                    NSString *urlStr= [NSString stringWithFormat:@"%@",args[1]];
                    temp=[temp stringByAppendingString:urlStr];
                    temp=[temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    STProductDetailsViewController *searchView = [STProductDetailsViewController new];
                    searchView.urlStr=temp;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf tabBarControllerHidden];
                         [weakSelf.navigationController pushViewController:searchView animated:YES];
                    });
                });
            }
        }
    };
    //店铺主页
    self.jsContext[@"IOS_GoStoreid"]=^(){
        NSArray *arry=[JSContext currentArguments];
        if(arry.count==2){
            NSString *urlStr= [NSString stringWithFormat:@"%@",arry[0]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                STShopHomeViewController *shopHomeVC = [STShopHomeViewController new];
                shopHomeVC.typeDict = @{@"storeid":urlStr};
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf tabBarControllerHidden];
                  [weakSelf.navigationController pushViewController:shopHomeVC animated:YES];
                });
            });
        }
    };
    //从购物车跳转到商品详细页  加价购
    self.jsContext[@"cartGotoProductBuy"]=^(){
        NSArray *array=[JSContext currentArguments];
        if(array.count>0){
            
            NSString *Pid = [NSString stringWithFormat:@"%@",array[0]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
                detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,Pid];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf tabBarControllerHidden];
                    [weakSelf.navigationController pushViewController:detailsVC animated:YES];
                });
            });
        }
    };
    
    if (!_isLoading) {
        
        _isLoading = YES;
        
        if ([Uitils getUserDefaultsForKey:@"cookie"]) {
            FxLog(@"已登录");
            [[NSNotificationCenter defaultCenter] postNotificationName:refresh_shopCart object:self userInfo:nil];
        }else {
            FxLog(@"未登录");
        }
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark --ScrollViewDelegate--
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // [_refreshView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // [_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)searchAction{
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"selectIndex", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 1;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_GoTab object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:inviteShareNOtifation object:nil];
    
}

@end