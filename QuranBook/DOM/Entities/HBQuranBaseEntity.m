#import "HBQuranBaseEntity.h"

@interface HBQuranBaseEntity ()

// Private interface goes here.

@end

#define kLocalizedMarker @"%"

@implementation HBQuranBaseEntity

- (NSString *)localizedName
{
    if ([self.name hasPrefix:kLocalizedMarker] && [self.name hasSuffix:kLocalizedMarker]) {
        NSArray<NSString *> *array = [self.name componentsSeparatedByString:kLocalizedMarker];
        return NSLocalizedString(array[1], nil);
    }
    return self.name;
}

- (NSString *)localizedSubname
{
    if ([self.subname hasPrefix:kLocalizedMarker] && [self.subname hasSuffix:kLocalizedMarker]) {
        NSArray<NSString *> *array = [self.subname componentsSeparatedByString:kLocalizedMarker];
        return NSLocalizedString(array[1], nil);
    }
    return self.subname;
}

@end
