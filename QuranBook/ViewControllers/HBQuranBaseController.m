//
//  HBQuranBaseController.m
//  Habar
//
//  Created by Соколов Георгий on 11.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranBaseController.h"
#import "QuranPlayerSmallView.h"
#import "HBQuranPlayerController.h"

#define kPlayerViewSize    54.f
#define kRightMargin       30.f
#define kBottomMargin      60.f
#define kTimerInterval      1.f

@interface HBQuranBaseController ()

@property (strong, nonatomic) QuranPlayerSmallView *playerSmallView;
@property (weak, nonatomic) NSLayoutConstraint *rightPlayerConstraint;
@property (weak, nonatomic) NSLayoutConstraint *bottomPlayerConstraint;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HBQuranBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.quranSoundService registerPresenterDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.quranSoundService.state == HBQuranSoundStatePlay || self.quranSoundService.state == HBQuranSoundStatePause) {
        [self showSmallPlayViewWithAnimate:NO];
        [self activateTimer];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self deactivateTimer];
}

- (void)dealloc {
    [self.quranSoundService unregisterPresenterDelegate:self];
 }

- (void)showSmallPlayViewWithAnimate:(BOOL)animate;
{
    if (self.playerSmallView) {
        return;
    }
    QuranPlayerSmallView *playerView = [QuranPlayerSmallView instanceFromNibByOwner:self];
    [playerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:playerView];
    NSLayoutConstraint *rightPlayerConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:playerView
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.f
                                                                              constant:animate ? - kPlayerViewSize : kRightMargin];
    NSLayoutConstraint *bottomPlayerConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:playerView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.f
                                                                               constant:animate ? - kPlayerViewSize : kBottomMargin];
    NSLayoutConstraint *widthPlayerConstraint = [NSLayoutConstraint constraintWithItem:playerView
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.f
                                                                               constant:kPlayerViewSize];
    NSLayoutConstraint *heightPlayerConstraint = [NSLayoutConstraint constraintWithItem:playerView
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1.f
                                                                               constant:kPlayerViewSize];
    [self.view addConstraints:@[rightPlayerConstraint, bottomPlayerConstraint]];
    [playerView addConstraints:@[widthPlayerConstraint, heightPlayerConstraint]];
    [self.view layoutIfNeeded];
    if (animate) {
        rightPlayerConstraint.constant = kRightMargin;
        bottomPlayerConstraint.constant = kBottomMargin;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    self.playerSmallView = playerView;
    self.rightPlayerConstraint = rightPlayerConstraint;
    self.bottomPlayerConstraint = bottomPlayerConstraint;
}

- (void)closeSmallPlayerView
{
    if (!self.playerSmallView) {
        return;
    }
    self.rightPlayerConstraint.constant = - kPlayerViewSize;
    self.bottomPlayerConstraint.constant = - kPlayerViewSize;
   [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                      } completion:^(BOOL finished) {
                         [self.playerSmallView removeFromSuperview];
                         self.playerSmallView = nil;
                     }];
}

- (void)activateTimer
{
    if (self.timer) {
        return;
    }
    [self.playerSmallView setPercent:self.quranSoundService.percentPlay withAnimate:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(updatePercent:) userInfo:nil repeats:YES];
}

- (void)deactivateTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Timer

- (void)updatePercent:(NSTimer *)timer
{
    float percent = self.quranSoundService.percentPlay;
    [self.playerSmallView setPercent:percent withAnimate:percent != 0.f];
}

#pragma mark - HBQuranPresenterDelegate

- (void)onStartPlaySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    [self showSmallPlayViewWithAnimate:YES];
    [self activateTimer];
}

- (void)onChangeSura:(NSInteger)suraIndex
{
    
}

- (void)onStopPlay
{
    [self closeSmallPlayerView];
    [self deactivateTimer];
}



@end
