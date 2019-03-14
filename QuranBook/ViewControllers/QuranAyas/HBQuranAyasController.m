//
//  HBQuranAyasController.m
//  Habar
//
//  Created by Соколов Георгий on 26.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranAyasController.h"
#import "UIView+StatusBar.h"
#import "UIView+UITableViewCell.h"
#import "UIResponder+FirstResponder.h"
#import "UIMenuItem+CXAImageSupport.h"
#import "UIColor+Habar.h"
#import "HBControllerState.h"
#import "HBParentControllerDelegate.h"
#import "HBConstants.h"
#import "HBProfileManager.h"
#import "HBQuranService.h"
#import "HBSuraModel.h"
#import "HBAyaModel.h"
#import "QuranTopScrollView.h"
#import "SWRevealViewController.h"
#import "HBQuranSearchController.h"
#import "HBQuranNoticeController.h"
#import "QuranMenuView.h"
#import "HBQuranSearchSuraCell.h"
#import "HBQuranAyaCell.h"

#import "HBQuranAyasPresenter.h"


#define kTopHeightView          20.f
#define kTopScrollHeightView    60.f
#define kBottomScrollHeightView 54.f

#define kSearchBarHeight        56.f

@interface HBQuranAyasController () <UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching, UISearchBarDelegate, HBParentControllerDelegate, HBQuranAyasView>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topArabicLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomSubtitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;

@property (strong, nonatomic) QuranTopScrollView *topScrollView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) QuranMenuView *menuView;

@property (assign, nonatomic) CGFloat currentOffset;

@property (assign, nonatomic) BOOL flagReloadBySound;



@property (strong, nonatomic) id<HBQuranAyasPresenter> presenter;



@end

@implementation HBQuranAyasController

@synthesize resultController = _resultController;

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranAyasController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocalized];
    [self setUp];
 }

- (void)dealloc
{
    [self.presenter checkStopPlay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.presenter whenDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray<NSIndexPath *> *indexPaths = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *lastIndexPath = [indexPaths firstObject];
    //сохранаяем последний аят
    if (lastIndexPath) {
        [self.presenter saveLastAyaAtIndexPath:lastIndexPath];
    }
}

- (void)setupLocalized
{
    self.bottomTitleLabel.text = NSLocalizedString(@"QuranNextSuraTitle", nil);
    self.bottomSubtitleLabel.text = NSLocalizedString(@"QuranNextSuraSubTitle", nil);
}

- (void)setUp
{
    self.resultController = [HBQuranSearchController instanceFromStoryboard];
    self.resultController.parentController = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultController];
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.placeholder = NSLocalizedString(@"SearchTitle", nil);
    self.searchController.searchBar.tintColor = [UIColor colorWithHex:kHabarColor];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;

    self.flagReloadBySound = NO;
    
    self.menuView = [QuranMenuView instanceFromNibByOwner:self];
    self.menuView.tag = kMenuViewTag;

    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"quranMenu"]
                                                                              style:UIBarButtonItemStylePlain target:self.revealController action:@selector(rightRevealToggle:)];
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;

    UIMenuItem *markMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"HighlightingMenuItem", nil) action:@selector(markColor:) image:[UIImage imageNamed:@"markColor"]];
    UIMenuItem *unmarkMenuItem = [[UIMenuItem alloc] initWithTitle:@"" action:@selector(unmarkColor:) image:[UIImage imageNamed:@"rubber_white"]];
    [[UIMenuController sharedMenuController] setMenuItems:@[markMenuItem, unmarkMenuItem]];
    
    [self.presenter initView];
    
}

- (void)initBySuraModel:(HBSuraModel *)suraModel
{
    self.presenter.suraModel = suraModel;
}

- (void)initByListAyas:(NSMutableArray<HBAyaModel *> *)listAyas
{
    self.presenter.listAyas = listAyas;
}

- (void)setNeedLoadSuraModel:(HBSuraModel *)suraModel
{
    [self.presenter setNeedLoadSuraModel:suraModel];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(markColor:)) {
        id obj = [UIResponder currentFirstResponder];
        return [obj isKindOfClass:[UITextView class]];
        
    } else if (action == @selector(unmarkColor:)) {
        id obj = [UIResponder currentFirstResponder];
        if([obj isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *) obj;
            UITableViewCell *cell = [textView superViewCell];
            if (cell) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                if (indexPath) {
                    NSRange range = textView.selectedRange;
                    if (range.length > 0) {
                        HBAyaModel *ayaModel = [self.presenter ayaModelAtIndexPath:indexPath];
                        HBQuranItemType quranType = [self quranTypeByTextView:textView];
                        return [ayaModel isTouchRange:range byType:quranType];
                    }
                }
            }
        }
        return NO;
    }

    return [super canPerformAction:action withSender:sender];
}

- (QuranMenuView *)menuViewByCell:(HBQuranAyaCell *)cell {
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == kMenuViewTag) {
            return (QuranMenuView *)view;
        }
    }
    return nil;
}

