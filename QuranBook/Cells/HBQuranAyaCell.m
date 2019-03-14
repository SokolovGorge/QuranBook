//
//  HBQuranAyaCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranAyaCell.h"
#import "HBConstants.h"
#import "QuranMenuView.h"


@implementation HBQuranAyaCell

+ (NSString *)identifierCell
{
    return @"quranAyaCell";
}

- (UIImageView *)stateImageViewByIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return self.stateImageView0;
        case 1:
            return self.stateImageView1;
        case 2:
            return self.stateImageView2;
        default:
            return nil;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.stateImageView0.hidden = YES;
    self.stateImageView1.hidden = YES;
    self.stateImageView2.hidden = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.stateImageView0.hidden = YES;
    self.stateImageView1.hidden = YES;
    self.stateImageView2.hidden = YES;
}


#pragma mark - HBQuranAyaCellView

- (BOOL)hasArabicGesture
{
    return self.arabicTextView.gestureRecognizers.count > 0;
}

- (BOOL)hasTranslitGesture
{
    return self.translitTextView.gestureRecognizers.count > 0;
}

- (BOOL)hasTranslationGesture
{
    return self.translationTextView.gestureRecognizers.count > 0;
}

- (void)addArabicGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [self.arabicTextView addGestureRecognizer:gestureRecognizer];
}

- (void)addTranslitGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [self.translitTextView addGestureRecognizer:gestureRecognizer];
}

- (void)addTranslationGesture:(UIGestureRecognizer*)gestureRecognizer
{
    [self.translationTextView addGestureRecognizer:gestureRecognizer];
}

- (void)modifyBackgroundClolor:(UIColor *)backgroundColor
{
    self.backgroundColor = backgroundColor;
}

- (void)updateMenuView:(BOOL)visibleMenu
{
    QuranMenuView *menuView = [self getMenuView];
    if (visibleMenu) {
        if (!menuView) {
            [self.parentMenuView prepareForSize:self.contentView.bounds.size];
            [self.contentView addSubview:self.parentMenuView];
            [self.parentMenuView openMenuWithAnimate:NO];
        }
    } else {
        if (menuView) {
            [menuView removeFromSuperview];
        }
    }

}

- (void)displayNumber:(NSString *)numberText
{
    self.numberLabel.text = numberText;
}

- (void)displayArabicText:(NSAttributedString *)arabicText
{
    self.arabicTextView.attributedText = arabicText;
}

- (void)displayTranslitText:(NSAttributedString *)translitText
{
    self.translitTextView.attributedText = translitText;
}

- (void)displayTranslationText:(NSAttributedString *)translationText
{
    self.translationTextView.attributedText = translationText;
}

#pragma mark - Private Methods

- (QuranMenuView *)getMenuView {
    for (UIView *view in self.contentView.subviews) {
        if (view.tag == kMenuViewTag) {
            return (QuranMenuView *)view;
        }
    }
    return nil;
}


@end
