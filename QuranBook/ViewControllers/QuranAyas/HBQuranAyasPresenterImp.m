//
//  HBQuranAyasPresenterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 08/02/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import "HBQuranAyasPresenterImp.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "UIColor+Habar.h"
#import "HBConstants.h"
#import "HBQuranService.h"
#import "HBQuranSoundService.h"
#import "HBQuranGateway.h"
#import "HBProfileManager.h"
#import "HBSuraModel.h"
#import "HBAyaModel.h"
#import "HBQuranAyaCellView.h"
#import "HBQuranSearchController.h"
#import "HBQuranAyasRouter.h"

#define kTopScrollReload        64.f
#define kBottomScrollReload     30.f

@interface HBQuranAyasPresenterImp()

@property (weak, nonatomic) id<HBQuranAyasView> view;
@property (strong, nonatomic) id<HBQuranAyasRouter> router;
@property (strong, nonatomic) id<HBQuranService> quranService;
@property (strong, nonatomic) id<HBQuranSoundService> quranSoundService;
@property (strong, nonatomic) HBQuranGateway *gateway;

@property (strong, nonatomic) NSIndexPath *soundIndexPath;
@property (strong, nonatomic) NSIndexPath *menuIndexPath;
@property (strong, nonatomic) NSOperation *currentOperation;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) HBSuraModel *needSuraModel;

@property (assign, nonatomic) BOOL flagLoading;

@property (strong, nonatomic)  HBAyaModel *editModel;
@property (strong, nonatomic) NSIndexPath *editIndexPath;


@end

@implementation HBQuranAyasPresenterImp

@synthesize suraModel = _suraModel;
@synthesize listAyas = _listAyas;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.flagLoading = NO;
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}


#pragma mark - HBQuranAyasPresenter

- (void)initView
{
    [self.view updateTitleBySuraModel:self.suraModel];
    
    [self.view addViewMenuAction:self action:@selector(viewMenuAction:)];
    [self.view addFavoriteMenuAction:self action:@selector(favoriteMenuAction:)];
    [self.view addNoticeMenuAction:self action:@selector(noticeMenuAction:)];
    [self.view addPlayMenuAction:self action:@selector(playMenuAction:)];
    [self.view addCloseMenuAction:self action:@selector(closeMenuAction:)];

}

- (void)setNeedLoadSuraModel:(HBSuraModel *)suraModel
{
    self.needSuraModel = suraModel;
}

- (void)checkStopPlay
{
    //проверяем статус проигрывателя: если приостановлен, то ваще снимаем
    if (self.quranSoundService.state == HBQuranSoundStatePause) {
        [self.quranSoundService stopPlay];
    }
}

- (void)stopPlay
{
    if (self.quranSoundService.state != HBQuranSoundStateInactive && self.suraModel.index != self.quranSoundService.suraIndex) {
        self.soundIndexPath = nil;
        [self.quranSoundService stopPlay];
    }
}

- (void)saveLastAyaAtIndexPath:(NSIndexPath *)indexPath
{
    HBAyaModel *ayaModel = [self ayaModelAtIndexPath:indexPath];
    [HBProfileManager sharedInstance].quranLastSura = [NSNumber numberWithInteger:ayaModel.suraIndex];
    [HBProfileManager sharedInstance].quranLastAya = [NSNumber numberWithInteger:ayaModel.index];
    //посылаем, чтоб перечитать последний аят
    if (self.view.parentPresenterDelegate) {
        [self.view.parentPresenterDelegate onCommitActionFromChild:self userInfo:nil];
    }
}

- (void)reloadDataBySuraModel:(HBSuraModel *)suraModel
{
    if (!suraModel) {
        return;
    }
    self.flagLoading = YES;
    [self.view startWaitAnimation];
    
    self.suraModel = suraModel;
    self.menuIndexPath = nil;
    [self.listAyas removeAllObjects];
    [self.view reloadTable];
    [self.gateway prepareAyasBySuraNumber:self.suraModel.index onComplite:^(NSMutableArray<HBAyaModel *> *listAyas) {
        self.listAyas = listAyas;
        [self.view updateTitleBySuraModel:self.suraModel];
        [self.view checkScrollViewsBySuraModel:self.suraModel];
        [self.view reloadTable];
        [self.view stopWaitAnimation];
        self.flagLoading = NO;
        [self.view moveToAyaBySoundIndexPath:self.soundIndexPath];
    }];
}

- (void)whenDidAppear
{
    [self.view checkScrollViewsBySuraModel:self.suraModel];
    //отключаем проигрывание
    [self stopPlay];
    
    if (self.needSuraModel) {
        [self reloadDataBySuraModel:self.needSuraModel];
        self.needSuraModel = nil;
    } else {
        [self.view moveToAyaBySoundIndexPath:self.soundIndexPath];
    }
}


- (NSInteger)countOfAyas
{
    return self.listAyas.count;
}

- (HBAyaModel *)ayaModelAtIndexPath:(NSIndexPath *)indexPath
{
    return self.listAyas[indexPath.row];
}

