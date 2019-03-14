//
//  HBQuranSoundProvider.m
//  Habar
//
//  Created by Соколов Георгий on 30.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranSoundProvider.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIAlertController+Habar.h"
#import "HBProfileManager.h"
#import "HBMacros.h"
#import "AppDelegate.h"
#import "HBQuranService.h"
#import "HBQuranBaseEntity.h"
#import "HBQuranSoundEntity.h"
#import "HBAyaSoundEntity.h"
#import "HBAyaSoundModel.h"
#import "HBQuranWaitController.h"

@interface HBQuranSoundProvider()

@property (assign, nonatomic) NSInteger preparedSuraIndex;
@property (assign, nonatomic) NSInteger preparedAyaIndex;
@property (strong, nonatomic) HBQuranSoundEntity *quranEntity;
@property (strong, nonatomic) NSArray<HBAyaSoundModel *> *indexArray;
@property (strong, nonatomic) HBQuranWaitController *waitController;

@property (strong, nonatomic) AVAudioPlayer *player0;
@property (strong, nonatomic) AVAudioPlayer *player1;
@property (strong, nonatomic) AVAudioPlayer *player2;

@property (strong, nonatomic) id<HBQuranService> quranService;

@property (assign) BOOL isReady;

@end

@implementation HBQuranSoundProvider

- (instancetype)initWithQuranService:(id<HBQuranService>)quranService quranEntity:(HBQuranSoundEntity *)quranEntity suraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex onError:(NSError **)error
{
    self = [super init];
    if (self) {
        self.isReady = false;
         _suraIndex = suraIndex;
        _ayaIndex = ayaIndex;
        self.quranService = quranService;
        self.preparedSuraIndex = _suraIndex;
        self.preparedAyaIndex = _ayaIndex;
        if (![HBProfileManager sharedInstance].quranSound) {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:@"Quran recitation not defined" forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"HabarQuranError" code:1001 userInfo:details];
            return self;
        }
        NSError *localError = nil;
        [self.quranService checkLoadSoundIndexFromServerByItemId:[HBProfileManager sharedInstance].quranSound onError:&localError];
        if (localError) {
            *error = localError;
            return self;
        }
        self.quranEntity = quranEntity;
        self.indexArray = [self.quranService listSoundModelByQuranItem:self.quranEntity suraIndex:self.suraIndex onError:&localError];
        if (localError) {
            *error = localError;
            return self;
        }
        _totalTime = [self calcTotalTime];
        [self prepareSound];
    }
    return self;
}

- (void)provideNextVerseOnComplite:(void(^)(AVAudioPlayer *player, NSInteger beforeTime))block
{
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        while (!self.isReady) {
            [self showWaitController];
            [NSThread sleepForTimeInterval:0.5f];
        }
        if (self->_suraIndex != self.preparedSuraIndex) {
            self->_totalTime = [self calcTotalTime];
        }
        [self hideWaitControllerOnComplite:nil];
        self->_suraIndex = self.preparedSuraIndex;
        self->_ayaIndex = self.preparedAyaIndex;
        // достигли конца
        if (self.preparedAyaIndex < 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil, 0);
            });
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.error) {
                    [self hideWaitControllerOnComplite:^{
                        block(nil, 0);
                    }];
                } else {
                    NSInteger beforeTime = [self timeBeforeByAyaIndex:self.ayaIndex];
                    block([self playerByAyaIndex:self.ayaIndex], beforeTime);
                }
            });
            if (!self.error) {
                self.preparedAyaIndex = self.ayaIndex + 1;
                [self prepareSound];
            }
        }
    });
}

