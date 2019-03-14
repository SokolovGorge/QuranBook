//
//  HBQuranPlayerController.m
//  Habar
//
//  Created by Соколов Георгий on 11.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranPlayerController.h"
#import "HBConstants.h"
#import "HBTimeUtils.h"
#import "HBProfileManager.h"
#import "HBQuranSoundRepeat.h"
#import "HBQuranSoundService.h"
#import "HBQuranBaseController.h"
#import "HBQuranAyasController.h"
#import "HBQuranSoundSettingsController.h"

#define kKeyAudioVolume @"outputVolume"
#define kButtonsSize   38.f
#define kRepeatSize    43.f

@interface HBQuranPlayerController () <HBQuranPresenterDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderTime;
@property (weak, nonatomic) IBOutlet UISlider *sliderVolume;
@property (weak, nonatomic) IBOutlet UIButton *executeButton;
@property (weak, nonatomic) IBOutlet UIButton *speedButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *scrollButton;
@property (weak, nonatomic) IBOutlet UIButton *authorButton;
@property (weak, nonatomic) IBOutlet UIView *repeatView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repeatHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repeatWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repeatHorizontalConstraint;

@property (assign, nonatomic) BOOL blockVolume;
@property (assign, nonatomic) BOOL blockTime;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *timeSliderTimer;
@property (strong, nonatomic) NSTimer *volumeSliderTimer;

@property (strong, nonatomic) id<HBQuranSoundService> quranSoundService;

@end

@implementation HBQuranPlayerController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    HBQuranPlayerController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranPlayerController class])];
    return vc;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.definesPresentationContext = YES;
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.quranSoundService registerPresenterDelegate:self];
    [self setUp];
 }

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc
{
    [self.quranSoundService unregisterPresenterDelegate:self];
    [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:kKeyAudioVolume];
}

- (void)setUp
{
    self.blockTime = NO;
    self.blockVolume = NO;
    [self.sliderTime setThumbImage:[UIImage imageNamed:@"quranThumbTime"] forState:UIControlStateNormal];
    [self.sliderTime setMinimumTrackImage:[UIImage imageNamed:@"quranLeftSide"] forState:UIControlStateNormal];
    [self.sliderTime setMaximumTrackImage:[UIImage imageNamed:@"quranRightSide"] forState:UIControlStateNormal];
    self.sliderTime.minimumValue = 0.f;
    self.sliderTime.value = 0.f;
    self.sliderTime.maximumValue = 100.f;
    [self.sliderVolume setThumbImage:[UIImage imageNamed:@"quranThumbVoice"] forState:UIControlStateNormal];
    [self.sliderVolume setMinimumTrackImage:[UIImage imageNamed:@"quranLeftSide"] forState:UIControlStateNormal];
    [self.sliderVolume setMaximumTrackImage:[UIImage imageNamed:@"quranRightSide"] forState:UIControlStateNormal];
    self.sliderVolume.minimumValue = 0.f;
    self.sliderVolume.maximumValue = 1.f;
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:kKeyAudioVolume options:NSKeyValueObservingOptionNew context:nil];
    self.sliderVolume.value = [AVAudioSession sharedInstance].outputVolume;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTaped:)];
    [self.backView addGestureRecognizer:tapGesture];
    self.bottomConstraint.constant = - self.heightConstraint.constant;
    self.authorLabel.text = [self.quranSoundService currentAuthor];
    [self updateTitle];
    [self updatePlayButtons];
    [self updateCurrentTime:nil];
    [self loadSettings];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateCurrentTime:) userInfo:nil repeats:YES];
}

- (void)loadSettings
{
    [self updateButtonBySpeed:self.quranSoundService.speed];
    [self updateButtonByRepeat:[HBProfileManager sharedInstance].quranSoundRepeat];
    [self updateButtonByAutoScroll:[HBProfileManager sharedInstance].quranSoundAutoscroll];
}

