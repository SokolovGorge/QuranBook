//
//  HBQuranSoundSettingsController.h
//  Habar
//
//  Created by Соколов Георгий on 28.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBaseViewController.h"
#import "HBSoundSettingsPresenter.h"

@protocol HBParentControllerDelegate;

@interface HBQuranSoundSettingsController : HBBaseViewController <HBSoundSettingsView>

+ (instancetype)instanceFromStoryboardForModalState:(BOOL)modalState;

@end
