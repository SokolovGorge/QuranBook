//
//  HBUIStyleManager.m
//  QuranBook
//
//  Created by Соколов Георгий on 11/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBUIStyleManager.h"
#import "UIColor+Habar.h"
#import "HBConstants.h"

@implementation HBUIStyleManager

+ (void)applyStyles
{
    [self applyNavBarStyle];
}

+ (void)resetStyles
{
    [self resetStyles];
}

+ (void)applyNavBarStyle
{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTranslucent:NO];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithHex:kHabarColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

+ (void)resetNavBarStyle
{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setTranslucent:YES];
    [UINavigationBar appearance].tintColor = nil;
    [UINavigationBar appearance].barTintColor = nil;
    [UINavigationBar appearance].titleTextAttributes = nil;
}

@end
