//
//  AnimationView.m
//  sosoYY
//
//  Created by zhy on 2017/7/12.
//  Copyright © 2017年 felix. All rights reserved.
//

#define CELLH 60

#import "AnimationView.h"
#import "AnimationCell.h"
@interface AnimationView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)UIButton *animationBtn;
@property (nonatomic,strong)UILabel  *closeLabel;
@property (nonatomic,strong)UIView   *backView;
@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = [NSArray arrayWithArray:dataSource];
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    
    self.backView = [[UIView alloc]initWithFrame:self.frame];
    self.backView.clipsToBounds = YES;
    [self addSubview:self.backView];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth-160, kScreenHeight - 130, 1, 1) style:UITableViewStylePlain];
    self.tableV.separatorColor = [UIColor clearColor];
    self.tableV.hidden = YES;
    self.tableV.backgroundColor = [UIColor clearColor];
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    [self.backView addSubview:self.tableV];
    
    
    self.closeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-60, kScreenHeight-20, 40, 30)];
    self.closeLabel.text = @"关闭";
    self.closeLabel.textAlignment = NSTextAlignmentCenter;
    self.closeLabel.textColor = [UIColor whiteColor];
    self.closeLabel.backgroundColor = [UIColor blackColor];
    [self.closeLabel sizeToFit];
    self.closeLabel.font = [UIFont systemFontOfSize:14];
    self.closeLabel.layer.cornerRadius = 2;
    self.closeLabel.clipsToBounds = YES;
    self.closeLabel.hidden = YES;
    self.closeLabel.frame = CGRectMake(kScreenWidth-60, kScreenHeight-100-(20-self.closeLabel.height/2)-self.closeLabel.height, self.closeLabel.width, self.closeLabel.height);
    [self.backView addSubview:self.closeLabel];
    
    self.animationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.animationBtn.backgroundColor = [UIColor fromHexValue:0xEA5413];
    self.animationBtn.layer.cornerRadius = self.width/2;
    [self.animationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.animationBtn setImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    [self.animationBtn addTarget:self action:@selector(animationMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.animationBtn];
}

- (void)animationMethod {
    
    if (_foldAnimationBlock) {
        _foldAnimationBlock(!self.animationBtn.selected);
    }
    
    if (self.animationBtn.selected) {
        
        [self repeatAnimation];
        self.animationBtn.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.tableV.frame = CGRectMake(kScreenWidth-160, kScreenHeight - 130, 150, 1);
            self.closeLabel.hidden = YES;
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.tableV.frame = CGRectMake(kScreenWidth-160, kScreenHeight - 130, 1, 1);
            }completion:^(BOOL finished) {
                self.tableV.hidden = YES;
                self.backView.frame = self.frame;
                self.backView.backgroundColor = [UIColor clearColor];
            }];
        }];
    }else {
    
        [self AnimationGroup];
        
        self.backView.frame = CGRectMake(-(kScreenWidth-70), -(kScreenHeight-150), kScreenWidth, kScreenHeight);
        self.animationBtn.selected = YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.tableV.hidden = NO;
            self.tableV.frame = CGRectMake(kScreenWidth-160, kScreenHeight - 130, 150, 1);
            self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        }completion:^(BOOL finished) {
            self.closeLabel.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.tableV.frame = CGRectMake(kScreenWidth-160, kScreenHeight - self.dataSource.count * CELLH-150, 150, self.dataSource.count * CELLH);
            }];
        }];
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return CELLH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reuser = @"cell";
    AnimationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnimationCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.tltle.text = dic[@"title"];
    cell.logo.image = [UIImage imageNamed:dic[@"logo"]];
    cell.logo.backgroundColor = dic[@"color"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_searchScanBlock) {
        _searchScanBlock(indexPath.row);
    }
    
    [self animationMethod];
    
}

- (void)repeatAnimation {

    [UIView animateWithDuration:0.3 animations:^{
        
        self.closeLabel.transform = CGAffineTransformIdentity;
        self.animationBtn.transform = CGAffineTransformIdentity;
        self.animationBtn.backgroundColor = [UIColor fromHexValue:0xEA5413];
    }];
}

- (void)AnimationGroup {

    /* 移动 */
    [UIView animateWithDuration:0.3 animations:^{
    
        self.closeLabel.transform = CGAffineTransformMakeTranslation(-self.closeLabel.width-20, 0);
    }];
    
    /* 旋转 */
    [UIView animateWithDuration:0.3 animations:^{
        
        self.animationBtn.backgroundColor = [UIColor fromHexValue:0x777777];
         self.animationBtn.transform = CGAffineTransformMakeRotation(-M_PI_4); //缩放+旋转
     }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.tableV convertPoint:point fromView:self];
    if ([self.self.tableV pointInside:buttonPoint withEvent:event]) {
        return self.tableV;
    }
    
    if (self.animationBtn.selected == YES) {
        [self animationMethod];
    }
    
    return result;
}

@end
