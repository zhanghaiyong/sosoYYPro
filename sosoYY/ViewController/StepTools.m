//
//  StepTools.m
//  sosoYY
//
//  Created by zhy on 2017/8/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "StepTools.h"

@implementation StepTools
//原始尺寸
static CGRect oldframe;
static UIButton *button;
static UIImageView *imageView;
static UIView *backgroundView;
/**
 *  浏览大图
 *
 *  @param currentImageview 当前图片
 *  @param alpha            背景透明度
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview image:(UIImage *)image alpha:(CGFloat)alpha button:(UIButton *)modifyBtn {
    
    //  当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //  背景
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
    //  当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:alpha]];
    
    //  此时视图不会显示
    [backgroundView setAlpha:0];
    //  将所展示的imageView重新绘制在Window中
    imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    [imageView setTag:1024];
    [backgroundView addSubview:imageView];
    //  将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    if (modifyBtn) {
        button = modifyBtn;
        [window addSubview:modifyBtn];
    }
    
    
    //  添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //  动画放大所展示的ImageView
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸

 */
+(void)hideImageView {
    
    [button removeFromSuperview];
//    UIView *backgroundView = tap.view;
//    //  原始imageview
//    UIImageView *imageView = [tap.view viewWithTag:1024];
    //  恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}


- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

+ (UIImage *) imageyasuo: (UIImage *) image fillSize: (CGSize) newSize {
    
    CGSize size = image.size;
    
    CGFloat scalex = newSize.width / size.width;
    CGFloat scaley = newSize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(newSize);
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    float dwidth = ((newSize.width - width) / 2.0f);
    float dheight = ((newSize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
    
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // End the context
//    UIGraphicsEndImageContext();
//    // Return the new image.
//    return newImage;
}

//获取申请人信息
+(void)getApplyMsgRequest:(NSString *)url finshed:(void(^)(ApplyMsgModel *entity,NSError *error))finshed {

    [KSMNetworkRequest postRequest:requestApplyMsg params:nil success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
            
            NSDictionary *dic = responseObj[@"data"];
            ApplyMsgModel *entity = [ApplyMsgModel mj_objectWithKeyValues:dic];
            finshed(entity,nil);

        }else {
            
            finshed(nil,nil);
        }
    } failure:^(NSError *error) {
        
        finshed(nil,error);
    }];
}

//获取申请人照片信息
+(void)getApplyImgRequest:(NSString *)url finshed:(void(^)(id entity,NSError *error))finshed {
    
    [KSMNetworkRequest postRequest:requestApplyImg params:nil success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([[responseObj objectForKey:@"success"] integerValue] == 1) {
            
            NSDictionary *dic = responseObj[@"data"];
            finshed(dic,nil);
            
        }else {
            
            finshed(nil,nil);
        }
    } failure:^(NSError *error) {
        
        finshed(nil,error);
    }];
}


@end
