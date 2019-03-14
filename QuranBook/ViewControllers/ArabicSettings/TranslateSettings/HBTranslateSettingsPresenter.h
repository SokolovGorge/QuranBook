//
//  HBTranslatePresenter.h
//  QuranBook
//
//  Created by Соколов Георгий on 09/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"

@protocol HBQuranItemCellView;

@protocol HBTranslateSettingsView <HBBaseControllerView>

- (NSIndexPath *)indexPathByView:(UIView *)view;

- (void)reloadRowAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@end


@protocol HBTranslateSettingsPresenter <NSObject>

- (void)configureCell:(id<HBQuranItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;

- (void)loadData;

- (NSInteger)numberOfSections;

- (NSInteger)countItemsBySection:(NSInteger)section;

- (void)didSelectCell:(id<HBQuranItemCellView>)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)onClose;

@end


