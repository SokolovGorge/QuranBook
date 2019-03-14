//
//  UIAlertController+Habar.h
//  Habar
//
//  Created by Gorge Sokolov on 13.04.17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIAlertControllerHabar_h
#define UIAlertControllerHabar_h


typedef NS_ENUM(NSInteger, HBAlertActionType) {
    HBAlertActionFirst = 0,
    HBAlertActionOther
};

typedef void (^UIAlertCompletionBlock) (HBAlertActionType actionType);

@interface UIAlertController (Habar)

+ (instancetype)showAlertIn:(UIViewController *)controller
                  withTitle:(NSString *)title
                    message:(NSString *)message
              firstButtonTitle:(NSString *)firstButtonTitle
              firstButtonStyle:(UIAlertActionStyle)firstButtonStyle
           otherButtonTitle:(NSString *)otherButtonTitle
           otherButtonStyle:(UIAlertActionStyle)otherButtonStyle
                   tapBlock:(UIAlertCompletionBlock)tapBlock;

+ (instancetype)showAlertIn:(UIViewController *)controller
                  withTitle:(NSString *)title
                    message:(NSString *)message
              firstButtonTitle:(NSString *)firstButtonTitle
           otherButtonTitle:(NSString *)otherButtonTitle
                   tapBlock:(UIAlertCompletionBlock)tapBlock;

+ (UIAlertController* )showCriticalAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

#endif /* UIAlertControllerHabar_h */
