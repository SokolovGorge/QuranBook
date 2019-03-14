//
//  HBQuranSoundManager.m
//  Habar
//
//  Created by Соколов Георгий on 30.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranSoundManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIAlertController+Habar.h"
#import "HBProfileManager.h"
#import "HBQuranSoundProvider.h"
#import "HBQuranService.h"
#import "HBQuranGateway.h"
#import "HBQuranSoundEntity.h"
#import "HBSuraModel.h"

@interface HBQuranSoundManager()<AVAudioPlayerDelegate>


@property (strong, nonatomic) HBQuranSoundEntity *quranEntity;
@property (strong, nonatomic) HBQuranSoundProvider *soundProvider;
@property (strong, nonatomic) NSHashTable<id<HBQuranPresenterDelegate>> *presenterTable;
@property (strong, nonatomic) UISlider *volumeSlider;
@property (strong, nonatomic) MPVolumeView *volumeView;
@property (assign, nonatomic) NSInteger countRepeat;

@property (strong, nonatomic) id<HBQuranService> quranService;
@property (strong, nonatomic) HBQuranGateway *gateway;


@end

@implementation HBQuranSoundManager

@synthesize state = _state;
@synthesize speed = _speed;
@synthesize player = _player;
@synthesize suraIndex =_suraIndex;
@synthesize ayaIndex = _ayaIndex;
@synthesize totalTime = _totalTime;
@synthesize beforeTime = _beforeTime;
@synthesize percentPlay = _percentPlay;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _state = HBQuranSoundStateInactive;
        _speed = HBQuranSoundSpeedOne;
        self.presenterTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)registerPresenterDelegate:(id<HBQuranPresenterDelegate>)presenterDelegate
{
    __weak id<HBQuranPresenterDelegate> weekPresenter = presenterDelegate;
    if (![self.presenterTable containsObject:weekPresenter]) {
        [self.presenterTable addObject:weekPresenter];
    }
}

- (void)unregisterPresenterDelegate:(id<HBQuranPresenterDelegate>)presenterDelegate
{
    [self.presenterTable removeObject:presenterDelegate];
}


- (void)startPlayWithSuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    [self stopPlayWithFireDelegate:NO];
     NSError *error = nil;
    self.quranEntity = (HBQuranSoundEntity *)[self.quranService quranEntityById:[HBProfileManager sharedInstance].quranSound];
    self.soundProvider = [[HBQuranSoundProvider alloc] initWithQuranService:self.quranService quranEntity:self.quranEntity suraIndex:suraIndex ayaIndex:ayaIndex onError:&error];
    if (error) {
        [UIAlertController showAlertIn:nil
                             withTitle:NSLocalizedString(@"CaptionError", nil)
                               message:error.localizedDescription
                      firstButtonTitle:NSLocalizedString(@"ButtonOk", nil)
                      otherButtonTitle:nil
                              tapBlock:nil];
        return;
    }
    if ([HBProfileManager sharedInstance].quranSoundNotDouse) {
        //отключаем блокировку экрана
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    _state = HBQuranSoundStatePlay;
    _suraIndex = suraIndex;
    [self playNextVerse];
}

- (void)startPlayNextVerse
{
    [self startPlayByDiff:1];
}

- (void)startPlayPriorVerse
{
    [self startPlayByDiff:-1];
}

- (void)startPlayByTimePercent:(float)timePercent
{
    float duration = self.soundProvider.totalTime * timePercent / 100.f;
    NSInteger newAyaIndex = [self.soundProvider ayaIndexByDuration:duration];
    [self startPlayWithSuraIndex:self.suraIndex ayaIndex:newAyaIndex];
}

- (void)startPlayByDiff:(NSInteger)diff
{
    if (self.suraIndex == 0) {
        return;
    }
    [self.gateway checkCacheSura];
    BOOL flagChangeSura = NO;
    NSInteger newSuraIndex = self.suraIndex;
    NSInteger newAyaIndex = self.ayaIndex + diff;
    //проверка на предыдущую суру
    if (newAyaIndex <= 0) {
        if (newSuraIndex == 1) {
            return;
        }
        newSuraIndex -= 1;
        HBSuraModel *suraModel = [self.gateway suraModelBySuraNumber:newSuraIndex];
        newAyaIndex = suraModel.countAyas;
        flagChangeSura = YES;
    } else {
        //проверка на следующую
        HBSuraModel *suraModel = [self.gateway suraModelBySuraNumber:newSuraIndex];
        if (newAyaIndex > suraModel.countAyas) {
            if (newSuraIndex >= [self.quranService surasCount]) {
                return;
            }
            newSuraIndex += 1;
            newAyaIndex = 1;
            flagChangeSura = YES;
        }
    }
    _suraIndex = newSuraIndex;
    _ayaIndex = newAyaIndex;
    if (flagChangeSura) {
        for (id<HBQuranPresenterDelegate> presenter in self.presenterTable) {
            [presenter onChangeSura:newSuraIndex];
        }
    }
    [self startPlayWithSuraIndex:newSuraIndex ayaIndex:newAyaIndex];
}

