// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranBaseEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "HBQuranItemType.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBQuranBaseEntityID : NSManagedObjectID {}
@end

@interface _HBQuranBaseEntity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBQuranBaseEntityID *objectID;

@property (nonatomic, strong, nullable) NSNumber* defValue;

@property (atomic) BOOL defValueValue;
- (BOOL)defValueValue;
- (void)setDefValueValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSNumber* itemId;

@property (atomic) int16_t itemIdValue;
- (int16_t)itemIdValue;
- (void)setItemIdValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSNumber* itemType;

@property (atomic) HBQuranItemType itemTypeValue;
- (HBQuranItemType)itemTypeValue;
- (void)setItemTypeValue:(HBQuranItemType)value_;

@property (nonatomic, strong, nullable) NSNumber* loaded;

@property (atomic) BOOL loadedValue;
- (BOOL)loadedValue;
- (void)setLoadedValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSNumber* size;

@property (atomic) int64_t sizeValue;
- (int64_t)sizeValue;
- (void)setSizeValue:(int64_t)value_;

@property (nonatomic, strong, nullable) NSString* subname;

@property (nonatomic, strong, nullable) NSString* url_data;

@property (nonatomic, strong, nullable) NSString* url_image;

@end

@interface _HBQuranBaseEntity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveDefValue;
- (void)setPrimitiveDefValue:(nullable NSNumber*)value;

- (BOOL)primitiveDefValueValue;
- (void)setPrimitiveDefValueValue:(BOOL)value_;

- (nullable NSNumber*)primitiveItemId;
- (void)setPrimitiveItemId:(nullable NSNumber*)value;

- (int16_t)primitiveItemIdValue;
- (void)setPrimitiveItemIdValue:(int16_t)value_;

- (nullable NSNumber*)primitiveItemType;
- (void)setPrimitiveItemType:(nullable NSNumber*)value;

- (HBQuranItemType)primitiveItemTypeValue;
- (void)setPrimitiveItemTypeValue:(HBQuranItemType)value_;

- (nullable NSNumber*)primitiveLoaded;
- (void)setPrimitiveLoaded:(nullable NSNumber*)value;

- (BOOL)primitiveLoadedValue;
- (void)setPrimitiveLoadedValue:(BOOL)value_;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSNumber*)primitiveSize;
- (void)setPrimitiveSize:(nullable NSNumber*)value;

- (int64_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int64_t)value_;

- (nullable NSString*)primitiveSubname;
- (void)setPrimitiveSubname:(nullable NSString*)value;

- (nullable NSString*)primitiveUrl_data;
- (void)setPrimitiveUrl_data:(nullable NSString*)value;

- (nullable NSString*)primitiveUrl_image;
- (void)setPrimitiveUrl_image:(nullable NSString*)value;

@end

@interface HBQuranBaseEntityAttributes: NSObject 
+ (NSString *)defValue;
+ (NSString *)itemId;
+ (NSString *)itemType;
+ (NSString *)loaded;
+ (NSString *)name;
+ (NSString *)size;
+ (NSString *)subname;
+ (NSString *)url_data;
+ (NSString *)url_image;
@end

@interface HBQuranBaseEntityUserInfo: NSObject 
+ (NSString *)additionalHeaderFileName;
@end

NS_ASSUME_NONNULL_END
