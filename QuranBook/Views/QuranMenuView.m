//
//  QuranManuView.m
//  Habar
//
//  Created by Соколов Георгий on 07.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "QuranMenuView.h"

#define kStartEdge    10.f
#define kEdgeMin      14.f
#define kEdgeMax      32.f
#define kButtonWidth  58.f
#define kMenuDuration 0.3

@interface QuranMenuView() {
    CGFloat c1, c2, c3, c4;
}

@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoriteConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playConstraint;

@property (assign, nonatomic) CGFloat edge;

@end

@implementation QuranMenuView

+ (instancetype)instanceFromNibByOwner:(id)owner
{
    return [[NSBundle mainBundle] loadNibNamed:@"QuranMenuView" owner:owner options:nil].firstObject;
}

- (instancetype)cloneView
{
    QuranMenuView *instance = [QuranMenuView instanceFromNibByOwner:self];
    instance.tag = self.tag;

    for (id target in self.viewButton.allTargets) {
        NSArray *actions = [self.viewButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString *action in actions) {
            [instance.viewButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    for (id target in self.favoriteButton.allTargets) {
        NSArray *actions = [self.favoriteButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString *action in actions) {
            [instance.favoriteButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    for (id target in self.noticeButton.allTargets) {
        NSArray *actions = [self.noticeButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString *action in actions) {
            [instance.noticeButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    for (id target in self.playButton.allTargets) {
        NSArray *actions = [self.playButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString *action in actions) {
            [instance.playButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    for (id target in self.closeButton.allTargets) {
        NSArray *actions = [self.closeButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (NSString *action in actions) {
            [instance.closeButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    return instance;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.viewLabel.text = NSLocalizedString(@"QuranMenuViewTitle", nil);
    self.favoriteLabel.text = NSLocalizedString(@"QuranMenuFavoriteTitle", nil);
    self.noticeLabel.text = NSLocalizedString(@"QuranMenuNoticeTitle", nil);
    self.playLabel.text = NSLocalizedString(@"QuranMenuPlayTitle", nil);
    CGRect rect = [UIScreen mainScreen].bounds;
    if (CGRectGetWidth(rect) <= 320) {
        self.edge = kEdgeMin;
    } else {
        self.edge = kEdgeMax;
    }
    [self clipLabel:self.viewLabel];
    [self clipLabel:self.favoriteLabel];
    [self clipLabel:self.noticeLabel];
    [self clipLabel:self.playLabel];
}

- (void)clipLabel:(UILabel *)label
{
    label.layer.cornerRadius = CGRectGetHeight(label.frame) / 2;
    label.clipsToBounds = YES;

}

- (void)prepareForSize:(CGSize)size
{
    self.frame = CGRectMake(0.f, 0.f, size.width, size.height);
    CGFloat delta = roundf((size.width - 2 * self.edge - 4 * kButtonWidth) / 3);
    c1 = self.edge;
    c2 = self.edge + (kButtonWidth + delta);
    c3 = self.edge + (kButtonWidth + delta) * 2;
    c4 = self.edge + (kButtonWidth + delta) * 3;
    self.viewConstraint.constant = kStartEdge;
    self.favoriteConstraint.constant = kStartEdge;
    self.noticeConstraint.constant = kStartEdge;
    self.playConstraint.constant = kStartEdge;
    [self layoutIfNeeded];
}

- (void)openMenuWithAnimate:(BOOL)animate
{
    self.viewConstraint.constant = c1;
    self.favoriteConstraint.constant = c2;
    self.noticeConstraint.constant = c3;
    self.playConstraint.constant = c4;
    if (animate) {
        [UIView animateWithDuration:kMenuDuration
                         animations:^{
                             [self layoutIfNeeded];
                         }];
    } else {
        [self layoutIfNeeded];
    }
}

- (void)closeMenuOnCompletion:(void (^)(void))completion
{
    self.viewConstraint.constant = kStartEdge;
    self.favoriteConstraint.constant = kStartEdge;
    self.noticeConstraint.constant = kStartEdge;
    self.playConstraint.constant = kStartEdge;
    [UIView animateWithDuration:kMenuDuration
                     animations:^{
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

@end
