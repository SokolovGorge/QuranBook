//
//  HBSoundSettingsPresenterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 09/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBSoundSettingsPresenterImp.h"
#import "UIColor+Habar.h"
#import "HBConstants.h"
#import "HBQuranService.h"
#import "HBLoadContentService.h"
#import "HBQuranSoundService.h"
#import "HBQuranSoundEntity.h"
#import "HBProfileManager.h"
#import "HBBaseLoader.h"
#import "HBQuranSoundItemCellView.h"
#import "HBQuranSoundSwitchCellView.h"
#import "HBQuranSoundOptCellView.h"


@interface HBSoundSettingsPresenterImp () <HBLoaderContentDelegate>

@property (assign, nonatomic) BOOL flagUpdate;
@property (strong, nonatomic) NSArray<HBQuranSoundEntity *> *soundArray;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *expandedArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UIColor *loadingColor;
@property (strong, nonatomic) UIColor *unpackingColor;


@property (weak, nonatomic) id<HBSoundSettingsView> view;
@property (strong, nonatomic) id<HBQuranService> quranService;
@property (strong, nonatomic) id<HBLoadContentService> loadContentService;
@property (strong, nonatomic) id<HBQuranSoundService> quranSoundService;


@end

@implementation HBSoundSettingsPresenterImp


- (void)dealloc
{
    [self.loadContentService unregisterLoaderDelegate:self];
}

#pragma mark - HBSoundSettingsPresenter

- (void)setup
{
    self.flagUpdate = NO;
    self.loadingColor = [UIColor colorWithHex:kHabarColor];
    self.unpackingColor = [UIColor colorWithRed:243.f/255.f green:213.f/255.f blue:115.f/255.f alpha:1.f];
    [self.loadContentService registerLoaderDelegate:self];
}

- (void)onClose
{
    if (self.flagUpdate && self.view.parentPresenterDelegate) {
        [self.view.parentPresenterDelegate onCommitActionFromChild:self userInfo:nil];
    }

}

- (void)loadData
{
    self.soundArray = [self.quranService listQuranSoundEnity];
    self.expandedArray = [NSMutableArray array];
    for (int i = 0; i < self.soundArray.count; i++) {
        //если выбранная ячейка или процесс не равен None - раскрываем ячейку
        HBLoadState loadState = [self calculateLoadStateByItem:self.soundArray[i]];
        BOOL expand = [self checkedBySoundItem:self.soundArray[i]] || loadState != HBLoadStateNone;
        [self.expandedArray addObject:[NSNumber numberWithBool:expand]];
    }
}

- (void)configureOptCellView1:(id<HBQuranSoundSwitchCellView>)cellView atIndexPath:(NSIndexPath *)indexPath
{
    [cellView addSwitchTarget:self action:@selector(changeSwitch:)];
    switch (indexPath.row) {
        case 0:
            [cellView displayTitle:NSLocalizedString(@"QuranReadAutoScrollItem", nil)];
            cellView.checked = [HBProfileManager sharedInstance].quranSoundAutoscroll;
            break;
        case 1:
            [cellView displayTitle:NSLocalizedString(@"QuranReadKeepScreenItem", nil)];
            cellView.checked = [HBProfileManager sharedInstance].quranSoundNotDouse;
            break;
        default:
            break;
    }
}

- (void)configureOptCellView2:(id<HBQuranSoundOptCellView>)cellView atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
            [cellView displayTitle:NSLocalizedString(@"QuranReadEndSura", nil)];
            [cellView displaySubtitle:[self.quranService stringFromQuranSoundEndAction:[HBProfileManager sharedInstance].quranSoundEndAction]];
            break;
        case 3:
            [cellView displayTitle:NSLocalizedString(@"QuranReadRepeatVerse", nil)];
            [cellView displaySubtitle:[self.quranService stringFromQuranSoundRepeat:[HBProfileManager sharedInstance].quranSoundRepeat]];
            break;
        default:
            break;
    }
}

