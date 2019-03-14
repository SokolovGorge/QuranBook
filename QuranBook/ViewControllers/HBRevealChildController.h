//
//  HBRevealChildController.h
//  Habar
//
//  Created by Соколов Георгий on 13.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranBaseController.h"

@class SWRevealViewController;

@interface HBRevealChildController : HBQuranBaseController

@property (weak, nonatomic) SWRevealViewController *revealController;

@end
