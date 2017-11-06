//
//  TakePhotoViewController.h
//  Guide
//
//  Created by ksm on 16/4/19.
//  Copyright © 2016年 ksm. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnImageBlock)(UIImage *image);

@interface TakePhotoViewController : UIViewController
@property (nonatomic, copy) ReturnImageBlock callBack;

- (void)returnImage:(ReturnImageBlock)block;
@end
