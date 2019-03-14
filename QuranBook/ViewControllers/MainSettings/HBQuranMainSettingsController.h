//
//  HBQuranMainSettingsController.h
//  Habar
//
//  Created by Соколов Георгий on 18.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBaseTableViewController.h"
#import "HBMainSettingsPresenter.h"

@interface HBQuranMainSettingsController : HBBaseTableViewController<HBMainSettingsView>

+ (instancetype)instanceFromStoryboard;


@end