- (void)changeSelectedItemAtCellView:(id<HBQuranSoundItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray arrayWithObject:indexPath];
    BOOL expanded = [self expandedAtIndexPath:indexPath];
    [self setExpanded:!expanded atIndexPath:indexPath];
    if (!cellView.checked) {
        HBQuranSoundEntity *soundEntity = [self itemAtIndexPath:indexPath];
        
        [HBProfileManager sharedInstance].quranSound = soundEntity.itemId;
        if (self.selectedIndexPath) {
            [indexPathArray addObject:self.selectedIndexPath];
        }
        self.selectedIndexPath = indexPath;
        self.flagUpdate = YES;
        //проверяем загрузку индексного файла
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.quranService checkLoadSoundIndexFromServerByItemId:[HBProfileManager sharedInstance].quranSound onError:nil];
        });
        //если саунд стоит на паузе, то останавливаем так как перегрузить остановленный процесс нельзя
        if (self.quranSoundService.state == HBQuranSoundStatePause) {
            [self.quranSoundService stopPlay];
        }
        //перезапускаем саунд если играет
        if (self.quranSoundService.state == HBQuranSoundStatePlay) {
            NSInteger suraIndex = self.quranSoundService.suraIndex;
            NSInteger ayaIndex = self.quranSoundService.ayaIndex;
            [self.quranSoundService stopPlay];
            [self.quranSoundService startPlayWithSuraIndex:suraIndex ayaIndex:ayaIndex];
        }
        [self setExpanded:YES atIndexPath:indexPath];
    } else {
        [self setExpanded:!expanded atIndexPath:indexPath];
    }
    [self.view refreshRowAtIndexPaths:indexPathArray];
    [self.view scrollAtIndexPath:indexPath];
}

- (void)changeEndSuraAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"QuranReadEndSura", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundEndAction:HBQuranSoundEndActionStop] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundEndAction = HBQuranSoundEndActionStop;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundEndAction:HBQuranSoundEndActionRepeat] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundEndAction = HBQuranSoundEndActionRepeat;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundEndAction:HBQuranSoundEndActionNext] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundEndAction = HBQuranSoundEndActionNext;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ButtonCancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    actionSheet.view.tintColor = [UIColor colorWithHex:kHabarColor];
    [self.view showAlertController:actionSheet];
}

- (void)changeRepeatVerseAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"QuranReadRepeatVerse", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundRepeat:HBQuranSoundRepeatNever] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundRepeat = HBQuranSoundRepeatNever;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundRepeat:HBQuranSoundRepeatOne] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundRepeat = HBQuranSoundRepeatOne;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundRepeat:HBQuranSoundRepeatTwo] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundRepeat = HBQuranSoundRepeatTwo;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundRepeat:HBQuranSoundRepeatThree] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundRepeat = HBQuranSoundRepeatThree;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[self.quranService stringFromQuranSoundRepeat:HBQuranSoundRepeatEndlessly] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HBProfileManager sharedInstance].quranSoundRepeat = HBQuranSoundRepeatEndlessly;
        [self.view refreshRowAtIndexPaths:@[indexPath]];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ButtonCancel", nil) style:UIAlertActionStyleCancel handler:nil]];
    
    actionSheet.view.tintColor = [UIColor colorWithHex:kHabarColor];
    [self.view showAlertController:actionSheet];
    self.flagUpdate = YES;
}

- (NSInteger)countItemsBySection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.soundArray.count;
        case 1:
            return 4;
        default:
            return 0;
    }
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"QuranReadSectionTitle1", nil);
        case 1:
            return NSLocalizedString(@"QuranReadSectionTitle2", nil);
        default:
            return @"";
    }
}

#pragma mark - HBLoaderContentDelegate

- (void)onChangeStatus:(HBLoadState)loadState byType:(HBLoadType)loadType byId:(NSString *)itemId
{
    if (loadType == HBLoadTypeQuranSound) {
        NSNumber *numberId = @([itemId intValue]);
        NSIndexPath *indexPath = [self indexPathByItemId:numberId];
        if (indexPath) {
            id<HBQuranSoundItemCellView> cellView = [self.view cellViewAtIndexPath:indexPath];
            if (cellView) {
                HBQuranSoundEntity *soundItem = [self itemAtIndexPath:indexPath];
                [self updateStatusSoundCellView:cellView bySoundItem:soundItem];
            }
        }
    }
}

- (void)onChangePercent:(float)percent byType:(HBLoadType)loadType byId:(NSString *)itemId
{
    if (loadType == HBLoadTypeQuranSound) {
        NSNumber *numberId = @([itemId intValue]);
        NSIndexPath *indexPath = [self indexPathByItemId:numberId];
        if (indexPath) {
            id<HBQuranSoundItemCellView> cellView = [self.view cellViewAtIndexPath:indexPath];
            if (cellView) {
                HBQuranSoundEntity *soundItem = [self itemAtIndexPath:indexPath];
                [cellView setPercent:percent withAnimate:NO];
                [cellView displayInfo:[self textByPercent:percent andSizeByItem:soundItem]];
             }
        }
    }
}

