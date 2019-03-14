// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranImageEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "HBQuranBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBQuranImageEntityID : HBQuranBaseEntityID {}
@end

@interface _HBQuranImageEntity : HBQuranBaseEntity
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBQuranImageEntityID *objectID;

@end

@interface _HBQuranImageEntity (CoreDataGeneratedPrimitiveAccessors)

@end

NS_ASSUME_NONNULL_END
