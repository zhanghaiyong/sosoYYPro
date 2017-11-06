//
//  STShopHomeTopView.h
//  my
//
//  Created by soso-mac on 2016/12/15.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeView.h"

@protocol STShopHomeTopViewDelegate <NSObject>

-(void)g_setLogin:(void(^)(BOOL isLogin))finshed;
-(void)g_setChangeFavoriteStore:(NSString *)favoriteStore;
- (void)showNotice;
@end
@interface STShopHomeTopView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *concernLab;
@property (weak, nonatomic) IBOutlet UIImageView *concernImgV;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *tallageLab;
@property (weak, nonatomic) IBOutlet UILabel *pricLab;
@property (weak, nonatomic) IBOutlet UILabel *posLab;
@property (weak, nonatomic) IBOutlet UILabel *moreLab;
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgeV;
@property (weak, nonatomic) IBOutlet UIImageView *IOUImg;
@property (weak, nonatomic) IBOutlet UIView *newsListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsListViewH;

@property (nonatomic,strong)NSArray *newsList;

@property (nonatomic,strong)NoticeView *noticeView;

@property(assign,nonatomic)id<STShopHomeTopViewDelegate>delegate;
-(void)setShopHomeTop:(id)dataResult index:(NSInteger)index favoriteStore:(NSString *)favoriteStore;
@property (copy, nonatomic) void(^moreBlock)(id sender);
@end
