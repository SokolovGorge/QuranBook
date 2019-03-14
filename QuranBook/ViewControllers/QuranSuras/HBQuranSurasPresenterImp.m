//
//  HBQuranSurasPresenterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 03/01/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import "HBQuranSurasPresenterImp.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "UIColor+Habar.h"
#import "HBConstants.h"
#import "HBControllerState.h"
#import "HBQuranSurasRouter.h"
#import "HBQuranService.h"
#import "HBQuranSoundService.h"
#import "HBQuranGateway.h"
#import "HBSuraModel.h"
#import "HBQuranSuraCellView.h"
#import "HBQuranSearchSuraCellView.h"

@interface HBQuranSurasPresenterImp()

@property (weak, nonatomic) id<HBQuranSurasView> view;
@property (strong, nonatomic) id<HBQuranSurasRouter> router;
@property (strong, nonatomic) HBQuranGateway *gateway;
@property (strong, nonatomic) id<HBQuranService> quranService;
@property (strong, nonatomic) id<HBQuranSoundService> quranSoundService;

@property (strong, nonatomic) NSOperation *currentOperation;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (strong, nonatomic) NSMutableArray<HBSuraModel *> *suraArray;
@property (strong, nonatomic) NSIndexPath *executedIndexPath;
@property (strong, nonatomic) NSArray<HBSuraModel *> *filteredArray;



@end

@implementation HBQuranSurasPresenterImp

@synthesize controllerState = _controllerState;
@synthesize soundIndexPath = _soundIndexPath;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        _controllerState = HBControllerStateNormal;
    }
    return self;
}

- (void)setControllerState:(HBControllerState)controllerState
{
    if (_controllerState == controllerState) {
        return;
    }
    _controllerState = controllerState;
    [self.view updateByState:controllerState];
}


#pragma mark - HBQuranSurasPresenter

- (void)checkData
{
    if ([self.quranService listNeedLoad].count > 0) {
        [self.router callSettings];
    }
}

- (void)loadData
{
    self.suraArray = [self.gateway listSuraModelFromCache];
    if (self.quranSoundService.state == HBQuranSoundStatePlay) {
        [self updateSoundIndexBySuraIndex:self.quranSoundService.suraIndex];
    }
    [self.view reloadData];
}

- (NSUInteger)countOfRows
{
    return self.controllerState == HBControllerStateNormal ? self.suraArray.count : self.filteredArray.count;
}

- (void)configureCell:(id<HBQuranSuraCellView>)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.soundIndexPath isEqual:indexPath]) {
        [cell modifyBackgroudColor:[UIColor colorWithHex:kQuranReadColor]];
    } else {
        [cell modifyBackgroudColor:[UIColor whiteColor]];
    }
    
    HBSuraModel *model = [self suraModelAtIndexPath:indexPath];
    [cell setHiddenNumber:model.state != HBSuraStateNormal];
    if (model.state == HBSuraStateNormal) {
        [cell displayNumber:[NSString stringWithFormat:@"%ld", (long)model.index]];
     }
    [cell displayIconImage:model.state == HBSuraStateNormal ? [UIImage imageNamed:@"quranSura"] : [UIImage imageNamed:@"quranBook"]];
    [cell displayTitle:model.state == HBSuraStateNormal ? model.translitName : NSLocalizedString(@"QuranLastRead", nil)];
    NSInteger cnt = model.state == HBSuraStateNormal ? model.countAyas : model.lastAya;
    [cell displaySubtitle:[NSString stringWithFormat:@"%@ (%ld)", model.translationName, (long)cnt]];
 
    [cell updateSizeByImageSize:model.titleImage.size];
    [cell displayTitleImage:model.titleImage];
}

- (void)updateSoundIndexBySuraIndex:(NSInteger)suraIndex
{
    self.soundIndexPath = [self indexPathBySuraIndex:suraIndex];
}

