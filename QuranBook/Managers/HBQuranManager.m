//
//  HBQuranManager.m
//  Habar
//
//  Created by Соколов Георгий on 19.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranManager.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "SSZipArchive.h"
#import "UIColor+Habar.h"
#import "HBFileUtils.h"
#import "HBMacros.h"
#import "HBConstants.h"
#import "HBCoreDataManager.h"
#import "HBProfileManager.h"
#import "HBNetConnectionChecker.h"
#import "HBQuranBaseEntity.h"
#import "HBQuranItemEntity.h"
#import "HBQuranSoundEntity.h"
#import "HBQuranImageEntity.h"
#import "HBSuraEntity.h"
#import "HBAyaEntity.h"
#import "HBAyaHighlightEntity.h"
#import "HBAyaExtraEntity.h"
#import "HBAyaSoundEntity.h"
#import "HBSuraModel.h"
#import "HBAyaModel.h"
#import "HBJuzModel.h"
#import "HBHighlightModel.h"
#import "HBAyaSoundModel.h"

#define kTypeTranslation  @"translation"
#define kTypeTranslit     @"translit"
#define kTypeArabic       @"arabic"
#define kTypeSound        @"sound"
#define kTypeImage        @"image"

#define kItemId        @"id"
#define kItemType      @"type"
#define kItemName      @"name"
#define kItemSubname   @"subname"
#define kItemUrlData   @"href"
#define kItemUrlImage  @"image"
#define kItemDefault   @"default"
#define kItemSize      @"size"

#define kQuranSection @"quran"
#define kSuraSection  @"sura"
#define kAyaSection   @"aya"
#define kIndexField   @"@index"
#define kNameField    @"@name"
#define kTextField    @"@text"
#define kTimeField    @"time_sec"

#define kSoundIndexJSON   @"index.json"
#define kQuranImageFolder @"QuranImages"
#define kSuraImageFile    @"suraTitle%ld.png"
#define kQuranSoundFolder @"QuranSoundFolder%@"

#define kSurasCount      114

@implementation HBQuranManager


#pragma mark - Static Methods

- (UIFont *)arabicFont
{
    static UIFont *sArabicFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sArabicFont = [UIFont fontWithName:@"Amiri-Regular" size:30.f];
    });
    return sArabicFont;
}

- (UIColor *)arabicColor
{
    static UIColor *sArabicColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sArabicColor = [UIColor blackColor];
    });
    return sArabicColor;
}

- (UIFont *)translitFont
{
    static UIFont *sTranslitfont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTranslitfont = [UIFont fontWithName:@"SFUIText-Regular" size:19.f];
    });
    return sTranslitfont;
}

- (UIColor *)translitColor
{
    static UIColor *sTranslitColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTranslitColor = [UIColor colorWithHex:kHabarColor];
    });
    return sTranslitColor;
}

- (UIFont *)translationFont
{
    static UIFont *sTranslationFont = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTranslationFont = [UIFont fontWithName:@"SFUIText-Regular" size:19.f];
    });
    return sTranslationFont;
}

- (UIColor *)translationColor
{
    static UIColor *sTranslationColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTranslationColor = [UIColor darkGrayColor];
    });
    return sTranslationColor;
}

- (UIColor *)highlightColor
{
    static UIColor *sHighlightColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sHighlightColor = [UIColor colorWithHex:0xFFFC8C];
    });
    return sHighlightColor;
}

- (NSString *)stringFromQuranSoundEndAction:(HBQuranSoundEndAction)value
{
    switch (value) {
        case HBQuranSoundEndActionStop:
            return NSLocalizedString(@"QuranSoundEndActionStop", nil);
        case HBQuranSoundEndActionNext:
            return NSLocalizedString(@"QuranSoundEndActionNext", nil);
        case HBQuranSoundEndActionRepeat:
            return NSLocalizedString(@"QuranSoundEndActionRepeat", nil);
    }
}

