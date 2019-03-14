//
//  HBHighlightModel.m
//  Habar
//
//  Created by Соколов Георгий on 17.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "HBHighlightModel.h"

@implementation HBHighlightModel

- (instancetype)initWithObjectID:(NSManagedObjectID *)objectID range:(NSRange)range
{
    self = [super init];
    if (self) {
        self.objectID = objectID;
        self.range = range;
    }
    return self;
}

@end
