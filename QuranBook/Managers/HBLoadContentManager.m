//
//  HBLoadContentManager.m
//  Habar
//
//  Created by Соколов Георгий on 22.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBLoadContentManager.h"
#import "HBBaseLoader.h"
#import "HBQuranSoundLoader.h"
#import "HBQuranService.h"

@interface HBHandlerWrapper: NSObject

@property (copy, nonatomic) HBURLSessionHandler handler;

@end

@interface HBLoadContentManager ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, HBBaseLoader *> *loaderDictionary;
@property (strong, nonatomic) NSHashTable<id<HBLoaderContentDelegate>> *delegateTable;
@property (strong, nonatomic) NSMutableDictionary<NSString *, HBHandlerWrapper *> *handlerDictionary;

@property (strong, nonatomic) id<HBQuranService> quranService;

@end

@implementation HBHandlerWrapper

- (instancetype)initWithHandler:(HBURLSessionHandler)handler
{
    self = [super init];
    if (self) {
        self.handler = handler;
    }
    return self;
}

@end

@implementation HBLoadContentManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loaderDictionary = [NSMutableDictionary dictionary];
        self.delegateTable = [NSHashTable weakObjectsHashTable];
        self.handlerDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerLoaderDelegate:(id<HBLoaderContentDelegate>)delegate
{
    __weak id<HBLoaderContentDelegate> weakDelegate = delegate;
    if (![self.delegateTable containsObject:weakDelegate]) {
        [self.delegateTable addObject:weakDelegate];
    }
}

- (void)unregisterLoaderDelegate:(id<HBLoaderContentDelegate>)delegate
{
    [self.delegateTable removeObject:delegate];
}

- (void)startLoadByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    HBBaseLoader *loader = [self getOrCreateLoaderByType:loadType byId:itemId];
    if (loader.loadState != HBLoadStateLoading && loader.loadState != HBLoadStateUnpacking) {
        [loader startLoad];
    }
}

- (void)pauseLoadByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    HBBaseLoader *loader = [self getLoaderByType:loadType byId:itemId];
    if (loader) {
        [loader pause];
    }
}

- (void)stopLoadByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    HBBaseLoader *loader = [self getLoaderByType:loadType byId:itemId];
    if (loader) {
        [loader stopLoad];
    }
}

- (void)resumeLoadByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    HBBaseLoader *loader = [self getLoaderByType:loadType byId:itemId];
    if (loader) {
        [loader resume];
    }
}

- (void)clearDataByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    HBBaseLoader *loader = [self getOrCreateLoaderByType:loadType byId:itemId];
    loader.loadState = HBLoadStateComplete;
    [loader clearData];
}

- (HBBaseLoader *)loaderByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    NSString *key = [self keyByType:loadType byId:itemId];
    return self.loaderDictionary[key];
}

- (void)restoreLoadProcess
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [HBQuranSoundLoader restoreLoadProcessWithLoadContentService:self];
    });
}

- (void)sendStatus:(HBLoadState)loadState byType:(HBLoadType)loadType byId:(NSString *)itemId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<HBLoaderContentDelegate> delegate in self.delegateTable) {
            [delegate onChangeStatus:loadState byType:loadType byId:itemId];
        }
    });
}

- (void)sendPercent:(float)percent byType:(HBLoadType)loadType byId:(NSString *)itemId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<HBLoaderContentDelegate> delegate in self.delegateTable) {
            [delegate onChangePercent:percent byType:loadType byId:itemId];
        }
    });
}

- (void)removeLoader:(HBBaseLoader *)loader
{
    @synchronized(self.loaderDictionary) {
        NSString *key = [self keyByType:[loader loadType] byId:loader.itemId];
        [self.loaderDictionary removeObjectForKey:key];
    }
}

- (void)addURLSessionHandler:(HBURLSessionHandler)handler withIdentifier:(NSString *)identifier
{
    HBHandlerWrapper *handlerWrapper = [[HBHandlerWrapper alloc] initWithHandler:handler];
    self.handlerDictionary[identifier] = handlerWrapper;
}

- (HBURLSessionHandler)URLSessionHandlerByIdentifier:(NSString *)identifier
{
    @synchronized(self.handlerDictionary) {
        return self.handlerDictionary[identifier].handler;
    }
}

- (void)removeURLSessionHandlerByIdentifier:(NSString *)identifier
{
    @synchronized(self.handlerDictionary) {
        [self.handlerDictionary removeObjectForKey:identifier];
    }
}

- (HBBaseLoader *)getOrCreateLoaderByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    NSString *key = [self keyByType:loadType byId:itemId];
    HBBaseLoader *loader = self.loaderDictionary[key];
    if (!loader) {
        loader = [self createLoaderByType:loadType byId:itemId];
        @synchronized(self.loaderDictionary) {
            self.loaderDictionary[key] = loader;
        }
    }
    return loader;
}

#pragma mark - Private Methods

- (HBBaseLoader *)getLoaderByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    NSString *key = [self keyByType:loadType byId:itemId];
    return self.loaderDictionary[key];
}

- (NSString *)keyByType:(HBLoadType)type byId:(NSString *)itemId
{
    return [NSString stringWithFormat:@"%ld#%@", (long)type, itemId];
}

- (HBBaseLoader *)createLoaderByType:(HBLoadType)loadType byId:(NSString *)itemId
{
    HBBaseLoader *loader = nil;
    switch (loadType) {
        case HBLoadTypeQuranSound:
            loader = [[HBQuranSoundLoader alloc] initLoadService:self withQuranService:self.quranService withId:itemId];
            break;
        case HBLoadTypeMessage:
            break;
    }
    return loader;
}


@end

