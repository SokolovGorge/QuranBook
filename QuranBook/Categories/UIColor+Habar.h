//
//  UIColor+Hex.h
//  Zinier
//
//  Created by Dmitry Laenko on 22/07/15.
//  Copyright (c) 2015 Zinier Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Habar)

/**
 takes @"#123456"
 */
+ (UIColor *)colorWithHex:(UInt32)col;

/**
 takes 0x123456
 */
+ (UIColor *)colorWithHexString:(NSString *)str;

+ (UInt32)hexFromColor:(UIColor *)color;

+ (UIColor *)defaultGreen;
+ (UIColor *)defaultBlue;
+ (NSArray *)defaultGradientCGColorPair;

@end
