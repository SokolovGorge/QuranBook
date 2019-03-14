//
//  HBQuranManager.h
//  Habar
//
//  Created by Соколов Георгий on 19.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranItemType.h"
#import "HBQuranRearType.h"
#import "HBQuranSoundEndAction.h"
#import "HBQuranSoundRepeat.h"
#import "HBQuranService.h"

@class HBQuranItemEntity;
@class HBQuranBaseEntity;
@class HBQuranImageEntity;
@class HBQuranSoundEntity;
@class HBAyaSoundModel;

@interface HBQuranManager : NSObject <HBQuranService>

/*
+ (instancetype)sharedInstance;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
*/

@end
