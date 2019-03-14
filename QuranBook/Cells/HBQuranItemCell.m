//
//  HBQuranItemCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HBQuranItemCell

@synthesize state = _state;

+ (NSString *)identifierCell
{
    return @"quranCell";
}

- (void)setState:(HBQuranItemState)state
{
    _state = state;
    self.checkedImageView.hidden = state != HBQuranItemStateChecked;
    self.deleteImageView.hidden = state != HBQuranItemStateLoaded;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.checkedImageView.image = [UIImage imageNamed:@"checkmark"];
    self.state = HBQuranItemStateNone;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.state = HBQuranItemStateNone;
}

#pragma mark - HBQuranItemCellView

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)displaySubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
    self.titleVerticalConstraint.constant = self.subtitleLabel.text.length > 0 ? -8.f : 0.f;
}

- (void)setImageByURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
    [self.itemImageView sd_setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setItemImage:(UIImage *)image
{
    self.itemImageView.image = image;
}

- (void)addDeleteActionWithTarget:(id)target action:(SEL)sel
{
    if (!self.deleteImageView.userInteractionEnabled) {
        self.deleteImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *_tapDeleteGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
        [self.deleteImageView addGestureRecognizer:_tapDeleteGesture];
    }
}

@end
