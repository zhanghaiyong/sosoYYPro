//
//  STStorewideViewController.m
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STStorewideViewController.h"
#import "STStorewideFilterView.h"
#import "STStorewideBgView.h"
#import "ScanViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "SYQRCodeViewController.h"
#import "STProductDetailsViewController.h"

@interface STStorewideViewController (){
    BOOL isSelected;
    __block BOOL isBack;
}
@property(strong,nonatomic)STStorewideFilterView *filterView;
@property(strong,nonatomic)STStorewideBgView *storewideBgView;
@end

@implementation STStorewideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    isBack = YES;
    isSelected = YES;
    [self addSubView];
//    [self setupForDismissKeyboard];
}

-(void)addSubView{
    _filterView = [[STStorewideFilterView alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100, self.view.frame.size.height)];
    [self.view addSubview:_filterView];
    
    _storewideBgView = [[STStorewideBgView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) typeDict:_typeDict];
    [self.view addSubview:_storewideBgView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backMothed)
                                                 name:@"storewideback"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showFilterView)
                                                 name:@"filterView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenFilterView)
                                                 name:@"hiddenFilterView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushScan)
                                                 name:@"pushScan"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushStorewideDetailsMothed:)
                                                 name:@"StorewideDetails"
                                               object:nil];
}
-(void)showFilterView{
    if (isSelected) {
        [UIView animateWithDuration:0.3 animations:^{
            _storewideBgView.frame  = CGRectMake(-(self.view.frame.size.width - 100), 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
        isSelected = NO;
    }else{
        [self hiddenFilterView];
    }
}
-(void)hiddenFilterView{
    isSelected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _storewideBgView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
-(void)backMothed{
    
    
    
    if (_backTopBlock) {
        [self.navigationController popViewControllerAnimated:NO];
        _backTopBlock();
    }else {
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)pushScan{
    NSDictionary *dict =@{@"scanSelected":@"0",@"storeid":@""};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"scanSelected"];
    [[STCommon sharedSTSTCommon]toScanViewWith:self];
}
-(void)pushStorewideDetailsMothed:(NSNotification *)sender{
    STProductDetailsViewController *detailsVC = [STProductDetailsViewController new];
    detailsVC.urlStr = [NSString stringWithFormat:@"%@pid=%@&fromcategories=2",requestProductProductBuy,[sender.userInfo objectForKey:@"pid"]];
    detailsVC.backBlock = ^(id sender){
        isBack = NO;
    };
    [self.navigationController pushViewController:detailsVC animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"storewideback" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"filterView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hiddenFilterView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushScan" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StorewideDetails" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (isBack) {
        [_storewideBgView viewWillAppear];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self performSelector:@selector(storewideFirstResponder) withObject:self afterDelay:.5];
}
-(void)storewideFirstResponder{
    [_storewideBgView storewideTextFieldResignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end