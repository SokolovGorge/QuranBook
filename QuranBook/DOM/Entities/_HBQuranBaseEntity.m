// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HBQuranBaseEntity.m instead.

#import "_HBQuranBaseEntity.h"

@implementation HBQuranBaseEntityID
@end

@implementation _HBQuranBaseEntity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HBQuranBaseEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HBQuranBaseEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HBQuranBaseEntity" inManagedObjectContext:moc_];
}

- (HBQuranBaseEntityID*)objectID {
	return (HBQuranBaseEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"defValueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"defValue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"itemIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itemId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"itemTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itemType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"loadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"size"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic defValue;

- (BOOL)defValueValue {
	NSNumber *result = [self defValue];
	return [result boolValue];
}

- (void)setDefValueValue:(BOOL)value_ {
	[self setDefValue:@(value_)];
}

- (BOOL)primitiveDefValueValue {
	NSNumber *result = [self primitiveDefValue];
	return [result boolValue];
}

- (void)setPrimitiveDefValueValue:(BOOL)value_ {
	[self setPrimitiveDefValue:@(value_)];
}

@dynamic itemId;

- (int16_t)itemIdValue {
	NSNumber *result = [self itemId];
	return [result shortValue];
}

- (void)setItemIdValue:(int16_t)value_ {
	[self setItemId:@(value_)];
}

- (int16_t)primitiveItemIdValue {
	NSNumber *result = [self primitiveItemId];
	return [result shortValue];
}

- (void)setPrimitiveItemIdValue:(int16_t)value_ {
	[self setPrimitiveItemId:@(value_)];
}

@dynamic itemType;

- (HBQuranItemType)itemTypeValue {
	NSNumber *result = [self itemType];
	return [result shortValue];
}

- (void)setItemTypeValue:(HBQuranItemType)value_ {
	[self setItemType:@(value_)];
}

- (HBQuranItemType)primitiveItemTypeValue {
	NSNumber *result = [self primitiveItemType];
	return [result shortValue];
}

- (void)setPrimitiveItemTypeValue:(HBQuranItemType)value_ {
	[self setPrimitiveItemType:@(value_)];
}

@dynamic loaded;

- (BOOL)loadedValue {
	NSNumber *result = [self loaded];
	return [result boolValue];
}

- (void)setLoadedValue:(BOOL)value_ {
	[self setLoaded:@(value_)];
}

- (BOOL)primitiveLoadedValue {
	NSNumber *result = [self primitiveLoaded];
	return [result boolValue];
}

- (void)setPrimitiveLoadedValue:(BOOL)value_ {
	[self setPrimitiveLoaded:@(value_)];
}

@dynamic name;

@dynamic size;

- (int64_t)sizeValue {
	NSNumber *result = [self size];
	return [result longLongValue];
}

- (void)setSizeValue:(int64_t)value_ {
	[self setSize:@(value_)];
}

- (int64_t)primitiveSizeValue {
	NSNumber *result = [self primitiveSize];
	return [result longLongValue];
}

- (void)setPrimitiveSizeValue:(int64_t)value_ {
	[self setPrimitiveSize:@(value_)];
}

@dynamic subname;

@dynamic url_data;

@dynamic url_image;

@end

@implementation HBQuranBaseEntityAttributes 
+ (NSString *)defValue {
	return @"defValue";
}
+ (NSString *)itemId {
	return @"itemId";
}
+ (NSString *)itemType {
	return @"itemType";
}
+ (NSString *)loaded {
	return @"loaded";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)size {
	return @"size";
}
+ (NSString *)subname {
	return @"subname";
}
+ (NSString *)url_data {
	return @"url_data";
}
+ (NSString *)url_image {
	return @"url_image";
}
@end

@implementation HBQuranBaseEntityUserInfo 
+ (NSString *)additionalHeaderFileName {
	return @"HBQuranItemType.h";
}
@end

