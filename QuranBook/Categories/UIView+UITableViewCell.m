//
//  UIView+UITableViewCell.m
//  Habar
//
//  Created by Соколов Георгий on 08.09.17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)

- (nullable __kindof UITableViewCell *)superViewCell
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *) self;
    }
    if (!self.superview) {
        return nil;
    }
    return [self.superview superViewCell];
}

@end
