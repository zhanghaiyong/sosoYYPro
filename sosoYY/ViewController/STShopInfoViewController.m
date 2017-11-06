//
//  STShopInfoViewController.m
//  my
//
//  Created by soso-mac on 2016/12/19.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopInfoViewController.h"
#import "STShopInfoCell.h"
#import "STShopInfoHeaderView.h"
#import "STShopInfoFooterView.h"

#define kSreenHeight [UIScreen mainScreen].bounds.size.height
#define kSreenWidth [UIScreen mainScreen].bounds.size.width

@interface STShopInfoViewController ()<UITableViewDelegate,UITableViewDataSource,STShopInfoHeaderViewDelegate>{
    __block BOOL isOK;
}
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)STShopInfoHeaderView *shopInfoHeaderView;
@property(strong,nonatomic)STShopInfoFooterView *shopInfoFooterView;
@property(strong,nonatomic)NSMutableArray *dataResult;
@property(strong,nonatomic)NSMutableDictionary *dataResultDict;
@property(strong,nonatomic)UITableView *mjTableView;
@end

@implementation STShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataResult = [NSMutableArray new];
    _dataResultDict = [NSMutableDictionary new];
    isOK = NO;
    
    
    _mjTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSreenWidth, kSreenHeight)style:UITableViewStylePlain];
    [_mjTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mjTableView];
    
    self.mjTableView.mj_header.automaticallyChangeAlpha = YES;
    self.mjTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self httpDownloadParams:@{@"storeid":_storeid}];
    }];
    [self.mjTableView.mj_header beginRefreshing];
}
-(void)httpDownloadParams:(NSDictionary *)params{
    __weak STShopInfoViewController *weakSelf = self;
    [[UIApplication sharedApplication].keyWindow showLoadingView:@"loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [KSMNetworkRequest getShopInfoListUrl:requestShopInfo
                                       params:params finshed:^(id dataResult,NSError *error) {
                                           weakSelf.dataResultDict = dataResult;
                                           [weakSelf.dataResult addObject:weakSelf.dataResultDict[@"StoreInfo"][@"ManagerName"]];
                                           [weakSelf.dataResult addObject:weakSelf.dataResultDict[@"StoreInfo"][@"Contact"]];
                                           [weakSelf.dataResult addObject:weakSelf.dataResultDict[@"StoreInfo"][@"Phone"]];
                                           [weakSelf.dataResult addObject:weakSelf.dataResultDict[@"StoreInfo"][@"Mobile"]];
                                           [weakSelf.dataResult addObject:weakSelf.dataResultDict[@"StoreInfo"][@"QQ"]];
                                           [weakSelf.dataResult addObject:weakSelf.dataResultDict[@"StoreKeeperInfo"][@"Address"]];
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self addSubView];
                                               [weakSelf.shopInfoFooterView setContent:weakSelf.dataResultDict[@"StoreInfo"][@"Description"] finished:^(CGFloat hight) {
                                                   weakSelf.shopInfoFooterView.frame = CGRectMake(0, 0, kSreenWidth, hight + 36);
                                               }];
                                               
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
            [weakSelf.mjTableView.mj_header endRefreshing];
        }
    }];
}

-(void)addSubView{
    NSArray *headerNib = [[NSBundle mainBundle]loadNibNamed:@"STShopInfoHeaderView" owner:self options:nil];
    _shopInfoHeaderView = [headerNib objectAtIndex:0];
    _shopInfoHeaderView.delegate = self;
    _shopInfoHeaderView.frame = CGRectMake(0, 0, kSreenWidth, 65);
    [_shopInfoHeaderView setShopInfoHeader:_dataResultDict];
    
    NSArray *footerNib = [[NSBundle mainBundle]loadNibNamed:@"STShopInfoFooterView" owner:self options:nil];
    _shopInfoFooterView = [footerNib objectAtIndex:0];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSreenWidth, kSreenHeight)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _shopInfoHeaderView;
    _tableView.tableFooterView = _shopInfoFooterView;
    [_tableView registerNib:[UINib nibWithNibName:[STShopInfoCell.class description] bundle:nil] forCellReuseIdentifier:@"STShopInfoCell"];
    [self.view addSubview:_tableView];
    [self.mjTableView.mj_header endRefreshing];
    self.mjTableView.hidden = YES;
}
#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataResult.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    STShopInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STShopInfoCell" forIndexPath:indexPath];
    [cell setShopInfo:_dataResult indexPath:indexPath];
    return cell;
}
#pragma mark -- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 || indexPath.row == 3) {
        [self setCallTell:_dataResult[indexPath.row]];
    }else if(indexPath.row == 4){
        [self setOpenQQ:_dataResult[indexPath.row]];
    }
}

#pragma mark -- STShopInfoHeaderViewDelegate
-(void)g_setInfoLogin:(void (^)(BOOL))finshed{
    __weak STShopInfoViewController *weakSelf = self;
    if ([weakSelf.login intValue] == 1) {
        finshed(YES);
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还未登录,是否登录?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_GoTab object:nil userInfo:@{@"selectIndex":@"4",@"frome":@"0"}];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        finshed(NO);
    }
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
