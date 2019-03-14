//
//  HBTranslateSettingsPresenterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 09/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBTranslateSettingsPresenterImp.h"
#import "HBQuranService.h"
#import "HBParentPresenterDelegate.h"
#import "HBTranslateSettingsPresenter.h"
#import "HBQuranItemCellView.h"
#import "HBProfileManager.h"
#import "HBQuranItemEntity.h"

@interface HBTranslateSettingsPresenterImp()

@property (strong, nonatomic) NSArray<HBQuranItemEntity *> *translitArray;
@property (strong, nonatomic) NSArray<HBQuranItemEntity *> *translationArray;
@property (assign, nonatomic) BOOL flagUpdate;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSIndexPath *> *selectedIndexPath;

@property (strong, nonatomic) id<HBQuranService> quranService;
@property (weak, nonatomic) id<HBTranslateSettingsView> view;

@end

@implementation HBTranslateSettingsPresenterImp

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedIndexPath = [NSMutableDictionary dictionaryWithCapacity:2];
        self.flagUpdate = NO;
    }
    return self;
}

#pragma mark - HBTranslateSettingsPresenter

- (void)onClose
{
    if (self.flagUpdate && self.view.parentPresenterDelegate) {
        [self.view.parentPresenterDelegate onCommitActionFromChild:self userInfo:nil];
    }
}

- (void)loadData
{
    self.translitArray = [self.quranService listQuranEntityByType:HBQuranItemTypeTranslit];
    self.translationArray = [self.quranService listQuranEntityByType:HBQuranItemTypeTranslation];
}

- (void)configureCell:(id<HBQuranItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath
{
    HBQuranItemEntity *itemEntity = [self itemByAtIndexPath:indexPath];
    [cellView displayTitle:itemEntity.localizedName];
    [cellView displaySubtitle:itemEntity.localizedSubname];
    if (itemEntity.url_image) {
        [cellView setImageByURL:[NSURL URLWithString:itemEntity.url_image] placeholderImage:[UIImage imageNamed:@"emptyCircle"]];
    } else {
        [cellView setItemImage:[UIImage imageNamed:@"emptyCircle"]];
    }
    if (itemEntity.itemId.integerValue == [self selectedIdBySection:indexPath.section].integerValue) {
        cellView.state = HBQuranItemStateChecked;
        [self.selectedIndexPath setObject:indexPath forKey:[NSNumber numberWithInteger:indexPath.section]];
    }
    else if (itemEntity.loadedValue) {
        cellView.state = HBQuranItemStateLoaded;
    }
    else {
        cellView.state = HBQuranItemStateNone;
    }
    [cellView addDeleteActionWithTarget:self action:@selector(deleteCellTap:)];
}

- (NSInteger)numberOfSections
{
    return 2;
}

- (NSInteger)countItemsBySection:(NSInteger)section
{
    return [self datasetBySection:section].count;
}

- (void)didSelectCell:(id<HBQuranItemCellView>)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (cell.state) {
        case HBQuranItemStateNone: {
            HBQuranItemEntity *itemEntity = [self itemByAtIndexPath:indexPath];
            NSString *localizedString = indexPath.section == 0 ? NSLocalizedString(@"QuranQuestionLoadTranslit", nil) : NSLocalizedString(@"QuranQuestionLoadTranslation", nil);
            NSString *questionString = [NSString stringWithFormat:@"%@ (%@ Kb)", localizedString, itemEntity.size];
            [self.view showAlertWthTitle:@""
                                 message:questionString
                        firstButtonTitle:NSLocalizedString(@"ButtonCancel", nil)
                        firstButtonStyle:UIAlertActionStyleCancel
                        otherButtonTitle:NSLocalizedString(@"ButtonLoad", nil)
                        otherButtonStyle:UIAlertActionStyleDefault
                                tapBlock:^(HBAlertActionType actionType) {
                                    if (actionType == HBAlertActionOther) {
                                        [self loadDataToItemEntity:itemEntity onComplite:^{
                                            [self changeSelectedToIndexPath:indexPath];
                                        }];
                                    }
                                }];
            break;
        }
        case HBQuranItemStateLoaded:
            [self changeSelectedToIndexPath:indexPath];
            break;
        default:
            break;
    }

}

