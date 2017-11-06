//
//  STWisdomAddListViewController.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomAddListViewController : UIViewController
@property(strong,nonatomic)NSString *storeid;
@property(copy,nonatomic)void(^WisdomAddListBackBlock)(void);
@end
