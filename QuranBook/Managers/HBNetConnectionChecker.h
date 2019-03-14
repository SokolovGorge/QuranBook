//
//  HBNetConnectionChecker.h
//  Habar
//
//  Created by Соколов Георгий on 30.03.2018.
//  Copyright © 2018 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBNetConnectionChecker : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)sharedInstance;

- (BOOL)checkConnection;

@end
