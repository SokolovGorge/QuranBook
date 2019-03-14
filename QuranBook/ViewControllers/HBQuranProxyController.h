//
//  HBQuranProxyController.h
//  Habar
//
//  Created by Соколов Георгий on 14.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBQuranGateway;

@interface HBQuranProxyController : NSObject

+ (UIViewController *)instanceMainQuranControllerWithGateway:(HBQuranGateway *)gateway;

@end