- (NSString *)stringFromQuranSoundRepeat:(HBQuranSoundRepeat)value
{
    switch (value) {
        case HBQuranSoundRepeatNever:
            return NSLocalizedString(@"QuranSoundRepeatNever", nil);
        case HBQuranSoundRepeatOne:
            return NSLocalizedString(@"HBQuranSoundRepeatOne", nil);
        case HBQuranSoundRepeatTwo:
            return NSLocalizedString(@"HBQuranSoundRepeatTwo", nil);
        case HBQuranSoundRepeatThree:
            return NSLocalizedString(@"HBQuranSoundRepeatThree", nil);
        case HBQuranSoundRepeatEndlessly:
            return NSLocalizedString(@"HBQuranSoundRepeatEndlessly", nil);
    }
}

- (NSString *)suraImagesFolder
{
    return documentPathWithFileName(kQuranImageFolder);
}


- (NSURL *)soundURLByPathName:(NSString *)pathName suraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    NSString *urlString = [pathName stringByAppendingPathComponent:[self soundFileNameBySuraIndex:suraIndex ayaIndex:ayaIndex]];
    return [NSURL URLWithString:urlString];
}


- (NSString *)soundFileNameBySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    return [NSString stringWithFormat:@"%03ld%03ld.mp3", suraIndex, ayaIndex];
}

- (NSString *)soundFolderByItemId:(NSString *)itemId
{
    return documentPathWithFileName([NSString stringWithFormat:kQuranSoundFolder, itemId]);
}

- (NSString *)digitToEasternDigit:(NSString *)westernDigit
{
    if (!westernDigit) {
        return nil;
    }
    NSMutableString *easternDigit = [NSMutableString string];
    for (int i = 0; i < westernDigit.length; i++) {
        char character = [westernDigit characterAtIndex:i];
        switch (character) {
            case 0x30:
                [easternDigit appendString:@"٠"];
                break;
            case 0x31:
                [easternDigit appendString:@"١"];
                break;
            case 0x32:
                [easternDigit appendString:@"٢"];
                break;
            case 0x33:
                [easternDigit appendString:@"٣"];
                break;
            case 0x34:
                [easternDigit appendString:@"٤"];
                break;
            case 0x35:
                [easternDigit appendString:@"٥"];
                break;
            case 0x36:
                [easternDigit appendString:@"٦"];
                break;
            case 0x37:
                [easternDigit appendString:@"٧"];
                break;
            case 0x38:
                [easternDigit appendString:@"٨"];
                break;
            case 0x39:
                [easternDigit appendString:@"٩"];
                break;
            default:
                break;
        }
    }
    return easternDigit;
}

- (NSInteger)surasCount
{
    return kSurasCount;
}

- (NSString *)suraImageFileByIndex:(NSInteger)suraIndex
{
    return [[self suraImagesFolder] stringByAppendingPathComponent:[NSString stringWithFormat:kSuraImageFile, (long)suraIndex]];
}

#pragma mark - Public Methods

