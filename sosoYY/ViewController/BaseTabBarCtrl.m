//
//  BaseTabBarCtrl.m
//  sosoYY
//
//  Created by zhy on 16/11/22.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "BaseTabBarCtrl.h"
#import "HomeViewController.h"
#import "STSearchViewController.h"
#import "ScanSearchViewController.h"
#import "ShopCartViewController.h"
#import "MYViewController.h"
#import "SYQRCodeViewController.h"
#import "STWisdomProcurementViewController.h"

#import "STOrderViewController.h"
#import "MyWalletViewController.h"

@interface BaseTabBarCtrl ()<UITabBarDelegate>{
    MYViewController *personal;
    HomeViewController *homePage;
    STSearchViewController *search;
    ScanSearchViewController *scan;
    ShopCartViewController *shopCart;
    UIButton *wisdomBtn;
}

@end

@implementation BaseTabBarCtrl


- (void)addSubCtrls {
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    wisdomBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2 - 30, 49-60, 60, 60)];
    wisdomBtn.userInteractionEnabled = NO;
    wisdomBtn.backgroundColor = [UIColor clearColor];
    wisdomBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    wisdomBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    [wisdomBtn setImage:[UIImage imageNamed:@"Wisdom"] forState:UIControlStateNormal];
    [self.tabBar addSubview:wisdomBtn];
    
    homePage = [[HomeViewController alloc]init];
    homePage.title = @"首页";
    homePage.tabBarItem.tag = 100;
    homePage.tabBarItem.image = [UIImage imageNamed:@"iconfont-home"];
    UINavigationController *navi1 = [[UINavigationController alloc]initWithRootViewController:homePage];
    
    search = [[STSearchViewController alloc]init];
    search.title = @"探索";
    search.tabBarItem.tag = 101;
    search.tabBarItem.image = [UIImage imageNamed:@"iconfont-sousuo"];
    UINavigationController *navi2 = [[UINavigationController alloc]initWithRootViewController:search];
    
    scan = [[ScanSearchViewController alloc]init];
    scan.tabBarItem.tag = 102;
    scan.title = @"智慧采购";
    UINavigationController *navi3 = [[UINavigationController alloc]initWithRootViewController:scan];
    
    shopCart = [[ShopCartViewController alloc]init];
    shopCart.title = @"购物车";
    shopCart.tabBarItem.tag = 103;
    shopCart.tabBarItem.image = [UIImage imageNamed:@"iconfont-gouwuche"];
    UINavigationController *navi4 = [[UINavigationController alloc]initWithRootViewController:shopCart];
    
    personal = [[MYViewController alloc]init];
    personal.title = @"我的";
    personal.tabBarItem.tag = 104;
    personal.tabBarItem.image = [UIImage imageNamed:@"iconfont-wode"];
    UINavigationController *navi5 = [[UINavigationController alloc]initWithRootViewController:personal];
    
    self.viewControllers = @[navi1,navi2,navi3,navi4,navi5];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, self.view.width, 22)];
    imageV.image = [UIImage imageNamed:@"组-5"];
    imageV.contentMode = UIViewContentModeCenter;
    [self.tabBar addSubview:imageV];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *TabBarView = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    TabBarView.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:TabBarView];
    
    [self addSubCtrls];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAction:) name:PUSH_Notification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToOrderList:) name:@"pushToOrderList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToDetails:) name:PUSH_Details object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNum:) name:PUSH_NUM object:nil];
    }
    return self;
}

-(void)pushNum:(NSNotification *)noticication{
    
    NSDictionary *userInfo = noticication.userInfo;
    
    homePage.newsNumLab.hidden = NO;
    homePage.newsNumLab.text = [NSString stringWithFormat:@"%@",userInfo[@"pushNum"]];
    if ([userInfo[@"pushNum"] intValue] > 9) {
        homePage.newsNumLab.text = @"9+";
    }else if ([userInfo[@"pushNum"] intValue] == 0){
        homePage.newsNumLab.hidden = YES;
    }
}

-(void)pushToOrderList:(NSNotification*)noticication {
    
    NSDictionary *userInfo = noticication.userInfo;
    
    CGRect frame = self.tabBar.frame;
    frame.origin.y = kScreenHeight-49;
    self.tabBar.frame = frame;
    self.tabBar.hidden = NO;
    self.selectedIndex = 4;
    
    //待验货
    if ([[userInfo objectForKey:@"flag"] isEqualToString:@"waitReceive"]) {
        [personal reloadOrderList:101];
    }else {
        //待支付
        [personal reloadOrderList:100];
    }
}

-(void)pushAction:(NSNotification*)noticication {
    
    NSDictionary *info = noticication.userInfo;
    FxLog(@"sfsdfinfo = %@",info);
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //审计划
    if ([[info objectForKey:@"type"] isEqualToString:@"plan"]) {
        self.selectedIndex = 2;
        STWisdomProcurementViewController *wisdomProcurementVC = [STWisdomProcurementViewController new];
        [self.navigationController pushViewController:wisdomProcurementVC animated:YES];
        
    }else if ([[info objectForKey:@"type"] isEqualToString:@"third"]){ //个人中心
        
        self.selectedIndex = 4;
    }else {
        self.selectedIndex = 4;
        [personal reloadOrderList:101];
    }
}

-(void)pushToDetails:(NSNotification*)noticication{
    
    NSDictionary *info = noticication.userInfo;
    
    self.selectedIndex = 4;
    [personal jumpOrderDetail:0 withUrl:[NSString stringWithFormat:@"%s/Ucenter/OrderDetail?Oid=%@",requestHost,info[@"oid"]]];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    switch (item.tag) {
        case 100:
        {
            [homePage.view showLoadingView:@"loading"];
            NSURL *debugURL=[NSURL URLWithString:requestIndex];
            NSURLRequest *request=[NSURLRequest requestWithURL:debugURL];
            [homePage.webView loadRequest:request];
            [homePage CheckVersion];
            homePage.tabBarController.tabBar.hidden = NO;
        }
            break;
        case 101:
            search.tabBarController.tabBar.hidden = NO;
            break;
        case 102:
            scan.tabBarController.tabBar.hidden = NO;
            break;
        case 103:
            shopCart.tabBarController.tabBar.hidden = NO;
            break;
        case 104:
            personal.tabBarController.tabBar.hidden = NO;
            break;
            
        default:
            break;
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_Notification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushToOrderList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_Details object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_NUM object:nil];
}


@end