- (void) customDismissViewController
{
    self.backView.hidden = YES;
    self.bottomConstraint.constant = - self.heightConstraint.constant;
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

- (void)updateTitle
{
    self.soundLabel.text = [self.quranSoundService currentAyaTitle];
 }

- (void)updateCurrentTime:(NSTimer *)timer
{
    if (self.blockTime) {
        return;
    }
    //если проигрывается 0 аят (вступление), то стоим на месте
    NSTimeInterval curTime = self.quranSoundService.ayaIndex == 0 ? 0.f : self.quranSoundService.beforeTime + self.quranSoundService.player.currentTime;
    self.timeLabel.text = timeInSecondsToString(curTime);
    self.restLabel.text = timeInSecondsToString(self.quranSoundService.totalTime - curTime);
    float persent = self.quranSoundService.percentPlay;
    self.sliderTime.value = persent;
}

- (void)updatePlayButtons
{
    NSString *nameImage = @"quranStop";
    if ([self isAyaRegim]) {
        nameImage = @"quranPause";
    }
    if (self.quranSoundService.state == HBQuranSoundStatePause) {
        nameImage = @"quranPlay";
    }
    [self.executeButton setImage:[UIImage imageNamed:nameImage] forState:UIControlStateNormal];
}

- (void)updateButtonBySpeed:(HBQuranSoundSpeed)speed
{
    NSString *imageName = nil;
    switch (speed) {
        case HBQuranSoundSpeedOne:
            imageName = @"quranSpeedButton1";
            break;
        case HBQuranSoundSpeedOneHalf:
            imageName = @"quranSpeedButton15";
            break;
        case HBQuranSoundSpeedTwo:
            imageName = @"quranSpeedButton2";
            break;
    }
    [self.speedButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)updateButtonByRepeat:(HBQuranSoundRepeat)soundRepeat
{
    self.repeatWidthConstraint.constant = soundRepeat == HBQuranSoundRepeatNever ? kButtonsSize : kRepeatSize;
    self.repeatHeightConstraint.constant = soundRepeat == HBQuranSoundRepeatNever ? kButtonsSize : kRepeatSize;
    self.repeatHorizontalConstraint.constant = soundRepeat == HBQuranSoundRepeatNever ? 0.f : (kRepeatSize - kButtonsSize) / 2.f;
    [self.repeatView layoutIfNeeded];
    NSString *imageName = nil;
    switch (soundRepeat) {
        case HBQuranSoundRepeatNever:
            imageName = @"quranRepeatButton0";
            break;
        case HBQuranSoundRepeatOne:
            imageName = @"quranRepeatButton1";
            break;
        case HBQuranSoundRepeatTwo:
            imageName = @"quranRepeatButton2";
            break;
        case HBQuranSoundRepeatThree:
            imageName = @"quranRepeatButton3";
            break;
        case HBQuranSoundRepeatEndlessly:
            imageName = @"quranRepeatButton8";
            break;
    }
    [self.repeatButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)updateButtonByAutoScroll:(BOOL)autoScroll
{
    [self.scrollButton setImage:[UIImage imageNamed:autoScroll ? @"quranScrollButtonOn" : @"quranScrollButtonOff"] forState:UIControlStateNormal];
}

- (void)backTaped:(UITapGestureRecognizer *)recognizer
{
    [self customDismissViewController];
}

- (BOOL)isAyaRegim
{
    return [self.parentController isKindOfClass:[HBQuranAyasController class]];
}

- (void)volumeSliderChanged:(NSTimer *)timer
{
    [self.volumeSliderTimer invalidate];
    self.volumeSliderTimer = nil;
    self.blockVolume = NO;
    [self updatePlayButtons];
}

- (void)timeSliderChanged:(NSTimer *)timer
{
    [self.timeSliderTimer invalidate];
    self.timeSliderTimer = nil;
    [self.quranSoundService startPlayByTimePercent:self.sliderTime.value];
}

#pragma mark - HBQuranPresenterDelegate


- (void)onStartPlaySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    //при старте проигрывания снимаем блокировку изменения слайдера времени, если была выставлена
    self.blockTime = NO;
    [self updateTitle];
}

- (void)onChangeSura:(NSInteger)suraIndex
{
}

- (void)onStopPlay
{
    [self customDismissViewController];
}

#pragma mark - HBParentControllerDelegate

- (void)onCommitActionFromChild:(UIViewController *)childController userInfo:(NSDictionary *)userInfo
{
    [self loadSettings];
}

- (void)onCancelActionFromChild:(UIViewController *)childController
{
    
}

#pragma mark - Key Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kKeyAudioVolume]) {
        NSNumber *value = change[@"new"];
        if (!self.blockVolume && value) {
            self.sliderVolume.value = value.floatValue;
        }
    }
}

