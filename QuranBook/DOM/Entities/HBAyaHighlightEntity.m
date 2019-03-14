#import "HBAyaHighlightEntity.h"

@interface HBAyaHighlightEntity ()

// Private interface goes here.

@end

@implementation HBAyaHighlightEntity

- (NSRange)toRange
{
    NSRange range;
    range.location = self.locationValue;
    range.length = self.lengthValue;
    return range;
}


@end
