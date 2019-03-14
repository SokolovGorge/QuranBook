//
//  HBQuranSurasController.m
//  Habar
//
//  Created by Соколов Георгий on 25.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranSurasController.h"
#import "UIColor+Habar.h"
#import "UIView+Statusbar.h"
#import "HBConstants.h"
#import "HBSuraCellState.h"
#import "HBProfileManager.h"
#import "HBQuranSuraCell.h"
#import "HBQuranSearchSuraCell.h"
#import "HBQuranSurasPresenter.h"

#define kRowHeightNormal   60.f
#define kRowHeightSearch   44.f
#define kStatusHeight      20.f

@interface HBQuranSurasController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, HBQuranPresenterDelegate, HBQuranSurasView>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) id<HBQuranSurasPresenter> presenter;

@end

@implementation HBQuranSurasController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranSurasController class])];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self setupLocalization];
    [self.presenter checkData];
    [self.presenter loadData];
}

- (void)setUp
{
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor colorWithHex:kHabarColor];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"quranMenu"]
                                                                              style:UIBarButtonItemStylePlain target:revealController action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:kQuranRefreshNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)setupLocalization
{
    self.revealViewController.navigationItem.title = NSLocalizedString(@"QuranTitle", nil);
    self.navigationItem.title = NSLocalizedString(@"QuranTitle", nil);
    self.searchBar.placeholder = NSLocalizedString(@"SearchTitle", nil);
}

- (void)showAyaByModel:(HBSuraModel *)suraModel
{
    [self.presenter showAyaByModel:suraModel];
}

#pragma mark - HBQuranSurasView

- (void)updateByState:(HBControllerState)controllerState
{
    [UIView setStatusBarBackgroundColor:controllerState == HBControllerStateSearch ? [UIColor colorWithHex:kHabarColor] : [UIColor clearColor]];
    
    SWRevealViewController *revealController = [self revealViewController];
    revealController.blockPanGestures = controllerState == HBControllerStateSearch;
    
    self.searchBar.showsCancelButton = controllerState == HBControllerStateSearch;
    [self.revealViewController.navigationController setNavigationBarHidden:controllerState == HBControllerStateSearch animated:YES];
    
    if (controllerState == HBControllerStateSearch) {
        self.tableView.rowHeight = kRowHeightSearch;
        self.tableView.hidden = self.presenter.countOfRows == 0;
    } else {
        self.tableView.rowHeight = kRowHeightNormal;
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setHiddenTableView:(BOOL)hidden
{
    self.tableView.hidden = hidden;
}

- (void)closeSliderMenu
{
    SWRevealViewController *revealController = [self revealViewController];
    if (revealController.frontViewPosition == FrontViewPositionLeftSide) {
        [revealController performSelector:@selector(rightRevealToggle:) withObject:nil];
    }
}

- (void)updateCellState:(HBSuraCellState)state atIndexPath:(NSIndexPath *)indexPath
{
    HBQuranSuraCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        cell.state = state;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presenter.countOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.presenter.controllerState) {
        case HBControllerStateNormal: {
            HBQuranSuraCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSuraCell identifierCell]forIndexPath:indexPath];
            [self.presenter configureCell:cell atIndexPath:indexPath];
            return cell;
        }
        case HBControllerStateSearch: {
            HBQuranSearchSuraCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSearchSuraCell identifierCell] forIndexPath:indexPath];
            [self.presenter configureSearchCell:cell atIndexPath:indexPath];
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.presenter presentAyaByIndexPath:indexPath];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = nil;
    [self.presenter clearFiltered];
    [self.searchBar resignFirstResponder];
    self.presenter.controllerState = HBControllerStateNormal;
 }

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.presenter filterAyaBySearchText:searchText];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.presenter.controllerState = HBControllerStateSearch;
    SWRevealViewController *revealController = [self revealViewController];
    if (revealController.frontViewPosition == FrontViewPositionLeftSide) {
        SWRevealViewController *revealController = [self revealViewController];
        [revealController performSelector:@selector(rightRevealToggle:) withObject:nil];
    }
}

#pragma mark - Notifications

- (void)refreshData:(NSNotification *) notification
{
    [self.presenter refreshData];
}

- (void)keyboardWillShow:(NSNotification *) notification
{
    UIViewAnimationCurve animationCurve = [[notification.userInfo valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[notification.userInfo valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardBounds = [(NSValue *)[notification.userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.bottomConstraint.constant = - CGRectGetHeight(keyboardBounds);
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    UIViewAnimationCurve animationCurve = [[notification.userInfo valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[notification.userInfo valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.bottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

#pragma  mark - HBQuranPresenterDelegate

- (void)onStartPlaySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    [super onStartPlaySuraIndex:suraIndex ayaIndex:ayaIndex];
    
    NSIndexPath *oldIndexPath = self.presenter.soundIndexPath;
    [self.presenter updateSoundIndexBySuraIndex:suraIndex];
    if ([self.presenter.soundIndexPath isEqual:oldIndexPath]) {
        return;
    }
    NSMutableArray<NSIndexPath *> *array = [NSMutableArray arrayWithCapacity:2];
    if (oldIndexPath) {
        [array addObject:oldIndexPath];
    }
    if (self.presenter.soundIndexPath) {
        [array addObject:self.presenter.soundIndexPath];
    }
    if (array.count > 0) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    if (self.presenter.soundIndexPath && [HBProfileManager sharedInstance].quranSoundAutoscroll) {
        [self.tableView scrollToRowAtIndexPath:self.presenter.soundIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)onChangeSura:(NSInteger)suraIndex
{
    [super onChangeSura:suraIndex];
}

- (void)onStopPlay
{
    [super onStopPlay];
    
    if (self.presenter.soundIndexPath) {
        NSIndexPath *indexPath = self.presenter.soundIndexPath;
        self.presenter.soundIndexPath = nil;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

#pragma mark - SWRevealViewControllerDelegate

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
}

#pragma mark - Actions

- (IBAction)backAction:(id)sender {
    if (self.rootNavigationController) {
        self.rootNavigationController.navigationBarHidden = NO;
        [self.rootNavigationController popViewControllerAnimated:YES];
    }
}

@end
