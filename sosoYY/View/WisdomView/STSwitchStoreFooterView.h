//
//  STSwitchStoreFooterView.h
//  sosoYY
//
//  Created by soso-mac on 2017/7/10.
//  Copyright © 2017年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSwitchStoreFooterView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *finishedBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *oldLab;
@property (weak, nonatomic) IBOutlet UILabel *line;

@property (copy, nonatomic) void(^SwitchStoreBuyCountBlock)(int type,NSDictionary *dict,NSIndexPath *indexpath);
@property (copy, nonatomic) void(^SwitchBouncedPromptBlock)(NSString *buyCount,STSwitchStoreEneity *entity,NSIndexPath *indexpath);
@property (copy, nonatomic) void(^SwitchNumBlock)(NSString *numPrice,NSString *buyCount,NSIndexPath *indexpath,CGFloat price);

-(void)setSwitchStoreByCountBuy:(STSwitchStoreEneity *)entity indexPath:(NSIndexPath *)indexPath buyCount:(NSString *)buyCount title:(NSString *)title;
-(void)setMode:(STSwitchStoreEneity *)mode buyCount:(NSString *)buyCount;
@end

