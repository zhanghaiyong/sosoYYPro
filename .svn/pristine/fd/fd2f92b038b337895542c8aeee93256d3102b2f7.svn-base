
//
//  DutyCodeViewController.m
//  sosoYY
//
//  Created by zhy on 2017/10/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "DutyCodeViewController.h"

@interface DutyCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dutyTF;

@end

@implementation DutyCodeViewController

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"税号";
    self.dutyTF.text = self.dutyStr;
}

- (IBAction)submitDutyAction:(id)sender {
    
    [self.view showLoadingView:@"loading"];
    if (self.dutyTF.text.length == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入税号"];
        [self.view hideToastActivity];
        return;
    }
    
    [KSMNetworkRequest postRequest:requestLoadDuty params:@{@"keyWords":self.dutyTF.text} success:^(id responseObj) {
        
        [self.view hideToastActivity];
        if ([responseObj[@"success"] integerValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:responseObj[@"info"]];
            
            [self performSelector:@selector(backAction:) withObject:self afterDelay:1];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObj[@"info"]];
        }
        
    } failure:^(NSError *error) {
        [self.view hideToastActivity];
    }];
    
}

- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
