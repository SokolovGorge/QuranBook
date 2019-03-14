//
//  HBQuranNoiticeController.m
//  Habar
//
//  Created by Соколов Георгий on 08.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranNoticeController.h"
#import "HBConstants.h"
#import "HBParentControllerDelegate.h"
#import "UIAlertController+Habar.h"

@interface HBQuranNoticeController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (assign, nonatomic) BOOL flagChanged;

@end

@implementation HBQuranNoticeController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranNoticeController class])];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self setupLocalized];
     [self checkDoneActive];
 }

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)setUp
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.textView.text = self.noticeText;
    self.flagChanged = NO;
}

- (void)setupLocalized
{
    self.doneButton.title = NSLocalizedString(@"ButtonDone", nil);
    self.cancelButton.title = NSLocalizedString(@"ButtonCancel", nil);
}

- (void)checkDoneActive
{
    self.doneButton.enabled = self.flagChanged;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self checkDoneActive];
    self.flagChanged = YES;
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender
{
    if (self.flagChanged) {
        [UIAlertController showAlertIn:self
                             withTitle:NSLocalizedString(@"ConfirmationTitle", nil)
                               message:NSLocalizedString(@"QuranNoiticeQuestion", nil)
                      firstButtonTitle:NSLocalizedString(@"ButtonNo", nil)
                      otherButtonTitle:NSLocalizedString(@"ButtonYes", nil)
                              tapBlock:^(HBAlertActionType actionType) {
                                  if (actionType == HBAlertActionOther) {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                              }];
    }  else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)doneAction:(id)sender
{
    if (self.parentController) {
        self.noticeText = self.textView.text;
        [self.parentController onCommitActionFromChild:self userInfo:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *) notification
{
    UIViewAnimationCurve animationCurve = [[notification.userInfo valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[notification.userInfo valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardBounds = [(NSValue *)[notification.userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.bottomConstraint.constant = - CGRectGetHeight(keyboardBounds);
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    UIViewAnimationCurve animationCurve = [[notification.userInfo valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[notification.userInfo valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.bottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

@end
