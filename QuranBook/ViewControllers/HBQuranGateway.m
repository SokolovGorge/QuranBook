//
//  HBQuranViewModel.m
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranGateway.h"
#import "HBMacros.h"
#import "HBCoreDataManager.h"
#import "HBProfileManager.h"
#import "HBQuranService.h"
#import "HBQuranBaseEntity.h"
#import "HBQuranItemEntity.h"
#import "HBSuraEntity.h"
#import "HBAyaEntity.h"
#import "HBAyaExtraEntity.h"
#import "HBAyaHighlightEntity.h"
#import "HBSuraModel.h"
#import "HBAyaModel.h"
#import "HBJuzModel.h"
#import "HBHighlightModel.h"

@interface HBQuranGateway()

@property (strong, nonatomic) NSMutableDictionary<NSNumber*, HBSuraModel*> *cachedSuras;

@property (strong, nonatomic) id<HBQuranService> quranService;

@end

@implementation HBQuranGateway

#pragma mark - Public Methods


- (NSNumber *)countQuranEnities
{
    __block NSNumber *count = nil;
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[HBQuranBaseEntity entityName]];
        request.resultType = NSCountResultType;
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!error) {
            count = result.firstObject;
        }
    }];
    return count;
}

- (BOOL)containsId:(NSNumber *)itemId inArray:(NSArray<HBQuranBaseEntity *> *)array {
    for (HBQuranBaseEntity *item in array) {
        if (item.itemId.integerValue == itemId.integerValue) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Prepare Data

- (void)checkCacheSura
{
    if (self.cachedSuras) {
        return;
    }
    NSArray<HBSuraEntity *> *arabicArray = [self listSuraEntityByType:HBQuranItemTypeArabic];
    NSArray<HBSuraEntity *> *translitArray = [self listSuraEntityByType:HBQuranItemTypeTranslit];
    NSArray<HBSuraEntity *> *translationArray = [self listSuraEntityByType:HBQuranItemTypeTranslation];
    
    self.cachedSuras = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < arabicArray.count; i++) {
        HBSuraModel *model = [[HBSuraModel alloc] initArabicEntity:arabicArray[i]
                                                    translitEntity:translitArray[i]
                                                 translationEntity:translationArray[i]
                                                        titleImage:[self imageTitleSuraByIndex:arabicArray[i].index.integerValue]];
        self.cachedSuras[arabicArray[i].index] = model;
    }
}

- (void)reloadCacheSura
{
    self.cachedSuras = nil;
    [self checkCacheSura];
}

- (NSMutableArray<HBSuraModel *> *)listSuraModelFromCache
{
    NSAssert(self.cachedSuras, @"Cache suras not prepared!");
    NSMutableArray<HBSuraModel *> *resultArray = self.cachedSuras.allValues.mutableCopy;
    [resultArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HBSuraModel *model1 = (HBSuraModel *)obj1;
        HBSuraModel *model2 = (HBSuraModel *)obj2;
        if (model1.index == model2.index) {
            return NSOrderedSame;
        }
        if (model1.index > model2.index) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    HBSuraModel *lastModel = [self lastReadSuraModel];
    if (lastModel) {
        [resultArray insertObject:lastModel atIndex:0];
    }
    return resultArray;
}

- (NSArray<HBJuzModel *> *)listJusModel
{
    NSAssert(self.cachedSuras, @"Cache suras not prepared!");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Juzes" ofType:@"plist"];
    NSArray<NSDictionary *> *dictArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray<HBJuzModel *> *juzArray = [NSMutableArray arrayWithCapacity:dictArray.count];
    for (NSDictionary *dict in dictArray) {
        HBJuzModel *juzModel = [[HBJuzModel alloc] init];
        NSNumber *index = [dict valueForKey:@"index"];
        juzModel.index = index.integerValue;
        juzModel.arabicName = [dict valueForKey:@"arabic"];
        NSNumber *suraIndex = [dict valueForKey:@"suraIndex"];
        NSNumber *ayaIndex = [dict valueForKey:@"ayaIndex"];
        HBSuraModel *suraModel = self.cachedSuras[suraIndex].copy;
        suraModel.lastAya = ayaIndex.integerValue;
        juzModel.suraModel = suraModel;
        [juzArray addObject:juzModel];
    }
    return juzArray;
}

- (HBSuraModel *)lastReadSuraModel
{
    HBSuraModel *model = nil;
    NSNumber *lastSura = [HBProfileManager sharedInstance].quranLastSura;
    NSNumber *lastAya = [HBProfileManager sharedInstance].quranLastAya;
    if (lastSura && lastAya) {
        model = self.cachedSuras[lastSura].copy;
        if (model) {
            model.lastAya = lastAya.integerValue;
            model.state = HBSuraStateLastRead;
        }
    }
    return model;
}

- (HBSuraModel *)suraModelBySuraNumber:(NSInteger)suraIndex
{
    return self.cachedSuras[[NSNumber numberWithInteger:suraIndex]].copy;
}


- (NSArray<HBSuraModel *> *)filteredSurasByText:(NSString *)searchText withOperation:(NSOperation *)operation
{
    if (!searchText || searchText.length == 0) {
        return nil;
    }
    __block NSMutableArray<HBSuraModel *> *filteredArray = nil;
    NSMutableSet<NSString *> *indexSet = [NSMutableSet set];
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[HBAyaEntity entityName]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sura.quran.itemId = %@ OR sura.quran.itemId = %@ OR sura.quran.itemId = %@) AND (text contains[cd] %@)",
                                  [HBProfileManager sharedInstance].quranArabic,
                                  [HBProfileManager sharedInstance].quranTranslit,
                                  [HBProfileManager sharedInstance].quranTranslition,
                                  searchText];
        [request setPredicate:predicate];
        NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"sura.index" ascending:YES];
        NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        [request setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
        NSError *error = nil;
        if (operation.isCancelled) {
            return;
        }
        NSArray<HBAyaEntity *> *ayaArray = [context executeFetchRequest:request error:&error];
        if (error) {
            DLog(@"Filtered ayas fetch request error: %@", error.localizedDescription);
            return;
        }
        filteredArray = [NSMutableArray array];
        NSAssert(self.cachedSuras, @"Cache suras not prepared!");
        for (HBAyaEntity *ayaEntity in ayaArray) {
            if (operation.isCancelled) {
                return;
            }
            NSString *indexIdentifier = [NSString stringWithFormat:@"%@-%@", ayaEntity.sura.index, ayaEntity.index];
            if (![indexSet containsObject:indexIdentifier]) {
                [indexSet addObject:indexIdentifier];
                HBSuraModel *suraModel = [self.cachedSuras[ayaEntity.sura.index] copy];
                suraModel.lastAya = ayaEntity.index.integerValue;
                [filteredArray addObject:suraModel];
            }
        }
    }];
    return operation.isCancelled ? nil : filteredArray;
}

