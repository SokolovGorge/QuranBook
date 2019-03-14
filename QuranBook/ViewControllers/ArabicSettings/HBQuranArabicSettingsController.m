//
//  HBQuranArabicSettingsController.m
//  Habar
//
//  Created by Соколов Георгий on 25.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranArabicSettingsController.h"
#import "UIView+UITableViewCell.h"
#import "HBConstants.h"
#import "HBQuranArabicItemCell.h"
#import "HBArabicSettingsPresenter.h"

@interface HBQuranArabicSettingsController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) id<HBArabicSettingsPresenter> presenter;

@end

@implementation HBQuranArabicSettingsController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranArabicSettingsController class])];
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
    self.navigationItem.title = NSLocalizedString(@"QuranArabicControllerTitle", nil);
}


#pragma mark - HBArabicSettingsView

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presenter.countItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBQuranArabicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranArabicItemCell identifierCell]];
    [self.presenter configureCell:cell atIndexPath:indexPath];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HBQuranArabicItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.presenter didSelectCell:cell atIndexPath:indexPath];
     }
}


@end