- (void)setTopViewHide:(BOOL)hide
{
    CGFloat height = 0.f;
    if (!hide) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            height = window.safeAreaInsets.top;
        }
        if (height == 0.f) {
            height = 20.f;
        }
        height += kTopHeightView;
    }
    self.topView.hidden = hide;
    self.topHeightConstraint.constant = height;
}

- (void)deactivateSearchBar
{
     self.searchController.searchBar.text = nil;
    self.resultController.filteredArray = nil;
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    [self.searchController.searchBar resignFirstResponder];
    self.searchController.searchBar.showsCancelButton = NO;

}

- (void)showMenuAtIndexPath:(NSIndexPath *)indexPath
{
    HBQuranAyaCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.menuView prepareForSize:cell.contentView.bounds.size];
        [cell.contentView addSubview:self.menuView];
        [self.menuView openMenuWithAnimate:YES];
        [self.presenter updateMenuIndexPath:indexPath];
    }
}


- (void)callMenuAtIndexPath:(NSIndexPath *)indexPath
{
    //проверяем на наличие меню
    HBQuranAyaCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([self menuViewByCell:cell]) {
        [self closeMenu];
        return;
    }
    if (self.menuView.superview) {
        QuranMenuView *menu = self.menuView;
        [menu closeMenuOnCompletion:^{
            [menu removeFromSuperview];
        }];
        self.menuView = [menu cloneView];
        [self showMenuAtIndexPath:indexPath];
    } else {
        [self showMenuAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.currentOffset = scrollView.contentOffset.y;
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    bool hide = (scrollView.contentOffset.y > self.currentOffset);
    if (self.navigationController.navigationBarHidden != hide) {
        [self.navigationController setNavigationBarHidden:hide animated:NO];
        [self setTopViewHide:!hide];
    }
    [self.presenter scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.presenter scrollViewDidScroll:scrollView];
}

- (void)reloadDataBySuraModel:(HBSuraModel *)suraModel
{
    [self.presenter reloadDataBySuraModel:suraModel];
}

#pragma mark - HBQuranAyasView

- (void)startWaitAnimation
{
    [self.activityView startAnimating];
}

- (void)stopWaitAnimation
{
    [self.activityView stopAnimating];
}

- (void)reloadTable
{
    [self.tableView reloadData];
    //****************  затычка исправляющая баг обновления первой ячейки таблицы  *********************************
    if ([self.presenter countOfAyas] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    //*************************************************************************************************************
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)updateTitleBySuraModel:(HBSuraModel *)suraModel
{
    self.navigationItem.title = suraModel.translitName;
    self.topNameLabel.text = [NSString stringWithFormat:@"%ld. %@ (%@)", (long)suraModel.index, suraModel.translitName, suraModel.translationName];
    self.topArabicLabel.text = suraModel.arabicName;
    [self setTopViewHide:!self.navigationController.navigationBarHidden];
}

- (void)checkScrollViewsBySuraModel:(HBSuraModel *)suraModel
{
    if (suraModel.index > 1) {
        if (!self.topScrollView) {
            self.topScrollView = [QuranTopScrollView instanceFromNibByOwner:self];
            [self.tableView addSubview:self.topScrollView];
            self.topScrollView.frame = CGRectMake(0.f, -kTopScrollHeightView , CGRectGetWidth([UIScreen mainScreen].bounds), kTopScrollHeightView);
        }
    } else if (self.topScrollView) {
        [self.topScrollView removeFromSuperview];
        self.topScrollView = nil;
    }
    if (suraModel.index < [self.presenter surasCount]) {
        self.bottomView.hidden = NO;
        self.bottomView.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bottomView.bounds), kBottomScrollHeightView);
    } else {
        self.bottomView.hidden = YES;
        self.bottomView.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bottomView.bounds), 0.f);
    }
}

