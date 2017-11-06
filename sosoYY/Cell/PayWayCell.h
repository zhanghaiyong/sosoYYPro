//
//  PayWayCell.h
//  sosoyyDemo
//
//  Created by zhy on 16/11/21.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayWayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *payLogo;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UILabel *payExplain;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
