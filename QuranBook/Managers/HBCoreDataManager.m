//
//  SHCoreDataManager.m
//  Shaka
//
//  Created by Dmitry Laenko on 31/03/15.
//  Copyright (c) 2015 Shaka OOO. All rights reserved.
//

#import "HBCoreDataManager.h"
#import "HBMacros.h"
#import "HBConstants.h"


#import "HBMigrationManager.h"


@interface HBCoreDataManager() <HBMigrationManagerDelegate>

@end

@implementation HBCoreDataManager

#define LOGCORE     YES

+ (instancetype)sharedInstance
{
    static HBCoreDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HBCoreDataManager alloc] initPrivate];
    });
    return manager;
}

+ (NSString*)newUUID{
    NSString *uuID = nil;
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    uuID = [NSString stringWithString: (__bridge NSString *)string];
    
    CFRelease(string);
    
    return uuID;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _isActive = NO;
    }
    return self;
}

- (void)initializeStorage
{
    NSURL *pathStore = [self sourceStoreURL];
#ifdef COREDATA_AUTOMIGRATION
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:pathStore];
#else
    [MagicalRecord setupCoreDataStackWithStoreAtURL:pathStore];
#endif
    _isActive = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCoredataInitNotification object:nil];
}

- (BOOL)isMigrationNeeded
{
    NSError *error = nil;
    
    // Check if we need to migrate
    NSDictionary *sourceMetadata = [self sourceMetadata:&error];
    BOOL isMigrationNeeded = NO;
    
    if (sourceMetadata != nil) {
        NSManagedObjectModel *destinationModel = [self managedObjectModel];
        // Migration is needed if destinationModel is NOT compatible
        isMigrationNeeded = ![destinationModel isConfiguration:nil
                                   compatibleWithStoreMetadata:sourceMetadata];
    }
    DLog(@"isMigrationNeeded: %d", isMigrationNeeded);
    return isMigrationNeeded;
}

- (BOOL)migrate:(NSError **)error
{
    // Enable migrations to run even while user exits app
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    HBMigrationManager *migrationManager = [[HBMigrationManager alloc] init];
    migrationManager.delegate = self;
    
    BOOL OK = [migrationManager progressivelyMigrateURL:[self sourceStoreURL]
                                                 ofType:[self sourceStoreType]
                                                toModel:[self managedObjectModel]
                                                  error:error];
    if (OK) {
        DLog(@"migration complete");
    }
    
    // Mark it as invalid
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
    return OK;
    
}

- (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self sourceStoreType]
                                                                      URL:[self sourceStoreURL]
                                                                  options:nil
                                                                    error:error];
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSString *momPath = [[NSBundle mainBundle] pathForResource:@"QuranBook"
                                                        ofType:@"momd"];
    
    if (!momPath) {
        momPath = [[NSBundle mainBundle] pathForResource:@"QuranBook"
                                                  ofType:@"mom"];
    }
    
    NSURL *url = [NSURL fileURLWithPath:momPath];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
}

- (NSURL *)sourceStoreURL
{
    NSURL *directory = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;
    return [directory URLByAppendingPathComponent:kMagicalRecordDefaultStoreFileName];
}

- (NSString *)sourceStoreType
{
    return NSSQLiteStoreType;
}

- (void)releaseStorage{
    [MagicalRecord cleanUp];
}

- (void)performAsync:(void (^)(NSManagedObjectContext *context))block
{
    if (!block) {
        return;
    }
    NSManagedObjectContext *rootContext = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *readContext = [NSManagedObjectContext MR_contextWithParent:rootContext];
    [readContext performBlock:^{
        block(readContext);
    }];
}

- (void)performSync:(void (^)(NSManagedObjectContext *context))block
{
    if (!block) {
        return;
    }
    if ([NSThread isMainThread]) {
        NSManagedObjectContext *readContext = [NSManagedObjectContext MR_defaultContext];
        block(readContext);
    } else {
        NSManagedObjectContext *rootContext = [NSManagedObjectContext MR_rootSavingContext];
        NSManagedObjectContext *readContext = [NSManagedObjectContext MR_contextWithParent:rootContext];
        [readContext performBlockAndWait:^{
            block(readContext);
        }];
    }
}

- (void)performSyncAndSave:(void (^)(NSManagedObjectContext *context))block{
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        if (block){
            block(localContext);
        }
    }];
}

- (void)performAsyncAndSave:(void (^)(NSManagedObjectContext *context))block{
    [self performAsyncAndSave:block completion:nil];
}

- (void)performAsyncAndSave:(void (^)(NSManagedObjectContext *context))block completion:(MRSaveCompletionHandler)completion{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        if (block){
            block(localContext);
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (completion){
            completion(contextDidSave, error);
        }
    }];
}

- (void)deleteObjectByID:(NSManagedObjectID *)objectId {
    [self performSyncAndSave:^(NSManagedObjectContext *context) {
        NSManagedObject *object = [context objectRegisteredForID:objectId];
        if (object) {
            [context deleteObject:object];
        }
    }];
}

- (void)deleteObject:(NSManagedObject *)object {
    [self performSyncAndSave:^(NSManagedObjectContext *context) {
        NSManagedObject *objectInContext = [object MR_inContext:context];
        [context deleteObject:objectInContext];
    }];
}

#pragma mark - HBMigrationManagerDelegate

- (void)migrationManager:(HBMigrationManager *)migrationManager migrationProgress:(float)migrationProgress
{
    DLog(@"Migrate - %f", migrationProgress);
}

- (NSArray *)migrationManager:(HBMigrationManager *)migrationManager mappingModelsForSourceModel:(NSManagedObjectModel *)sourceModel
{
    // определяет последовательность  моделей миграции при наличии несколких моделей на одну версию
    
    NSMutableArray *mappingModels = [NSMutableArray array];
    
    /****************************** ПРИМЕР  ******************************************************************
     NSString *modelName = [sourceModel hb_modelName];
     if ([modelName isEqual:@"Model2"]) {
     // Migrating to Model3
     NSArray *urls = [[NSBundle bundleForClass:[self class]]
     URLsForResourcesWithExtension:@"cdm"
     subdirectory:nil];
     for (NSURL *url in urls) {
     if ([url.lastPathComponent rangeOfString:@"Model2_to_Model"].length != 0) {
     NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:url];
     if ([url.lastPathComponent rangeOfString:@"User"].length != 0) {
     // User first so we create new relationship
     [mappingModels insertObject:mappingModel atIndex:0];
     } else {
     [mappingModels addObject:mappingModel];
     }
     }
     }
     }
     *********************************************************************************************************/
    
    return mappingModels;
}


@end



@implementation NSArray(MagicalRecord)

- (NSArray *)MR_inThreadContext{
    __block NSMutableArray *mar = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSManagedObject class]]){
            NSManagedObject *newObj = [obj MR_inThreadContext];
            if (newObj)
                [mar addObject:newObj];
            else
                [mar addObject:obj];
        }
    }];
    return [NSArray arrayWithArray:mar];
}

@end
