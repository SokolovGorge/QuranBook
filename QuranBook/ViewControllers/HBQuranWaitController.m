//
//  HBQuranWaitController.m
//  Habar
//
//  Created by Соколов Георгий on 04.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranWaitController.h"
#import "HBConstants.h"

@interface HBQuranWaitController ()

@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) NSString *mesageString;

@end

@implementation HBQuranWaitController

+ (instancetype)instanceFromStoryboardWithMessage:(NSString *)message
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    HBQuranWaitController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranWaitController class])];
    vc.mesageString = message;
    return vc;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.definesPresentationContext = YES;
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barView.layer.cornerRadius = 8.f;
    self.barView.clipsToBounds = YES;
    self.messageLabel.text = self.mesageString;
    [self.activityIndicator startAnimating];
}

@end
