//
//  HBQuranSoundService.h
//  QuranBook
//
//  Created by Соколов Георгий on 25/11/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, HBQuranSoundState) {
    HBQuranSoundStateInactive,
    HBQuranSoundStatePlay,
    HBQuranSoundStatePause
};

typedef NS_ENUM(NSInteger, HBQuranSoundSpeed) {
    HBQuranSoundSpeedOne,
    HBQuranSoundSpeedOneHalf,
    HBQuranSoundSpeedTwo
};

@protocol HBQuranPresenterDelegate

@required

- (void)onStartPlaySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex;
- (void)onChangeSura:(NSInteger)suraIndex;
- (void)onStopPlay;

@end


@protocol HBQuranSoundService <NSObject>

@property (assign, nonatomic, readonly) HBQuranSoundState state;
@property (assign, nonatomic, readonly) HBQuranSoundSpeed speed;
@property (strong, nonatomic, readonly) AVAudioPlayer *player;
@property (assign, nonatomic, readonly) NSInteger suraIndex;
@property (assign, nonatomic, readonly) NSInteger ayaIndex;
@property (assign, nonatomic, readonly) NSInteger totalTime;
@property (assign, nonatomic, readonly) NSInteger beforeTime;
@property (assign, nonatomic, readonly) float percentPlay;

- (void)startPlayWithSuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex;

- (void)startPlayNextVerse;

- (void)startPlayPriorVerse;

- (void)startPlayByTimePercent:(float)timePercent;

- (void)pausePlay;

- (void)resumePlay;

- (void)stopPlay;

- (void)registerPresenterDelegate:(id<HBQuranPresenterDelegate>)presenterDelegate;

- (void)unregisterPresenterDelegate:(id<HBQuranPresenterDelegate>)presenterDelegate;

- (NSString *)currentAyaTitle;

- (NSString *)currentAuthor;

- (HBQuranSoundSpeed)setNextSpeed;

- (void)setSoundVolume:(float)volume;


@end
