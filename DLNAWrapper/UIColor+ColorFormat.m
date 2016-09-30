//
//  UIColor+ColorFormat.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/28.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "UIColor+ColorFormat.h"

@implementation UIColor (ColorFormat)

+ (instancetype)colorWithFormat:(NSString *)color
{
    unsigned int alpha = 1;
    unsigned int red;
    unsigned int green;
    unsigned int blue;
    NSRange range;
    range.length = 2;
    
    if ([color hasPrefix:@"#"]) {
        color = [color substringFromIndex:1];
    }
    
    NSInteger colorLength = [color length];
    BOOL hasAlpha = NO;
    if (colorLength > 6) {
        hasAlpha = YES;
    }
    
    if (hasAlpha) {
        range.location = 0;
        [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&alpha];
    }
    
    range.location = hasAlpha ? 2 : 0;
    [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&red];
    
    range.location = hasAlpha ? 4 : 2;
    [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&green];
    
    range.location = hasAlpha ? 6 : 4;
    [[NSScanner scannerWithString:[color substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float) (red / 255.0f) green:(float) (green / 255.0f) blue:(float) (blue / 255.0f) alpha:hasAlpha? (float) (alpha / 255.0) : 1.0f];
}

@end
