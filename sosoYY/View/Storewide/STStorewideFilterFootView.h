//
//  STStorewideFilterFootView.h
//  my
//
//  Created by soso-mac on 2016/11/25.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol STStorewideFilterFootViewDelegte <NSObject>

-(void)g_setStorewideFilterFinished;
@end

@interface STStorewideFilterFootView : UICollectionReusableView
@property(assign,nonatomic)id<STStorewideFilterFootViewDelegte>delegate;
-(void)setAddBtn;

@end
