//
//  ApplyMsgModel.h
//  sosoYY
//
//  Created by zhy on 2017/8/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyMsgModel : NSObject<MJKeyValue>

@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *storeName;
@property (nonatomic,strong)NSString *number;
@property (nonatomic,strong)NSString *realname;
@property (nonatomic,strong)UIImage *editImage;
@property (nonatomic,strong)UIImage *oriImage;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,assign)CLLocationDegrees latitude;
@property (nonatomic,assign)CLLocationDegrees longitude;
@end
