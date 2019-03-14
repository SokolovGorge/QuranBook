//
//  HBQuranRearController.m
//  Habar
//
//  Created by Соколов Георгий on 13.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranRearController.h"
#import "UIView+UITableViewCell.h"
#import "HBQuranRearType.h"
#import "HBRearCellState.h"
#import "HBConstants.h"
#import "HBQuranSurasController.h"
#import "HBQuranMainSettingsController.h"
#import "HBJuzModel.h"
#import "HBSuraModel.h"
#import "HBQuranRearCell.h"

@interface HBQuranRearItem: NSObject

@property (assign, nonatomic, readonly) HBQuranRearType type;
@property (strong, nonatomic, readonly) UIImage *iconImage;
@property (strong, nonatomic, readonly) NSString *title;

@end

@implementation HBQuranRearItem

- (instancetype)initWithType:(HBQuranRearType)type iconName:(NSString *)iconName title:(NSString *)title
{
    self = [super init];
    if (self) {
        _type = type;
        _iconImage = [UIImage imageNamed:iconName];
        _title = title;
    }
    return self;
}

@end


@interface HBQuranSubRearCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *arabicLabel;

@end

@implementation HBQuranSubRearCell

+ (NSString *)identifierCell
{
    return @"quranSubRearCell";
}

@end


@interface HBQuranRearController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<HBJuzModel *> *juzArray;
@property (strong, nonatomic) NSArray<HBSuraModel *> *viewArray;
@property (strong, nonatomic) NSArray<HBSuraModel *> *favoriteArray;
@property (strong, nonatomic) NSArray<HBSuraModel *> *noticeArray;
@property (strong, nonatomic) NSArray<HBSuraModel *> *markColorArray;
@property (strong, nonatomic) NSArray<HBQuranRearItem *> *itemArray;
@property (strong, nonatomic) NSArray *extraArray;
@property (assign, nonatomic) HBQuranRearType extraType;

@end

@implementation HBQuranRearController

+ (instancetype)instanceFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoreMain bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBQuranRearController class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
    self.itemArray = [self generateData];
 }

- (void)setUp
{
    self.tableView.allowsSelectionDuringEditing = YES;
    self.extraType = HBQuranRearTypeNone;
}

- (NSArray<HBQuranRearItem *> *)generateData {
    NSMutableArray<HBQuranRearItem *> *array = [NSMutableArray array];
    [array addObject:[[HBQuranRearItem alloc] initWithType:HBQuranRearTypeJuz iconName:@"quranRearJuz" title:NSLocalizedString(@"QuranRearJuz", nil)]];
    [array addObject:[[HBQuranRearItem alloc] initWithType:HBQuranRearTypeView iconName:@"quranRearView" title:NSLocalizedString(@"QuranRearView", nil)]];
    [array addObject:[[HBQuranRearItem alloc] initWithType:HBQuranRearTypeFavorite iconName:@"quranRearFavorite" title:NSLocalizedString(@"QuranRearFavorite", nil)]];
    [array addObject:[[HBQuranRearItem alloc] initWithType:HBQuranRearTypeNotice iconName:@"quranRearNotice" title:NSLocalizedString(@"QuranRearNotice", nil)]];
    [array addObject:[[HBQuranRearItem alloc] initWithType:HBQuranRearTypeMarkColor iconName:@"quranRearMarkColor" title:NSLocalizedString(@"QuranRearMarkColor", nil)]];
    [array addObject:[[HBQuranRearItem alloc] initWithType:HBQuranRearTypeSettings iconName:@"quranMenu" title:NSLocalizedString(@"SettingsTitle", nil)]];
    return array;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self closeSubMenu];
}

- (NSInteger)indexByRearType:(HBQuranRearType)type
{
    return type;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.extraArray) {
        
        if (indexPath.row <= [self indexByRearType:self.extraType]) {
            return self.itemArray[indexPath.row];
        }
        if (indexPath.row <= [self indexByRearType:self.extraType] + self.extraArray.count) {
            return self.extraArray[indexPath.row - [self indexByRearType:self.extraType] - 1];
        }
        return self.itemArray[indexPath.row - self.extraArray.count];
        
    } else {
        return self.itemArray[indexPath.row];
    }
}

