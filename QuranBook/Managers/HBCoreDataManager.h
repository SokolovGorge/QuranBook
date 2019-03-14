//
//  SHCoreDataManager.h
//  Shaka
//
//  Created by Dmitry Laenko on 31/03/15.
//  Copyright (c) 2015 Shaka OOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MagicalRecord.h"


@interface HBCoreDataManager : NSObject

@property (assign, nonatomic, readonly) BOOL isActive;

+ (instancetype)sharedInstance;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (NSString*)newUUID;


- (void)releaseStorage;

- (void)initializeStorage;

- (void)performSync:(void (^)(NSManagedObjectContext *context))block;
- (void)performAsync:(void (^)(NSManagedObjectContext *context))block;

- (void)performSyncAndSave:(void (^)(NSManagedObjectContext *context))block;
- (void)performAsyncAndSave:(void (^)(NSManagedObjectContext *context))block;
- (void)performAsyncAndSave:(void (^)(NSManagedObjectContext *context))block completion:(MRSaveCompletionHandler)completion;

- (void)deleteObjectByID:(NSManagedObjectID *)objectId;
- (void)deleteObject:(NSManagedObject *)object;

- (BOOL)isMigrationNeeded;
- (BOOL)migrate:(NSError **)error;

@property (nonatomic) BOOL migrationFailed;

@end

@interface NSArray(MagicalRecord)

- (NSArray *)MR_inThreadContext;

@end
