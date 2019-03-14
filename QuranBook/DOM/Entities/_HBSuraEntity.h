// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBSuraEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class HBAyaEntity;
@class HBQuranItemEntity;

@interface HBSuraEntityID : NSManagedObjectID {}
@end

@interface _HBSuraEntity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBSuraEntityID *objectID;

@property (nonatomic, strong, nullable) NSNumber* countAyas;

@property (atomic) int32_t countAyasValue;
- (int32_t)countAyasValue;
- (void)setCountAyasValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber* index;

@property (atomic) int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSSet<HBAyaEntity*> *ayas;
- (nullable NSMutableSet<HBAyaEntity*>*)ayasSet;

@property (nonatomic, strong, nullable) HBQuranItemEntity *quran;

@end

@interface _HBSuraEntity (AyasCoreDataGeneratedAccessors)
- (void)addAyas:(NSSet<HBAyaEntity*>*)value_;
- (void)removeAyas:(NSSet<HBAyaEntity*>*)value_;
- (void)addAyasObject:(HBAyaEntity*)value_;
- (void)removeAyasObject:(HBAyaEntity*)value_;

@end

@interface _HBSuraEntity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveCountAyas;
- (void)setPrimitiveCountAyas:(nullable NSNumber*)value;

- (int32_t)primitiveCountAyasValue;
- (void)setPrimitiveCountAyasValue:(int32_t)value_;

- (nullable NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(nullable NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (NSMutableSet<HBAyaEntity*>*)primitiveAyas;
- (void)setPrimitiveAyas:(NSMutableSet<HBAyaEntity*>*)value;

- (HBQuranItemEntity*)primitiveQuran;
- (void)setPrimitiveQuran:(HBQuranItemEntity*)value;

@end

@interface HBSuraEntityAttributes: NSObject 
+ (NSString *)countAyas;
+ (NSString *)index;
+ (NSString *)name;
@end

@interface HBSuraEntityRelationships: NSObject
+ (NSString *)ayas;
+ (NSString *)quran;
@end

NS_ASSUME_NONNULL_END
