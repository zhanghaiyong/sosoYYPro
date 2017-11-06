//
//  STShopInfoFooterView.m
//  my
//
//  Created by soso-mac on 2016/12/19.
//  Copyright © 2016年 soso-mac. All rights reserved.
//

#import "STShopInfoFooterView.h"
#define kSreenHeight [UIScreen mainScreen].bounds.size.height
#define kSreenWidth [UIScreen mainScreen].bounds.size.width
@implementation STShopInfoFooterView

-(void)setContent:(NSString *)content finished:(void(^)(CGFloat hight))finished{
    if (![content isEqualToString:@""]) {
     _contentLab.text = content;
    }else{
      _contentLab.text = @"暂无介绍";
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = _contentLab.font.pointSize * 2;
    paraStyle.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle.tailIndent = 0.0f;//行尾缩进
    paraStyle.lineSpacing = 2.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_contentLab.text attributes:@{NSParagraphStyleAttributeName:paraStyle}];
    
    _contentLab.attributedText = attrText;
    
    CGSize contentSize = [_contentLab.text boundingRectWithSize:CGSizeMake(kSreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    _contentLab.frame = CGRectMake(10, 32, kScreenWidth - 20, contentSize.height);
    finished(contentSize.height);
}

@end
