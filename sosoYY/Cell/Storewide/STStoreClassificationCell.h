//
//  STStoreClassificationCell.h
//  sosoYY
//
//  Created by soso-mac on 2016/12/1.
//  Copyright © 2016年 felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STStoreClassificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
-(void)setStoreClassification:(NSMutableArray *)arr indexpath:(NSIndexPath *)indexPath;
@end