- (void)prepareSound
{
    self.isReady = NO;
    _error = nil;
    // проверка конца суры
    if (self.preparedAyaIndex > [self lastAyaIndex]) {
        
         if (self.suraIndex == [self.quranService surasCount]) {
            // достигли конца Корана
            self.preparedAyaIndex = -1;
            self.isReady = YES;
            return;
        } else {
            switch ([HBProfileManager sharedInstance].quranSoundEndAction) {
                case HBQuranSoundEndActionStop:
                    self.preparedAyaIndex = -1;
                    self.isReady = YES;
                    return;
                case HBQuranSoundEndActionRepeat:
                    self.preparedAyaIndex = 0;
                    break;
                case HBQuranSoundEndActionNext:
                    // переход на следующую суру
                    self.preparedSuraIndex = self.suraIndex + 1;
                    self.preparedAyaIndex = 0;
                    break;
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSError *localError = nil;
        if (self.preparedSuraIndex != self.suraIndex) {
            self.indexArray = [self.quranService listSoundModelByQuranItem:self.quranEntity suraIndex:self.preparedSuraIndex onError:&localError];
        }
        if (localError) {
            self->_error = localError;
            [self setPlayer:nil byAyaIndex:self.preparedAyaIndex];
        } else {
            NSData *data = [self.quranService loadAndCacheDataSoundByQuranItem:self.quranEntity suraIndex:self.suraIndex ayaIndex:self.preparedAyaIndex onError:&localError];
            if (localError) {
                self->_error = localError;
                [self setPlayer:nil byAyaIndex:self.preparedAyaIndex];
            } else {
                AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&localError];
                if (localError) {
                    self->_error = localError;
                    [self setPlayer:nil byAyaIndex:self.preparedAyaIndex];
                } else {
                    if (![player prepareToPlay]) {
                        [self setPlayer:nil byAyaIndex:self.preparedAyaIndex];
                        NSMutableDictionary* details = [NSMutableDictionary dictionary];
                        [details setValue:@"AVPlayer not prepared" forKey:NSLocalizedDescriptionKey];
                        self->_error = [NSError errorWithDomain:@"HabarQuranError" code:1002 userInfo:details];
                    } else {
                        [self setPlayer:player byAyaIndex:self.preparedAyaIndex];
                    }
                }
            }
        }
        self.isReady = YES;
    });
}

- (void)showWaitController
{
    if (!self.waitController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HBQuranWaitController *vc = [HBQuranWaitController instanceFromStoryboardWithMessage:NSLocalizedString(@"QuranAudioAyaLoad", nil)];
            [TOPVIEWCONTROLLER() presentViewController:vc animated:NO completion:nil];
            self.waitController = vc;
        });
    }
}

- (void)hideWaitControllerOnComplite:(void (^)(void))completion
{
    if (self.waitController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.waitController dismissViewControllerAnimated:NO completion:completion];
            self.waitController = nil;
        });
    } else {
        if (completion) {
            completion();
        }
    }
}

- (NSInteger)lastAyaIndex
{
    return [self.indexArray lastObject].ayaIndex;
}

- (NSInteger)calcTotalTime
{
    NSInteger value = 0;
    for (HBAyaSoundModel *model in self.indexArray) {
        value += model.duration;
    }
    return value;
}

- (NSInteger)timeBeforeByAyaIndex:(NSInteger)ayaIndex
{
    NSInteger result = 0;
    for (HBAyaSoundModel *model in self.indexArray) {
        if (model.ayaIndex < ayaIndex) {
            result += model.duration;
        }
    }
    return result;
}

- (NSInteger)ayaIndexByDuration:(float)duration
{
    if (!self.indexArray || self.indexArray.count == 0) {
        return 1;
    }
    NSInteger time = 0;
    for (HBAyaSoundModel *model in self.indexArray) {
        time += model.duration;
        if (time > duration) {
            return model.ayaIndex;
        }
    }
    return [self lastAyaIndex];
}

- (AVAudioPlayer *)playerByAyaIndex:(NSInteger)ayaIndex
{
    if (ayaIndex == 0) {
        return self.player0;
    }
    return (ayaIndex % 2 == 0) ? self.player1 : self.player2;
}

- (void)setPlayer:(AVAudioPlayer *)player byAyaIndex:(NSInteger)ayaIndex
{
    if (ayaIndex == 0) {
        self.player0 = player;
    } else if (ayaIndex % 2 == 0) {
        self.player1 = player;
    } else {
        self.player2 = player;
    }
}

@end
