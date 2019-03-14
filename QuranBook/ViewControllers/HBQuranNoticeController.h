//
//  HBQuranNoiticeController.h
//  Habar
//
//  Created by Соколов Георгий on 08.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBParentControllerDelegate;

@interface HBQuranNoticeController : UIViewController

@property (weak, nonatomic) id<HBParentControllerDelegate> parentController;

@property (strong, nonatomic) NSString *noticeText;

+ (instancetype)instanceFromStoryboard;


@end
