// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaHighlightEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class HBAyaEntity;

@interface HBAyaHighlightEntityID : NSManagedObjectID {}
@end

@interface _HBAyaHighlightEntity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBAyaHighlightEntityID *objectID;

@property (nonatomic, strong, nullable) NSNumber* length;

@property (atomic) int32_t lengthValue;
- (int32_t)lengthValue;
- (void)setLengthValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber* location;

@property (atomic) int32_t locationValue;
- (int32_t)locationValue;
- (void)setLocationValue:(int32_t)value_;

@property (nonatomic, strong, nullable) HBAyaEntity *aya;

@end

@interface _HBAyaHighlightEntity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveLength;
- (void)setPrimitiveLength:(nullable NSNumber*)value;

- (int32_t)primitiveLengthValue;
- (void)setPrimitiveLengthValue:(int32_t)value_;

- (nullable NSNumber*)primitiveLocation;
- (void)setPrimitiveLocation:(nullable NSNumber*)value;

- (int32_t)primitiveLocationValue;
- (void)setPrimitiveLocationValue:(int32_t)value_;

- (HBAyaEntity*)primitiveAya;
- (void)setPrimitiveAya:(HBAyaEntity*)value;

@end

@interface HBAyaHighlightEntityAttributes: NSObject 
+ (NSString *)length;
+ (NSString *)location;
@end

@interface HBAyaHighlightEntityRelationships: NSObject
+ (NSString *)aya;
@end

NS_ASSUME_NONNULL_END
