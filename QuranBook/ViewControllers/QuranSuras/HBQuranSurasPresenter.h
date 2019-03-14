//
//  HBQuranSurasPresenter.h
//  QuranBook
//
//  Created by Соколов Георгий on 03/01/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"
#import "HBControllerState.h"
#import "HBSuraCellState.h"

@protocol HBQuranSuraCellView;
@protocol HBQuranSearchSuraCellView;

@class HBSuraModel;

@protocol HBQuranSurasView <HBBaseControllerView>

- (void)reloadData;

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)setHiddenTableView:(BOOL)hidden;

- (void)updateByState:(HBControllerState)controllerState;

- (void)updateCellState:(HBSuraCellState)state atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HBQuranSurasPresenter <NSObject>

@property (assign, nonatomic) HBControllerState controllerState;
@property (strong, nonatomic) NSIndexPath *soundIndexPath;

- (void)checkData;

- (void)loadData;

- (void)refreshData;

- (NSUInteger)countOfRows;

- (void)configureCell:(id<HBQuranSuraCellView>)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)configureSearchCell:(id<HBQuranSearchSuraCellView>)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)presentAyaByIndexPath:(NSIndexPath *)indexPath;

- (void)clearFiltered;

- (void)filterAyaBySearchText:(NSString *)searchText;

- (void)updateSoundIndexBySuraIndex:(NSInteger)suraIndex;

- (void)showAyaByModel:(HBSuraModel *)suraModel;

@end
