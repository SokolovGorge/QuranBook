//
//  HBQuranSoundProvider.h
//  Habar
//
//  Created by Соколов Георгий on 30.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol HBQuranService;
@class HBQuranManager;
@class HBQuranSoundEntity;

@interface HBQuranSoundProvider : NSObject

@property (assign, nonatomic, readonly) NSInteger suraIndex;
@property (assign, nonatomic, readonly) NSInteger ayaIndex;
@property (assign, nonatomic, readonly) NSInteger totalTime;
@property (strong, nonatomic, readonly) NSError *error;

- (instancetype)initWithQuranService:(id<HBQuranService>)quranService quranEntity:(HBQuranSoundEntity *)quranEntity suraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex onError:(NSError **)error;

- (void)provideNextVerseOnComplite:(void(^)(AVAudioPlayer *player, NSInteger beforeTime))block;

- (NSInteger)ayaIndexByDuration:(float)duration;

@end