- (void)configureSearchCell:(id<HBQuranSearchSuraCellView>)cell atIndexPath:(NSIndexPath *)indexPath
{
    HBSuraModel *model = [self suraModelAtIndexPath:indexPath];
    [cell displayTitle:model.translitName];
    [cell displaySubtitle:[NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"QuranAyaName", nil), (long)model.lastAya]];
    [cell setTitleImage:model.titleImage];
}


- (void)presentAyaByIndexPath:(NSIndexPath *)indexPath
{
    if (self.controllerState == HBControllerStateNormal) {
        self.executedIndexPath = indexPath;
        [self.view updateCellState:HBSuraCellStateWaiting atIndexPath:indexPath];
    }
    HBSuraModel *suraModel = [self suraModelAtIndexPath:indexPath];
    [self.gateway prepareAyasBySuraNumber:suraModel.index
                               onComplite:^(NSMutableArray<HBAyaModel *> *listAyas) {
                                   [self.router showAyaControllerByModel:suraModel preparedAyas:listAyas];
                                   [self.view updateCellState:HBSuraCellStateNormal atIndexPath:indexPath];
                               }];
}

- (void)clearFiltered
{
    self.filteredArray = nil;
}

- (void)filterAyaBySearchText:(NSString *)searchText
{
    if (!searchText || searchText.length == 0) {
        self.filteredArray = nil;
        return;
    }
    [self.currentOperation cancel];
    @weakify(self);
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        @strongify(self);
        NSArray<HBSuraModel *> *resultArray = [self.gateway filteredSurasByText:searchText withOperation:self.currentOperation];
        if (resultArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.filteredArray = resultArray;
            });
        }
    }];
    [self.operationQueue addOperation:self.currentOperation];
}

- (void)refreshData
{
    [self.gateway reloadCacheSura];
    [self loadData];

}

- (void)showAyaByModel:(HBSuraModel *)suraModel
{
    [self.router showAyaControllerByModel:suraModel];
}

#pragma mark - HBParentPresenterDelegate

- (void)onCommitActionFromChild:(NSObject *)childPresenter userInfo:(NSDictionary *)userInfo
{
    HBSuraModel *lastSuraModel = [self.gateway lastReadSuraModel];
    if (lastSuraModel) {
        HBSuraModel *model = self.suraArray[0];
        
        if (model.state == HBSuraStateLastRead) {
            self.suraArray[0] = lastSuraModel;
            if (self.controllerState == HBControllerStateNormal) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.view reloadRowsAtIndexPaths:@[indexPath]];
            }
        } else {
            [self.suraArray insertObject:lastSuraModel atIndex:0];
            if (self.controllerState == HBControllerStateNormal) {
                [self.view reloadData];
            }
        }
    }
}

- (void)onCancelActionFromChild:(NSObject *)childPresenter
{
    if (self.controllerState == HBControllerStateNormal && self.executedIndexPath) {
        [self.view updateCellState:HBSuraCellStateNormal atIndexPath:self.executedIndexPath];
    }
}

#pragma mark - Private Methods

- (NSIndexPath *)indexPathBySuraIndex:(NSInteger)suraIndex
{
    if (self.controllerState != HBControllerStateNormal) {
        return nil;
    }
    NSInteger index = suraIndex - 1;
    if (self.suraArray[0].state == HBSuraStateLastRead) {
        index += 1;
    }
    return [NSIndexPath indexPathForRow:index inSection:0];
}

- (HBSuraModel *)suraModelAtIndexPath:(NSIndexPath *)indexPath
{
    return self.controllerState == HBControllerStateNormal ? self.suraArray[indexPath.row] : self.filteredArray[indexPath.row];
}

- (void)setFilteredArray:(NSArray<HBSuraModel *> *)filteredArray
{
    _filteredArray = filteredArray;
    [self.view setHiddenTableView:filteredArray.count == 0];
    [self.view reloadData];
}


@end
