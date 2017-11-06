//
//  STWisdomNotView.h
//  sosoYY
//
//  Created by soso-mac on 2017/1/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomNotView : UIView
@property (strong, nonatomic) UILabel *errorLab;
-(void)setError:(NSString *)error;
@end
