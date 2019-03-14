// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaHighlightEntity.m instead.

#import "_HBAyaHighlightEntity.h"

@implementation HBAyaHighlightEntityID
@end

@implementation _HBAyaHighlightEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBAyaHighlightEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBAyaHighlightEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBAyaHighlightEntity" inManagedObjectContext:moc_];
}

- (HBAyaHighlightEntityID*)objectID {
	return (HBAyaHighlightEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"lengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"length"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"locationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"location"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic length;

- (int32_t)lengthValue {
	NSNumber *result = [self length];
	return [result intValue];
}

- (void)setLengthValue:(int32_t)value_ {
	[self setLength:@(value_)];
}

- (int32_t)primitiveLengthValue {
	NSNumber *result = [self primitiveLength];
	return [result intValue];
}

- (void)setPrimitiveLengthValue:(int32_t)value_ {
	[self setPrimitiveLength:@(value_)];
}

@dynamic location;

- (int32_t)locationValue {
	NSNumber *result = [self location];
	return [result intValue];
}

- (void)setLocationValue:(int32_t)value_ {
	[self setLocation:@(value_)];
}

- (int32_t)primitiveLocationValue {
	NSNumber *result = [self primitiveLocation];
	return [result intValue];
}

- (void)setPrimitiveLocationValue:(int32_t)value_ {
	[self setPrimitiveLocation:@(value_)];
}

@dynamic aya;

@end

@implementation HBAyaHighlightEntityAttributes 
+ (NSString *)length {
	return @"length";
}
+ (NSString *)location {
	return @"location";
}
@end

@implementation HBAyaHighlightEntityRelationships 
+ (NSString *)aya {
	return @"aya";
}
@end

