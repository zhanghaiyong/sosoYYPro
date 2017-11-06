//
//  UIColor+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "UIColor+XTExtension.h"

@implementation UIColor (XTExtention)

+ (UIColor *)fromHexValue:(NSUInteger)hex {
	NSUInteger a = ((hex >> 24) & 0x000000FF);
	float fa = ((0 == a) ? 1.0f : (a * 1.0f) / 255.0f);
    
	return [UIColor fromHexValue:hex alpha:fa];
}

+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha {
    if ( hex == 0xECE8E3 ) {
        
    }
	NSUInteger r = ((hex >> 16) & 0x000000FF);
	NSUInteger g = ((hex >> 8) & 0x000000FF);
	NSUInteger b = ((hex >> 0) & 0x000000FF);
	
	float fr = (r * 1.0f) / 255.0f;
	float fg = (g * 1.0f) / 255.0f;
	float fb = (b * 1.0f) / 255.0f;
	
	return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}

+ (UIColor *)fromShortHexValue:(NSUInteger)hex {
	return [UIColor fromShortHexValue:hex alpha:1.0f];
}

+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha {
	NSUInteger r = ((hex >> 8) & 0x0000000F);
	NSUInteger g = ((hex >> 4) & 0x0000000F);
	NSUInteger b = ((hex >> 0) & 0x0000000F);
	
	float fr = (r * 1.0f) / 15.0f;
	float fg = (g * 1.0f) / 15.0f;
	float fb = (b * 1.0f) / 15.0f;
	
	return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}

@end
