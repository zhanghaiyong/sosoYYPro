//
//  MaskingView.m
//  sosoYY
//
//  Created by zhy on 17/3/3.
//  Copyright © 2017年 felix. All rights reserved.
//

#define margin 10
#import "MaskingView.h"

@interface MaskingView ()
{
    Direction _direction;
    UILabel   *_label;
}

@end

@implementation MaskingView

- (instancetype)initWithFrame:(CGRect)frame direction:(Direction)direction {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        
        _direction = direction;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {

    
    CGRect labelFrame;
    switch (_direction) {
            
        case LEFT_TOP:
            
            labelFrame = CGRectMake(0, margin, self.width, self.height-margin);
            
            break;
            
        case RIGHT_TOP:
            
            labelFrame = CGRectMake(0, margin, self.width, self.height-margin);
            break;
            
        case LEFT_BOTTOM:
            
            labelFrame = CGRectMake(0, 0, self.width, self.height-margin);
            
            break;
            
        case RIGHT_BOTTOM:
            
            labelFrame = CGRectMake(0, 0, self.width, self.height-margin);
            
        default:
            break;
    }
    _label = [[UILabel alloc]initWithFrame:labelFrame];
    _label.font = [UIFont systemFontOfSize:13];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

-(void)setAlertString:(NSString *)alertString {

    _alertString = alertString;
    _label.text = alertString;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    switch (_direction) {
            
        case LEFT_TOP:
            
            CGContextMoveToPoint(ctx, 0, margin+5); //1
            CGContextAddArcToPoint(ctx, 0, margin, 5,margin,3);
            CGContextAddLineToPoint(ctx, margin, margin); //2
            CGContextAddLineToPoint(ctx, margin*2, 0);//3
            CGContextAddLineToPoint(ctx, margin*3, margin);//4
            CGContextAddLineToPoint(ctx, self.width-5, margin);//5
            CGContextAddArcToPoint(ctx, self.width, margin, self.width,margin+5,3);
            CGContextAddLineToPoint(ctx, self.width, self.height);//6
            CGContextAddLineToPoint(ctx, 0, self.height);//7
            break;
            
            case RIGHT_TOP:
            
            CGContextMoveToPoint(ctx, 0, margin+5); //1
            CGContextAddArcToPoint(ctx, 0, margin, 5,margin,3);
            CGContextAddLineToPoint(ctx, self.width-margin*3, margin); //2
            CGContextAddLineToPoint(ctx, self.width - margin*2, 0);//3
            CGContextAddLineToPoint(ctx, self.width - margin, margin);//4
            CGContextAddLineToPoint(ctx, self.width-5, margin);//5
            CGContextAddArcToPoint(ctx, self.width, margin, self.width,margin+5,3);
            CGContextAddLineToPoint(ctx, self.width, self.height);//6
            CGContextAddLineToPoint(ctx, 0, self.height);//7
            break;
            
        case LEFT_BOTTOM:
            
            CGContextMoveToPoint(ctx, 0, 0); //1
            CGContextAddLineToPoint(ctx, self.width, 0); //2
            CGContextAddLineToPoint(ctx, self.width, self.height-margin-5); //3
            CGContextAddArcToPoint(ctx, self.width, self.height-margin, self.width-5,self.height-margin,3);//4 5
            CGContextAddLineToPoint(ctx, margin*3, self.height-margin); //6
            CGContextAddLineToPoint(ctx, margin*2, self.height); //7
            CGContextAddLineToPoint(ctx, margin, self.height-margin); //8
            CGContextAddLineToPoint(ctx, 5, self.height-margin); //8
            CGContextAddArcToPoint(ctx, 0, self.height-margin, 0,self.height-margin-5,3);//9 10
            break;
            
        case RIGHT_BOTTOM:
            
            CGContextMoveToPoint(ctx, 0, 0); //1
            CGContextAddLineToPoint(ctx, self.width, 0); //2
            CGContextAddLineToPoint(ctx, self.width, self.height-margin-5); //3
            CGContextAddArcToPoint(ctx, self.width, self.height-margin, self.width-5,self.height-margin,3);//4 5
            CGContextAddLineToPoint(ctx, self.width-margin, self.height-margin); //6
            CGContextAddLineToPoint(ctx, self.width-margin*2, self.height); //7
            CGContextAddLineToPoint(ctx, self.width-margin*3, self.height-margin); //8
            CGContextAddLineToPoint(ctx, 5, self.height-margin); //9
            CGContextAddArcToPoint(ctx, 0, self.height-margin, 0,self.height-margin-5,3);//4 5
            break;
            
        default:
            break;
    }
    
    [[UIColor colorWithWhite:0 alpha:0.6] set];
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}


@end
