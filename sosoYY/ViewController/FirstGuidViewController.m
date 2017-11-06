//
//  FirstGuidViewController.m
//  novel-design
//
//  Created by 杨千 on 16/5/26.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "FirstGuidViewController.h"
#import "BaseTabBarCtrl.h"
#define kImageCount 4
#define kIntoButtonRatio 0.8//intoButton相对于pageImageView的高度比
#define kPageControlRatio 0.9//pageControl相对于根视图的高度比
@interface FirstGuidViewController ()<UIScrollViewDelegate>
//@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation FirstGuidViewController

-(void)loadView{
    [super loadView];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //     创建第二层的scrollView
    [self createScrollView];
    //     创建第二层的pageControl
//    [self createPageControl];
    [self initButton];
}

#pragma mark 创建和scrollView同为第二层视图的pageControl
//-(void)createPageControl{
//    
//    _pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-75, self.view.bounds.size.height-30, 150, 40)];
//    //    设置页数
//    [_pageControl setNumberOfPages:kImageCount];
//    //    设置页面轨道颜色
//    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
//    [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
//    //    注意，父视图不是ScrollView!
//    [self.view addSubview:_pageControl];
//}

- (void)initButton {
    
    UIButton *pass = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 25, 60, 40)];
    [pass setTitle:@"跳过" forState:UIControlStateNormal];
    [pass setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pass.layer.borderWidth = 1;
    pass.titleLabel.font = [UIFont systemFontOfSize:14];
    pass.layer.borderColor = [UIColor blackColor].CGColor;
    pass.layer.cornerRadius = 20;
    [pass addTarget:self action:@selector(intoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pass];
    
}

#pragma mark 创建第二层视图scrollView
-(void)createScrollView {
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    //    设置scrollView内容大小--可滑动范围
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width*kImageCount, 0)];
    //    向其中添加pageImageView
    scrollView.delegate = self;
    CGFloat width=self.view.bounds.size.width;
    CGFloat height=self.view.bounds.size.height;
    for (int i=0; i<kImageCount; i++) {
        //        相对于scrollView内容的位置
        UIImageView *pageImageView=[[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        [pageImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d.png",i + 1]]];
        if (i==kImageCount - 1) {
            //            [self createIntoButton:pageImageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(intoButtonClick)];
            [pageImageView addGestureRecognizer:tap];
            [pageImageView setUserInteractionEnabled:YES];
            
        }
        [scrollView addSubview:pageImageView];
    }
    //    设置分页,否则滚动效果很糟糕
    [scrollView setPagingEnabled:YES];
    //    去掉弹性
    [scrollView setBounces:NO];
    //    去掉滚动条
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    //    scrollView目前为第二层视图
    [self.view addSubview:scrollView];
}

//#pragma mark scrollView的代理方法
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
//    NSInteger index=scrollView.contentOffset.x/scrollView.bounds.size.width;
//    [_pageControl setCurrentPage:index];
//}

#pragma mark "立即体验"按钮消息响应
-(void)intoButtonClick{
    
    BaseTabBarCtrl *tabCtr=[[BaseTabBarCtrl alloc]init];
    UIWindow *window = (UIWindow *)[[UIApplication sharedApplication] keyWindow];
    window.rootViewController = tabCtr;
}





@end