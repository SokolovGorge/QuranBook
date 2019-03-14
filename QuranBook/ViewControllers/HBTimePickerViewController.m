//
//  HBTimePickerViewController.m
//  Habar
//
//  Created by Соколов Георгий on 25.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBTimePickerViewController.h"
#import "HBParentControllerDelegate.h"
#import "HBConstants.h"

@interface HBTimePickerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation HBTimePickerViewController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBTimePickerViewController class])];
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
    self.bottomConstraint.constant = - self.heightConstraint.constant;
    [self.view layoutIfNeeded];
    [self setupLocalized];
    self.datePicker.date = _currentDate;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)setupLocalized
{
    [self.doneButton setTitle:NSLocalizedString(@"ButtonDone", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"ButtonCancel", nil) forState:UIControlStateNormal];
}

- (void) customDismissViewController
{
    self.backView.hidden = YES;
    self.bottomConstraint.constant = - self.heightConstraint.constant;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

- (NSDate *)currentDate
{
    return self.datePicker.date;
}

#pragma mark - Action

- (IBAction)doneAction:(id)sender
{
    [self.parentController onCommitActionFromChild:self userInfo:nil];
    [self customDismissViewController];

}

- (IBAction)cancelAction:(id)sender
{
    [self customDismissViewController];
}

@end
