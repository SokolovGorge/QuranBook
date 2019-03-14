//
//  HBProfileManager.m
//  QuranBook
//
//  Created by Соколов Георгий on 30/09/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBProfileManager.h"

#define saveObj(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define saveInt(key, value) [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key]
#define saveBool(key, value) [[NSUserDefaults standardUserDefaults] setBool:value forKey:key]
#define loadBool(key) [[NSUserDefaults standardUserDefaults] boolForKey:key]
#define loadBoolDef(key, def)  [[NSUserDefaults standardUserDefaults] objectForKey:key] ? [[NSUserDefaults standardUserDefaults] boolForKey:key] : def
#define loadInt(key) [[NSUserDefaults standardUserDefaults] integerForKey:key]
#define loadIntDef(key, def) [[NSUserDefaults standardUserDefaults] objectForKey:key] ? [[NSUserDefaults standardUserDefaults] integerForKey:key] : def
#define loadStr(key) [[NSUserDefaults standardUserDefaults] stringForKey:key]
#define loadStrDef(key, def) [[NSUserDefaults standardUserDefaults] stringForKey:key] ?: def
#define loadObj(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define constQuranTranslition    @"QuranTranslition"
#define constQuranTranslit       @"QuranTranslit"
#define constQuranArabic         @"QuranArabic"
#define constQuranSound          @"QuranSound"
#define constQuranTajwid         @"QuranTajwid"
#define constQuranLastSura       @"QuranLastSura"
#define constQuranLastAya        @"QuranLastAya"
#define constQuranAutoscroll     @"QuranAutoscroll"
#define constQuranNotDouse       @"QuranNotDouse"
#define constQuranEndAction      @"QuranEndAction"
#define constQuranRepeat         @"QuranRepeat"
#define constFlagQuranInit       @"FlagQuranInit"

@implementation HBProfileManager

+ (instancetype)sharedInstance
{
    static HBProfileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HBProfileManager alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSNumber *)quranTranslition
{
    return (NSNumber *)loadObj(constQuranTranslition);
}

- (void)setQuranTranslition:(NSNumber *)quranTranslition
{
    saveObj(constQuranTranslition, quranTranslition);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)quranTranslit
{
    return (NSNumber *)loadObj(constQuranTranslit);
}

- (void)setQuranTranslit:(NSNumber *)quranTranslit
{
    saveObj(constQuranTranslit, quranTranslit);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)quranArabic
{
    return (NSNumber *)loadObj(constQuranArabic);
}

- (void)setQuranArabic:(NSNumber *)quranArabic
{
    saveObj(constQuranArabic, quranArabic);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)quranSound
{
    return (NSNumber *)loadObj(constQuranSound);
}

- (void)setQuranSound:(NSNumber *)quranSound
{
    saveObj(constQuranSound, quranSound);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)quranTajwid
{
    return loadBoolDef(constQuranTajwid, YES);
}

- (void)setQuranTajwid:(BOOL)quranTajwid
{
    saveBool(constQuranTajwid, quranTajwid);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)quranLastSura
{
    return (NSNumber *)loadObj(constQuranLastSura);
}

- (void)setQuranLastSura:(NSNumber *)quranLastSura
{
    saveObj(constQuranLastSura, quranLastSura);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)quranLastAya
{
    return (NSNumber *)loadObj(constQuranLastAya);
}

- (void)setQuranLastAya:(NSNumber *)quranLastAya
{
    saveObj(constQuranLastAya, quranLastAya);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)quranSoundAutoscroll
{
    return loadBoolDef(constQuranAutoscroll, YES);
}

- (void)setQuranSoundAutoscroll:(BOOL)quranSoundAutoscroll
{
    saveBool(constQuranAutoscroll, quranSoundAutoscroll);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)quranSoundNotDouse
{
    return loadBoolDef(constQuranNotDouse, YES);
}

- (void)setQuranSoundNotDouse:(BOOL)quranSoundNotDouse
{
    saveBool(constQuranNotDouse, quranSoundNotDouse);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (HBQuranSoundEndAction)quranSoundEndAction
{
    return loadIntDef(constQuranEndAction, HBQuranSoundEndActionNext);
}

- (void)setQuranSoundEndAction:(HBQuranSoundEndAction)quranSoundEndAction
{
    saveInt(constQuranEndAction, quranSoundEndAction);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (HBQuranSoundRepeat)quranSoundRepeat
{
    return loadIntDef(constQuranRepeat, HBQuranSoundRepeatNever);
}

- (void)setQuranSoundRepeat:(HBQuranSoundRepeat)quranSoundRepeat
{
    saveInt(constQuranRepeat, quranSoundRepeat);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)flagQuranInit
{
    return loadBoolDef(constFlagQuranInit, NO);
}

- (void)setFlagQuranInit:(BOOL)flagQuranInit
{
    saveBool(constFlagQuranInit, flagQuranInit);
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
