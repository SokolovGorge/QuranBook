//
//  HBQuranSoundSettingsController.m
//  Habar
//
//  Created by Соколов Георгий on 28.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranSoundSettingsController.h"
#import "UIView+UITableViewCell.h"
#import "HBConstants.h"
#import "HBQuranSoundItemCell.h"
#import "HBQuranSoundSwitchCell.h"
#import "HBQuranSoundOptCell.h"
#import "HBSoundSettingsPresenter.h"

#define kRowHeight    44.f
#define kLoadHeight   56.f

@interface HBQuranSoundSettingsController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL modalState;

@property (strong, nonatomic) id<HBSoundSettingsPresenter> presenter;

@end

@implementation HBQuranSoundSettingsController

+ (instancetype)instanceFromStoryboardForModalState:(BOOL)modalState
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    HBQuranSoundSettingsController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranSoundSettingsController class])];
    vc.modalState = modalState;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocalization];
    [self setUp];
    [self.presenter loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.presenter onClose];
}

- (void)setUp
{
    [self.presenter setup];
    self.topConstraint.constant = self.modalState ? 0.f : - self.heightConstraint.constant;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"ButtonClose", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    }
}

- (void)setupLocalization
{
    self.navigationItem.title = NSLocalizedString(@"QuranSettingsRecitationTitle", nil);
    self.titleLabel.text = NSLocalizedString(@"QuranSettingsRecitationTitle", nil);
    [self.closeButton setTitle:NSLocalizedString(@"ButtonClose", nil) forState:UIControlStateNormal];
}

#pragma mark - HBSoundSettingsView

- (id<HBQuranSoundItemCellView>)cellViewAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)refreshRowAtIndexPaths:(NSArray<NSIndexPath *> *)indexPathArray
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (NSIndexPath *)indexPathByView:(UIView *)view
{
    UITableViewCell *cell = [view superViewCell];
    if (cell) {
        return [self.tableView indexPathForCell:cell];
    }
    return nil;
}

- (void)scrollAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.presenter countItemsBySection:section];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.presenter titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HBQuranSoundItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSoundItemCell identifierCell] forIndexPath:indexPath];
        [self.presenter configureSoundCellView:cell atIndexPath:indexPath];
        return cell;
    } else {
        if (indexPath.row <= 1) {
            HBQuranSoundSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSoundSwitchCell identifierCell] forIndexPath:indexPath];
            [self.presenter configureOptCellView1:cell atIndexPath:indexPath];
            return cell;
        } else {
            HBQuranSoundOptCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSoundOptCell identifierCell] forIndexPath:indexPath];
            [self.presenter configureOptCellView2:cell atIndexPath:indexPath];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        HBQuranSoundItemCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [self.presenter changeSelectedItemAtCellView:cell atIndexPath:indexPath];
        }
        
    } else if (indexPath.section == 1 && indexPath.row >= 2) {
            
        switch (indexPath.row) {
            case 2:
                [self.presenter changeEndSuraAtIndexPath:indexPath];
                break;
            case 3:
                [self.presenter changeRepeatVerseAtIndexPath:indexPath];
                break;
            default:
                break;
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kRowHeight;
    if (indexPath.section == 0 && [self.presenter expandedAtIndexPath:indexPath]) {
        height += kLoadHeight;
    }
    return height;
}

#pragma mark - Actions


- (IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
