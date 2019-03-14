//
//  HBQuranSoundState.h
//  Habar
//
//  Created by Соколов Георгий on 22.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#ifndef HBLoadState_h
#define HBLoadState_h

typedef NS_ENUM(NSInteger, HBLoadState) {
    HBLoadStateNone = 0,
    HBLoadStateLoading,
    HBLoadStateUnpacking,
    HBLoadStatePause,
    HBLoadStateError,
    HBLoadStateComplete
};

#endif /* HBLoadState_h */
