//
//  STArtificialPurchasingView.h
//  sosoYY
//
//  Created by soso-mac on 2017/7/7.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WisdomShopViewController.h"
@interface STArtificialPurchasingView : UIView

@property(copy,nonatomic)void(^ArtificialPurchasingNumBlock)(NSString *num);
-(void)httpDownloadArtificialPurchasing;
@property(strong,nonatomic)WisdomShopViewController *controller;

@end
