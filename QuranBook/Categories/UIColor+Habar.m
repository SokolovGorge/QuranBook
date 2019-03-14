//
//  UIColor+Hex.m
//  Zinier
//
//  Created by Dmitry Laenko on 22/07/15.
//  Copyright (c) 2015 Zinier Inc. All rights reserved.
//

#import "UIColor+Habar.h"

@implementation UIColor (Habar)

+ (UIColor *)colorWithHexString:(NSString *)str {
    
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    
    return [UIColor colorWithHex:(unsigned int)x];
}

+ (UIColor *)colorWithHex:(UInt32)col {
    
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+ (UInt32)hexFromColor:(UIColor *)color {
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    unsigned char r = lroundf(components[0] * 255);
    unsigned char g = lroundf(components[1] * 255);
    unsigned char b = lroundf(components[2] * 255);
    return b + (g << 8) + (r << 16);
}

+ (UIColor *)defaultGreen {
    return [UIColor colorWithRed:17./255. green:184./255. blue:106./255. alpha:1];
}

+ (UIColor *)defaultBlue {
    return [UIColor colorWithRed:38./255. green:140./255. blue:223./255. alpha:1];
}

+ (NSArray *)defaultGradientCGColorPair {
    return @[(id)[UIColor defaultGreen].CGColor, (id)[UIColor defaultBlue].CGColor];
}

@end
