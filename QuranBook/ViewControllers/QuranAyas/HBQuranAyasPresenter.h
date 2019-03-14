//
//  HBQuranAyasPresenter.h
//  QuranBook
//
//  Created by Соколов Георгий on 08/02/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"
#import "HBQuranItemType.h"

@class HBSuraModel;
@class HBAyaModel;
@class HBQuranSearchController;

@protocol HBQuranAyaCellView;

@protocol HBQuranAyasView <HBBaseControllerView>

@property (strong, nonatomic) HBQuranSearchController *resultController;

- (void)startWaitAnimation;

- (void)stopWaitAnimation;

- (void)reloadTable;

- (void)closeMenu;

- (void)updateTitleBySuraModel:(HBSuraModel *)suraModel;

- (void)checkScrollViewsBySuraModel:(HBSuraModel *)suraModel;

- (void)moveToAyaBySoundIndexPath:(NSIndexPath *)soundIndexPath;

- (void)addViewMenuAction:(id)target action:(SEL)viewAction;

- (void)addFavoriteMenuAction:(id)target action:(SEL)favoriteAction;

- (void)addNoticeMenuAction:(id)target action:(SEL)noticeAction;

- (void)addPlayMenuAction:(id)target action:(SEL)playAction;

- (void)addCloseMenuAction:(id)target action:(SEL)closeAction;

- (void)displayTopText:(NSString *)text;

- (void)displayBottomText:(NSString *)text;

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (void)deselectText;


@end

@protocol HBQuranAyasPresenter <NSObject>

@property (strong, nonatomic) HBSuraModel *suraModel;

@property (strong, nonatomic) NSMutableArray<HBAyaModel *> *listAyas;

- (void)initView;

- (void)setNeedLoadSuraModel:(HBSuraModel *)suraModel;

- (void)updateMenuIndexPath:(NSIndexPath *)indexPath;

- (void)checkStopPlay;

- (void)stopPlay;

- (void)saveLastAyaAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)countOfAyas;

- (HBAyaModel *)ayaModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)whenDidAppear;

- (void)configureCell:(id<HBQuranAyaCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (NSInteger)surasCount;

- (void)prepareAyaAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)filterAyaBySearchText:(NSString *)searchText;

- (void)reloadSuraModel:(HBSuraModel*)suraModel;

- (void)reloadDataBySuraModel:(HBSuraModel *)suraModel;

- (void)editAyaModelByNoticeText:(NSString *)text;

- (void)startPlaySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex;

- (void)onChangeSura:(NSInteger)suraIndex;

- (void)onStopPlay;

- (void)saveHighlightRange:(NSRange)range atIndexPath:(NSIndexPath *)indexPath quranType:(HBQuranItemType)quranType;

- (void)deleteHighlightRange:(NSRange)range atIndexPath:(NSIndexPath *)indexPath quranType:(HBQuranItemType)quranType;

@end
