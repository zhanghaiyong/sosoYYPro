//
//  VersionView.h
//  sosoYY
//
//  Created by zhy on 2017/6/29.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (nonatomic,copy)void(^updateAPPBlock)();
@property (nonatomic,copy)void(^closeUpdateAlertBlock)();
@end
