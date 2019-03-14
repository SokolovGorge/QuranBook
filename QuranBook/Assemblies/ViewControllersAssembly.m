//
//  ViewControllersAssembly.m
//  QuranBook
//
//  Created by Соколов Георгий on 04/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "ViewControllersAssembly.h"
#import "ApplicationAssembly.h"
#import "HBMainSettingsPresenter.h"
#import "HBMainSettingsPresenterImp.h"
#import "HBQuranMainSettingsController.h"
#import "HBMainSettingsRouter.h"
#import "HBMainSettingsRouterImp.h"
#import "HBQuranArabicSettingsController.h"
#import "HBArabicSettingsPresenter.h"
#import "HBArabicSettingsPresenterImp.h"
#import "HBQuranTranslateSettingsController.h"
#import "HBTranslateSettingsPresenter.h"
#import "HBTranslateSettingsPresenterImp.h"
#import "HBQuranSoundSettingsController.h"
#import "HBSoundSettingsPresenter.h"
#import "HBSoundSettingsPresenterImp.h"
#import "HBQuranSurasController.h"
#import "HBQuranSurasPresenter.h"
#import "HBQuranSurasPresenterImp.h"
#import "HBQuranSurasRouter.h"
#import "HBQuranSurasRouterImp.h"
#import "HBQuranAyasController.h"
#import "HBQuranAyasPresenter.h"
#import "HBQuranAyasPresenterImp.h"
#import "HBQuranAyasRouter.h"
#import "HBQuranAyasRouterImp.h"

@implementation ViewControllersAssembly

#pragma mark - HBQuranMainSettingsController

- (HBQuranMainSettingsController *)mainSettingsController
{
    return [TyphoonDefinition withClass:[HBQuranMainSettingsController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(presenter) with:[self mainSettingsPresenter]];
    }];
}

- (id<HBMainSettingsPresenter>)mainSettingsPresenter
{
    return [TyphoonDefinition withClass:[HBMainSettingsPresenterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self.applicationAssembly quranService]];
        [definition injectProperty:@selector(view) with:[self mainSettingsController]];
        [definition injectProperty:@selector(router) with:[self mainSettingsRouter]];
        definition.scope = TyphoonScopeWeakSingleton; // для передачи одного и того-же объекта как делегата HBParentPresenterDelegate
    }];
}

- (id<HBMainSettingsRouter>)mainSettingsRouter
{
    return [TyphoonDefinition withClass:[HBMainSettingsRouterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(curController) with:[self mainSettingsController]];
        [definition injectProperty:@selector(curPresenter) with:[self mainSettingsPresenter]];
    }];
}

#pragma mark - HBQuranArabicSettingsController

- (HBQuranArabicSettingsController *)arabicSettingController
{
    return [TyphoonDefinition withClass:[HBQuranArabicSettingsController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(presenter) with:[self arabicSettingsPresenter]];
    }];
}

- (id<HBArabicSettingsPresenter>)arabicSettingsPresenter
{
    return [TyphoonDefinition withClass:[HBArabicSettingsPresenterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self.applicationAssembly quranService]];
        [definition injectProperty:@selector(view) with:[self arabicSettingController]];
        definition.scope = TyphoonScopeWeakSingleton;
    }];
}

#pragma mark - HBQuranTranslateSettingsController

- (HBQuranTranslateSettingsController *)translateSettingsController
{
    return [TyphoonDefinition withClass:[HBQuranTranslateSettingsController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(presenter) with:[self translateSettingsPresenter]];
    }];
}

- (id<HBTranslateSettingsPresenter>)translateSettingsPresenter
{
    return [TyphoonDefinition withClass:[HBTranslateSettingsPresenterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self.applicationAssembly quranService]];
        [definition injectProperty:@selector(view) with:[self translateSettingsController]];
        definition.scope = TyphoonScopeWeakSingleton;
    }];
}

#pragma mark - HBQuranSoundSettingsController

- (HBQuranSoundSettingsController *)soundSettingsController
{
    return [TyphoonDefinition withClass:[HBQuranSoundSettingsController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(presenter) with:[self soundSettingsPresenter]];
    }];
}

- (id<HBSoundSettingsPresenter>)soundSettingsPresenter
{
    return [TyphoonDefinition withClass:[HBSoundSettingsPresenterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self.applicationAssembly quranService]];
        [definition injectProperty:@selector(loadContentService) with:[self.applicationAssembly loadContentService]];
        [definition injectProperty:@selector(quranSoundService) with:[self.applicationAssembly quranSoundService]];
        [definition injectProperty:@selector(view) with:[self soundSettingsController]];
    }];
}

#pragma mark - HBQuranSurasController

- (HBQuranSurasController *)surasController
{
    return [TyphoonDefinition withClass:[HBQuranSurasController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(presenter) with:[self surasPresenter]];
        definition.parent = [self.applicationAssembly quranBaseController];
    }];
}

- (id<HBQuranSurasPresenter>)surasPresenter
{
    return [TyphoonDefinition withClass:[HBQuranSurasPresenterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self.applicationAssembly quranService]];
        [definition injectProperty:@selector(quranSoundService) with:[self.applicationAssembly quranSoundService]];
        [definition injectProperty:@selector(gateway) with:[self.applicationAssembly quranGateway]];
        [definition injectProperty:@selector(view) with:[self surasController]];
        [definition injectProperty:@selector(router) with:[self surasRouter]];
        definition.scope = TyphoonScopeWeakSingleton; // для передачи одного и того-же объекта как делегата HBParentPresenterDelegate
    }];
}

- (id<HBQuranSurasRouter>)surasRouter
{
    return [TyphoonDefinition withClass:[HBQuranSurasRouterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(curController) with:[self surasController]];
        [definition injectProperty:@selector(curPresenter) with:[self surasPresenter]];
        [definition injectProperty:@selector(gateway) with:[self.applicationAssembly quranGateway]];
    }];
}

#pragma mark - HBQuranAyasController

- (HBQuranAyasController *)ayasController
{
    return [TyphoonDefinition withClass:[HBQuranAyasController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(presenter) with:[self ayasPresenter]];
        definition.parent = [self.applicationAssembly quranBaseController];
    }];
}

- (id<HBQuranAyasPresenter>)ayasPresenter
{
    return [TyphoonDefinition withClass:[HBQuranAyasPresenterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self.applicationAssembly quranService]];
        [definition injectProperty:@selector(quranSoundService) with:[self.applicationAssembly quranSoundService]];
        [definition injectProperty:@selector(gateway) with:[self.applicationAssembly quranGateway]];
        [definition injectProperty:@selector(view) with:[self ayasController]];
        [definition injectProperty:@selector(router) with:[self ayasRouter]];
        definition.scope = TyphoonScopeWeakSingleton;
    }];
}

- (id<HBQuranAyasRouter>)ayasRouter
{
    return [TyphoonDefinition withClass:[HBQuranAyasRouterImp class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(curController) with:[self ayasController]];
        [definition injectProperty:@selector(curPresenter) with:[self ayasPresenter]];
    }];
}


@end
