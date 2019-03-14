// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranSoundEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "HBQuranBaseEntity.h"

#import "HBLoadState.h"

NS_ASSUME_NONNULL_BEGIN

@class HBAyaSoundEntity;

@interface HBQuranSoundEntityID : HBQuranBaseEntityID {}
@end

@interface _HBQuranSoundEntity : HBQuranBaseEntity
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) HBQuranSoundEntityID *objectID;

@property (nonatomic, strong, nullable) NSNumber* soundState;

@property (atomic) HBLoadState soundStateValue;
- (HBLoadState)soundStateValue;
- (void)setSoundStateValue:(HBLoadState)value_;

@property (nonatomic, strong, nullable) NSSet<HBAyaSoundEntity*> *ayas;
- (nullable NSMutableSet<HBAyaSoundEntity*>*)ayasSet;

@end

@interface _HBQuranSoundEntity (AyasCoreDataGeneratedAccessors)
- (void)addAyas:(NSSet<HBAyaSoundEntity*>*)value_;
- (void)removeAyas:(NSSet<HBAyaSoundEntity*>*)value_;
- (void)addAyasObject:(HBAyaSoundEntity*)value_;
- (void)removeAyasObject:(HBAyaSoundEntity*)value_;

@end

@interface _HBQuranSoundEntity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSNumber*)primitiveSoundState;
- (void)setPrimitiveSoundState:(nullable NSNumber*)value;

- (HBLoadState)primitiveSoundStateValue;
- (void)setPrimitiveSoundStateValue:(HBLoadState)value_;

- (NSMutableSet<HBAyaSoundEntity*>*)primitiveAyas;
- (void)setPrimitiveAyas:(NSMutableSet<HBAyaSoundEntity*>*)value;

@end

@interface HBQuranSoundEntityAttributes: NSObject 
+ (NSString *)soundState;
@end

@interface HBQuranSoundEntityRelationships: NSObject
+ (NSString *)ayas;
@end

@interface HBQuranSoundEntityUserInfo: NSObject 
+ (NSString *)additionalHeaderFileName;
@end

NS_ASSUME_NONNULL_END