#pragma mark - Private Methods

- (HBLoadState)calculateLoadStateByItem:(HBQuranSoundEntity *)soundItem
{
    HBLoadState loadState = soundItem.soundStateValue;
    // определяем состояние по загрузчику
    NSString *itemId = [soundItem.itemId stringValue];
    HBBaseLoader *loader = [self.loadContentService loaderByType:HBLoadTypeQuranSound byId:itemId];
    if (loader) {
        loadState = loader.loadState;
    }
    return loadState;
}

- (BOOL)checkedBySoundItem:(HBQuranSoundEntity *)soundItem
{
    return soundItem.itemId.integerValue == [HBProfileManager sharedInstance].quranSound.integerValue;
}

- (HBQuranSoundEntity *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section == 0, @"Invalid section for HBQuranSoundEntity");
    return self.soundArray[indexPath.row];
}

- (NSIndexPath *)indexPathByItemId:(NSNumber *)itemId {
    for (int i = 0; i < self.soundArray.count; i++) {
        if (self.soundArray[i].itemId.integerValue == itemId.integerValue) {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    return nil;
}

- (void)updateStatusSoundCellView:(id<HBQuranSoundItemCellView>)cellView bySoundItem:(HBQuranSoundEntity *)soundItem
{
    HBLoadState loadState = [self calculateLoadStateByItem:soundItem];
    NSString *itemId = [soundItem.itemId stringValue];
    HBBaseLoader *loader = [self.loadContentService loaderByType:HBLoadTypeQuranSound byId:itemId];
    [cellView setVisibleStop:loadState == HBLoadStateLoading || loadState == HBLoadStatePause || loadState == HBLoadStateUnpacking || loadState == HBLoadStateComplete];
    [cellView setStopButtonImageNamed:loadState == HBLoadStateComplete? @"quranLoadDelete" : @"quranLoadStop"];
    cellView.progressColor = loadState == HBLoadStateUnpacking ? self.unpackingColor : self.loadingColor;
    switch (loadState) {
        case HBLoadStateNone:
            [cellView setExecButtonImageNamed:@"quranLoadStart"];
            [cellView setPercent:0.f withAnimate:NO];
            [cellView displayStatus:NSLocalizedString(@"QuranLoadStateLoadText", nil)];
            [cellView displayInfo:[self textSizeByItem:soundItem]];
            break;
        case HBLoadStateLoading:
            [cellView setExecButtonImageNamed:@"quranLoadPause"];
            [cellView setPercent:loader.percent withAnimate:NO];
            [cellView displayStatus:NSLocalizedString(@"QuranLoadStateLoadingText", nil)];
            [cellView displayInfo:[self textByPercent:loader.percent andSizeByItem:soundItem]];
            break;
        case HBLoadStatePause:
            [cellView setExecButtonImageNamed:@"quranLoadResume"];
            [cellView setPercent:loader.percent withAnimate:NO];
            [cellView displayStatus:NSLocalizedString(@"QuranLoadStatePauseText", nil)];
            [cellView displayInfo:[self textByPercent:loader.percent andSizeByItem:soundItem]];
            break;
        case HBLoadStateError:
            [cellView setExecButtonImageNamed:@"quranLoadError"];
            [cellView setPercent:0.f withAnimate:NO];
            [cellView displayStatus:NSLocalizedString(@"QuranLoadStateErrorText", nil)];
            [cellView displayInfo:NSLocalizedString(@"QuranLoadErrorDescription", nil)];
            break;
        case HBLoadStateUnpacking:
            [cellView setExecButtonImageNamed:@"quranLoadUnpack"];
            [cellView setPercent:loader.percent withAnimate:NO];
            [cellView displayStatus:NSLocalizedString(@"QuranLoadStateUnpackingText", nil)];
            [cellView displayInfo:[self textByPercent:loader.percent andSizeByItem:soundItem]];
            break;
        case HBLoadStateComplete:
            [cellView setExecButtonImageNamed:@"quranLoadLoaded"];
            [cellView setPercent:0.f withAnimate:NO];
            [cellView displayStatus:NSLocalizedString(@"QuranLoadStateLoadedText", nil)];
            [cellView displayInfo:[self textSizeByItem:soundItem]];
            break;
    }
}

- (NSString *)textSizeByItem:(HBQuranSoundEntity *)soundItem
{
    NSInteger size = soundItem.sizeValue / 1024;
    return [NSString stringWithFormat:@"%ld %@", size, NSLocalizedString(@"SizeMBText", nil)];
}

- (NSString *)textByPercent:(CGFloat)persent andSizeByItem:(HBQuranSoundEntity *)soundItem
{
    return [NSString stringWithFormat:@"%.1f%% %@ %@", persent, NSLocalizedString(@"PercentOffAllText", nil), [self textSizeByItem:soundItem]];
}

- (BOOL)expandedAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section == 0, @"Invalid section for HBQuranSoundEntity");
    return self.expandedArray[indexPath.row].boolValue;
}

