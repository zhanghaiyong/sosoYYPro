//
//  CustomWebVIew.h
//  novel-design
//
//  Created by 杨千 on 16/3/9.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface CustomWebView : UIWebView<UIWebViewDelegate>
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) NSString *shareURL;
@property (nonatomic,weak)UIViewController *uiContainerViewControl;
-(void) registerGoHome:(UIViewController *)viewController;
@property(nonatomic,strong)NSURLRequest *nowRequest;
@property (nonatomic,strong)NSDictionary *dicShareProduct;
@property(nonatomic,copy)NSString *shareAppUrl;



@end
