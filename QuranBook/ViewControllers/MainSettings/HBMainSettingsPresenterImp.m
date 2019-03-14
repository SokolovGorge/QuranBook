//
//  HBMainSettingsPresenterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 02/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBMainSettingsPresenterImp.h"
#import "HBConstants.h"
#import "HBMainSettingsRouter.h"
#import "HBQuranService.h"
#import "HBProfileManager.h"
#import "HBQuranBaseEntity.h"
#import "HBQuranItemEntity.h"
#import "HBQuranImageEntity.h"

@interface HBMainSettingsPresenterImp()

@property (weak, nonatomic) id<HBMainSettingsView> view;
@property (strong, nonatomic) id<HBMainSettingsRouter> router;
@property (strong, nonatomic) id<HBQuranService> quranService;

@property (assign, nonatomic) BOOL firstFlag;

@end

@implementation HBMainSettingsPresenterImp

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstFlag = YES;
    }
    return self;
}

#pragma mark - HBMainSettingsPresenter

- (void)loadSettings
{
    HBQuranBaseEntity *quranEntity = [self.quranService quranEntityById:[HBProfileManager sharedInstance].quranArabic];
    [self.view setArabicSettings:quranEntity ? quranEntity.localizedSubname : @""];
    quranEntity = [self.quranService quranEntityById:[HBProfileManager sharedInstance].quranTranslition];
    [self.view setTranslateSettings:quranEntity ? [NSString stringWithFormat:@"%@ (%@)", quranEntity.localizedName, quranEntity.localizedSubname] : @""];
    quranEntity = [self.quranService quranEntityById:[HBProfileManager sharedInstance].quranSound];
    [self.view setRecitationSettings:quranEntity ? [NSString stringWithFormat:@"%@ (%@)", quranEntity.localizedSubname, quranEntity.localizedName] : @""];
 }

- (void)checkAndLoadData
{
    if (!self.firstFlag) {
        return;
    }
    self.firstFlag = NO;
    
    NSArray<HBQuranBaseEntity *> *needLoadItems = [self.quranService listNeedLoad];
    if (needLoadItems.count > 0) {
        NSInteger allSize = 0;
        for (HBQuranBaseEntity *quranEntity in needLoadItems) {
            allSize += quranEntity.size.integerValue;
        }
        [self.view showAlertWthTitle:NSLocalizedString(@"CaptionAttention", nil)
                             message:[NSString stringWithFormat:NSLocalizedString(@"QuranFirstLoadAlert", nil), allSize]
                    firstButtonTitle:NSLocalizedString(@"ButtonNo", nil)
                    firstButtonStyle:UIAlertActionStyleCancel
                    otherButtonTitle:NSLocalizedString(@"ButtonYes", nil)
                    otherButtonStyle:UIAlertActionStyleDefault
                            tapBlock:^(HBAlertActionType actionType) {
                                if (actionType == HBAlertActionFirst) {
                                    [self.router closeCurController];
                                } else {
                                    [self loadNeedItems:needLoadItems];
                                }
                            }];
    }
}

- (NSString *)nameBySection:(NSInteger)section
{
    switch (section) {
        case 1:
            return NSLocalizedString(@"QuranSettingSection1", nil);
        default:
            return @"";
    }
}

- (void)presentDetailByIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self.router callArabicSettingsController];
                    break;
                case 1:
                    [self.router callTranslateSettingsController];
                    break;
                case 2:
                    [self.router callSoundSettingsController];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            break;
        default:
            break;
    }
}

- (void)closeSettings
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kQuranRefreshNotification object:nil];
    [self.router closeCurController];
}

#pragma mark - HBParentPresenterDelegate

- (void)onCommitActionFromChild:(NSObject *)childPresenter userInfo:(NSDictionary *)userInfo
{
    [self loadSettings];
}

- (void)onCancelActionFromChild:(NSObject *)childPresenter
{
    
}

#pragma mark - Private Methods

- (void)loadNeedItems:(NSArray<HBQuranBaseEntity *> *)needLoadItems
{
    [self.view showWaitScreen];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSError *error = nil;
        for (HBQuranBaseEntity * quranEntity in needLoadItems) {
            if ([quranEntity isKindOfClass:[HBQuranItemEntity class]]) {
                [self.quranService loadQuranFromServerToItemEntity:(HBQuranItemEntity *)quranEntity onError:&error];
            } else if ([quranEntity isKindOfClass:[HBQuranImageEntity class]]) {
                [self.quranService loadImagesFromServerByImageEntity:(HBQuranImageEntity *)quranEntity onError:&error];
            }
            if (error) {
                break;
            }
        }
        //проверяем загрузку индекса звука
        [self.quranService checkLoadSoundIndexFromServerByItemId:[HBProfileManager sharedInstance].quranSound onError:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideWaitScreen];
            if (error) {
                [self.view showAlertWithTitle:NSLocalizedString(@"CaptionError", nil)
                                      message:[NSString stringWithFormat:NSLocalizedString(@"QuranLoadError", nil), error.localizedDescription]
                             firstButtonTitle:NSLocalizedString(@"ButtonOk", nil)
                             otherButtonTitle:nil
                                     tapBlock:nil];
            } else {
                UIAlertController *alertController = [self.view showAlertWithTitle:NSLocalizedString(@"CaptionAttention", nil)
                                                                           message:NSLocalizedString(@"SuccessfullyLoadedMessage", nil)
                                                                  firstButtonTitle:NSLocalizedString(@"ButtonOk", nil)
                                                                  otherButtonTitle:nil
                                                                          tapBlock:nil];
                
                [self performSelector:@selector(dismissAlertView:) withObject:alertController afterDelay:2.f];
            }
        });
        
    });
}

- (void)dismissAlertView:(UIAlertController *)alertController
{
    [alertController dismissViewControllerAnimated:YES completion:nil];
}

@end
