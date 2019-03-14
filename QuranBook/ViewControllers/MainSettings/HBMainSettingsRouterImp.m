//
//  HBMainSettingsRouterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 02/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBMainSettingsRouterImp.h"
#import "HBQuranArabicSettingsController.h"
#import "HBQuranTranslateSettingsController.h"
#import "HBQuranSoundSettingsController.h"

@interface HBMainSettingsRouterImp()



@end

@implementation HBMainSettingsRouterImp

- (void)callArabicSettingsController
{
    HBQuranArabicSettingsController *vc = [HBQuranArabicSettingsController instanceFromStoryboard];
    vc.parentPresenterDelegate = self.curPresenter;
    [self.curController.navigationController pushViewController:vc animated:YES];
}

- (void)callTranslateSettingsController
{
    HBQuranTranslateSettingsController *vc = [HBQuranTranslateSettingsController instanceFromStoryboard];
    vc.parentPresenterDelegate = self.curPresenter;
    [self.curController.navigationController pushViewController:vc animated:YES];
}

- (void)callSoundSettingsController
{
    HBQuranSoundSettingsController *vc = [HBQuranSoundSettingsController instanceFromStoryboardForModalState:NO];
    vc.parentPresenterDelegate = self.curPresenter;
    [self.curController.navigationController pushViewController:vc animated:YES];
}

- (void)closeCurController
{
    [self.curController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
