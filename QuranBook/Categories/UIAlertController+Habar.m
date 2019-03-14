//
//  UIAlertController+Habar.m
//  Habar
//
//  Created by Gorge Sokolov on 13.04.17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "UIAlertController+Habar.h"
#import "HBMacros.h"
#import "AppDelegate.h"

@implementation UIAlertController (Habar)

+ (instancetype)showAlertIn:(UIViewController *)controller
                  withTitle:(NSString *)title
                    message:(NSString *)message
              firstButtonTitle:(NSString *)firstButtonTitle
              firstButtonStyle:(UIAlertActionStyle)firstButtonStyle
           otherButtonTitle:(NSString *)otherButtonTitle
              otherButtonStyle:(UIAlertActionStyle)otherButtonStyle
                  tapBlock:(UIAlertCompletionBlock)tapBlock {
    
    UIAlertController *alertController = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if(firstButtonTitle != nil) {
        
        UIAlertAction *firstButton = [UIAlertAction
                                   actionWithTitle:firstButtonTitle
                                   style:firstButtonStyle
                                   handler:^(UIAlertAction *action)
                                   {
                                       if (tapBlock) {
                                           tapBlock(HBAlertActionFirst); // FIRST BUTTON CALL BACK ACTION
                                       }
                                   }];
        [alertController addAction:firstButton];
        
    }
    
    if(otherButtonTitle != nil) {
        
        UIAlertAction *otherButton = [UIAlertAction
                                      actionWithTitle:otherButtonTitle
                                      style:otherButtonStyle
                                      handler:^(UIAlertAction *action)
                                      {
                                          tapBlock(HBAlertActionOther); // OTHER BUTTON CALL BACK ACTION
                                      }];
        
        [alertController addAction:otherButton];
    }
    
    UIViewController *resultController = controller;
    if (resultController == nil) {
        resultController = TOPVIEWCONTROLLER();
    }
    
    [resultController presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}

+ (instancetype)showAlertIn:(UIViewController *)controller
                  withTitle:(NSString *)title
                    message:(NSString *)message
              firstButtonTitle:(NSString *)firstButtonTitle
           otherButtonTitle:(NSString *)otherButtonTitle
                   tapBlock:(UIAlertCompletionBlock)tapBlock {
    return [UIAlertController showAlertIn:controller
                                withTitle:title
                                  message:message
                            firstButtonTitle:firstButtonTitle
                            firstButtonStyle:UIAlertActionStyleDefault
                         otherButtonTitle:otherButtonTitle
                         otherButtonStyle:UIAlertActionStyleDefault
                                 tapBlock:tapBlock];
}

+ (UIAlertController* )showCriticalAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstButton = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(@"ButtonOk", nil)
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      exit(0);
                                  }];
    [alertController addAction:firstButton];
    [TOPVIEWCONTROLLER() presentViewController:alertController animated:YES completion:nil];
    return alertController;
}


@end
