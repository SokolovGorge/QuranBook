//
//  HBProfileManager.h
//  QuranBook
//
//  Created by Соколов Георгий on 30/09/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBQuranSoundEndAction.h"
#import "HBQuranSoundRepeat.h"

@interface HBProfileManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSNumber *quranTranslition;
@property (nonatomic, strong) NSNumber *quranTranslit;
@property (nonatomic, strong) NSNumber *quranArabic;
@property (nonatomic, strong) NSNumber *quranSound;
@property (nonatomic, assign) BOOL quranTajwid;
@property (nonatomic, strong) NSNumber *quranLastSura;
@property (nonatomic, strong) NSNumber *quranLastAya;

@property (nonatomic, assign) BOOL quranSoundAutoscroll;
@property (nonatomic, assign) BOOL quranSoundNotDouse;
@property (nonatomic, assign) HBQuranSoundEndAction quranSoundEndAction;
@property (nonatomic, assign) HBQuranSoundRepeat quranSoundRepeat;
@property (nonatomic, assign) BOOL flagQuranInit;

@end

