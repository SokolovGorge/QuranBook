//
//  HBArabicSettingsPresenter.h
//  QuranBook
//
//  Created by Соколов Георгий on 04/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"

@protocol HBQuranArabicItemCellView;
@class HBQuranItemEntity;

@protocol HBArabicSettingsView <HBBaseControllerView>

- (NSIndexPath *)indexPathByView:(UIView *)view;

- (void)reloadRowAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@end


@protocol HBArabicSettingsPresenter <NSObject>

- (void)loadData;

- (void)configureCell:(id<HBQuranArabicItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;

- (void)loadDataToItemEntity:(HBQuranItemEntity *)itemEntity onComplite:(void(^)(void))block;

- (void)changeSelectedToIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)countItems;

- (void)didSelectCell:(id<HBQuranArabicItemCellView>)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)onClose;


@end

