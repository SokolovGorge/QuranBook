// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranItemEntity.m instead.

#import "_HBQuranItemEntity.h"

@implementation HBQuranItemEntityID
@end

@implementation _HBQuranItemEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBQuranItemEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBQuranItemEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBQuranItemEntity" inManagedObjectContext:moc_];
}

- (HBQuranItemEntityID*)objectID {
	return (HBQuranItemEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic suras;

- (NSMutableSet<HBSuraEntity*>*)surasSet {
	[self willAccessValueForKey:@"suras"];

	NSMutableSet<HBSuraEntity*> *result = (NSMutableSet<HBSuraEntity*>*)[self mutableSetValueForKey:@"suras"];

	[self didAccessValueForKey:@"suras"];
	return result;
}

@end

@implementation HBQuranItemEntityRelationships 
+ (NSString *)suras {
	return @"suras";
}
@end

