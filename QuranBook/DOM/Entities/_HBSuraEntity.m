// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBSuraEntity.m instead.

#import "_HBSuraEntity.h"

@implementation HBSuraEntityID
@end

@implementation _HBSuraEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBSuraEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBSuraEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBSuraEntity" inManagedObjectContext:moc_];
}

- (HBSuraEntityID*)objectID {
	return (HBSuraEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"countAyasValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"countAyas"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic countAyas;

- (int32_t)countAyasValue {
	NSNumber *result = [self countAyas];
	return [result intValue];
}

- (void)setCountAyasValue:(int32_t)value_ {
	[self setCountAyas:@(value_)];
}

- (int32_t)primitiveCountAyasValue {
	NSNumber *result = [self primitiveCountAyas];
	return [result intValue];
}

- (void)setPrimitiveCountAyasValue:(int32_t)value_ {
	[self setPrimitiveCountAyas:@(value_)];
}

@dynamic index;

- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:@(value_)];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:@(value_)];
}

@dynamic name;

@dynamic ayas;

- (NSMutableSet<HBAyaEntity*>*)ayasSet {
	[self willAccessValueForKey:@"ayas"];

	NSMutableSet<HBAyaEntity*> *result = (NSMutableSet<HBAyaEntity*>*)[self mutableSetValueForKey:@"ayas"];

	[self didAccessValueForKey:@"ayas"];
	return result;
}

@dynamic quran;

@end

@implementation HBSuraEntityAttributes 
+ (NSString *)countAyas {
	return @"countAyas";
}
+ (NSString *)index {
	return @"index";
}
+ (NSString *)name {
	return @"name";
}
@end

@implementation HBSuraEntityRelationships 
+ (NSString *)ayas {
	return @"ayas";
}
+ (NSString *)quran {
	return @"quran";
}
@end