- (void)prepareAyasBySuraNumber:(NSInteger)suraIndex onComplite:(void(^)(NSMutableArray<HBAyaModel *> *listAyas))block
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSArray<HBAyaEntity *> *arabicArray = [self listAyaEntityByType:HBQuranItemTypeArabic suraNumber:suraIndex];
        NSArray<HBAyaEntity *> *translitArray = [self listAyaEntityByType:HBQuranItemTypeTranslit suraNumber:suraIndex];
        NSArray<HBAyaEntity *> *translationArray = [self listAyaEntityByType:HBQuranItemTypeTranslation suraNumber:suraIndex];
        NSDictionary<NSNumber *, HBAyaExtraEntity *> *ayaExtraDict = [self listAyaExtraBySuraNumber:suraIndex];
        __block NSMutableArray<HBAyaModel *> *resultArray = [NSMutableArray arrayWithCapacity:arabicArray.count];
        for (int i = 0; i < arabicArray.count; i++) {
            HBAyaModel *model = [self createAyaModelSuraNumber:suraIndex
                                                     ayaNumber:arabicArray[i].index.integerValue
                                                byArabicEntity:arabicArray[i]
                                              byTranslitEntity:translitArray[i]
                                           byTranslationEntity:translationArray[i]
                                                 byExtraEntity:ayaExtraDict[arabicArray[i].index]];
            [resultArray addObject:model];
        }
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(resultArray);
            });
        }
    });
}