- (NSNumber *)selectedIdBySection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [HBProfileManager sharedInstance].quranTranslit;
        case 1:
            return [HBProfileManager sharedInstance].quranTranslition;
        default:
            return nil;
    }
}

#pragma mark - Private Methods

- (HBQuranItemEntity *)itemByAtIndexPath:(NSIndexPath *)indexPath
{
    return [self datasetBySection:indexPath.section][indexPath.row];
}

- (NSArray<HBQuranItemEntity *> *)datasetBySection:(NSInteger)section
{
    if (section == 0) {
        return self.translitArray;
    }
    return self.translationArray;
}

- (void)loadDataToItemEntity:(HBQuranItemEntity *)itemEntity onComplite:(void(^)(void))block
{
    [self.view showWaitScreen];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSError *error = nil;
        [self.quranService loadQuranFromServerToItemEntity:itemEntity onError:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideWaitScreen];
                [self.view showAlertWithTitle:NSLocalizedString(@"CaptionError", nil)
                                      message:[NSString stringWithFormat:NSLocalizedString(@"QuranLoadError", nil), error.localizedDescription]
                             firstButtonTitle:NSLocalizedString(@"ButtonOk", nil)
                             otherButtonTitle:nil
                                     tapBlock:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideWaitScreen];
                if (block) {
                    block();
                }
            });
        }
    });
}

- (void)changeSelectedToIndexPath:(NSIndexPath *)indexPath
{
    HBQuranItemEntity *itemEntity = [self itemByAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [HBProfileManager sharedInstance].quranTranslit = itemEntity.itemId;
            break;
        case 1:
            [HBProfileManager sharedInstance].quranTranslition = itemEntity.itemId;
        default:
            break;
    }
    NSMutableArray<NSIndexPath *> *rows = [NSMutableArray arrayWithObject:indexPath];
    NSIndexPath *oldIndexPath = self.selectedIndexPath[[NSNumber numberWithInteger:indexPath.section]];
    if (oldIndexPath) {
        [rows addObject:oldIndexPath];
    }
    [self.view reloadRowAtIndexPaths:rows];
    [self.selectedIndexPath setObject:indexPath forKey:[NSNumber numberWithInteger:indexPath.section]];
    self.flagUpdate = YES;
}

#pragma mark - Action

- (void)deleteCellTap:(UITapGestureRecognizer *)tapGesture
{
    NSIndexPath *indexPath = [self.view indexPathByView:tapGesture.view];
    if (indexPath) {
        HBQuranItemEntity *itemEntity = [self itemByAtIndexPath:indexPath];
        NSString *localizedString = indexPath.section == 0 ? NSLocalizedString(@"QuranQuestionDeleteTranslit", nil) : NSLocalizedString(@"QuranQuestionDeleteTransation", nil);
        NSString *questionString = [NSString stringWithFormat:localizedString, itemEntity.localizedSubname];
        [self.view showAlertWthTitle:@""
                             message:questionString
                    firstButtonTitle:NSLocalizedString(@"ButtonCancel", nil)
                    firstButtonStyle:UIAlertActionStyleCancel
                    otherButtonTitle:NSLocalizedString(@"DeleteTitle", nil)
                    otherButtonStyle:UIAlertActionStyleDefault
                            tapBlock:^(HBAlertActionType actionType) {
                                if (actionType == HBAlertActionOther) {
                                    [self.quranService clearQuranItemEntity:itemEntity];
                                    itemEntity.loadedValue = NO;
                                    [self.view reloadRowAtIndexPaths:@[indexPath]];
                                }
                            }];
    }
}



@end