- (void)checkQuranItems
{
    if ([HBProfileManager sharedInstance].flagQuranInit) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Quran" ofType:@"plist"];
    NSArray<NSDictionary *> *itemList = [[NSArray alloc] initWithContentsOfFile:path];
    
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        
        for (NSDictionary *item in itemList) {
            NSNumber *itemId = item[kItemId];
            HBQuranItemType itemType = [self quranItemTypeFromString:item[kItemType]];
            if (itemType == HBQuranItemTypeNone) {
                DLog(@"Untyped quarn item: %@", item);
            } else {
                HBQuranBaseEntity *itemEntity = [self createQuranEntityByType:itemType inContext:context];
                itemEntity.itemId = itemId;
                itemEntity.itemTypeValue = itemType;
                NSString *value = item[kItemName];
                if (value.length > 0) {
                    itemEntity.name = item[kItemName];
                }
                value = item[kItemSubname];
                if (value.length > 0) {
                    itemEntity.subname = item[kItemSubname];
                }
                value = item[kItemUrlData];
                if (value.length > 0) {
                    itemEntity.url_data = [NSString stringWithFormat:@"%@/%@", kResHabarDomain, value];
                }
                value = item[kItemUrlImage];
                if (value.length > 0) {
                    itemEntity.url_image = [NSString stringWithFormat:@"%@/%@", kResHabarDomain, value];
                }
                itemEntity.size = item[kItemSize];
                itemEntity.defValue = item[kItemDefault];
                itemEntity.loadedValue = false;
                
                // если загружается значение по умолчанию - то сохраняем в настройках как текущее
                if (itemEntity.defValueValue) {
                    switch (itemEntity.itemTypeValue) {
                        case HBQuranItemTypeTranslation:
                            if (![HBProfileManager sharedInstance].quranTranslition) {
                                [HBProfileManager sharedInstance].quranTranslition = itemEntity.itemId;
                            }
                            break;
                        case HBQuranItemTypeTranslit:
                            if (![HBProfileManager sharedInstance].quranTranslit) {
                                [HBProfileManager sharedInstance].quranTranslit = itemEntity.itemId;
                            }
                            break;
                        case HBQuranItemTypeArabic:
                            if (![HBProfileManager sharedInstance].quranArabic) {
                                [HBProfileManager sharedInstance].quranArabic = itemEntity.itemId;
                            }
                            break;
                        case HBQuranItemTypeSound:
                            if (![HBProfileManager sharedInstance].quranSound) {
                                [HBProfileManager sharedInstance].quranSound = itemEntity.itemId;
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }];
    [HBProfileManager sharedInstance].flagQuranInit = YES;
}

- (NSArray<HBQuranBaseEntity *>*)listNeedLoad
{
    __block NSMutableArray<HBQuranBaseEntity *> *needLoadArray = nil;
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        
        NSArray<HBQuranBaseEntity *> *cacheArray = [HBQuranBaseEntity MR_findAllInContext:context];
        needLoadArray = [NSMutableArray arrayWithCapacity:cacheArray.count];
        
        // сначала проверяем загрузку картинок
        for (HBQuranBaseEntity *baseEntity in cacheArray) {
            if ([baseEntity isKindOfClass:[HBQuranImageEntity class]] && !baseEntity.loadedValue) {
                [needLoadArray addObject:baseEntity];
            }
        }
        
        HBQuranBaseEntity *quranEntity = [self quranEntityByIndex:[HBProfileManager sharedInstance].quranTranslition inArray:cacheArray];
        if (quranEntity && !quranEntity.loadedValue) {
            [needLoadArray addObject:quranEntity];
        }
        quranEntity = [self quranEntityByIndex:[HBProfileManager sharedInstance].quranTranslit inArray:cacheArray];
        if (quranEntity && !quranEntity.loadedValue) {
            [needLoadArray addObject:quranEntity];
        }
        quranEntity = [self quranEntityByIndex:[HBProfileManager sharedInstance].quranArabic inArray:cacheArray];
        if (quranEntity && !quranEntity.loadedValue) {
            [needLoadArray addObject:quranEntity];
        }
    }];
    return needLoadArray;
}

- (HBQuranBaseEntity *)quranEntityById:(NSNumber *)itemId
{
    if (itemId) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId = %@", itemId];
        NSArray<HBQuranBaseEntity *> *array = [HBQuranBaseEntity MR_findAllWithPredicate:predicate];
        if (array) {
            return [array firstObject];
        }
    }
    return nil;
}

- (void)clearQuranItemEntity:(HBQuranItemEntity *)quranEntity
{
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        HBQuranItemEntity * quranInContext = [quranEntity MR_inContext:context];
        quranInContext.loadedValue = NO;
        for (HBSuraEntity *suraEntity in quranInContext.suras) {
            [suraEntity MR_deleteEntityInContext:context];
        }
    }];
}

- (NSArray<HBQuranSoundEntity *> *)listQuranSoundEnity
{
    __block NSArray<HBQuranSoundEntity *> *result = nil;
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[HBQuranSoundEntity entityName]];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:[HBQuranBaseEntityAttributes name] ascending:YES];
        [request setSortDescriptors:@[sort]];
        NSError *error = nil;
        result = [context executeFetchRequest:request error:&error];
        if (error) {
            DLog(@"Error fetch HBQuranSoundEntity list: %@", error.localizedDescription);
        }
    }];
    return result;
}

