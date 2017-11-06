//
//  WisdomHead.m
//  sosoYY
//
//  Created by zhy on 17/1/17.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "WisdomHead.h"
#import "WisdomModel.h"
#import "WisdomTool.h"
@interface WisdomHead ()
@end

@implementation WisdomHead

-(void)setWisdomModel:(WisdomModel *)wisdomModel {

    _wisdomModel = wisdomModel;
    
    self.lousImgW.constant = ([wisdomModel.islous integerValue] == 1) ? 39 : 0;
    
    self.StoreName.text = wisdomModel.store_Name;
}

-(void)setHaveSelectGood:(BOOL)haveSelectGood {

    _haveSelectGood = haveSelectGood;
}

-(void)setSectionCash:(double)sectionCash {

    _sectionCash = sectionCash;
    
    if (self.haveSelectGood) {

        //满足发货金额
        if ([self.wisdomModel.MoneySend doubleValue] > sectionCash && [self.wisdomModel.MoneySend intValue] > 0) {
            
            self.identifyLabel.text = @"起发";
            self.identifyLabel.textColor = [UIColor whiteColor];
            self.identifyLabel.backgroundColor = [UIColor fromHexValue:0xFF3333];
            
            
            NSString *string = [NSString stringWithFormat:@"%.2f",self.wisdomModel.MoneySend.doubleValue - sectionCash];
            NSString *alertString = [NSString stringWithFormat:@"还差￥%@ 点击凑单",[STCommon setHasSuffix:string]];
            NSString *length = [NSString stringWithFormat:@"%zi",alertString.length-2];
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"10",@"num":@"2"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"10",@"num":length}] andChengeString:alertString type:1 andFinished:^(NSMutableAttributedString *string) {
                self.content.attributedText = string;
            }];
            
            CGSize alertSize = [alertString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
            
            CGSize nameSize = [[self.wisdomModel.store_Name stringByReplacingOccurrencesOfString:@" " withString:@""] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5]} context:nil].size;
            
            
            if ((kScreenWidth-(40+6+19+26+3+5+alertSize.width+10)) > nameSize.width) {
                self.storeNameW.constant = nameSize.width;
            }else {
                self.storeNameW.constant = kScreenWidth-(40+6+19+26+3+5+alertSize.width+10);
            }
            
            //包邮
        }else if ([self.wisdomModel.MoneyFreePostage intValue] > 0 && self.wisdomModel.MoneyFreePostage.doubleValue > sectionCash) {
            
            
            self.identifyLabel.text = @"包邮";
            self.identifyLabel.textColor = [UIColor whiteColor];
            self.identifyLabel.backgroundColor = [UIColor fromHexValue:0xFFA800];
            
            NSString *string = [NSString stringWithFormat:@"%.2f",self.wisdomModel.MoneyFreePostage.doubleValue - sectionCash];
            NSString *alertString = [NSString stringWithFormat:@"还差￥%@ 点击凑单",[STCommon setHasSuffix:string]];
            NSString *length = [NSString stringWithFormat:@"%zi",alertString.length-2];
            [[STCommon sharedSTSTCommon] setChengeStringColor:@[@{@"color":[UIColor fromHexValue:0x555555 alpha:1],@"font":@"10",@"num":@"2"},@{@"color":[UIColor fromHexValue:0xea5413 alpha:1],@"font":@"10",@"num":length}] andChengeString:alertString type:1 andFinished:^(NSMutableAttributedString *string) {
                self.content.attributedText = string;
            }];
            
            CGSize alertSize = [alertString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
            
            CGSize nameSize = [[self.wisdomModel.store_Name stringByReplacingOccurrencesOfString:@" " withString:@""] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5]} context:nil].size;
            
            if ((kScreenWidth-(40+6+19+26+3+5+alertSize.width+10)) > nameSize.width) {
                self.storeNameW.constant = nameSize.width;
            }else {
                self.storeNameW.constant = kScreenWidth-(40+6+19+26+3+5+alertSize.width+10);
            }
            
        }else {
            
            
            CGSize nameSize = [[self.wisdomModel.store_Name stringByReplacingOccurrencesOfString:@" " withString:@""] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5]} context:nil].size;
            self.storeNameW.constant = nameSize.width;
            
            self.identifyLabel.hidden = NO;
            self.content.hidden =  NO;
            self.content.text = @"";
            
            self.identifyLabel.text = @"包邮";
            self.identifyLabel.textColor = [UIColor whiteColor];
            self.identifyLabel.backgroundColor = [UIColor fromHexValue:0x5AB85A];
            
        }
    }else {

        CGSize nameSize = [[self.wisdomModel.store_Name stringByReplacingOccurrencesOfString:@" " withString:@""] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.5]} context:nil].size;
        self.storeNameW.constant = nameSize.width;
        self.identifyLabel.hidden = YES;
        self.content.hidden = YES;
    }
}

- (IBAction)collectOrderAction:(id)sender {
    
    if (_toCollectBlock) {
        _toCollectBlock();
    }
}

//选中店铺
- (IBAction)isSelectAction:(UIButton *)sender {

    NSLog(@"selected = %zi",sender.selected);
    if (_headSelectBlock) {
        _headSelectBlock(!sender.selected);
    }
}

@end