- (void)configureItemCell:(HBQuranRearCell *)cell byItem:(HBQuranRearItem *)item
{
    cell.iconImageView.image = item.iconImage;
    cell.titleLabel.text = item.title;
    cell.isEditable = item.type != HBQuranRearTypeJuz && item.type != HBQuranRearTypeSettings;
    if (cell.changeButton.allTargets.count == 0) {
        [cell.changeButton addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)configureSubCell:(HBQuranSubRearCell *)cell byJuz:(HBJuzModel *)model
{
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"JuzName", nil), model.index];
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@ - %ld", model.suraModel.translitName, model.suraModel.lastAya];
    cell.arabicLabel.text = model.suraModel.arabicName;
}

- (void)configureSubCell:(HBQuranSubRearCell *)cell bySura:(HBSuraModel *)model
{
    cell.titleLabel.text = model.translitName;
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"QuranAyaName", nil), model.lastAya];
    cell.arabicLabel.text = model.arabicName;
}

- (NSArray<HBJuzModel *> *)juzArray {
    if (!_juzArray) {
        _juzArray = [self.gateway listJusModel];
    }
    return _juzArray;
}

- (NSArray<HBSuraModel *> *)viewArray
{
    if (!_viewArray) {
        _viewArray = [self.gateway listAyaByView];
    }
    return _viewArray;
}

- (NSArray<HBSuraModel *> *)favoriteArray
{
    if (!_favoriteArray) {
        _favoriteArray = [self.gateway listAyaByFavorite];
    }
    return _favoriteArray;
}

- (NSArray<HBSuraModel *> *)noticeArray
{
    if (!_noticeArray) {
        _noticeArray = [self.gateway listAyaByNotice];
    }
    return _noticeArray;
}

- (NSArray<HBSuraModel *> *)markColorArray
{
    if (!_markColorArray) {
        _markColorArray = [self.gateway listAyaByMarkColor];
    }
    return _markColorArray;
}

- (void)closeSubMenu
{
    if (self.extraType != HBQuranRearTypeNone) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexByRearType:self.extraType] inSection:0];
        id item = [self itemAtIndexPath:indexPath];
        if ([item isKindOfClass:[HBQuranRearItem class]]) {
            [self selectTopItem:item AtIndexPath:indexPath];
        }
    }
}

- (NSArray *)getExtraArrayByType:(HBQuranRearType)type
{
    switch (type) {
        case HBQuranRearTypeJuz:
            return self.juzArray;
        case HBQuranRearTypeView:
            return self.viewArray;
        case HBQuranRearTypeFavorite:
            return self.favoriteArray;
        case HBQuranRearTypeNotice:
            return self.noticeArray;
        case HBQuranRearTypeMarkColor:
            return self.markColorArray;
        default:
            return nil;
    }
}

- (void)setExtraArray:(NSArray *)array byType:(HBQuranRearType)type
{
    switch (type) {
        case HBQuranRearTypeJuz:
            self.juzArray = array;
            break;
        case HBQuranRearTypeView:
            self.viewArray = array;
            break;
        case HBQuranRearTypeFavorite:
            self.favoriteArray = array;
            break;
        case HBQuranRearTypeNotice:
            self.noticeArray = array;
            break;
        case HBQuranRearTypeMarkColor:
            self.markColorArray = array;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count + self.extraArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    id item = [self itemAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[HBQuranRearItem class]]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranRearCell identifierCell] forIndexPath:indexPath];
        [self configureItemCell:(HBQuranRearCell *)cell byItem:item];
        
    } else if ([item isKindOfClass:[HBJuzModel class]]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSubRearCell identifierCell] forIndexPath:indexPath];
        [self configureSubCell:(HBQuranSubRearCell *)cell byJuz:item];
        
    } else if ([item isKindOfClass:[HBSuraModel class]]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:[HBQuranSubRearCell identifierCell] forIndexPath:indexPath];
        [self configureSubCell:(HBQuranSubRearCell *)cell bySura:item];
        
    }
    NSAssert(cell, @"QuranRearCell is null");
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HBSuraModel *model = self.extraArray[indexPath.row - [self indexByRearType:self.extraType] - 1];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.extraArray];
        [array removeObject:model];
        self.extraArray = array;
        [self setExtraArray:array byType:self.extraType];
        [self.gateway dropPropertyByType:self.extraType fromAya:model];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tableView endUpdates];
        
        if (self.extraArray.count == 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexByRearType:self.extraType] inSection:0];
            HBQuranRearCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.state = HBRearCellStateNormal;
            }
        }
    }
}

