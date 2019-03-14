//
//  HBSystem.m
//  QuranBook
//
//  Created by Соколов Георгий on 06/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBSystem.h"
#import "HBMacros.h"
#import "HBProfileManager.h"
#import "HBCoreDataManager.h"
#import "HBQuranService.h"

@interface HBSystem ()

@property (strong, nonatomic) id<HBQuranService> quranService;

@end

@implementation HBSystem

- (void)initResources
{
    if ([[HBCoreDataManager sharedInstance] isMigrationNeeded]) {
        DLog(@"MIGRATION NEED!");
        NSError *error = nil;
#ifndef COREDATA_AUTOMIGRATION
        [[HBCoreDataManager sharedInstance] migrate:&error];
#endif
        if (error) {
            DLog(@"CoreData Migration Error: %@", error.localizedDescription);
        }
    }
    
    if ([HBCoreDataManager sharedInstance].migrationFailed) {
        return;
    }
    [[HBCoreDataManager sharedInstance] initializeStorage];
    
    [self.quranService checkQuranItems];
    
}

@end