- (NSArray<HBQuranItemEntity *> *)listQuranEntityByType:(HBQuranItemType)type
{
    __block NSArray<HBQuranItemEntity *> *result = nil;
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[HBQuranItemEntity entityName]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemType = %@", [NSNumber numberWithInt:type]];
        [request setPredicate:predicate];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:[HBQuranBaseEntityAttributes name] ascending:YES];
        [request setSortDescriptors:@[sort]];
        NSError *error = nil;
        result = [context executeFetchRequest:request error:&error];
        if (error) {
            DLog(@"Error fetch HBQuranItemEntity list: %@", error.localizedDescription);
        }
    }];
    return result;
}

- (NSData *)loadAndCacheDataSoundByQuranItem:(HBQuranSoundEntity *)quranEntity suraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex onError:(NSError **)error
{
    __block NSData *soundData = nil;
    __block NSError *localError = nil;
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        NSInteger localSuraIndex = suraIndex;
        //нулевой аят общий - идет с нулевым индексом суры
        if (ayaIndex == 0) {
            localSuraIndex = 0;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quran = %@ and suraIndex = %@ and ayaIndex = %@", quranEntity, [NSNumber numberWithInteger:localSuraIndex], [NSNumber numberWithInteger:ayaIndex]];
        HBAyaSoundEntity *soundEntity = [HBAyaSoundEntity MR_findFirstWithPredicate:predicate inContext:context];
        NSAssert(soundEntity != nil, @"HBAyaSoundEntity is null");
        NSString *filePath = [self soundFilePathByAyaSoundEntity:soundEntity];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            soundData = [NSData dataWithContentsOfFile:filePath];
        } else {
            NSURL *url = [self soundURLByPathName:quranEntity.url_data suraIndex:localSuraIndex ayaIndex:ayaIndex];
            soundData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&localError];
            if (!localError) {
                [self saveSoundData:soundData toAyaSoundEntity:soundEntity];
            } else {
                //проверяем сеть
                if (![[HBNetConnectionChecker sharedInstance] checkConnection]) {
                    localError = [NSError errorWithDomain:kHabarErrorDomain code:9014 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"NetNotReachableError", nil)}];
                }
            }
        }
    }];
    if (localError) {
        *error = localError;
    }
    return soundData;
}

- (NSArray <HBAyaSoundModel *> *)listSoundModelByQuranItem:(HBQuranSoundEntity *)quranEntity suraIndex:(NSInteger)suraIndex onError:(NSError **)error
{
    __block NSMutableArray <HBAyaSoundModel *> *resultArray = nil;
    __block NSError *localError = nil;
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[HBAyaSoundEntity entityName]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quran = %@ and suraIndex = %@", quranEntity, [NSNumber numberWithInteger:suraIndex]];
        [request setPredicate:predicate];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[HBAyaSoundEntityAttributes ayaIndex] ascending:YES];
        [request setSortDescriptors:@[sortDescriptor]];
        [request setResultType:NSDictionaryResultType];
        [request setPropertiesToFetch:[NSArray arrayWithObjects:[HBAyaSoundEntityAttributes suraIndex], [HBAyaSoundEntityAttributes ayaIndex], [HBAyaSoundEntityAttributes duration], nil]];
        NSArray<NSDictionary *> *fetchArray = [context executeFetchRequest:request error:&localError];
        if (!localError) {
            resultArray = [NSMutableArray arrayWithCapacity:fetchArray.count];
            for (NSDictionary *dict in fetchArray) {
                HBAyaSoundModel *model = [[HBAyaSoundModel alloc] init];
                model.suraIndex = ((NSNumber *)[dict objectForKey:[HBAyaSoundEntityAttributes suraIndex]]).integerValue;
                model.ayaIndex = ((NSNumber *)[dict objectForKey:[HBAyaSoundEntityAttributes ayaIndex]]).integerValue;
                model.duration = ((NSNumber *)[dict objectForKey:[HBAyaSoundEntityAttributes duration]]).integerValue;
                [resultArray addObject:model];
            }
        }
    }];
    if (localError) {
        *error = localError;
    }
    return resultArray;
}

#pragma mark - Load from server

