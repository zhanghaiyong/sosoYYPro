//
//  STlistViewController.m
//  my
//
//  Created by soso-mac on 2016/11/21.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STListViewController.h"
#import "STStorewideViewController.h"
#import "STListFilterView.h"
#import "STListBgView.h"
#import "UIViewController+DismissKeyboard.h"
#import "ScanViewController.h"
#import "SYQRCodeViewController.h"
#import "STProductDetailsViewController.h"
#import "STShopHomeViewController.h"

@interface STListViewController (){
    BOOL isSelected;
}
@property(strong,nonatomic)STListFilterView *filterView;
@property(strong,nonatomic)STListBgView *listBgView;
@end

@implementation STListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    isSelected = YES;
    [self addSubView];
    //    [self setupForDismissKeyboard];
    
}
-(void)addSubView{
    _filterView = [[STListFilterView alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100, self.view.frame.size.height) typeDict:_typeDict];
    [self.view addSubview:_filterView];
    
    _listBgView = [[STListBgView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) typeDict:_typeDict];
     [_listBgView viewWillAppear];
    [self.view addSubview:_listBgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushScanMothed)
                                                 name:@"scanName"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushMedicineDetailsMothed:)
                                                 name:@"Details"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popBackMothed)
                                                 name:@"backName"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showListFilterView)
                                                 name:@"showListFilterView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenListFilterView)
                                                 name:@"hiddenListFilterView"
                                               object:nil];
}

-(void)showListFilterView{
    if (isSelected) {
        [UIView animateWithDuration:0.3 animations:^{
            _listBgView.frame  = CGRectMake(-(self.view.frame.size.width - 100), 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
        isSelected = NO;
    }else{
        [self hiddenListFilterView];
    }
}
-(void)hiddenListFilterView{
    isSelected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _listBgView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
//二维码
-(void)pushScanMothed{
    NSDictionary *dict =@{@"scanSelected":@"0",@"storeid":@""};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"scanSelected"];
    [[STCommon sharedSTSTCommon]toScanViewWith:self];
}
//跳到详情
-(void)pushMedicineDetailsMothed:(NSNotification *)sender{
    if ([[sender.userInfo objectForKey:@"isShop"] isEqualToString:@"1"]) {
        STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
        detailsVC.urlStr =  [NSString stringWithFormat:@"%@goodsPackageId=%@&fromcategories=2",requestProductDetailTow,[sender.userInfo objectForKey:@"goods_Package_ID"]];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else if([[sender.userInfo objectForKey:@"isShop"] isEqualToString:@"2"]){
        STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
        detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,[sender.userInfo objectForKey:@"pid"]];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else if ([[sender.userInfo objectForKey:@"isShop"] isEqualToString:@"3"]){
        STShopHomeViewController *shopHomeVC = [STShopHomeViewController new];
//        shopHomeVC.hidesBottomBarWhenPushed = YES;
        shopHomeVC.typeDict = @{@"storeid":[sender.userInfo objectForKey:@"storeid"]};
         [self.navigationController pushViewController:shopHomeVC animated:YES];
    }
}
//返回
-(void)popBackMothed{
    
    if (_backTopBlock) {
         [self.navigationController popViewControllerAnimated:NO];
        _backTopBlock();
        
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scanName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Details" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showListFilterView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hiddenListFilterView" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [self performSelector:@selector(listBgViewFirstResponder) withObject:self afterDelay:.5];
    
}
-(void)listBgViewFirstResponder{
    [_listBgView listTextFieldResignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
