//
//  SwitchWalletBillView.m
//  sosoYY
//
//  Created by zhy on 2017/5/24.
//  Copyright © 2017年 felix. All rights reserved.
//

#define margin 10
#import "SwitchWalletBillView.h"

@interface SwitchWalletBillView ()
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataSource;
@end

@implementation SwitchWalletBillView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataSource = [NSArray arrayWithArray:array];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        [self setUp];
    }
    return self;
}

- (void)setUp {

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.width/2-50, 59, 100, self.dataSource.count*40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -8, 0, 0);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 3;
    self.tableView.layer.masksToBounds = YES;
    [self addSubview:self.tableView];
    

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2-5, 55, 10, 5)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"小三角"];
    [self addSubview:imageView];
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor fromHexValue:0x555555];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_switchTableBlock) {
        
        _switchTableBlock(indexPath.row);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (_removeMaskBlock) {
        
        _removeMaskBlock();
    }
}


@end