- (void)loadQuranFromServerToItemEntity:(HBQuranItemEntity *)quranEntity onError:(NSError **)error
{
    //сначала чистим данные во избежание дублирования
    [self clearQuranItemEntity:quranEntity];
    
    __block NSError *localError = nil;
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        HBQuranItemEntity *quranInContext = [quranEntity MR_inContext:context];
        if (!quranInContext.url_data) {
            localError = [NSError errorWithDomain:kHabarErrorDomain code:5001 userInfo:@{NSLocalizedDescriptionKey:@"In settings Quran don't define URL data."}];
        } else {
            NSURL *urlData = [NSURL URLWithString:quranInContext.url_data];
            NSData *data = [NSData dataWithContentsOfURL:urlData options:NSDataReadingMappedIfSafe error:&localError];
            if (!localError) {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&localError];
                if (!localError) {
                    NSDictionary *quranDict = jsonDict[kQuranSection];
                    //суры
                    NSArray<NSDictionary *> *surasArray = quranDict[kSuraSection];
                    for (NSDictionary *suraDict in surasArray) {
                        HBSuraEntity *suraEntity = [HBSuraEntity MR_createEntityInContext:context];
                        suraEntity.index = [formatter numberFromString:suraDict[kIndexField]];
                        suraEntity.name = suraDict[kNameField];
                        suraEntity.quran = quranInContext;
                        NSArray<NSDictionary *> *ayasArray = suraDict[kAyaSection];
                        suraEntity.countAyasValue = (int)ayasArray.count;
                        //аяты
                        for (NSDictionary *ayaDict in ayasArray) {
                            HBAyaEntity *ayaEntity = [HBAyaEntity MR_createEntityInContext:context];
                            ayaEntity.index = [formatter numberFromString:ayaDict[kIndexField]];
                            ayaEntity.text = ayaDict[kTextField];
                            ayaEntity.sura = suraEntity;
                        }
                    }
                    quranInContext.loadedValue = YES;
                }
            }
        }
        
    }];
    
    if (error && localError) {
        *error = localError;
    }
}

- (void)loadImagesFromServerByImageEntity:(HBQuranImageEntity *)imageEntity onError:(NSError **)error
{
    __block NSError *localError = nil;
    // чистим данные
    NSString *imagesPath = [self suraImagesFolder];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagesPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:imagesPath error:&localError];
    }
    if (!localError) {
        [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
            HBQuranImageEntity *entityInContext = [imageEntity MR_inContext:context];
            if (!entityInContext.url_data) {
                localError = [NSError errorWithDomain:kHabarErrorDomain code:5001 userInfo:@{NSLocalizedDescriptionKey:@"In settings Quran don't define URL data."}];
            } else {
                [[NSFileManager defaultManager] createDirectoryAtPath:imagesPath withIntermediateDirectories:NO attributes:nil error:&localError];
                if (!localError) {
                    NSURL *urlData = [NSURL URLWithString:entityInContext.url_data];
                    NSData *data = [NSData dataWithContentsOfURL:urlData options:NSDataReadingMappedIfSafe error:&localError];
                    if (!localError) {
                        NSString *tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
                        if ([data writeToFile:tempFilePath atomically:YES]) {
                            [SSZipArchive unzipFileAtPath:tempFilePath
                                            toDestination:imagesPath
                                                overwrite:YES
                                                 password:nil
                                                    error:&localError];
                            if (!localError) {
                                entityInContext.loadedValue = YES;
                            }
                            [[NSFileManager defaultManager] removeItemAtPath:tempFilePath error:nil];
                        } else {
                            localError = [NSError errorWithDomain:kHabarErrorDomain code:5001 userInfo:@{NSLocalizedDescriptionKey:@"Unable write temorary file"}];
                        }
                    }
                }
            }
        }];
    }
    if (error && localError) {
        *error = localError;
    }
}

