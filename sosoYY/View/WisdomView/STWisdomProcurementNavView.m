//
//  STWisdomProcurementNavView.m
//  sosoYY
//
//  Created by soso-mac on 2017/3/6.
//  Copyright © 2017年 felix. All rights reserved.
//

#import "STWisdomProcurementNavView.h"

@implementation STWisdomProcurementNavView

- (IBAction)back:(id)sender {
    if (_WisdomProcurementNavViewBlock) {
        _WisdomProcurementNavViewBlock(0);
    }
}
- (IBAction)selectList:(UIButton *)sender {
    if (_WisdomProcurementNavViewBlock) {
        _WisdomProcurementNavViewBlock(1);
    }
}


@end
