//
//  STStoreClassificationController.m
//  sosoYY
//
//  Created by soso-mac on 2016/12/1.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "STStoreClassificationController.h"
#import "STStoreClassificationCell.h"
#import "STStorewideViewController.h"

@interface STStoreClassificationController ()<UITableViewDelegate,UITableViewDataSource>{
    __block BOOL isOK;
}
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataResult;
@end

@implementation STStoreClassificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataResult = [NSMutableArray new];
    isOK = NO;
    [self addSubView];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self httpDownLoadStoreCateList:_storeid];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -- 店铺首页分类
-(void)httpDownLoadStoreCateList:(NSString *)storeid{
    __weak STStoreClassificationController *weakSelf = self;
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [KSMNetworkRequest getStoreCateListUrl:requestStoreCateList
                                     params:@{@"storeid":storeid} finshed:^(id dataResult, STStoreClassEntity *entity, NSError *error) {
                                         weakSelf.dataResult = dataResult;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [weakSelf.tableView reloadData];
                                             [weakSelf.tableView.mj_header endRefreshing];
                                             [[UIApplication sharedApplication].keyWindow hideToastActivity];
                                         });
                                         isOK = YES;
                                     }];
    });
    [[STCommon sharedSTSTCommon] setHideToastActivity:^(BOOL isYes) {
        if (isYes) {
            if (isOK) {
                return ;
            }
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
}

-(void)addSubView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}
#pragma mark --- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_dataResult.count != 0) {
            return 1;
        }
        return 0;
    }
    return _dataResult.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *StoreClass = @"StoreClass";
    STStoreClassificationCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreClass];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"STStoreClassificationCell" owner:self options:nil]lastObject];
    }
    [cell setStoreClassification:_dataResult indexpath:indexPath];
    return cell;
}

#pragma mark --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    STStorewideViewController *StorewideVC = [STStorewideViewController new];
    if (indexPath.section == 0) {
        StorewideVC.typeDict = @{@"storeid":_storeid,@"storecateid":@"",@"sort":@"default",@"IsBest":@"",@"StorekeyWords":@"",@"CateId":@""};
    }else{
        StorewideVC.typeDict = @{@"storeid":_storeid,@"storecateid":@"",@"sort":@"default",@"IsBest":@"",@"StorekeyWords":@"",@"CateId":[_dataResult[indexPath.row] CateId]};
    }
    [self.navigationController pushViewController:StorewideVC animated:YES];
}
- (IBAction)backSelected:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
