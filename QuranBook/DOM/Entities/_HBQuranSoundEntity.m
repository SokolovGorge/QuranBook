// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranSoundEntity.m instead.

#import "_HBQuranSoundEntity.h"

@implementation HBQuranSoundEntityID
@end

@implementation _HBQuranSoundEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBQuranSoundEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBQuranSoundEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBQuranSoundEntity" inManagedObjectContext:moc_];
}

- (HBQuranSoundEntityID*)objectID {
	return (HBQuranSoundEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"soundStateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"soundState"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic soundState;

- (HBLoadState)soundStateValue {
	NSNumber *result = [self soundState];
	return [result shortValue];
}

- (void)setSoundStateValue:(HBLoadState)value_ {
	[self setSoundState:@(value_)];
}

- (HBLoadState)primitiveSoundStateValue {
	NSNumber *result = [self primitiveSoundState];
	return [result shortValue];
}

- (void)setPrimitiveSoundStateValue:(HBLoadState)value_ {
	[self setPrimitiveSoundState:@(value_)];
}

@dynamic ayas;

- (NSMutableSet<HBAyaSoundEntity*>*)ayasSet {
	[self willAccessValueForKey:@"ayas"];

	NSMutableSet<HBAyaSoundEntity*> *result = (NSMutableSet<HBAyaSoundEntity*>*)[self mutableSetValueForKey:@"ayas"];

	[self didAccessValueForKey:@"ayas"];
	return result;
}

@end

@implementation HBQuranSoundEntityAttributes 
+ (NSString *)soundState {
	return @"soundState";
}
@end

@implementation HBQuranSoundEntityRelationships 
+ (NSString *)ayas {
	return @"ayas";
}
@end

@implementation HBQuranSoundEntityUserInfo 
+ (NSString *)additionalHeaderFileName {
	return @"HBLoadState.h";
}
@end

