//
//  QuranPlayerSmallView.m
//  Habar
//
//  Created by Соколов Георгий on 11.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "QuranPlayerSmallView.h"
#import "UIView+UIViewController.h"
#import "HBQuranPlayerController.h"
#import "HBQuranBaseController.h"
#import "SWRevealViewController.h"
#import "HBRevealChildController.h"
#import "HBCircleProgressView.h"


@interface QuranPlayerSmallView()

@property (weak, nonatomic) HBCircleProgressView *circleView;

@end

@implementation QuranPlayerSmallView

+ (instancetype)instanceFromNibByOwner:(id)owner
{
    QuranPlayerSmallView *view = [[NSBundle mainBundle] loadNibNamed:@"QuranPlayerSmallView" owner:owner options:nil].firstObject;
    UIColor *strokeColor = [UIColor colorWithRed:77.f/255.f green:77.f/255.f blue:77.f/255.f alpha:1.f];
    HBCircleProgressView *circleView = [[HBCircleProgressView alloc] initWithFrame:view.bounds withStrokeColor:strokeColor withLineWidth:4.f];
    [circleView setPercent:0.f withAnimate:NO];
    [view addSubview:circleView];
    NSLayoutConstraint *leftCircleConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:circleView
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.f
                                                                             constant:0.f];
    NSLayoutConstraint *rightCircleConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeRight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:circleView
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1.f
                                                                              constant:0.f];
    NSLayoutConstraint *topCircleConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:circleView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.f
                                                                               constant:0.f];
    NSLayoutConstraint *bottomCircleConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:circleView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.f
                                                                               constant:0.f];
    view.circleView = circleView;

    [view addConstraints:@[leftCircleConstraint, rightCircleConstraint, topCircleConstraint, bottomCircleConstraint]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(showPlayerAction:)];
    [view addGestureRecognizer:tapGesture];
    return view;
}

- (void)setPercent:(CGFloat)percent withAnimate:(BOOL)animate
{
    [self.circleView setPercent:percent withAnimate:animate];
}

- (void)showPlayerAction:(id)sender
{
    UIViewController *vc = [self viewController];
    if (vc) {
        //для слайдер меню выбираем корневой контроллер
        UIViewController *baseController = vc;
        if ([vc isKindOfClass:[HBRevealChildController class]]) {
            baseController = ((HBRevealChildController *)vc).revealController;
        }
        HBQuranPlayerController *playerController = [HBQuranPlayerController instanceFromStoryboard];
        playerController.parentController = (HBQuranBaseController *)vc;
        [baseController presentViewController:playerController animated:NO completion:nil];
    }
}

@end
