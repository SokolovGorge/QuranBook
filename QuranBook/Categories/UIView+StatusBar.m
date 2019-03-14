//
//  UIView+StatusBar.m
//  Habar
//
//  Created by Соколов Георгий on 09.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "UIView+StatusBar.h"

@implementation UIView (StatusBar)

+ (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
