//
//  HBHighlightModel.h
//  Habar
//
//  Created by Соколов Георгий on 17.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HBHighlightModel : NSObject

@property (strong, nonatomic) NSManagedObjectID *objectID;
@property (assign, nonatomic) NSRange range;

- (instancetype)initWithObjectID:(NSManagedObjectID *)objectID range:(NSRange)range;

@end
