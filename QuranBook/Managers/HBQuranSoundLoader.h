//
//  HBQuranSoundLoader.h
//  Habar
//
//  Created by Соколов Георгий on 25.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBBaseLoader.h"

@protocol HBQuranService;

@interface HBQuranSoundLoader : HBBaseLoader

- (instancetype)initLoadService:(id<HBLoadContentService>)loadContentService withQuranService:(id<HBQuranService>)quranService withId:(NSString *)itemId;

@end
