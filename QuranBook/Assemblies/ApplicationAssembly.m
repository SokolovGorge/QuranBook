//
//  ApplicationAssembly.m
//  QuranBook
//
//  Created by Соколов Георгий on 14/11/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "ApplicationAssembly.h"
#import "AppDelegate.h"
#import "HBSystem.h"
#import "HBQuranService.h"
#import "HBQuranManager.h"
#import "HBLoadContentService.h"
#import "HBLoadContentManager.h"
#import "HBQuranSoundService.h"
#import "HBQuranSoundManager.h"
#import "HBQuranBaseController.h"
#import "HBQuranPlayerController.h"
#import "HBQuranSoundProvider.h"
#import "HBQuranGateway.h"
#import "HBAyaModel.h"

@implementation ApplicationAssembly

- (AppDelegate *)appDelegate
{
    return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(systemInstance) with:[self systemInstance]];
        [definition injectProperty:@selector(gateway) with:[self quranGateway]];
    }];
}

- (HBSystem *)systemInstance
{
    return [TyphoonDefinition withClass:[HBSystem class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self quranService]];
        definition.scope = TyphoonScopeObjectGraph;
    }];
}

- (HBQuranBaseController *)quranBaseController
{
    return [TyphoonDefinition withClass:[HBQuranBaseController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranSoundService) with:[self quranSoundService]];
    }];
}

- (HBQuranPlayerController *)playerController
{
    return [TyphoonDefinition withClass:[HBQuranPlayerController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranSoundService) with:[self quranSoundService]];
    }];
}

- (HBQuranGateway *)quranGateway
{
    return [TyphoonDefinition withClass:[HBQuranGateway class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self quranService]];
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id<HBQuranSoundService>)quranSoundService
{
    return [TyphoonDefinition withClass:[HBQuranSoundManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self quranService]];
        [definition injectProperty:@selector(gateway) with:[self quranGateway]];
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id<HBQuranService>)quranService
{
    return [TyphoonDefinition withClass:[HBQuranManager class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id<HBLoadContentService>)loadContentService
{
    return [TyphoonDefinition withClass:[HBLoadContentManager class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quranService) with:[self quranService]];
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end
