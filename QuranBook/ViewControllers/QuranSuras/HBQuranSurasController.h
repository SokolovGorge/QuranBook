//
//  HBQuranSurasController.h
//  Habar
//
//  Created by Соколов Георгий on 25.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "HBQuranBaseController.h"
#import "HBQuranGateway.h"

@class HBSuraModel;

@interface HBQuranSurasController : HBQuranBaseController <HBQuranAyaDelegate, SWRevealViewControllerDelegate>

//@property (strong, nonatomic) HBQuranGateway *gateway;
@property (weak, nonatomic) UINavigationController *rootNavigationController;

+ (instancetype)instanceFromStoryboard;

//- (void)loadData;

- (void)showAyaByModel:(HBSuraModel *)suraModel;

- (void)closeSliderMenu;

@end