- (void)moveToAyaBySoundIndexPath:(NSIndexPath *)soundIndexPath
{
    if (soundIndexPath) {
        [self.tableView scrollToRowAtIndexPath:soundIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } else if (self.presenter.suraModel.lastAya > 0 && !self.flagReloadBySound) {
        NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:self.presenter.suraModel.lastAya - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)addViewMenuAction:(id)target action:(SEL)viewAction
{
    [self.menuView.viewButton addTarget:target action:viewAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)addFavoriteMenuAction:(id)target action:(SEL)favoriteAction
{
    [self.menuView.favoriteButton addTarget:target action:favoriteAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)addNoticeMenuAction:(id)target action:(SEL)noticeAction
{
    [self.menuView.noticeButton addTarget:target action:noticeAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)addPlayMenuAction:(id)target action:(SEL)playAction
{
    [self.menuView.playButton addTarget:target action:playAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)addCloseMenuAction:(id)target action:(SEL)closeAction
{
    [self.menuView.closeButton addTarget:target action:closeAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeMenu
{
    [self.menuView closeMenuOnCompletion:^{
        [self.menuView removeFromSuperview];
    }];
}

- (void)displayTopText:(NSString *)text
{
    self.topScrollView.subtitleLabel.text = text;
}

- (void)displayBottomText:(NSString *)text
{
    self.bottomSubtitleLabel.text = text;
}

- (void)deselectText
{
    id obj = [UIResponder currentFirstResponder];
    if ([obj isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *) obj;
        if (textView.selectedRange.length > 0) {
            textView.selectedTextRange = nil;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cnt = [self.presenter countOfAyas];
    self.bottomView.hidden = cnt == 0;
    return cnt;
 }

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.presenter prepareAyaAtIndexPaths:indexPaths];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBQuranAyaCell *cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranAyaCell identifierCell]forIndexPath:indexPath];
    
    if (!cell.hasArabicGesture) {
        [cell addArabicGesture:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textCellTap:)]];
    }
    if (!cell.hasTranslitGesture) {
        [cell addTranslitGesture:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textCellTap:)]];
    }
    if (!cell.hasTranslationGesture) {
        [cell addTranslationGesture:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textCellTap:)]];
    }

    cell.parentMenuView = self.menuView;
    [self.presenter configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self deselectText];
    [self callMenuAtIndexPath:indexPath];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self deactivateSearchBar];
    self.revealController.blockPanGestures = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   [self.presenter filterAyaBySearchText:searchText];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
     searchBar.showsCancelButton = YES;
    
    if (self.revealController.frontViewPosition == FrontViewPositionLeftSide) {
        [self.revealController performSelector:@selector(rightRevealToggle:) withObject:nil];
    }
    self.revealController.blockPanGestures = YES;
    [self presentViewController:self.searchController animated:YES completion:nil];
}

#pragma mark - HBQuranAyaDelegate

- (void)onChangeAyaByModel:(HBSuraModel*)suraModel
{
    [self.presenter reloadSuraModel:suraModel];
}

#pragma mark - HBParentControllerDelegate

- (void)onCommitActionFromChild:(UIViewController *)childController userInfo:(NSDictionary *)userInfo
{
    if ([childController isKindOfClass:[HBQuranSearchController class]]) {
        [self deactivateSearchBar];
        HBSuraModel *model = userInfo[@"item"];
        [self.presenter reloadDataBySuraModel:model];
        self.revealController.blockPanGestures = NO;
    } else if ([childController isKindOfClass:[HBQuranNoticeController class]]) {
        HBQuranNoticeController *vc = (HBQuranNoticeController *)childController;
        [self.presenter editAyaModelByNoticeText:vc.noticeText];
    }
}

- (void)onCancelActionFromChild:(UIViewController *)childController
{
    
}

#pragma  mark - HBQuranPresenterDelegate

- (void)onStartPlaySuraIndex:(NSInteger)suraIndex ayaIndex:(NSInteger)ayaIndex
{
    [super onStartPlaySuraIndex:suraIndex ayaIndex:ayaIndex];
    
    [self.presenter startPlaySuraIndex:suraIndex ayaIndex:ayaIndex];
}

- (void)onChangeSura:(NSInteger)suraIndex
{
    [super onChangeSura:suraIndex];
    self.flagReloadBySound = YES;
    [self.presenter onChangeSura:suraIndex];
 }

- (void)onStopPlay
{
    [super onStopPlay];
    [self.presenter onStopPlay];
}



#pragma mark - Notifications

- (void)updateAya:(NSNotification *)notification
{
}

#pragma mark - Menu Actions

- (void)markColor:(UIMenuController *)sender
{
    id obj = [UIResponder currentFirstResponder];
    if ([obj isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *) obj;
        UITableViewCell *cell = [textView superViewCell];
        if (cell) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {
                NSRange range = textView.selectedRange;
                if (range.length > 0) {
                    HBQuranItemType quranType = [self quranTypeByTextView:textView];
                    [self.presenter saveHighlightRange:range atIndexPath:indexPath quranType:quranType];
                }
            }
        }
        [textView resignFirstResponder];
    }
}

- (void)unmarkColor:(UIMenuController *)sender
{
    id obj = [UIResponder currentFirstResponder];
    if ([obj isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *) obj;
        UITableViewCell *cell = [textView superViewCell];
        if (cell) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {
                NSRange range = textView.selectedRange;
                if (range.length > 0) {
                    HBQuranItemType quranType = [self quranTypeByTextView:textView];
                    [self.presenter deleteHighlightRange:range atIndexPath:indexPath quranType:quranType];
                }
            }
        }
        [textView resignFirstResponder];
    }

}

- (HBQuranItemType)quranTypeByTextView:(UITextView *)textView
{
    switch (textView.tag) {
        case 1:
            return HBQuranItemTypeArabic;
        case 2:
            return HBQuranItemTypeTranslit;
        case 3:
            return HBQuranItemTypeTranslation;
        default:
            return HBQuranItemTypeNone;
    }
}

#pragma mark - Gestures

- (void)textCellTap:(UITapGestureRecognizer *)tapGesture
{
    [self deselectText];
    UITableViewCell *cell = [tapGesture.view superViewCell];
    if (cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath) {
            [self callMenuAtIndexPath:indexPath];
        }
    }
}


@end