- (void)checkLoadSoundIndexFromServerByItemId:(NSNumber *)itemId onError:(NSError **)error
{
    HBQuranSoundEntity *quranEntity = (HBQuranSoundEntity *)[self quranEntityById:itemId];
    if (!quranEntity || quranEntity.loadedValue) {
        return;
    }
    
    //сначала чистим данные во избежание дублирования
    [self clearIndexSoundEntity:quranEntity];
    
    __block NSError *localError = nil;
    
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        
        HBQuranSoundEntity *quranInContext = [quranEntity MR_inContext:context];
        if (!quranInContext.url_data) {
            localError = [NSError errorWithDomain:kHabarErrorDomain code:5001 userInfo:@{NSLocalizedDescriptionKey:@"In settings Quran don't define URL folder with data."}];
        } else {
            NSString *urlString = [quranInContext.url_data stringByAppendingPathComponent:kSoundIndexJSON];
            NSURL *urlData = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:urlData options:NSDataReadingMappedIfSafe error:&localError];
            if (!localError) {
                NSArray<NSDictionary *> *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&localError];
                if (!localError) {
                    for (NSDictionary *dict in jsonArray) {
                        HBAyaSoundEntity *ayaSoundEntity = [HBAyaSoundEntity MR_createEntityInContext:context];
                        ayaSoundEntity.suraIndex = dict[kSuraSection];
                        ayaSoundEntity.ayaIndex = dict[kAyaSection];
                        ayaSoundEntity.duration = dict[kTimeField];
                        ayaSoundEntity.quran = quranInContext;
                    }
                    quranInContext.loadedValue = YES;
                }
            }
        }
        
    }];
    
    if (error && localError) {
        *error = localError;
    }
}


#pragma mark - Private Methods

- (HBQuranItemType)quranItemTypeFromString:(NSString *)value
{
    if (value) {
        if ([value isEqualToString:kTypeTranslation]) {
            return HBQuranItemTypeTranslation;
        }
        if ([value isEqualToString:kTypeTranslit]) {
            return HBQuranItemTypeTranslit;
        }
        if ([value isEqualToString:kTypeArabic]) {
            return HBQuranItemTypeArabic;
        }
        if ([value isEqualToString:kTypeSound]) {
            return HBQuranItemTypeSound;
        }
        if ([value isEqualToString:kTypeImage]) {
            return HBQuranItemTypeImage;
        }
    }
    return HBQuranItemTypeNone;
}

- (HBQuranBaseEntity *)createQuranEntityByType:(HBQuranItemType)type inContext:(NSManagedObjectContext *)context
{
    if (type == HBQuranItemTypeSound) {
        return [HBQuranSoundEntity MR_createEntityInContext:context];
    }
    if (type == HBQuranItemTypeImage) {
        return [HBQuranImageEntity MR_createEntityInContext:context];
    }
    return [HBQuranItemEntity MR_createEntityInContext:context];
}

- (HBQuranBaseEntity *)quranEntityByIndex:(NSNumber *)itemIndex inArray:(NSArray<HBQuranBaseEntity *> *)array
{
    if (itemIndex) {
        for (HBQuranBaseEntity *itemEntity in array) {
            if (itemEntity.itemId.intValue == itemIndex.intValue) {
                return itemEntity;
            }
        }
    }
    return nil;
}

- (void)clearIndexSoundEntity:(HBQuranSoundEntity *)quranEntity
{
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        HBQuranSoundEntity *quranInContext = [quranEntity MR_inContext:context];
        quranInContext.loadedValue = NO;
        for (HBAyaSoundEntity *ayaSoundEntity in quranInContext.ayas) {
            [ayaSoundEntity MR_deleteEntityInContext:context];
        }
    }];
}

- (NSString *)soundFilePathByAyaSoundEntity:(HBAyaSoundEntity *)ayaSoundEntity
{
    NSString *folder = [self soundFolderByItemId:ayaSoundEntity.quran.itemId.stringValue];
    NSString *fileName = [self soundFileNameBySuraIndex:ayaSoundEntity.suraIndex.integerValue ayaIndex:ayaSoundEntity.ayaIndex.integerValue];
    return [folder stringByAppendingPathComponent:fileName];

}

- (void)saveSoundData:(NSData *)data toAyaSoundEntity:(HBAyaSoundEntity *)ayaSoundEntity
{
    NSString *soundFolder = [self soundFolderByItemId:ayaSoundEntity.quran.itemId.stringValue];
    if (![[NSFileManager defaultManager] fileExistsAtPath:soundFolder]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:soundFolder withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            DLog(@"Error sound folder create: %@", error);
            return;
        }
    }
    [data writeToFile:[self soundFilePathByAyaSoundEntity:ayaSoundEntity] atomically:NO];
}

@end
