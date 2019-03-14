//
//  HBQuranPlayerController.h
//  Habar
//
//  Created by Соколов Георгий on 11.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBParentControllerDelegate.h"

@class HBQuranBaseController;

@interface HBQuranPlayerController : UIViewController<HBParentControllerDelegate>

@property (weak, nonatomic) HBQuranBaseController *parentController;

+ (instancetype)instanceFromStoryboard;

@end
