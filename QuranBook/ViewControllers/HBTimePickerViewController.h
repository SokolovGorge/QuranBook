//
//  HBTimePickerViewController.h
//  Habar
//
//  Created by Соколов Георгий on 25.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBParentControllerDelegate;

@interface HBTimePickerViewController : UIViewController

@property (weak, nonatomic) id<HBParentControllerDelegate> parentController;

@property (strong, nonatomic) NSDate *currentDate;

+ (instancetype)instanceFromStoryboard;


@end
