//
//  HBArabicSettingsPresenterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 05/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBArabicSettingsPresenterImp.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "HBQuranService.h"
#import "HBQuranArabicItemCellView.h"
#import "HBProfileManager.h"
#import "HBQuranItemEntity.h"

@interface HBArabicSettingsPresenterImp()

@property (strong, nonatomic) NSArray<HBQuranItemEntity *> *arabicArray;
@property (assign, nonatomic) BOOL flagUpdate;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (weak, nonatomic) id<HBArabicSettingsView> view;
@property (strong, nonatomic) id<HBQuranService> quranService;


@end

@implementation HBArabicSettingsPresenterImp

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.flagUpdate = NO;
    }
    return self;
}

#pragma mark - HBArabicSettingsPresenter

- (void)loadData
{
    self.arabicArray = [self.quranService listQuranEntityByType:HBQuranItemTypeArabic];
}

- (void)onClose
{
    if (self.flagUpdate && self.view.parentPresenterDelegate) {
        [self.view.parentPresenterDelegate onCommitActionFromChild:self userInfo:nil];
    }
}

- (void)configureCell:(id<HBQuranArabicItemCellView>)cellView atIndexPath:(NSIndexPath *)indexPath;
{
    HBQuranItemEntity *itemEntity = [self itemByAtIndexPath:indexPath];
    [cellView displayTitle:itemEntity.localizedName];
    [cellView displaySubtitle:itemEntity.localizedSubname];
    
    if (itemEntity.itemId.integerValue == [HBProfileManager sharedInstance].quranArabic.integerValue) {
        cellView.state = HBQuranItemStateChecked;
        self.selectedIndexPath = indexPath;
    }
    else if (itemEntity.loadedValue) {
        cellView.state = HBQuranItemStateLoaded;
    }
    else {
        cellView.state = HBQuranItemStateNone;
    }
    [cellView addDeleteActionWithTarget:self action:@selector(deleteCellTap:)];
}

- (NSInteger)countItems
{
    return self.arabicArray.count;
}

- (void)loadDataToItemEntity:(HBQuranItemEntity *)itemEntity onComplite:(void(^)(void))block
{
    [self.view showWaitScreen];
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        @strongify(self);
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
    [HBProfileManager sharedInstance].quranArabic = itemEntity.itemId;
    NSMutableArray<NSIndexPath *> *rows = [NSMutableArray arrayWithObject:indexPath];
    if (self.selectedIndexPath) {
        [rows addObject:self.selectedIndexPath];
    }
    [self.view reloadRowAtIndexPaths:rows];
    self.selectedIndexPath = indexPath;
    self.flagUpdate = YES;
}

- (void)didSelectCell:(id<HBQuranArabicItemCellView>)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (cell.state) {
        case HBQuranItemStateNone: {
            HBQuranItemEntity *itemEntity = [self itemByAtIndexPath:indexPath];
            NSString *questionString = [NSString stringWithFormat:@"%@ (%@ Kb)", NSLocalizedString(@"QuranQuestionLoadArabic", nil), itemEntity.size];
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
                                            //STATS
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

#pragma mark - Private Methods

- (HBQuranItemEntity *)itemByAtIndexPath:(NSIndexPath *)indexPath
{
    return self.arabicArray[indexPath.row];
}

#pragma mark - Gestures

- (void)deleteCellTap:(UITapGestureRecognizer *)tapGesture
{
    NSIndexPath *indexPath = [self.view indexPathByView:tapGesture.view];
    if (indexPath) {
        HBQuranItemEntity *itemEntity = [self itemByAtIndexPath:indexPath];
        NSString *questionString = [NSString stringWithFormat:NSLocalizedString(@"QuranQuestionDeleteArabic", nil), itemEntity.localizedSubname];
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
                            } ];
    }
}

@end
