// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaExtraEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HBAyaExtraEntityID : NSManagedObjectID {}
@end

@interface _HBAyaExtraEntity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBAyaExtraEntityID *objectID;

@property (nonatomic, strong, nullable) NSNumber* ayaIndex;

@property (atomic) int32_t ayaIndexValue;
- (int32_t)ayaIndexValue;
- (void)setAyaIndexValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSNumber* flagFavorite;

@property (atomic) BOOL flagFavoriteValue;
- (BOOL)flagFavoriteValue;
- (void)setFlagFavoriteValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* flagView;

@property (atomic) BOOL flagViewValue;
- (BOOL)flagViewValue;
- (void)setFlagViewValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* noticeText;

@property (nonatomic, strong, nullable) NSNumber* suraIndex;

@property (atomic) int32_t suraIndexValue;
- (int32_t)suraIndexValue;
- (void)setSuraIndexValue:(int32_t)value_;

@end

@interface _HBAyaExtraEntity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveAyaIndex;
- (void)setPrimitiveAyaIndex:(nullable NSNumber*)value;

- (int32_t)primitiveAyaIndexValue;
- (void)setPrimitiveAyaIndexValue:(int32_t)value_;

- (nullable NSNumber*)primitiveFlagFavorite;
- (void)setPrimitiveFlagFavorite:(nullable NSNumber*)value;

- (BOOL)primitiveFlagFavoriteValue;
- (void)setPrimitiveFlagFavoriteValue:(BOOL)value_;

- (nullable NSNumber*)primitiveFlagView;
- (void)setPrimitiveFlagView:(nullable NSNumber*)value;

- (BOOL)primitiveFlagViewValue;
- (void)setPrimitiveFlagViewValue:(BOOL)value_;

- (nullable NSString*)primitiveNoticeText;
- (void)setPrimitiveNoticeText:(nullable NSString*)value;

- (nullable NSNumber*)primitiveSuraIndex;
- (void)setPrimitiveSuraIndex:(nullable NSNumber*)value;

- (int32_t)primitiveSuraIndexValue;
- (void)setPrimitiveSuraIndexValue:(int32_t)value_;

@end

@interface HBAyaExtraEntityAttributes: NSObject 
+ (NSString *)ayaIndex;
+ (NSString *)flagFavorite;
+ (NSString *)flagView;
+ (NSString *)noticeText;
+ (NSString *)suraIndex;
@end

NS_ASSUME_NONNULL_END
