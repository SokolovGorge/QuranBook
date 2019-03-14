//
//  HBQuranSoundItemCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranSoundItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Habar.h"
#import "HBConstants.h"
#import "HBCircleProgressView.h"

#define kStopWidth    42.f

@implementation HBQuranSoundItemCell

@synthesize progressColor = _progressColor;
@synthesize checked = _checked;

+ (NSString *)identifierCell
{
    return @"quranSoundItemCell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.checked = NO;
    self.checkedImageView.image = [UIImage imageNamed:@"checkmark"];
    _progressColor = [UIColor colorWithHex:kHabarColor];
    HBCircleProgressView *view = [[HBCircleProgressView alloc] initWithFrame:self.execButton.bounds withStrokeColor:self.progressColor withLineWidth:3.f];
    [self.execButton addSubview:view];
    self.progressView = view;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.checked = NO;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    self.checkedImageView.hidden = !checked;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    [self.progressView setStrokeColor:progressColor];
}

#pragma mark - HBQuranSoundItemCellView

- (void)setVisibleStop:(BOOL)visible
{
    self.stopButton.hidden = !visible;
    self.stopWidthConstraint.constant = visible ? kStopWidth : 0.f;
    [self.loadView layoutIfNeeded];
}

- (void)setExecButtonImageNamed:(NSString *)imageNamed
{
    [self.execButton setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
}

- (void)setStopButtonImageNamed:(NSString *)imageNamed
{
    [self.stopButton setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
}

- (void)setPercent:(float)percent withAnimate:(BOOL)animate
{
    [self.progressView setPercent:percent withAnimate:animate];
}

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)displaySubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)displayStatus:(NSString *)status
{
    self.statusLabel.text = status;
}

- (void)displayInfo:(NSString *)info
{
    self.infoLabel.text = info;
}

- (void)setImageByUrl:(NSURL *)url withPlaceholderImage:(UIImage *)placeholder
{
    [self.itemImageView sd_setImageWithURL:url placeholderImage:placeholder];
}

- (void)setImage:(UIImage *)image
{
    self.itemImageView.image = image;
}

- (void)addStopTarget:(id)target action:(SEL)action
{
    [self.stopButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addExecTarget:(id)target action:(SEL)action
{
    [self.execButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
