//
//  HBQuranViewModel.h
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBQuranItemType.h"
#import "HBQuranRearType.h"

@class HBSuraModel;
@class HBAyaModel;
@class HBJuzModel;
@class HBAyaSoundModel;
@class HBHighlightModel;


@protocol HBQuranExtraDelegate<NSObject>

@optional

- (void)onChangeAyaExtra;

- (void)onChangeAyaHighlight;

@end

@protocol HBQuranAyaDelegate<NSObject>

@optional

- (void)onChangeAyaByModel:(HBSuraModel*)suraModel;

@end


@interface HBQuranGateway: NSObject

@property (weak, nonatomic) id<HBQuranExtraDelegate> extraDelegate;

@property (weak, nonatomic) id<HBQuranAyaDelegate> ayaDelegate;

/**
 Проверяет и подготавливает кэш с сурами
 */
- (void)checkCacheSura;

/**
 Перегружает кеш с сурами
 */
- (void)reloadCacheSura;

/**
 Возвращает массив сур, отсортированных по номеру с последней прочитанной сурой на первом месте.
 Должен быть подготовлен кэш сур.
 
 @return NSArray<HBSuraModel *> - массив сур
 */
- (NSMutableArray<HBSuraModel *> *)listSuraModelFromCache;

/**
 Возвращает массив джузов
 Должен быть подготовлен кэш сур.
 
 @return NSArray<HBJuzModel *> - массив джузов
 */
- (NSArray<HBJuzModel *> *)listJusModel;

/**
 Возвращает список отмеченных аятов как прочитанные.
 Информация передается в моделе суры с состоянием HBSuraStateView.
 
 @return NSArray<HBSuraModel *> - массив аятов
 */
- (NSArray<HBSuraModel *> *)listAyaByView;

/**
 Возвращает список отмеченных аятов как избранные.
 Информация передается в моделе суры с состоянием HBSuraStateFavorite.
 
 @return NSArray<HBSuraModel *> - массив аятов
 */
- (NSArray<HBSuraModel *> *)listAyaByFavorite;

/**
 Возвращает список аятов с примечаниями.
 Информация передается в моделе суры с состоянием HBSuraStateNotice.
 
 @return NSArray<HBSuraModel *> - массив аятов
 */
- (NSArray<HBSuraModel *> *)listAyaByNotice;

/**
 Возвращает список аятов с отметками цветом.
 Информация передается в моделе суры с состоянием HBSuraStateNotice.
 
 @return NSArray<HBSuraModel *> - массив аятов
 */
- (NSArray<HBSuraModel *> *)listAyaByMarkColor;

/**
 Возвращает последнюю прочитанную суру
 
 @return HBSuraModel - суру со ссылкой на аят
 */
- (HBSuraModel *)lastReadSuraModel;

/**
 Возвращает модель суры по номеру
 Должен быть подготовлен кэш сур.
 
 @param suraIndex NSInteger - номер суры
 @return HBSuraModel - модель суры
 */
- (HBSuraModel *)suraModelBySuraNumber:(NSInteger)suraIndex;

/**
 Возвращает список аятов суры, отсортированных по номеру.
 
 @param suraIndex NSInteger - номер суры
 @param block void(^)(NSArray<HBAyaModel *> *listAyas) - блок, выполняющийся после формирования данных
 */
- (void)prepareAyasBySuraNumber:(NSInteger)suraIndex onComplite:(void(^)(NSMutableArray<HBAyaModel *> *listAyas))block;

/**
 Формирует модель аята
 
 @param suraIndex NSInteger - номер суры
 @param ayaIndex NSInteger - номер аята
 @return HBAyaModel - модель аята
 */
- (HBAyaModel *)ayaModelBySuraNumber:(NSInteger)suraIndex byAyaNumber:(NSInteger)ayaIndex;

/**
 Возвращает список сур с номерами аятов по поиску текста в аятах.
 ВНИМАНИЕ! Для корректной работы требуется создание кэша сур с помощью метода listSuraModelAndCached
 
 @param searchText NSString - текст поиска
 @param operation NSOperation - операция запуска (для проверки ее прерывания
 @return NSArray<HBSuraModel *> - список сур с номерами аятов
 */
- (NSArray<HBSuraModel *> *)filteredSurasByText:(NSString *)searchText withOperation:(NSOperation *)operation;


/**
 Сохранение дополнительных данных аята в БД в фоновом потоке.
 
 @param model HBAyaModel - модель аята
 */
- (void)saveAyaExtraByModel:(HBAyaModel *)model;

/**
 Сохраняет информацию выделения цветом.
 
 @param range NSRange - диапазон выделения
 @param type HBQuranItemType - тип данных
 @param suraIndex NSInteger - номер суры
 @param ayaIndex NSInteger - номер аята
 @return HBHighlightModel - модель сохраненных данных
 */
- (HBHighlightModel *)saveAyaHighlightRange:(NSRange)range byType:(HBQuranItemType)type bySuraNumber:(NSInteger)suraIndex byAyaNumber:(NSInteger)ayaIndex;

/**
 Удалаяет из базы данные выделения цветом.
 
 @param deletedArray - массив удаляемых моделей
 */
- (void)deleteAyaHighLights:(NSArray<HBHighlightModel *> *)deletedArray;

/**
 Снимает отметку аята или удаляет все выделения цетом в аяте.
 
 @param rearType HBQuranRearType - тип данных
 @param suraModel HBSuraModel - модель, определяет аят по индексам.
 */
- (void)dropPropertyByType:(HBQuranRearType)rearType fromAya:(HBSuraModel *)suraModel;

@end
