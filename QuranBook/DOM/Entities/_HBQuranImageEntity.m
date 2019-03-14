// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranImageEntity.m instead.

#import "_HBQuranImageEntity.h"

@implementation HBQuranImageEntityID
@end

@implementation _HBQuranImageEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBQuranImageEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBQuranImageEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBQuranImageEntity" inManagedObjectContext:moc_];
}

- (HBQuranImageEntityID*)objectID {
	return (HBQuranImageEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@end

