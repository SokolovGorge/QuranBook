// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaSoundEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class HBQuranSoundEntity;

@interface HBAyaSoundEntityID : NSManagedObjectID {}
@end

@interface _HBAyaSoundEntity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBAyaSoundEntityID *objectID;

@property (nonatomic, strong, nullable) NSNumber* ayaIndex;

@property (atomic) int32_t ayaIndexValue;
- (int32_t)ayaIndexValue;
- (void)setAyaIndexValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber* duration;

@property (atomic) int64_t durationValue;
- (int64_t)durationValue;
- (void)setDurationValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSNumber* suraIndex;

@property (atomic) int32_t suraIndexValue;
- (int32_t)suraIndexValue;
- (void)setSuraIndexValue:(int32_t)value_;

@property (nonatomic, strong, nullable) HBQuranSoundEntity *quran;

@end

@interface _HBAyaSoundEntity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveAyaIndex;
- (void)setPrimitiveAyaIndex:(nullable NSNumber*)value;

- (int32_t)primitiveAyaIndexValue;
- (void)setPrimitiveAyaIndexValue:(int32_t)value_;

- (nullable NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(nullable NSNumber*)value;

- (int64_t)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(int64_t)value_;

- (nullable NSNumber*)primitiveSuraIndex;
- (void)setPrimitiveSuraIndex:(nullable NSNumber*)value;

- (int32_t)primitiveSuraIndexValue;
- (void)setPrimitiveSuraIndexValue:(int32_t)value_;

- (HBQuranSoundEntity*)primitiveQuran;
- (void)setPrimitiveQuran:(HBQuranSoundEntity*)value;

@end

@interface HBAyaSoundEntityAttributes: NSObject 
+ (NSString *)ayaIndex;
+ (NSString *)duration;
+ (NSString *)suraIndex;
@end

@interface HBAyaSoundEntityRelationships: NSObject
+ (NSString *)quran;
@end

NS_ASSUME_NONNULL_END
