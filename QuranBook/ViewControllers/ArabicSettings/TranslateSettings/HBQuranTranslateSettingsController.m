//
//  HBQuranTranslateSettingsController.m
//  Habar
//
//  Created by Соколов Георгий on 24.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranTranslateSettingsController.h"
#import "UIView+UITableViewCell.h"
#import "HBConstants.h"
#import "HBTranslateSettingsPresenter.h"
#import "HBQuranItemCell.h"

@interface HBQuranTranslateSettingsController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) id<HBTranslateSettingsPresenter> presenter;

@end

@implementation HBQuranTranslateSettingsController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranTranslateSettingsController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocalization];
    [self.presenter loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.presenter onClose];
}

- (void)setupLocalization
{
    self.navigationItem.title = NSLocalizedString(@"QuranTranslationControllerTitle", nil);
}

#pragma mark - HBQuranItemCellView

- (NSIndexPath *)indexPathByView:(UIView *)view
{
    UITableViewCell *cell = [view superViewCell];
    if (cell) {
        return [self.tableView indexPathForCell:cell];
    }
    return nil;
}


- (void)reloadRowAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.presenter numberOfSections];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.presenter countItemsBySection:section];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"QuranTranstilSectionTitle", nil);
        case 1:
            return NSLocalizedString(@"QuranTranslationSectionTitle", nil);
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBQuranItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[HBQuranItemCell identifierCell]];
    [self.presenter configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HBQuranItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.presenter didSelectCell:cell atIndexPath:indexPath];
    }
}

@end


