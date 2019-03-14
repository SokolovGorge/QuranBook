//
//  HBQuranSuraCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranSuraCell.h"

#define kSuraTitleHeight   37.f

@implementation HBQuranSuraCell

+ (NSString *)identifierCell
{
    return @"quranSuraCell";
}

- (void)setState:(HBSuraCellState)state
{
    _state = state;
    switch (state) {
        case HBSuraCellStateNormal:
            [self.activityView stopAnimating];
            break;
        case HBSuraCellStateWaiting:
            [self.activityView startAnimating];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.state = HBSuraCellStateNormal;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.state = HBSuraCellStateNormal;
}

- (void)setTitleImage:(UIImage *)titleImage
{
    if (titleImage && titleImage.size.width > 0) {
        CGFloat width = roundf(kSuraTitleHeight / titleImage.size.height * titleImage.size.width);
        self.titleHeightConstraint.constant = kSuraTitleHeight;
        self.titleWidthConstraint.constant = width;
    }
    self.titleImageView.image = titleImage;
}

- (UIImage *)titleImage
{
    return self.titleImageView.image;
}

- (void)updateSizeByImageSize:(CGSize)imageSize
{
    CGFloat width = roundf(kSuraTitleHeight / imageSize.height * imageSize.width);
    self.titleHeightConstraint.constant = kSuraTitleHeight;
    self.titleWidthConstraint.constant = width;
}

- (void)modifyBackgroudColor:(UIColor *)color
{
    self.backgroundColor = color;
}

- (void)setHiddenNumber:(BOOL)hidden
{
    self.numberLabel.hidden = hidden;
}

- (void)displayNumber:(NSString *)number
{
    self.numberLabel.text = number;
}

- (void)displayIconImage:(UIImage *)image
{
    self.iconImageView.image = image;
}

- (void)displayTitleImage:(UIImage *)image
{
    self.titleImage = image;
}

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)displaySubtitle:(NSString *)subtitle
{
    self.subTitleLabel.text = subtitle;
}

@end
