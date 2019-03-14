//
//  HBQuranMainSettingsController.m
//  Habar
//
//  Created by Соколов Георгий on 18.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranMainSettingsController.h"
#import "HBConstants.h"
#import "HBMainSettingsPresenter.h"

@interface HBQuranMainSettingsController ()

@property (weak, nonatomic) IBOutlet UILabel *arabicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *arabicSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tajwidTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *translateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *translateSubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recitationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recitationSubtitleLabel;

@property (strong, nonatomic) id<HBMainSettingsPresenter> presenter;

@end

@implementation HBQuranMainSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocalization];
    [self.presenter loadSettings];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.presenter checkAndLoadData];
}

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranMainSettingsController class])];
}


- (void)setupLocalization
{
    self.navigationItem.title = NSLocalizedString(@"SettingsTitle", nil);
    self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"ButtonClose", nil);
    self.arabicTitleLabel.text = NSLocalizedString(@"QuranSettingsArabicTitle", nil);
    self.tajwidTitleLabel.text = NSLocalizedString(@"QuranSettingsTajwidTitle", nil);
    self.translateTitleLabel.text = NSLocalizedString(@"QuranSettingsTranslateTitle", nil);
    self.recitationTitleLabel.text = NSLocalizedString(@"QuranSettingsRecitationTitle", nil);
 }

#pragma mark - HBMainSettingsView

- (void)setArabicSettings:(NSString *)arabicSettings
{
    self.arabicSubtitleLabel.text = arabicSettings;
}

- (void)setTranslateSettings:(NSString *)translateSettings
{
    self.translateSubtitleLabel.text = translateSettings;
}

- (void)setRecitationSettings:(NSString *)recitationSettings
{
    self.recitationSubtitleLabel.text = recitationSettings;
}


#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.presenter nameBySection:section];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.presenter presentDetailByIndexPath:indexPath];
}

#pragma mark - Actions

- (IBAction)closeAction:(id)sender
{
    [self.presenter closeSettings];
}

@end
