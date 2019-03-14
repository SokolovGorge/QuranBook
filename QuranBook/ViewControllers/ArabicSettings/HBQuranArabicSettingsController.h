//
//  HBQuranArabicSettingsController.h
//  Habar
//
//  Created by Соколов Георгий on 25.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBaseViewController.h"
#import "HBArabicSettingsPresenter.h"

@protocol HBParentControllerDelegate;

@interface HBQuranArabicSettingsController : HBBaseViewController<HBArabicSettingsView>

+ (instancetype)instanceFromStoryboard;

@end
