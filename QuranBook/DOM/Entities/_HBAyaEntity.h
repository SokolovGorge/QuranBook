// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class HBAyaHighlightEntity;
@class HBSuraEntity;

@interface HBAyaEntityID : NSManagedObjectID {}
@end

@interface _HBAyaEntity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBAyaEntityID *objectID;

@property (nonatomic, strong, nullable) NSNumber* index;

@property (atomic) int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

@property (nonatomic, strong, nullable) NSString* text;

@property (nonatomic, strong, nullable) NSSet<HBAyaHighlightEntity*> *highlights;
- (nullable NSMutableSet<HBAyaHighlightEntity*>*)highlightsSet;

@property (nonatomic, strong, nullable) HBSuraEntity *sura;

@end

@interface _HBAyaEntity (HighlightsCoreDataGeneratedAccessors)
- (void)addHighlights:(NSSet<HBAyaHighlightEntity*>*)value_;
- (void)removeHighlights:(NSSet<HBAyaHighlightEntity*>*)value_;
- (void)addHighlightsObject:(HBAyaHighlightEntity*)value_;
- (void)removeHighlightsObject:(HBAyaHighlightEntity*)value_;

@end

@interface _HBAyaEntity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(nullable NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;

- (nullable NSString*)primitiveText;
- (void)setPrimitiveText:(nullable NSString*)value;

- (NSMutableSet<HBAyaHighlightEntity*>*)primitiveHighlights;
- (void)setPrimitiveHighlights:(NSMutableSet<HBAyaHighlightEntity*>*)value;

- (HBSuraEntity*)primitiveSura;
- (void)setPrimitiveSura:(HBSuraEntity*)value;

@end

@interface HBAyaEntityAttributes: NSObject 
+ (NSString *)index;
+ (NSString *)text;
@end

@interface HBAyaEntityRelationships: NSObject
+ (NSString *)highlights;
+ (NSString *)sura;
@end

NS_ASSUME_NONNULL_END
