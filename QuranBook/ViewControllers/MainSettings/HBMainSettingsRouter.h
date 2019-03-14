//
//  HBMainSettingsRouter.h
//  QuranBook
//
//  Created by Соколов Георгий on 02/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBMainSettingsRouter <NSObject>

- (void)callArabicSettingsController;

- (void)callTranslateSettingsController;

- (void)callSoundSettingsController;

- (void)closeCurController;

@end
