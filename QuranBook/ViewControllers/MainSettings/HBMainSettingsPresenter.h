//
//  HBMainSettingsPresenter.h
//  QuranBook
//
//  Created by Соколов Георгий on 02/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"

@protocol HBMainSettingsView <HBBaseControllerView>

- (void)setArabicSettings:(NSString *)arabicSettings;

- (void)setTranslateSettings:(NSString *)translateSettings;

- (void)setRecitationSettings:(NSString *)recitationSettings;

@end


@protocol HBMainSettingsPresenter <NSObject>

- (void)checkAndLoadData;

- (void)loadSettings;

- (void)closeSettings;

- (void)presentDetailByIndexPath:(NSIndexPath *)indexPath;

- (NSString *)nameBySection:(NSInteger)section;

@end
