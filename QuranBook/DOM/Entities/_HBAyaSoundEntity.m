// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaSoundEntity.m instead.

#import "_HBAyaSoundEntity.h"

@implementation HBAyaSoundEntityID
@end

@implementation _HBAyaSoundEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBAyaSoundEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBAyaSoundEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBAyaSoundEntity" inManagedObjectContext:moc_];
}

- (HBAyaSoundEntityID*)objectID {
	return (HBAyaSoundEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ayaIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ayaIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"suraIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"suraIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic ayaIndex;

- (int32_t)ayaIndexValue {
	NSNumber *result = [self ayaIndex];
	return [result intValue];
}

- (void)setAyaIndexValue:(int32_t)value_ {
	[self setAyaIndex:@(value_)];
}

- (int32_t)primitiveAyaIndexValue {
	NSNumber *result = [self primitiveAyaIndex];
	return [result intValue];
}

- (void)setPrimitiveAyaIndexValue:(int32_t)value_ {
	[self setPrimitiveAyaIndex:@(value_)];
}

@dynamic duration;

- (int64_t)durationValue {
	NSNumber *result = [self duration];
	return [result longLongValue];
}

- (void)setDurationValue:(int64_t)value_ {
	[self setDuration:@(value_)];
}

- (int64_t)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result longLongValue];
}

- (void)setPrimitiveDurationValue:(int64_t)value_ {
	[self setPrimitiveDuration:@(value_)];
}

@dynamic suraIndex;

- (int32_t)suraIndexValue {
	NSNumber *result = [self suraIndex];
	return [result intValue];
}

- (void)setSuraIndexValue:(int32_t)value_ {
	[self setSuraIndex:@(value_)];
}

- (int32_t)primitiveSuraIndexValue {
	NSNumber *result = [self primitiveSuraIndex];
	return [result intValue];
}

- (void)setPrimitiveSuraIndexValue:(int32_t)value_ {
	[self setPrimitiveSuraIndex:@(value_)];
}

@dynamic quran;

@end

@implementation HBAyaSoundEntityAttributes 
+ (NSString *)ayaIndex {
	return @"ayaIndex";
}
+ (NSString *)duration {
	return @"duration";
}
+ (NSString *)suraIndex {
	return @"suraIndex";
}
@end

@implementation HBAyaSoundEntityRelationships 
+ (NSString *)quran {
	return @"quran";
}
@end

