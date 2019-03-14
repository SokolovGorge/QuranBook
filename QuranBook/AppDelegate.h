//
//  AppDelegate.h
//  QuranBook
//
//  Created by Соколов Георгий on 25.09.2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (UIViewController *)topViewController;

@end