- (void)callSettingsController
{
    HBQuranMainSettingsController *vc = [HBQuranMainSettingsController instanceFromStoryboard];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.surasController presentViewController:nc animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id item = [self itemAtIndexPath:indexPath];
    if ([item isKindOfClass:[HBQuranRearItem class]]) {
        [self selectTopItem:item AtIndexPath:indexPath];
    } else if ([item isKindOfClass:[HBJuzModel class]] && !tableView.isEditing) {
        [self.surasController showAyaByModel:((HBJuzModel *)item).suraModel];
    } else if ([item isKindOfClass:[HBSuraModel class]] && !tableView.isEditing) {
        [self.surasController showAyaByModel:(HBSuraModel *)item];
    }
}


- (void)selectTopItem:(HBQuranRearItem *)item AtIndexPath:(NSIndexPath *)indexPath
{
    if (item.type == HBQuranRearTypeSettings) {
        [self.surasController closeSliderMenu];
        [self callSettingsController];
        return;
    }
    
    if (self.tableView.isEditing) {
        if (item.type == self.extraType) {
            return;
        }
        [self.tableView setEditing:NO animated:YES];
    }
    //убираем строки
    NSMutableArray<NSIndexPath *> *deleteArray = nil;
    NSMutableArray<NSIndexPath *> *insertArray = nil;
    if (self.extraType !=  HBQuranRearTypeNone) {
        if (self.extraType !=  HBQuranRearTypeJuz && self.extraType != HBQuranRearTypeSettings) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexByRearType:self.extraType] inSection:0];
            HBQuranRearCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.state = HBRearCellStateNormal;
            }
        }
        deleteArray = [NSMutableArray arrayWithCapacity:self.extraArray.count];
        for (int i = 0; i < self.extraArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexByRearType:self.extraType] + i + 1 inSection:0];
            [deleteArray addObject:indexPath];
        }
    }
    //просто закрываем
    if (item.type == self.extraType) {
        self.extraArray = nil;
        self.extraType = HBQuranRearTypeNone;
        
    } else {
        self.extraArray = [self getExtraArrayByType:item.type];
        self.extraType = item.type;
        
        insertArray = [NSMutableArray arrayWithCapacity:self.extraArray.count];
        for (int i = 0; i < self.extraArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexByRearType:self.extraType] + i + 1 inSection:0];
            [insertArray addObject:indexPath];
        }
    }
    
    [self.tableView beginUpdates];
    if (deleteArray) {
        [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationTop];
    }
    if (insertArray) {
        [self.tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
    
    if (self.extraType != HBQuranRearTypeNone) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self indexByRearType:self.extraType] inSection:0];
        HBQuranRearCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            cell.state = self.extraArray.count > 0 ? HBRearCellStateSelect : HBRearCellStateNormal;
        }
    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.extraArray) {
        if (indexPath.row <= [self indexByRearType:self.extraType]) {
            return UITableViewCellEditingStyleNone;
        }
        if ((self.extraType == HBQuranRearTypeView ||
             self.extraType == HBQuranRearTypeFavorite ||
             self.extraType == HBQuranRearTypeNotice ||
             self.extraType == HBQuranRearTypeMarkColor) &&
            indexPath.row <= [self indexByRearType:self.extraType] + self.extraArray.count) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - HBQuranExtraDelegate

- (void)onChangeAyaExtra
{
    _viewArray = nil;
    _favoriteArray = nil;
    _noticeArray = nil;
}

- (void)onChangeAyaHighlight
{
    _markColorArray = nil;
}

#pragma mark - Actions

- (void)changeAction:(UIButton *)sender
{
    UITableViewCell *cell = [sender superViewCell];
    if (cell && [cell isKindOfClass:[HBQuranRearCell class]]) {
        HBQuranRearCell *rearCell = (HBQuranRearCell *)cell;
        [self.tableView setEditing:!self.tableView.isEditing animated:YES];
        rearCell.state = self.tableView.isEditing ? HBRearCellStateEdit : HBRearCellStateSelect;
    }
}


@end
