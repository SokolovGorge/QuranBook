//
//  HBQuranProxyController.m
//  Habar
//
//  Created by Соколов Георгий on 14.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranProxyController.h"
#import "HBQuranGateway.h"
#import "SWRevealViewController.h"
#import "HBQuranSurasController.h"
#import "HBQuranRearController.h"

@interface HBQuranProxyController()

@end

@implementation HBQuranProxyController

+ (UIViewController *)instanceMainQuranControllerWithGateway:(HBQuranGateway *)gateway
{
    [gateway checkCacheSura];

    HBQuranSurasController *frontViewController = [HBQuranSurasController instanceFromStoryboard];
    HBQuranRearController *rearViewController = [HBQuranRearController instanceFromStoryboard];
    rearViewController.surasController = frontViewController;

//    frontViewController.gateway = gateway;
//    rearViewController.gateway = gateway;
    gateway.extraDelegate = rearViewController;

    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:nil frontViewController:frontNavigationController];
    revealViewController.rightViewController = rearViewController;
    revealViewController.delegate = frontViewController;
    revealViewController.rightViewRevealWidth = 270;
    
    return revealViewController;
}


@end
