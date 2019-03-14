//
//  HBQuranService.h
//  QuranBook
//
//  Created by Соколов Георгий on 14/11/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranSoundEndAction.h"
#import "HBQuranSoundRepeat.h"
#import "HBQuranSoundEndAction.h"
#import "HBQuranItemType.h"

@class HBQuranBaseEntity;
@class HBQuranItemEntity;
@class HBQuranImageEntity;
@class HBQuranSoundEntity;
@class HBAyaSoundModel;



@protocol HBQuranService <NSObject>

/**
 Возвращает шрифт для арабского текста в режиме отображения Корана
 
 @return UIFont - шрифт
 */
- (UIFont *)arabicFont;

/**
 Возвращает цвет текста для арабского текста в режиме отображения Корана
 
 @return UIColor - цвет
 */
- (UIColor *)arabicColor;

/**
 Возвращает шрифт для транслита в режиме отображения Корана
 
 @return UIFont - шрифт
 */
- (UIFont *)translitFont;

/**
 Возвращает цвет текста для транслита в режиме отображения Корана
 
 @return UIColor - цвет
 */
- (UIColor *)translitColor;

/**
 Возвращает шрифт для перевода в режиме отображения Корана
 
 @return UIFont - шрифт
 */
- (UIFont *)translationFont;

/**
 Возвращает цвет текста для перевода в режиме отображения Корана
 
 @return UIColor - цвет
 */
- (UIColor *)translationColor;

/**
 Возвращает цвет выделения текста в режиме отображения Корана
 
 @return UIColor - цвет
 */
- (UIColor *)highlightColor;

/**
 Конвертирование арабских цифр в восточно-арабские цифры.
 
 @param westernDigit NSString - строка с арабскими цифрами
 @return NSString - строка с восточно-арабскими цифрами
 */
- (NSString *)digitToEasternDigit:(NSString *)westernDigit;

/**
 Преобразование в строку
 
 @param value HBQuranSoundEndAction - значение перечисления
 @return NSString - строковый эквивалент
 */
- (NSString *)stringFromQuranSoundEndAction:(HBQuranSoundEndAction)value;

/**
 Преобразование в строку
 
 @param value HBQuranSoundRepeat - значение перечисления
 @return NSString - строковый эквивалент
 */
- (NSString *)stringFromQuranSoundRepeat:(HBQuranSoundRepeat)value;

/**
 Возвращает URL звукового файла Корана
 
 @param pathName NSString - путь к папке звуков
 @param suraIndex NSInteger - индекс суры
 @param ayaIndex NSInteger - индекс аята
 @return NSURL звукового файла Корана
 */
- (NSURL *)soundURLByPathName:(NSString *)pathName suraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex;

/**
 Возвращает каталог хранения звуков Корана
 
 @param itemId NSString - идентификатор Корана
 @return NSString - имя каталога
 */
- (NSString *)soundFolderByItemId:(NSString *)itemId;

/**
 Возвращает имя звукового файла Корана
 
 @param suraIndex NSInteger - индекс суры
 @param ayaIndex NSInteger - индекс аята
 @return NSString - имя файла
 */
- (NSString *)soundFileNameBySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex;

/**
 Возвращает количество сур
 
 @return NSInteger - количество сур
 */
- (NSInteger)surasCount;

/**
 Возвращает полный путь к файлу картинки названия суры по индексу суры
 
 @param suraIndex NSInteger - индекс суры
 @return NSString - путь к файлу
 */
- (NSString *)suraImageFileByIndex:(NSInteger)suraIndex;

/**
 Загружает JSON с данными элемента Корана, парсит и кладет в базу
 
 @param quranEntity HBQuranItemEntity - элемент Корана
 @param error NSError - ошибка загрузки
 */
- (void)loadQuranFromServerToItemEntity:(HBQuranItemEntity *)quranEntity onError:(NSError **)error;

/**
 Загружает картинки названий сур Корана и кладет в отдельный каталог.
 
 @param imageEntity HBQuranImageEntity - - элемент Корана
 @param error NSError - ошибка загрузки
 */
- (void)loadImagesFromServerByImageEntity:(HBQuranImageEntity *)imageEntity onError:(NSError **)error;

/**
 Загружает JSON c данными о звуковых файлах, парсит и кладет в базу
 
 @param itemId NSNumber - Id элемента Корана
 @param error NSError - ошибка загрузки
 */
- (void)checkLoadSoundIndexFromServerByItemId:(NSNumber *)itemId onError:(NSError **)error;


/**
 Заполнение списка элементов корана
 */
- (void)checkQuranItems;

/**
 Возвращает список элементов Корана, которые необходимо загрузить.
 
 @return NSArray<HBQuranItemEntity *> - список
 */
- (NSArray<HBQuranBaseEntity *>*)listNeedLoad;


/**
 Возвращает элемент Корана по Id
 
 @param itemId NSNumber - Id элемента
 @return HBQuranBaseEntity - элемент Корана
 */
- (HBQuranBaseEntity *)quranEntityById:(NSNumber *)itemId;

/**
 Удаляет из базы данные элемента Корана
 
 @param quranEntity HBQuranItemEntity - элемент Корана
 */
- (void)clearQuranItemEntity:(HBQuranItemEntity *)quranEntity;

/**
 Возвращает список прочтений Корана, отсортированные по имени.
 
 @return NSArray<HBQuranSoundEntity *> - список элементов
 */
- (NSArray<HBQuranSoundEntity *> *)listQuranSoundEnity;

/**
 Возвращает список элементов Корана заданного типа, отсортированные по имени
 
 @param type HBQuranItemType - тип элемента Корана
 @return NSArray<HBQuranItemEntity *> - список элементов
 */
- (NSArray<HBQuranItemEntity *> *)listQuranEntityByType:(HBQuranItemType)type;

/**
 Возвращает звук аята. Проверяет загрузку звука в БД. Если не загружен, то грузит с сервера, сохраняет в БД.
 
 @param quranEntity HBQuranSoundEntity - элемент  Корана
 @param suraIndex NSInteger - номер суры
 @param ayaIndex NSInteger - номер аята
 @param error NSError  - возвращяемая ошибка
 @return NSData - звук аята
 */
- (NSData *)loadAndCacheDataSoundByQuranItem:(HBQuranSoundEntity *)quranEntity suraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex onError:(NSError **)error;

/**
 Возвращает список индексов проигрывания Корана
 
 @param quranEntity HBQuranSoundEntity - выбранный нобор чтения
 @param suraIndex NSInteger - номер суры
 @param error NSError  - возвращяемая ошибка
 @return NSArray <HBAyaSoundModel *> - список информации о чтении
 */
- (NSArray <HBAyaSoundModel *> *)listSoundModelByQuranItem:(HBQuranSoundEntity *)quranEntity suraIndex:(NSInteger)suraIndex onError:(NSError **)error;




@end