- (void)playNextVerse
{
    [self.soundProvider provideNextVerseOnComplite:^(AVAudioPlayer *player, NSInteger beforeTime) {
        if (player) {
            BOOL flagChangeSura = self.soundProvider.suraIndex != self.suraIndex;
            self->_suraIndex = self.soundProvider.suraIndex;
            self->_ayaIndex = self.soundProvider.ayaIndex;
            self->_totalTime = self.soundProvider.totalTime;
            self->_beforeTime = beforeTime;
            self->_player = player;
            self->_player.delegate = self;
            self->_player.enableRate = YES;
            self->_player.rate = [self rateFromSpeed:self.speed];
            self.countRepeat = 0;
            if (flagChangeSura) {
                for (id<HBQuranPresenterDelegate> presenter in self.presenterTable) {
                    [presenter onChangeSura:self.suraIndex];
                }
            }
            [self.player play];
            for (id<HBQuranPresenterDelegate> presenter in self.presenterTable) {
                [presenter onStartPlaySuraIndex:self.suraIndex ayaIndex:self.ayaIndex];
            }
        } else {
            if (self.soundProvider.error) {
                NSError *error = self.soundProvider.error;
                //ставим задержку, чтоб уничтожился HBQuranWaitController
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIAlertController showAlertIn:nil
                                         withTitle:NSLocalizedString(@"CaptionError", nil)
                                           message:error.localizedDescription
                                  firstButtonTitle:NSLocalizedString(@"ButtonOk", nil)
                                  otherButtonTitle:nil
                                          tapBlock:nil];
                });

            }
            [self stopPlayWithFireDelegate:YES];
        }
    }];
}

- (void)pausePlay
{
    _state = HBQuranSoundStatePause;
    [_player pause];
}

- (void)resumePlay
{
    if (self.state == HBQuranSoundStatePause) {
        _state = HBQuranSoundStatePlay;
        [_player play];
    }
}

- (void)stopPlay
{
    [self stopPlayWithFireDelegate:YES];
}

- (void)stopPlayWithFireDelegate:(BOOL)fireDelegate
{
    _state = HBQuranSoundStateInactive;
    [_player stop];
    self.soundProvider = nil;
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if (fireDelegate) {
        for (id<HBQuranPresenterDelegate> presenter in self.presenterTable) {
            [presenter onStopPlay];
        }
    }
}



- (NSInteger)countRepeatFromSettings
{
    switch ([HBProfileManager sharedInstance].quranSoundRepeat) {
        case HBQuranSoundRepeatNever:
            return 0;
        case HBQuranSoundRepeatOne:
            return 1;
        case HBQuranSoundRepeatTwo:
            return 2;
        case HBQuranSoundRepeatThree:
            return 3;
        case HBQuranSoundRepeatEndlessly:
            return -1;
    }
}

- (NSString *)currentAyaTitle
{
    if (self.state == HBQuranSoundStateInactive) {
        return @"";
    }
    [self.gateway checkCacheSura];
    HBSuraModel *suraModel = [self.gateway suraModelBySuraNumber:self.suraIndex];
    if (self.ayaIndex == 0) {
        return [NSString stringWithFormat:@"%ld %@", (long)self.suraIndex, suraModel.translitName];
    }
    return [NSString stringWithFormat:@"%ld %@ %ld", (long)self.suraIndex, suraModel.translitName, (long)self.ayaIndex];
}

- (NSString *)currentAuthor
{
    return  self.quranEntity != nil ? self.quranEntity.localizedName : @"";
}

- (HBQuranSoundSpeed)setNextSpeed
{
    switch (self.speed) {
        case HBQuranSoundSpeedOne:
            _speed = HBQuranSoundSpeedOneHalf;
            break;
        case HBQuranSoundSpeedOneHalf:
            _speed = HBQuranSoundSpeedTwo;
            break;
        case HBQuranSoundSpeedTwo:
            _speed = HBQuranSoundSpeedOne;
            break;
    }
    if (_player) {
        _player.rate = [self rateFromSpeed:self.speed];
    }
    return self.speed;
}

- (float)percentPlay
{
    if (_ayaIndex == 0 || self.totalTime == 0) {
        return 0.f;
    }
    return ((double)self.beforeTime + self.player.currentTime)/(double)self.totalTime * 100.f;
}

- (float)rateFromSpeed:(HBQuranSoundSpeed)speed
{
    switch (speed) {
        case HBQuranSoundSpeedOne:
            return 1.f;
        case HBQuranSoundSpeedOneHalf:
            return 1.5;
        case HBQuranSoundSpeedTwo:
            return 2.f;
    }
}

- (void)setSoundVolume:(float)volume
{
    self.volumeSlider.value = volume;
}

- (UISlider *)volumeSlider
{
    if (!_volumeSlider) {
        self.volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in self.volumeView.subviews) {
            if ([view isKindOfClass:[UISlider class]]) {
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeSlider;
}


#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_state == HBQuranSoundStatePlay) {
        NSInteger maxRepeat = [self countRepeatFromSettings];
        if ((maxRepeat < 0 || _countRepeat < maxRepeat) && self.ayaIndex != 0) {
            _countRepeat++;
            [_player play];
        } else {
            [self playNextVerse];
        }
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self stopPlay];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    
}

@end
