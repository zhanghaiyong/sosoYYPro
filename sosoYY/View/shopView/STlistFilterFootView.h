//
//  STlistFilterFootView.h
//  my
//
//  Created by soso-mac on 2016/11/22.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STlistFilterFootViewDelegte <NSObject>

-(void)g_setFinished;
@end

@interface STlistFilterFootView : UICollectionReusableView
@property(assign,nonatomic)id<STlistFilterFootViewDelegte>delegate;
-(void)setAddBtn;
@end
