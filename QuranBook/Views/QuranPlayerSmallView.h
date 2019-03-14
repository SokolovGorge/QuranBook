//
//  QuranPlayerSmallView.h
//  Habar
//
//  Created by Соколов Георгий on 11.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuranPlayerSmallView : UIView

+ (instancetype)instanceFromNibByOwner:(id)owner;

- (void)setPercent:(CGFloat)percent withAnimate:(BOOL)animate;

@end
