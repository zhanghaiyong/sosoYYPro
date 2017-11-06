//
//  SelectListView.m
//  sosoYY
//
//  Created by zhy on 2017/7/11.
//  Copyright © 2017年 felix. All rights reserved.
//

#define CELLH 38

#import "SelectListView.h"

@interface SelectListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *selects;
@property (nonatomic,strong)UIImageView *backImage;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation SelectListView

- (instancetype)initWithFrame:(CGRect)frame selects:(NSArray *)selects
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selects = [NSArray arrayWithArray:selects];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        [self setUp];
    }
    return self;
}

- (void)setUp {

    self.backImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.backImage.layer.masksToBounds = YES;
    self.backImage.userInteractionEnabled = YES;
    self.backImage.layer.cornerRadius = 3.0f;
    [self addSubview:self.backImage];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 40;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 3.0f;
    [self.backImage addSubview:self.tableView];
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.backImage.frame = CGRectMake(kScreenWidth - 162, 54, 160, CELLH*self.selects.count + 4);
    self.backImage.image = [UIImage imageNamed:@"listed"];

    self.tableView.frame = CGRectMake(0, 4, self.backImage.width, CELLH*self.selects.count);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.selects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return CELLH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reuser = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuser];
    }
    
    NSDictionary *dic = self.selects[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"logo"]];
    cell.textLabel.text = [dic objectForKey:@"label"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectSelectListView) {
        _selectSelectListView(indexPath.row);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {


    if (_removeSelectListView) {
        _removeSelectListView();
    }
}

@end
