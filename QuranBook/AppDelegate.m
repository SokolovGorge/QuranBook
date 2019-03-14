//
//  AppDelegate.m
//  QuranBook
//
//  Created by Соколов Георгий on 25.09.2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "AppDelegate.h"
#import "UIAlertController+Habar.h"
#import "HBSystem.h"
#import "HBUIStyleManager.h"
#import "HBCoreDataManager.h"
#import "HBQuranGateway.h"
#import "HBQuranProxyController.h"

@interface AppDelegate ()

@property (strong, nonatomic) HBSystem * systemInstance;
@property (strong, nonatomic) HBQuranGateway *gateway;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.systemInstance initResources];
    
    if ([HBCoreDataManager sharedInstance].migrationFailed) {
        [self showReinstallAlert];
        return YES;
    }
    [self initUI];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


#pragma mark - Custom methods

- (void)initUI
{
    [HBUIStyleManager applyStyles];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *vc = [HBQuranProxyController instanceMainQuranControllerWithGateway:self.gateway];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

- (void)showReinstallAlert
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController* vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    [UIAlertController showCriticalAlertWithTitle:NSLocalizedString(@"CaptionError", nil) message:NSLocalizedString(@"ReinstallRequest", nil)];
}

- (UIViewController *)topViewController
{
    UIViewController *vc = [[UIApplication sharedApplication] windows].firstObject.rootViewController;
    
    if ([vc isKindOfClass:[UITabBarController class]]){
        vc = ((UITabBarController *)vc).selectedViewController;
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]){
        vc = ((UINavigationController *)vc).topViewController;
    }
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

@end
