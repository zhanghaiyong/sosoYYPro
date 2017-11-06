//
//  StepTools.h
//  sosoYY
//
//  Created by zhy on 2017/8/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplyMsgModel.h"
@interface StepTools : NSObject
/**
 *  浏览大图
 *
 *  @param currentImageview 当前图片
 *  @param alpha            背景透明度
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview  image:(UIImage *)image alpha:(CGFloat)alpha button:(UIButton *)modifyBtn;

- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
/**
 *  恢复imageView原始尺寸
 
 */
+(void)hideImageView;

+ (UIImage *) imageyasuo: (UIImage *) image fillSize: (CGSize) viewsize;

//获取申请人信息
+(void)getApplyMsgRequest:(NSString *)url finshed:(void(^)(ApplyMsgModel *entity,NSError *error))finshed;
//申请人证件照片
+(void)getApplyImgRequest:(NSString *)url finshed:(void(^)(id entity,NSError *error))finshed;

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
@end