- (HBAyaModel *)ayaModelBySuraNumber:(NSInteger)suraIndex byAyaNumber:(NSInteger)ayaIndex
{
    HBAyaEntity *arabicEntity = [self ayaEntityByType:HBQuranItemTypeArabic suraNumber:suraIndex ayaNumber:ayaIndex];
    HBAyaEntity *translitEntity = [self ayaEntityByType:HBQuranItemTypeTranslit suraNumber:suraIndex ayaNumber:ayaIndex];
    HBAyaEntity *translationEntity = [self ayaEntityByType:HBQuranItemTypeTranslation suraNumber:suraIndex ayaNumber:ayaIndex];
    HBAyaExtraEntity *extraEntity = [self ayaExtraEntityBySuraNumber:suraIndex byAyaNumber:ayaIndex];
    if (arabicEntity && translitEntity && translationEntity) {
        return [self createAyaModelSuraNumber:suraIndex
                                    ayaNumber:ayaIndex
                               byArabicEntity:arabicEntity
                             byTranslitEntity:translitEntity
                          byTranslationEntity:translationEntity
                                byExtraEntity:extraEntity];
    }
    return nil;
}

- (HBAyaModel *)createAyaModelSuraNumber:(NSInteger)suraIndex
                               ayaNumber:(NSInteger)ayaIndex
                          byArabicEntity:(HBAyaEntity *)arabicEntity
                        byTranslitEntity:(HBAyaEntity *)translitEntity
                     byTranslationEntity:(HBAyaEntity *)translationEntity
                           byExtraEntity:(HBAyaExtraEntity *)extraEntity
{
    HBAyaModel *model = [[HBAyaModel alloc] init];
    model.quranService = self.quranService;
    model.suraIndex = suraIndex;
    model.index = ayaIndex;
    
    model.arabicText = arabicEntity.text;
    for (HBAyaHighlightEntity *highlightEntity in arabicEntity.highlightsSet.objectEnumerator) {
        HBHighlightModel *highlightModel = [[HBHighlightModel alloc] initWithObjectID:highlightEntity.objectID range:[highlightEntity toRange]];
        [model addHighlightModel:highlightModel byType:HBQuranItemTypeArabic];
    }
    
    model.translitText = [NSString stringWithFormat:@"%ld. %@", (long)model.index, translitEntity.text];
    for (HBAyaHighlightEntity *highlightEntity in translitEntity.highlightsSet.objectEnumerator) {
        HBHighlightModel *highlightModel = [[HBHighlightModel alloc] initWithObjectID:highlightEntity.objectID range:[highlightEntity toRange]];
        [model addHighlightModel:highlightModel byType:HBQuranItemTypeTranslit];
    }
    model.translationText = [NSString stringWithFormat:@"%ld. %@", (long)model.index, translationEntity.text];
    for (HBAyaHighlightEntity *highlightEntity in translationEntity.highlightsSet.objectEnumerator) {
        HBHighlightModel *highlightModel = [[HBHighlightModel alloc] initWithObjectID:highlightEntity.objectID range:[highlightEntity toRange]];
        [model addHighlightModel:highlightModel byType:HBQuranItemTypeTranslation];
    }
    if (extraEntity) {
        model.flagView = extraEntity.flagViewValue;
        model.flagFavorite = extraEntity.flagFavoriteValue;
        model.noticeText = extraEntity.noticeText;
    }
    return model;
}

- (HBQuranBaseEntity *)quranEntityByType:(HBQuranItemType)type
{
    NSNumber *itemId = [self itemIdByType:type];
    if (!itemId) {
        return nil;
    }
    return [self.quranService quranEntityById:itemId];
}

- (HBSuraEntity *)suraEntityByType:(HBQuranItemType)type suraNumber:(NSInteger)suraIndex
{
    NSAssert(type != HBQuranItemTypeSound, @"HBQuranItemTypeSound not valid type");
    HBQuranItemEntity *quranEntity = (HBQuranItemEntity *) [self quranEntityByType:type];
    if (!quranEntity) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quran = %@ and index = %@", quranEntity, [NSNumber numberWithInteger:suraIndex]];
    NSArray<HBSuraEntity *> *suraArray = [HBSuraEntity MR_findAllWithPredicate:predicate];
    if (suraArray) {
        return [suraArray firstObject];
    } else {
        return nil;
    }
    
}

- (HBAyaEntity *)ayaEntityByType:(HBQuranItemType)type suraNumber:(NSInteger)suraIndex ayaNumber:(NSInteger)ayaIndex
{
    NSAssert(type != HBQuranItemTypeSound, @"HBQuranItemTypeSound not valid type");
    HBQuranItemEntity *quranEntity = (HBQuranItemEntity *) [self quranEntityByType:type];
    if (!quranEntity) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sura.quran = %@ AND sura.index = %@ AND index = %@", quranEntity, [NSNumber numberWithInteger:suraIndex], [NSNumber numberWithInteger:ayaIndex]];
    NSArray<HBAyaEntity *> *ayaArray = [HBAyaEntity MR_findAllWithPredicate:predicate];
    return [ayaArray firstObject];
}

