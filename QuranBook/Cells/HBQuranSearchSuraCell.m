//
//  HBQuranSearchSuraCell.m
//  Habar
//
//  Created by Соколов Георгий on 02.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranSearchSuraCell.h"

#define kSuraTitleHeight   30.f

@implementation HBQuranSearchSuraCell


+ (NSString *)identifierCell
{
    return @"quranSearchSuraCell";
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

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)displaySubtitle:(NSString *)subtitle
{
    self.subTitleLabel.text = subtitle;
}

@end
