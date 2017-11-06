//
//  STWisdomSearchViewController.h
//  sosoYY
//
//  Created by soso-mac on 2017/3/27.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWisdomSearchViewController : UIViewController
@property (nonatomic,copy)void(^backTopBlock)(void);
@property (nonatomic,copy)void(^backBlock)(void);
@property(strong,nonatomic)NSMutableArray *dataResult;
@property(strong,nonatomic)NSMutableDictionary *paramsDict;
@property(strong,nonatomic)NSString *codeStr;
@property(strong,nonatomic)STProductListEntity *toEntity;
@property(strong,nonatomic)NSString *keywords;
@end
