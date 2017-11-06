//
//  UIImageView+STAdd.m
//  sosoYY
//
//  Created by soso-mac on 2016/11/29.
//  Copyright © 2016年 felix. All rights reserved.
//

#import "UIImageView+STAdd.h"
#import <objc/runtime.h>

@implementation UIImageView (STAdd)
- (void)st_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    //    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    [self addSubview:activityView];
    //    [activityView startAnimating];
    //    activityView.frame = CGRectMake(self.frame.size.height/2 - 50 , self.frame.size.width/2 - 50, 100, 100);
    objc_setAssociatedObject(self, @selector(st_imageURL), url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        [activityView stopAnimating];
    }];
}
- (void)st_setImageWithURLString:(NSString *)urlString placeholderImage:(NSString *)placeholder {
    [self st_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeholder]];
}

- (NSURL *)st_imageURL {
    return objc_getAssociatedObject(self, @selector(st_imageURL));
}
@end
