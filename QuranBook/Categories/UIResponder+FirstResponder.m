//
//  UIResponder+FirstResponder.m
//  Habar
//
//  Created by Соколов Георгий on 09.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+ (id)currentFirstResponder
{
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}

@end
