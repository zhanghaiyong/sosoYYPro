//
//  HomeViewController.h
//  novel-design
//
//  Created by 杨千 on 16/2/20.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : BaseViewController
@property (nonatomic,strong) UILabel *newsNumLab;
@property (strong, nonatomic)CustomWebView *webView;

-(void)CheckVersion;
@end
