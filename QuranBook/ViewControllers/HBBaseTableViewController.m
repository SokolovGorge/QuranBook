//
//  HBBaseTableViewController.m
//  QuranBook
//
//  Created by Соколов Георгий on 02/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBBaseTableViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation HBBaseTableViewController

@synthesize parentPresenterDelegate =  _parentPresenterDelegate;

- (void)showWaitScreen
{
    [SVProgressHUD show];
}

- (void)hideWaitScreen
{
    [SVProgressHUD dismiss];
}

- (UIAlertController *)showAlertWthTitle:(NSString *)title
                                 message:(NSString *)message
                        firstButtonTitle:(NSString *)firstButtonTitle
                        firstButtonStyle:(UIAlertActionStyle)firstButtonStyle
                        otherButtonTitle:(NSString *)otherButtonTitle
                        otherButtonStyle:(UIAlertActionStyle)otherButtonStyle
                                tapBlock:(UIAlertCompletionBlock)tapBlock
{
    return [UIAlertController showAlertIn:self
                                withTitle:title
                                  message:message
                         firstButtonTitle:firstButtonTitle
                         firstButtonStyle:firstButtonStyle
                         otherButtonTitle:otherButtonTitle
                         otherButtonStyle:otherButtonStyle
                                 tapBlock:tapBlock];
}

- (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                         firstButtonTitle:(NSString *)firstButtonTitle
                         otherButtonTitle:(NSString *)otherButtonTitle
                                 tapBlock:(UIAlertCompletionBlock)tapBlock
{
    return [UIAlertController showAlertIn:self
                                withTitle:title
                                  message:message
                         firstButtonTitle:firstButtonTitle
                         otherButtonTitle:otherButtonTitle
                                 tapBlock:tapBlock];
}

- (void)showAlertController:(UIAlertController *)alertConrtoller
{
    [self presentViewController:alertConrtoller animated:YES completion:nil];
}


@end
