//
//  NoticeListViewController.m
//  sosoYY
//
//  Created by zhy on 2017/10/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "NoticeListViewController.h"
#import "CouponViewController.h"
@interface NoticeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, KDeviceHeight-64)];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableFooterView = [UIView new];
    [self.view addSubview:tableV];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuser = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuser];
    }
    NSDictionary *dic = self.newsList[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor fromHexValue:0x555555];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.newsList[indexPath.row];
    CouponViewController *couponVC = [[CouponViewController alloc]init];
    couponVC.loadUrl = [NSString stringWithFormat:@"%@newsId=%@&storeId=%@",requestActiviteDetail,dic[@"newsid"],self.storeId];
    [self.navigationController pushViewController:couponVC animated:YES];
}


- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
