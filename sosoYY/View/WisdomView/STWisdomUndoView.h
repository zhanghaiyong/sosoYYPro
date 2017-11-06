//
//  STWisdomUndoView.h
//  sosoYY
//
//  Created by soso-mac on 2017/2/21.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomUndoView : UIView
@property(copy,nonatomic)void(^WisdomUndoViewBlock)(void);
@property(strong,nonatomic)UILabel *numLab;
@end
