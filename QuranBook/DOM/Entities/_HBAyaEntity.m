// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBAyaEntity.m instead.

#import "_HBAyaEntity.h"

@implementation HBAyaEntityID
@end

@implementation _HBAyaEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBAyaEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBAyaEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBAyaEntity" inManagedObjectContext:moc_];
}

- (HBAyaEntityID*)objectID {
	return (HBAyaEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
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

@dynamic text;

@dynamic highlights;

- (NSMutableSet<HBAyaHighlightEntity*>*)highlightsSet {
	[self willAccessValueForKey:@"highlights"];

	NSMutableSet<HBAyaHighlightEntity*> *result = (NSMutableSet<HBAyaHighlightEntity*>*)[self mutableSetValueForKey:@"highlights"];

	[self didAccessValueForKey:@"highlights"];
	return result;
}

@dynamic sura;

@end

@implementation HBAyaEntityAttributes 
+ (NSString *)index {
	return @"index";
}
+ (NSString *)text {
	return @"text";
}
@end

@implementation HBAyaEntityRelationships 
+ (NSString *)highlights {
	return @"highlights";
}
+ (NSString *)sura {
	return @"sura";
}
@end

