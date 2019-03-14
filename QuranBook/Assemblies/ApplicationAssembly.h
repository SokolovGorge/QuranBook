//
//  ApplicationAssembly.h
//  QuranBook
//
//  Created by Соколов Георгий on 14/11/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "TyphoonAssembly.h"

@protocol HBQuranService;
@protocol HBLoadContentService;
@protocol HBQuranSoundService;

@class HBQuranBaseController;
@class HBQuranGateway;


@interface ApplicationAssembly : TyphoonAssembly

- (id<HBQuranService>)quranService;

- (id<HBLoadContentService>)loadContentService;

- (id<HBQuranSoundService>)quranSoundService;

- (HBQuranBaseController *)quranBaseController;

- (HBQuranGateway *)quranGateway;

@end
