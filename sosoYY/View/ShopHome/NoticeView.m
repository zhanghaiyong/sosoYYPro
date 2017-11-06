//
//  NoticeView.m
//  sosoYY
//
//  Created by zhy on 2017/10/19.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "NoticeView.h"

@interface NoticeView ()
{
    UITableView *tableV;
    NSInteger row;
    NSArray *newsList;
}
@end

@implementation NoticeView

- (instancetype)initWithFrame:(CGRect)frame newsList:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        newsList = [NSArray arrayWithArray:array];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    UIImageView *noticeImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 24, 24)];
    noticeImg.image = [UIImage imageNamed:@"公告"];
    noticeImg.contentMode =  UIViewContentModeCenter;
    [self addSubview:noticeImg];
    
    tableV = [[UITableView alloc]initWithFrame:CGRectMake(noticeImg.right, 0, self.width-noticeImg.width, self.height)];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.scrollEnabled = NO;
    tableV.separatorColor = [UIColor clearColor];
    [self addSubview:tableV];
    
    _time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollCell) userInfo:nil repeats:YES];
}


- (void)scrollCell {
    
    NSLog(@"noticeView被销毁了");
    
    if (row == newsList.count-1) {
        row = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }else {
        row ++;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [tableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }

}

#pragma mark UITableVIewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuser = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuser];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = newsList[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor fromHexValue:0x555555];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了cell");
    if (_tapNoticeTabBack) {
        _tapNoticeTabBack();
    }
}

@end
