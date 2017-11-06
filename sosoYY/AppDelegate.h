//
//  AppDelegate.h
//  sosoYY
//
//  Created by zhy on 16/11/22.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UIAlertView *alert;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign)BOOL showAlert;
@property (copy,nonatomic)NSString * trackViewUrl;
@property (nonatomic,strong)AMapLocationManager *locationManager;
@property (assign, nonatomic) BOOL isLaunchedByNotification;
-(void)setShowViewController;
- (void)startLocationFinshed:(void(^)(CLLocationDegrees latitude,CLLocationDegrees longitude,NSError *error))finshed;
@end

