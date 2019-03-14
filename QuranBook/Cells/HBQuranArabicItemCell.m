//
//  HBQuranArabicItemCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranArabicItemCell.h"

@implementation HBQuranArabicItemCell

@synthesize state = _state;

+ (NSString *)identifierCell
{
    return @"arabicItemCell";
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

#pragma mark - HBQuranArabicItemCellView

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)displaySubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
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