- (NSArray<HBSuraEntity *> *)listSuraEntityByType:(HBQuranItemType)type
{
    NSAssert(type != HBQuranItemTypeSound, @"HBQuranItemTypeSound not valid type");
    HBQuranItemEntity *quranEntity = (HBQuranItemEntity *)[self quranEntityByType:type];
    if (!quranEntity) {
        return nil;
    }
    NSMutableArray<HBSuraEntity *> *array = [quranEntity.suras allObjects].mutableCopy;
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HBSuraEntity *entity1 = obj1;
        HBSuraEntity *entity2 = obj2;
        return [entity1.index compare:entity2.index];
    }];
    return array;
}


- (NSArray<HBAyaEntity *> *)listAyaEntityByType:(HBQuranItemType)type suraNumber:(NSInteger)suraIndex
{
    HBSuraEntity *suraEntity = [self suraEntityByType:type suraNumber:suraIndex];
    if (!suraEntity) {
        DLog(@"Unable fetch HBSuraEntity by index %ld", (long)suraIndex);
        return nil;
    }
    NSMutableArray<HBAyaEntity *> *ayaArray = [suraEntity.ayas allObjects].mutableCopy;
    [ayaArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HBAyaEntity *entity1 = obj1;
        HBAyaEntity *entity2 = obj2;
        return [entity1.index compare:entity2.index];
    }];
    return ayaArray;
}

- (NSDictionary<NSNumber *, HBAyaExtraEntity *> *)listAyaExtraBySuraNumber:(NSInteger)suraIndex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suraIndex = %@", [NSNumber numberWithInteger:suraIndex]];
    NSArray<HBAyaExtraEntity *> *ayaArray = [HBAyaExtraEntity MR_findAllWithPredicate:predicate];
    NSMutableDictionary<NSNumber *, HBAyaExtraEntity *> *dict = [NSMutableDictionary dictionaryWithCapacity:ayaArray.count];
    for (HBAyaExtraEntity *ayaEntity in ayaArray) {
        dict[ayaEntity.ayaIndex] = ayaEntity;
    }
    return dict;
}

- (UIImage *)imageTitleSuraByIndex:(NSInteger)suraIndex
{
    NSData *data = [NSData dataWithContentsOfFile:[self.quranService suraImageFileByIndex:suraIndex]];
    if (data) {
        return [UIImage imageWithData:data];
    }
    return nil;
}

- (HBAyaExtraEntity *)ayaExtraEntityBySuraNumber:(NSInteger)suraIndex byAyaNumber:(NSInteger)ayaIndex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suraIndex = %@ AND ayaIndex = %@", [NSNumber numberWithInteger:suraIndex], [NSNumber numberWithInteger:ayaIndex]];
    NSArray<HBAyaExtraEntity *> *ayaArray = [HBAyaExtraEntity MR_findAllWithPredicate:predicate];
    return [ayaArray firstObject];
}

- (NSArray<HBSuraModel *> *)listAyaByView
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"flagView = %@", [NSNumber numberWithBool:YES]];
    return [self listAyaByPredicate:predicate];
}

- (NSArray<HBSuraModel *> *)listAyaByFavorite
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"flagFavorite = %@", [NSNumber numberWithBool:YES]];
    return [self listAyaByPredicate:predicate];
}

- (NSArray<HBSuraModel *> *)listAyaByNotice
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"noticeText.length > 0"];
    return [self listAyaByPredicate:predicate];
}

