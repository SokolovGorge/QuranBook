//
//  HBBaseView.h
//  QuranBook
//
//  Created by Соколов Георгий on 02/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertController+Habar.h"
#import "HBParentPresenterDelegate.h"

@protocol HBBaseControllerView <NSObject>

@property (weak, nonatomic) id<HBParentPresenterDelegate> parentPresenterDelegate;


- (void)showWaitScreen;

- (void)hideWaitScreen;

- (UIAlertController *)showAlertWthTitle:(NSString *)title
                                 message:(NSString *)message
                        firstButtonTitle:(NSString *)firstButtonTitle
                        firstButtonStyle:(UIAlertActionStyle)firstButtonStyle
                        otherButtonTitle:(NSString *)otherButtonTitle
                        otherButtonStyle:(UIAlertActionStyle)otherButtonStyle
                                tapBlock:(UIAlertCompletionBlock)tapBlock;


- (UIAlertController *)showAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                         firstButtonTitle:(NSString *)firstButtonTitle
                         otherButtonTitle:(NSString *)otherButtonTitle
                                 tapBlock:(UIAlertCompletionBlock)tapBlock;

- (void)showAlertController:(UIAlertController *)alertConrtoller;

@end
