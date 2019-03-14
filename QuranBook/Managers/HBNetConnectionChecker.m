//
//  HBNetConnectionChecker.m
//  Habar
//
//  Created by Соколов Георгий on 30.03.2018.
//  Copyright © 2018 Bezlimit. All rights reserved.
//

#import "HBNetConnectionChecker.h"
#import <Reachability/Reachability.h>

@interface HBNetConnectionChecker()

@property (strong, nonatomic) Reachability *reachability;

@end

@implementation HBNetConnectionChecker

+ (instancetype)sharedInstance
{
    static HBNetConnectionChecker *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HBNetConnectionChecker alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

- (BOOL)checkConnection
{
    if ([self.reachability startNotifier]) {
        BOOL result = [self.reachability currentReachabilityStatus] != NotReachable;
        [self.reachability stopNotifier];
        return result;
    } else {
        return YES;
    }
}


@end
