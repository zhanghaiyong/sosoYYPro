//
//  STShopListTableViewCell.h
//  my
//
//  Created by soso-mac on 2016/11/24.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
-(void)setShopList:(NSArray *)arr indexPath:(NSIndexPath *)indexPath type:(NSInteger)type;
@end