- (void)setExpanded:(BOOL)expanded atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section == 0, @"Invalid section for HBQuranSoundEntity");
    self.expandedArray[indexPath.row] = [NSNumber numberWithBool:expanded];
}

- (void)configureSoundCellView:(id<HBQuranSoundItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath
{
    HBQuranSoundEntity *item = [self itemAtIndexPath:indexPath];
    [cellView displayTitle:item.name];
    [cellView displaySubtitle:item.subname];
    if (item.url_image) {
        [cellView setImageByUrl:[NSURL URLWithString:item.url_image] withPlaceholderImage:[UIImage imageNamed:@"emptyCircle"]];
    } else {
        [cellView setImage:[UIImage imageNamed:@"emptyCircle"]];
    }
    cellView.checked = [self checkedBySoundItem:item];
    if (cellView.checked) {
        self.selectedIndexPath = indexPath;
    }
    [cellView addStopTarget:self action:@selector(stopLoadAction:)];
    [cellView addExecTarget:self action:@selector(executeLoadAction:)];
    [self updateStatusSoundCellView:cellView bySoundItem:item];
}

#pragma mark - Actions

- (void)executeLoadAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.view indexPathByView:sender];
    if (indexPath) {
        HBQuranSoundEntity *soundItem = [self itemAtIndexPath:indexPath];
        NSString *itemId = [soundItem.itemId stringValue];
        HBLoadState loadState = [self calculateLoadStateByItem:soundItem];
        switch (loadState) {
            case HBLoadStateNone:
                [self.loadContentService startLoadByType:HBLoadTypeQuranSound byId:itemId];
                break;
            case HBLoadStateLoading:
                [self.loadContentService pauseLoadByType:HBLoadTypeQuranSound byId:itemId];
                break;
            case HBLoadStatePause:
                [self.loadContentService resumeLoadByType:HBLoadTypeQuranSound byId:itemId];
                break;
            case HBLoadStateError:
                // пытаемся загрузить повторно
                [self.loadContentService startLoadByType:HBLoadTypeQuranSound byId:itemId];
                break;
            case HBLoadStateUnpacking:
                break;
            case HBLoadStateComplete:
                break;
        }
    }
}

- (void)stopLoadAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.view indexPathByView:sender];
    if (indexPath) {
        HBQuranSoundEntity *soundItem = [self itemAtIndexPath:indexPath];
        NSString *itemId = [soundItem.itemId stringValue];
        HBLoadState loadState = [self calculateLoadStateByItem:soundItem];
        switch (loadState) {
            case HBLoadStateLoading:
            case HBLoadStatePause:
            case HBLoadStateUnpacking:
                [self.loadContentService stopLoadByType:HBLoadTypeQuranSound byId:itemId];
                break;
            case HBLoadStateComplete:
                [self.loadContentService clearDataByType:HBLoadTypeQuranSound byId:itemId];
                break;
            default:
                break;
        }
    }
}

- (void)changeSwitch:(UISwitch *)sender
{
    NSIndexPath *indexPath = [self.view indexPathByView:sender];
    if (indexPath) {
        switch (indexPath.row) {
            case 0:
                [HBProfileManager sharedInstance].quranSoundAutoscroll = sender.on;
                self.flagUpdate = YES;
                break;
            case 1:
                [HBProfileManager sharedInstance].quranSoundNotDouse = sender.on;
                break;
            default:
                break;
        }
    }
}


@end