#pragma mark - Action

- (IBAction)executeAction:(id)sender
{
    // если на аятах, то приостанавливаем проигрывание, иначе останавливаем проигрывание
    if (self.quranSoundService.state == HBQuranSoundStatePlay) {
        if ([self isAyaRegim]) {
            [self.quranSoundService pausePlay];
        } else {
            [self.quranSoundService stopPlay];
            [self.parentController closeSmallPlayerView];
            [self customDismissViewController];
        }
    } else {
        [self.quranSoundService resumePlay];
    }
    [self updatePlayButtons];
}

- (IBAction)forwardAction:(id)sender
{
    [self.quranSoundService startPlayNextVerse];
    [self updatePlayButtons];
}

- (IBAction)backwardAction:(id)sender
{
    [self.quranSoundService startPlayPriorVerse];
    [self updatePlayButtons];
}

- (IBAction)speedAction:(id)sender
{
    [self updateButtonBySpeed:[self.quranSoundService setNextSpeed]];
}

- (IBAction)repeatAction:(id)sender
{
    HBQuranSoundRepeat soundRepeat = [HBProfileManager sharedInstance].quranSoundRepeat;
    switch (soundRepeat) {
        case HBQuranSoundRepeatNever:
            soundRepeat = HBQuranSoundRepeatOne;
            break;
        case HBQuranSoundRepeatOne:
            soundRepeat = HBQuranSoundRepeatTwo;
            break;
        case HBQuranSoundRepeatTwo:
            soundRepeat = HBQuranSoundRepeatThree;
            break;
        case HBQuranSoundRepeatThree:
            soundRepeat = HBQuranSoundRepeatEndlessly;
            break;
        case HBQuranSoundRepeatEndlessly:
            soundRepeat = HBQuranSoundRepeatNever;
            break;
    }
    [HBProfileManager sharedInstance].quranSoundRepeat = soundRepeat;
    [self updateButtonByRepeat:soundRepeat];
}

- (IBAction)scrollAction:(id)sender
{
    BOOL newAutoScroll = ![HBProfileManager sharedInstance].quranSoundAutoscroll;
    [HBProfileManager sharedInstance].quranSoundAutoscroll = newAutoScroll;
    [self updateButtonByAutoScroll:newAutoScroll];
}

- (IBAction)authorAction:(id)sender
{
    HBQuranSoundSettingsController *vc = [HBQuranSoundSettingsController instanceFromStoryboardForModalState:YES];
    
//    vc.parentController = self; заменить
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)slideTime:(id)sender
{
    self.blockTime = YES;
    if (self.timeSliderTimer) {
        [self.timeSliderTimer invalidate];
    }
    self.timeSliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeSliderChanged:) userInfo:nil repeats:NO];
}

- (IBAction)slideVolume:(id)sender
{
    self.blockVolume = YES;
    if (self.volumeSliderTimer) {
        [self.volumeSliderTimer invalidate];
    }
    [self.quranSoundService setSoundVolume:self.sliderVolume.value];
    self.volumeSliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(volumeSliderChanged:) userInfo:nil repeats:NO];
}

@end