- (NSArray<HBSuraModel *> *)listAyaByMarkColor
{
    NSAssert(self.cachedSuras, @"Cache suras not prepared!");
    NSArray<HBAyaHighlightEntity *> *highlightArray = [HBAyaHighlightEntity MR_findAll];
    NSMutableDictionary<NSString *, HBAyaHighlightEntity *> *dict = [NSMutableDictionary dictionaryWithCapacity:highlightArray.count];
    for (HBAyaHighlightEntity *highlightEntity in highlightArray) {
        NSString *key = [NSString stringWithFormat:@"%@-%@", highlightEntity.aya.sura.index, highlightEntity.aya.index];
        dict[key] =  highlightEntity;
    }
    
    NSMutableArray<HBSuraModel *> *resultArray = [NSMutableArray arrayWithCapacity:highlightArray.count];
    for (HBAyaHighlightEntity *highlightEntity in dict.allValues) {
        HBSuraModel *suraModel = self.cachedSuras[highlightEntity.aya.sura.index].copy;
        suraModel.lastAya = highlightEntity.aya.index.integerValue;
        [resultArray addObject:suraModel];
    }
    
    [resultArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HBSuraModel *model1 = obj1;
        HBSuraModel *model2 = obj2;
        if (model1.index == model2.index) {
            if (model1.lastAya > model2.lastAya) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        } else if (model1.index > model2.index) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    return resultArray;
}


- (NSArray<HBSuraModel *> *)listAyaByPredicate:(NSPredicate *)predicate
{
    NSAssert(self.cachedSuras, @"Cache suras not prepared!");
    __block NSMutableArray<HBSuraModel *> *resultArray = [NSMutableArray array];
    
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[HBAyaExtraEntity entityName]];
        [request setPredicate:predicate];
        NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:[HBAyaExtraEntityAttributes suraIndex] ascending:YES];
        NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:[HBAyaExtraEntityAttributes ayaIndex] ascending:YES];
        [request setSortDescriptors:@[sort1, sort2]];
        NSError *error = nil;
        NSArray<HBAyaExtraEntity *> *ayaArray = [context executeFetchRequest:request error:&error];
        if (error) {
            DLog(@"Error fetch HBAyaExtraEntity list: %@", error.localizedDescription);
        } else {
            for (HBAyaExtraEntity *ayaEntity in ayaArray) {
                HBSuraModel *suraModel = self.cachedSuras[ayaEntity.suraIndex].copy;
                suraModel.lastAya = ayaEntity.ayaIndex.integerValue;
                [resultArray addObject:suraModel];
            }
        }
    }];
    return resultArray;
}

- (NSNumber *)itemIdByType:(HBQuranItemType)type
{
    switch (type) {
        case HBQuranItemTypeArabic:
            return [HBProfileManager sharedInstance].quranArabic;
        case HBQuranItemTypeTranslit:
            return [HBProfileManager sharedInstance].quranTranslit;
        case HBQuranItemTypeTranslation:
            return [HBProfileManager sharedInstance].quranTranslition;
        default:
            return nil;
    }
}

#pragma mark - modify data

- (void)saveAyaExtraByModel:(HBAyaModel *)model
{
    [[HBCoreDataManager sharedInstance] performAsyncAndSave:^(NSManagedObjectContext *context) {
        NSNumber *suraIndex = [NSNumber numberWithInteger:model.suraIndex];
        NSNumber *ayaIndex = [NSNumber numberWithInteger:model.index];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suraIndex = %@ AND ayaIndex = %@", suraIndex, ayaIndex];
        HBAyaExtraEntity *ayaEntity = nil;
        NSArray<HBAyaExtraEntity *> *ayaArray = [HBAyaExtraEntity MR_findAllWithPredicate:predicate inContext:context];
        ayaEntity = [ayaArray firstObject];
        if (!ayaEntity) {
            ayaEntity = [HBAyaExtraEntity MR_createEntityInContext:context];
            ayaEntity.suraIndex = suraIndex;
            ayaEntity.ayaIndex = ayaIndex;
        }
        ayaEntity.noticeText = model.noticeText;
        ayaEntity.flagViewValue = model.flagView;
        ayaEntity.flagFavoriteValue = model.flagFavorite;
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave && self.extraDelegate && [self.extraDelegate respondsToSelector:@selector(onChangeAyaExtra)]) {
            [self.extraDelegate onChangeAyaExtra];
        }
    }];
}

- (HBHighlightModel *)saveAyaHighlightRange:(NSRange)range byType:(HBQuranItemType)type bySuraNumber:(NSInteger)suraIndex byAyaNumber:(NSInteger)ayaIndex
{
    __block HBHighlightModel *highlightModel = nil;
    __block HBAyaHighlightEntity *highlightEntity = nil;
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        NSNumber *suraNumber = [NSNumber numberWithInteger:suraIndex];
        NSNumber *ayaNumber = [NSNumber numberWithInteger:ayaIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sura.quran.itemId = %@ AND sura.index = %@ AND index = %@",
                                  [self itemIdByType:type],
                                  suraNumber,
                                  ayaNumber];
        NSArray<HBAyaEntity *> *array = [HBAyaEntity MR_findAllWithPredicate:predicate inContext:context];
        if (array.count > 0) {
            HBAyaEntity *ayaEntity = [array firstObject];
            highlightEntity = [HBAyaHighlightEntity MR_createEntityInContext:context];
            highlightEntity.aya = ayaEntity;
            highlightEntity.location = [NSNumber numberWithInteger:range.location];
            highlightEntity.length = [NSNumber numberWithInteger:range.length];
        } else {
            DLog(@"Can't find aya suraIndex = %@, ayaIndex = %@", suraNumber, ayaNumber);
        }
    }];
    if (highlightEntity) {
        highlightModel = [[HBHighlightModel alloc] initWithObjectID:highlightEntity.objectID range:[highlightEntity toRange]];
    }
    if (highlightModel && self.extraDelegate && [self.extraDelegate respondsToSelector:@selector(onChangeAyaHighlight)]) {
        [self.extraDelegate onChangeAyaHighlight];
    }
    return highlightModel;
}