- (void)configureCell:(id<HBQuranAyaCellView>)cellView atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.soundIndexPath isEqual:indexPath]) {
        [cellView modifyBackgroundClolor:[UIColor colorWithHex:kQuranReadColor]];
    } else {
        [cellView modifyBackgroundClolor:[UIColor whiteColor]];
    }
    
    [cellView updateMenuView:indexPath == self.menuIndexPath];
    
    HBAyaModel *ayaModel = [self ayaModelAtIndexPath:indexPath];
    //проверяем подготовлены ли данные транслита
    if (!ayaModel.prepared) {
        [ayaModel prepareData];
    }
    [cellView displayNumber:[self.quranService digitToEasternDigit:[NSString stringWithFormat:@"%ld", (long)ayaModel.index]]];
    [cellView displayArabicText:ayaModel.formatedArabicText];
    [cellView displayTranslitText:ayaModel.formatedTranslitText];
    [cellView displayTranslationText:ayaModel.formatedTranslationText];
    
    //выставляем значки
    NSInteger index = 0;
    if (ayaModel.noticeText.length > 0) {
        UIImageView *imageView = [cellView stateImageViewByIndex:index];
        imageView.image = [UIImage imageNamed:@"quranStateNotice"];
        imageView.hidden = NO;
        index++;
    }
    if (ayaModel.flagFavorite) {
        UIImageView *imageView = [cellView stateImageViewByIndex:index];
        imageView.image = [UIImage imageNamed:@"quranStateFavorite"];
        imageView.hidden = NO;
        index++;
    }
    if (ayaModel.flagView) {
        UIImageView *imageView = [cellView stateImageViewByIndex:index];
        imageView.image = [UIImage imageNamed:@"quranStateView"];
        imageView.hidden = NO;
        index++;
    }
    
}

- (void)filterAyaBySearchText:(NSString *)searchText
{
    if (!searchText || searchText.length == 0) {
        self.view.resultController.filteredArray = nil;
        return;
    }
    [self.currentOperation cancel];
    @weakify(self);
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        @strongify(self);
        NSArray<HBSuraModel *> *resultArray = [self.gateway filteredSurasByText:searchText withOperation:self.currentOperation];
        if (resultArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.view.resultController.filteredArray = resultArray;
            });
        }
    }];
    [self.operationQueue addOperation:self.currentOperation];
}


- (void)updateMenuIndexPath:(NSIndexPath *)indexPath
{
    self.menuIndexPath = indexPath;
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.suraModel.index > 1 && scrollView.contentOffset.y < -kTopScrollReload) {
        [self reloadDataByDelta:-1];
    } else if (self.suraModel.index < [self.quranService surasCount] && scrollView.contentOffset.y - (scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds)) > kBottomScrollReload) {
        [self reloadDataByDelta:1];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.suraModel.index > 1) {
        if (scrollView.contentOffset.y < 0) {
            [self.view displayTopText:scrollView.contentOffset.y > -kTopScrollReload ? NSLocalizedString(@"QuranPreviousSuraSubTitle", nil) : NSLocalizedString(@"QuranReleaseSuraSubTitle", nil)];
        }
    }
    if (self.suraModel.index < [self.quranService surasCount]) {
        CGFloat bottomY = scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds);
        if (scrollView.contentOffset.y > bottomY) {
            [self.view displayBottomText:scrollView.contentOffset.y - bottomY < kBottomScrollReload ? NSLocalizedString(@"QuranNextSuraSubTitle", nil) : NSLocalizedString(@"QuranReleaseSuraSubTitle", nil)];
        }
    }
}

- (NSInteger)surasCount
{
    return [self.quranService surasCount];
}

- (void)prepareAyaAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        for (NSIndexPath *indexPath in indexPaths) {
            HBAyaModel *ayaModel = [self ayaModelAtIndexPath:indexPath];
            if (ayaModel) {
                [ayaModel prepareData];
            }
        }
    });
}

- (void)reloadSuraModel:(HBSuraModel*)suraModel
{
    HBAyaModel *ayaModel = [self.gateway ayaModelBySuraNumber:suraModel.index byAyaNumber:suraModel.lastAya];
    if (ayaModel) {
        [ayaModel prepareData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ayaModel.index - 1 inSection:0];
        self.listAyas[ayaModel.index - 1] = ayaModel;
        [self.view reloadRowsAtIndexPaths:@[indexPath]];
    }
}

- (void)editAyaModelByNoticeText:(NSString *)text
{
    self.editModel.noticeText = text;
    [self.gateway saveAyaExtraByModel:self.editModel];
    [self.view reloadRowsAtIndexPaths:@[self.editIndexPath]];
}

