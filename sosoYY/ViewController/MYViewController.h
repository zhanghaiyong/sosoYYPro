//
//  MYViewController.h
//  novel-design
//
//  Created by 杨千 on 16/2/24.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MYViewController : UIViewController
@property (strong, nonatomic)CustomWebView *webView;

//订单列表
-(void)reloadOrderList:(NSInteger)btnTag;

//通知 跳转到订单详情
-(void)jumpOrderDetail:(NSInteger)btnTag withUrl:(NSString *)url;

-(void)InitPage:(NSString*)url;
@end
