//
//  HBQuranTranslateSettingsController.h
//  Habar
//
//  Created by Соколов Георгий on 24.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBaseViewController.h"
#import "HBTranslateSettingsPresenter.h"

@protocol HBParentControllerDelegate;

@interface HBQuranTranslateSettingsController : HBBaseViewController <HBTranslateSettingsPresenter>

+ (instancetype)instanceFromStoryboard;


@end
