//
//  HBQuranBaseController.h
//  Habar
//
//  Created by Соколов Георгий on 11.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranSoundService.h"
#import "HBBaseViewController.h"

@interface HBQuranBaseController: HBBaseViewController <HBQuranPresenterDelegate>

@property (strong, nonatomic) id<HBQuranSoundService> quranSoundService;

- (void)closeSmallPlayerView;

@end
