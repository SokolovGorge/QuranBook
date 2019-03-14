// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaExtraEntity.m instead.

#import "_HBAyaExtraEntity.h"

@implementation HBAyaExtraEntityID
@end

@implementation _HBAyaExtraEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBAyaExtraEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBAyaExtraEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBAyaExtraEntity" inManagedObjectContext:moc_];
}

- (HBAyaExtraEntityID*)objectID {
	return (HBAyaExtraEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ayaIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"ayaIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"flagFavoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"flagFavorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"flagViewValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"flagView"];
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

@dynamic flagFavorite;

- (BOOL)flagFavoriteValue {
	NSNumber *result = [self flagFavorite];
	return [result boolValue];
}

- (void)setFlagFavoriteValue:(BOOL)value_ {
	[self setFlagFavorite:@(value_)];
}

- (BOOL)primitiveFlagFavoriteValue {
	NSNumber *result = [self primitiveFlagFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFlagFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFlagFavorite:@(value_)];
}

@dynamic flagView;

- (BOOL)flagViewValue {
	NSNumber *result = [self flagView];
	return [result boolValue];
}

- (void)setFlagViewValue:(BOOL)value_ {
	[self setFlagView:@(value_)];
}

- (BOOL)primitiveFlagViewValue {
	NSNumber *result = [self primitiveFlagView];
	return [result boolValue];
}

- (void)setPrimitiveFlagViewValue:(BOOL)value_ {
	[self setPrimitiveFlagView:@(value_)];
}

@dynamic noticeText;

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

@end

@implementation HBAyaExtraEntityAttributes 
+ (NSString *)ayaIndex {
	return @"ayaIndex";
}
+ (NSString *)flagFavorite {
	return @"flagFavorite";
}
+ (NSString *)flagView {
	return @"flagView";
}
+ (NSString *)noticeText {
	return @"noticeText";
}
+ (NSString *)suraIndex {
	return @"suraIndex";
}
@end

