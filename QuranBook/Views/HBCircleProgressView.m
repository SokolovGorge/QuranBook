//
//  HBCircleProgressView.m
//  Habar
//
//  Created by Соколов Георгий on 16.01.2018.
//  Copyright © 2018 Bezlimit. All rights reserved.
//

#import "HBCircleProgressView.h"

#define kShowTime   0.3f
#define kDiff       0.1f

@interface HBCircleProgressView() {
    
    UIColor *_strokeColor;
    CGFloat _lineWidth;
    
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGFloat _newPercent;
    NSTimer *_timer;
    BOOL _flagIncrease;
}

@end


@implementation HBCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame withStrokeColor:(UIColor *)strokeColor withLineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _strokeColor = strokeColor;
        _lineWidth = lineWidth;
        _startAngle = M_PI + M_PI_2;
        _endAngle = _startAngle + M_PI * 2;
        _percent = 0.f;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //убираем обработку всех событий из этого вьюера
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds)/ 2)
                          radius:CGRectGetWidth(self.bounds) / 2 - _lineWidth / 2
                      startAngle:_startAngle
                        endAngle:(_endAngle - _startAngle) * _percent / 100 + _startAngle
                       clockwise:YES];
    bezierPath.lineWidth = _lineWidth;
    [_strokeColor setStroke];
    [bezierPath stroke];
    
}

- (void)setPercent:(CGFloat)percent withAnimate:(BOOL)animate
{
    if (percent == _percent) {
        return;
    }
    if (percent < 0) {
        percent = 0;
    } else if (percent > 100) {
        percent = 100;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (!animate) {
        _percent = percent;
        [self setNeedsDisplay];
        return;
    }
    _flagIncrease = percent >= _percent;
    _newPercent = percent;
    int count = fabs(_newPercent - _percent) / kDiff;
    if (count > 1) {
        NSTimeInterval interval = kShowTime / count;
        _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(changePercent:) userInfo:nil repeats:YES];
    } else {
        _percent = _newPercent;
        [self setNeedsDisplay];
    }
}

- (void)changePercent:(NSTimer *)timer
{
    if ((_flagIncrease && _percent < _newPercent) || (!_flagIncrease && _percent > _newPercent)) {
        if (_flagIncrease) {
            _percent += kDiff;
        } else {
            _percent -= kDiff;
        }
        [self setNeedsDisplay];
    } else {
        _percent = _newPercent;
        [self setNeedsDisplay];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}


@end
