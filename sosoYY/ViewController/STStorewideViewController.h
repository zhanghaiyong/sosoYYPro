//
//  STStorewideViewController.h
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStorewideViewController : BaseViewController
@property(strong,nonatomic)NSDictionary *typeDict;
@property (nonatomic,copy)void(^backTopBlock)(void);
@end
