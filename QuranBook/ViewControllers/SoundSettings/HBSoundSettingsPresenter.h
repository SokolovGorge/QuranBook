//
//  HBSoundSettingsPresenter.h
//  QuranBook
//
//  Created by Соколов Георгий on 09/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"

@protocol HBQuranSoundItemCellView;
@protocol HBQuranSoundSwitchCellView;
@protocol HBQuranSoundOptCellView;

@protocol HBSoundSettingsView <HBBaseControllerView>

- (id<HBQuranSoundItemCellView>)cellViewAtIndexPath:(NSIndexPath *)indexPath;

- (void)refreshRowAtIndexPaths:(NSArray<NSIndexPath *> *)indexPathArray;

- (void)scrollAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathByView:(UIView *)view;

@end

@protocol HBSoundSettingsPresenter <NSObject>

- (void)setup;

- (void)onClose;

- (void)loadData;

- (void)configureSoundCellView:(id<HBQuranSoundItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;

- (void)configureOptCellView1:(id<HBQuranSoundSwitchCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;

- (void)configureOptCellView2:(id<HBQuranSoundOptCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;

- (void)changeSelectedItemAtCellView:(id<HBQuranSoundItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;

- (void)changeEndSuraAtIndexPath:(NSIndexPath *)indexPath;

- (void)changeRepeatVerseAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)countItemsBySection:(NSInteger)section;

- (NSString *)titleForHeaderInSection:(NSInteger)section;

- (BOOL)expandedAtIndexPath:(NSIndexPath *)indexPath;

@end
