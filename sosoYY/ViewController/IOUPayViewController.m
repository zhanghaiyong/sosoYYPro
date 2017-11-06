//
//  IOUPayViewController.m
//  sosoYY
//
//  Created by zhy on 2017/8/23.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "IOUPayViewController.h"
#import "IOUDetailViewController.h"
@interface IOUPayViewController ()
//可用额度
@property (weak, nonatomic) IBOutlet UILabel *UsableCreditLimitLab;
//总额度
@property (weak, nonatomic) IBOutlet UILabel *CreditLimitLab;
@property (weak, nonatomic) IBOutlet UILabel *WaitPayMoneyLab;

@end

@implementation IOUPayViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *UsableCreditLimit = [STCommon setHasSuffix:self.result[@"UsableCreditLimit"]];
    self.UsableCreditLimitLab.text = [NSString stringWithFormat:@"可用额度 %@",[STCommon addCutDownInStr:UsableCreditLimit]];
    
    NSString *CreditLimit = [STCommon setHasSuffix:self.result[@"CreditLimit"]];
    self.CreditLimitLab.text = [NSString stringWithFormat:@"总额度 %@",[STCommon addCutDownInStr:CreditLimit]];
    
    self.WaitPayMoneyLab.text = [NSString stringWithFormat:@"    申请金额 ￥%@",[STCommon setHasSuffix:self.result[@"OrderAmount_NoteBlank"]]];
    
}
- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)applyIouClick:(id)sender {
    
    
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    [KSMNetworkRequest postRequest:requestIOUPrePay params:@{@"masterOid":self.result[@"MasterOidList"]} success:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        
        if ([responseObj[@"success"] integerValue] == 1) {
            IOUDetailViewController *IOUDetailVC = [[IOUDetailViewController alloc]init];
            IOUDetailVC.data = responseObj[@"data"];
            [self.navigationController pushViewController:IOUDetailVC animated:YES];
        }else {
        
            [ZHProgressHUD showErrorWithText:responseObj[@"info"]];
        }
        
    } failure:^(NSError *error) {
        [ZHProgressHUD showInfoWithText:@"网络错误，请重试！"];
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}

@end