- (void)startPlaySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    if (self.flagLoading) {
        return;
    }
    
    if (self.suraModel.index != suraIndex) {
        return;
    }
    NSIndexPath *oldIndexPath = self.soundIndexPath;
    self.soundIndexPath = [self indexPathByAyaIndex:ayaIndex];
    NSMutableArray<NSIndexPath *> *array = [NSMutableArray arrayWithCapacity:2];
    if (self.soundIndexPath) {
        [array addObject:self.soundIndexPath];
    }
    if (oldIndexPath) {
        [array addObject:oldIndexPath];
    }
    if (array.count > 0) {
        [self.view reloadRowsAtIndexPaths:array];
        if (self.soundIndexPath && [HBProfileManager sharedInstance].quranSoundAutoscroll) {
            //анимируем скролл только при небольшой разнице - иначе позиционирование глючит
            BOOL animatedScroll = oldIndexPath == nil ? YES : labs(self.soundIndexPath.row - oldIndexPath.row) <= 10;
            [self.view scrollToRowAtIndexPath:self.soundIndexPath animated:animatedScroll];
        }
    }
}

- (void)onChangeSura:(NSInteger)suraIndex
{
    HBSuraModel *suraModel =  [self.gateway suraModelBySuraNumber:suraIndex];
    self.soundIndexPath = nil;
    [self reloadDataBySuraModel:suraModel];
}

- (void)onStopPlay
{
    if (self.soundIndexPath) {
        NSIndexPath *indexPath = self.soundIndexPath;
        self.soundIndexPath = nil;
        [self.view reloadRowsAtIndexPaths:@[indexPath]];
    }
}

- (void)saveHighlightRange:(NSRange)range atIndexPath:(NSIndexPath *)indexPath quranType:(HBQuranItemType)quranType
{
    HBAyaModel *ayaModel = [self ayaModelAtIndexPath:indexPath];
    if (quranType != HBQuranItemTypeNone) {
        NSArray<HBHighlightModel *> *deletedArray = [ayaModel removeTouchItemsByRange:range byType:quranType];
        [self.gateway deleteAyaHighLights:deletedArray];
        [ayaModel prepareData];
        [self.view reloadRowsAtIndexPaths:@[indexPath]];
    }
}

- (void)deleteHighlightRange:(NSRange)range atIndexPath:(NSIndexPath *)indexPath quranType:(HBQuranItemType)quranType
{
    HBAyaModel *ayaModel = [self ayaModelAtIndexPath:indexPath];
    if (quranType != HBQuranItemTypeNone) {
        NSArray<HBHighlightModel *> *deletedArray = [ayaModel removeTouchItemsByRange:range byType:quranType];
        [self.gateway deleteAyaHighLights:deletedArray];
        [ayaModel prepareData];
        [self.view reloadRowsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark - Private Methods

- (void)reloadDataByDelta:(NSInteger)delta
{
    HBSuraModel *suraModel =  [self.gateway suraModelBySuraNumber:self.suraModel.index + delta];
    [self reloadDataBySuraModel:suraModel];
}

- (void)setSuraModel:(HBSuraModel *)suraModel
{
    _suraModel = suraModel;
    
    if (self.quranSoundService.state == HBQuranSoundStatePlay && self.suraModel.index == self.quranSoundService.suraIndex) {
        self.soundIndexPath = [self indexPathByAyaIndex:self.quranSoundService.ayaIndex];
    }

}

- (NSIndexPath *)indexPathByAyaIndex:(NSInteger)ayaIndex
{
    if (ayaIndex == 0) {
        return nil;
    }
    return [NSIndexPath indexPathForRow:ayaIndex - 1 inSection:0];
}

- (void)closeMenu
{
    self.menuIndexPath = nil;
    [self.view closeMenu];
}



#pragma mark - Actions

- (void)viewMenuAction:(UIButton *)sender
{
    self.editModel = [self ayaModelAtIndexPath:self.menuIndexPath];
    self.editModel.flagView = !self.editModel.flagView;
    [self.gateway saveAyaExtraByModel:self.editModel];
    [self.view reloadRowsAtIndexPaths:@[self.menuIndexPath]];
    [self closeMenu];
}

- (void)favoriteMenuAction:(UIButton *)sender
{
    self.editModel = [self ayaModelAtIndexPath:self.menuIndexPath];
    self.editModel.flagFavorite = !self.editModel.flagFavorite;
    [self.gateway saveAyaExtraByModel:self.editModel];
    [self.view reloadRowsAtIndexPaths:@[self.menuIndexPath]];
    [self closeMenu];
}

- (void)noticeMenuAction:(UIButton *)sender
{
    self.editIndexPath = self.menuIndexPath;
    self.editModel = [self ayaModelAtIndexPath:self.menuIndexPath];
    [self.router callNoticeControllerWithTitle:[NSString stringWithFormat:@"%ld. %@", (long)self.editModel.index, self.suraModel.translitName] noticeText:self.editModel.noticeText];
    [self closeMenu];
}

- (void)playMenuAction:(UIButton *)sender
{
    HBAyaModel *ayaModel = [self ayaModelAtIndexPath:self.menuIndexPath];
    [self.quranSoundService startPlayWithSuraIndex:ayaModel.suraIndex ayaIndex:ayaModel.index];
    [self closeMenu];
}

- (void)closeMenuAction:(UIButton *)sender
{
    [self closeMenu];
}



@end
