//
//  HBQuranSearchController.h
//  Habar
//
//  Created by Соколов Георгий on 02.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBParentControllerDelegate;

@class HBSuraModel;

@interface HBQuranSearchController : UIViewController

@property (weak, nonatomic) id<HBParentControllerDelegate> parentController;

@property (strong, nonatomic) NSArray<HBSuraModel *> *filteredArray;

+ (instancetype)instanceFromStoryboard;

@end
