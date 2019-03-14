// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranItemEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "HBQuranBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@class HBSuraEntity;

@interface HBQuranItemEntityID : HBQuranBaseEntityID {}
@end

@interface _HBQuranItemEntity : HBQuranBaseEntity
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBQuranItemEntityID *objectID;

@property (nonatomic, strong, nullable) NSSet<HBSuraEntity*> *suras;
- (nullable NSMutableSet<HBSuraEntity*>*)surasSet;

@end

@interface _HBQuranItemEntity (SurasCoreDataGeneratedAccessors)
- (void)addSuras:(NSSet<HBSuraEntity*>*)value_;
- (void)removeSuras:(NSSet<HBSuraEntity*>*)value_;
- (void)addSurasObject:(HBSuraEntity*)value_;
- (void)removeSurasObject:(HBSuraEntity*)value_;

@end

@interface _HBQuranItemEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet<HBSuraEntity*>*)primitiveSuras;
- (void)setPrimitiveSuras:(NSMutableSet<HBSuraEntity*>*)value;

@end

@interface HBQuranItemEntityRelationships: NSObject
+ (NSString *)suras;
@end

NS_ASSUME_NONNULL_END
