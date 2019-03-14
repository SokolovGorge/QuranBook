//
//  HBQuranSearchController.m
//  Habar
//
//  Created by Соколов Георгий on 02.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranSearchController.h"
#import "HBParentControllerDelegate.h"
//#import "HBSystemUtils.h"
#import "HBSuraModel.h"
#import "HBQuranSearchSuraCell.h"
#import "HBConstants.h"

@interface HBQuranSearchController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (assign, nonatomic) CGFloat keyBoardHeight;

@end

@implementation HBQuranSearchController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranSearchController class])];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //в первый раз обрезаем таблицу под клавиатуру - нотификация прилетает раньше появления контрола
    if (self.keyBoardHeight > 0) {
        self.bottomConstraint.constant = - self.keyBoardHeight;
    }
}

- (void)setUp
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (UIView *)topViewFromView:(UIView *)view
{
    if (view.superview) {
        return [self topViewFromView:view.superview];
    }
    return view;
}

- (HBSuraModel *)suraModelAtIndexPath:(NSIndexPath *)indexPath
{
    return self.filteredArray[indexPath.row];
}

- (void)setFilteredArray:(NSArray<HBSuraModel *> *)filteredArray
{
    _filteredArray = filteredArray;
    self.tableView.hidden = !(filteredArray.count > 0);
    [self.tableView reloadData];
}

- (void)configureCell:(HBQuranSearchSuraCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    HBSuraModel *model = [self suraModelAtIndexPath:indexPath];
    cell.titleLabel.text = model.translitName;
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@ %lu", NSLocalizedString(@"QuranAyaName", nil), (long)model.lastAya];
    cell.titleImage = model.titleImage;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBQuranSearchSuraCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSearchSuraCell identifierCell] forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.parentController) {
        [self.parentController onCommitActionFromChild:self
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[self suraModelAtIndexPath:indexPath], @"item", nil]];
    }
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *) notification
{
    UIViewAnimationCurve animationCurve = [[notification.userInfo valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[notification.userInfo valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardBounds = [(NSValue *)[notification.userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.keyBoardHeight = CGRectGetHeight(keyboardBounds);
    self.bottomConstraint.constant = - self.keyBoardHeight;
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

@end
