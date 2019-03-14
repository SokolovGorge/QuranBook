//
//  HBLoadContentService.h
//  QuranBook
//
//  Created by Соколов Георгий on 24/11/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBLoadState.h"
#import "HBLoadType.h"

@class HBBaseLoader;

typedef void (^HBURLSessionHandler)(void);

@protocol HBLoaderContentDelegate

@required

- (void)onChangeStatus:(HBLoadState)loadState byType:(HBLoadType)loadType byId:(NSString *)itemId;

- (void)onChangePercent:(float)percent byType:(HBLoadType)loadType byId:(NSString *)itemId;

@end

@protocol HBLoadContentService <NSObject>

/**
 Подписываение делегата на события
 
 @param delegate HBLoaderContentDelegate - делегат
 */
- (void)registerLoaderDelegate:(id<HBLoaderContentDelegate>)delegate;

/**
 Отписывание делегата
 
 @param delegate HBLoaderContentDelegate - делегат
 */
- (void)unregisterLoaderDelegate:(id<HBLoaderContentDelegate>)delegate;

/**
 Возвращает загрузчик по типу и Id элемента
 
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 @return HBBaseLoader - объект загрузчика
 */
- (HBBaseLoader *)loaderByType:(HBLoadType)loadType byId:(NSString *)itemId;

/**
 Запускает процесс загрузки объекта
 
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 */
- (void)startLoadByType:(HBLoadType)loadType byId:(NSString *)itemId;

- (HBBaseLoader *)getOrCreateLoaderByType:(HBLoadType)loadType byId:(NSString *)itemId;

/**
 Пауза процесса загрузки
 
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 */
- (void)pauseLoadByType:(HBLoadType)loadType byId:(NSString *)itemId;

/**
 Останавливает процесс загрузки
 
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 */
- (void)stopLoadByType:(HBLoadType)loadType byId:(NSString *)itemId;

/**
 Возобновляет процесс загрузки
 
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 */
- (void)resumeLoadByType:(HBLoadType)loadType byId:(NSString *)itemId;

/**
 Очищает загруженные данные
 
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 */
- (void)clearDataByType:(HBLoadType)loadType byId:(NSString *)itemId;

/**
 В фоновом режиме проверяет объекты загрузки и при необходимости возобновляет процесс загрузки.
 */
- (void)restoreLoadProcess;

/**
 Удаляется из списка загрузок. Должен вызываться в конкретной реализации загрузчика после завершения процесса загрузки в случае состояния HBLoadStateLoaded или HBLoadStateStop.
 
 @param loader HBBaseLoader - загрузчик
 */
- (void)removeLoader:(HBBaseLoader *)loader;

/**
 Посылает делегатам событие изменения статуса объекта загрузки. Используется загрузчиком.
 
 @param loadState HBLoadState - статус объекта загрузки
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 */
- (void)sendStatus:(HBLoadState)loadState byType:(HBLoadType)loadType byId:(NSString *)itemId;

/**
 Посылает делегатам событие изменения процента загрузки. Используется загрузчиком.
 
 @param percent float - процент загрузки
 @param loadType HBLoadType - тип объекта загрузки
 @param itemId NSNumber - Id элемента загрузки
 */
- (void)sendPercent:(float)percent byType:(HBLoadType)loadType byId:(NSString *)itemId;

- (void)addURLSessionHandler:(HBURLSessionHandler)handler withIdentifier:(NSString *)identifier;

- (HBURLSessionHandler)URLSessionHandlerByIdentifier:(NSString *)identifier;

- (void)removeURLSessionHandlerByIdentifier:(NSString *)identifier;


@end
