//
//  HBCircleProgressView.h
//  Habar
//
//  Created by Соколов Георгий on 16.01.2018.
//  Copyright © 2018 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBCircleProgressView : UIView

@property (assign, nonatomic, readonly) CGFloat percent;

- (instancetype)initWithFrame:(CGRect)frame withStrokeColor:(UIColor *)strokeColor withLineWidth:(CGFloat)lineWidth;

- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

- (void)setPercent:(CGFloat)percent withAnimate:(BOOL)animate;

- (void)setStrokeColor:(UIColor *)strokeColor;

@end
