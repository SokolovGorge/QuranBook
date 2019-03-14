//
//  HBQuranRearController.h
//  Habar
//
//  Created by Соколов Георгий on 13.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranGateway.h"

@class HBQuranSurasController;

@interface HBQuranRearController : UIViewController <HBQuranExtraDelegate>

@property (strong, nonatomic) HBQuranGateway *gateway;
@property (weak, nonatomic) HBQuranSurasController *surasController;

+ (instancetype)instanceFromStoryboard;

@end