- (void)deleteAyaHighLights:(NSArray<HBHighlightModel *> *)deletedArray
{
    if (deletedArray.count > 0) {
        [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
            for (HBHighlightModel *model in deletedArray) {
                NSError *error = nil;
                NSManagedObject *object = [context existingObjectWithID:model.objectID error:&error];
                if (error) {
                    DLog(@"Error get object by ID: %@", error.localizedDescription);
                }
                if (object) {
                    [context deleteObject:object];
                }
            }
        }];
        if (self.extraDelegate && [self.extraDelegate respondsToSelector:@selector(onChangeAyaHighlight)]) {
            [self.extraDelegate onChangeAyaHighlight];
        }
    }
}

- (void)dropPropertyByType:(HBQuranRearType)rearType fromAya:(HBSuraModel *)suraModel
{
    if (rearType == HBQuranRearTypeMarkColor) {
        [self dropMarkColorFromAya:suraModel];
    } else {
        [self dropExtraByType:rearType fromAya:suraModel];
    }
    if (self.ayaDelegate && [self.ayaDelegate respondsToSelector:@selector(onChangeAyaByModel:)]) {
        [self.ayaDelegate onChangeAyaByModel:suraModel];
    }
}

- (void)dropExtraByType:(HBQuranRearType)rearType fromAya:(HBSuraModel *)suraModel
{
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        NSNumber *suraIndex = [NSNumber numberWithInteger:suraModel.index];
        NSNumber *ayaIndex = [NSNumber numberWithInteger:suraModel.lastAya];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suraIndex = %@ AND ayaIndex = %@", suraIndex, ayaIndex];
        NSArray<HBAyaExtraEntity *> *ayaArray = [HBAyaExtraEntity MR_findAllWithPredicate:predicate inContext:context];
        HBAyaExtraEntity *ayaEntity = [ayaArray firstObject];
        if (ayaEntity) {
            switch (rearType) {
                case HBQuranRearTypeView:
                    ayaEntity.flagViewValue = NO;
                    break;
                case HBQuranRearTypeFavorite:
                    ayaEntity.flagFavoriteValue = NO;
                    break;
                case HBQuranRearTypeNotice:
                    ayaEntity.noticeText = nil;
                    break;
                default:
                    break;
            }
        }
    }];
}

- (void)dropMarkColorFromAya:(HBSuraModel *)suraModel
{
    [self dropMarkColorByQuranType:HBQuranItemTypeArabic FromAya:suraModel];
    [self dropMarkColorByQuranType:HBQuranItemTypeTranslit FromAya:suraModel];
    [self dropMarkColorByQuranType:HBQuranItemTypeTranslation FromAya:suraModel];
}

- (void)dropMarkColorByQuranType:(HBQuranItemType)quranType FromAya:(HBSuraModel *)suraModel
{
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        NSNumber *itemId = [self itemIdByType:quranType];
        NSNumber *suraIndex = [NSNumber numberWithInteger:suraModel.index];
        NSNumber *ayaIndex = [NSNumber numberWithInteger:suraModel.lastAya];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sura.quran.itemId = %@ AND sura.index = %@ AND index = %@", itemId, suraIndex, ayaIndex];
        NSArray<HBAyaEntity *> *ayaArray = [HBAyaEntity MR_findAllWithPredicate:predicate inContext:context];
        if (ayaArray) {
            HBAyaEntity *ayaEntity = [ayaArray firstObject];
            if (ayaEntity) {
                NSArray<HBAyaHighlightEntity *> *highlightArray = ayaEntity.highlightsSet.allObjects;
                for (HBAyaHighlightEntity *highlightEntity in highlightArray) {
                    [context deleteObject:highlightEntity];
                }
            }
        }
    }];
}


@end
