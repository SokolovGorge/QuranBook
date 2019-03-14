//
//  HBQuranRearCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranRearCell.h"

@implementation HBQuranRearCell

+ (NSString *)identifierCell
{
    return @"quranRearCell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _state = HBRearCellStateNormal;
    _isEditable = NO;
    self.changeButton.hidden = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _state = HBRearCellStateNormal;
    _isEditable = NO;
    self.changeButton.hidden = YES;
}

- (void)setState:(HBRearCellState)state
{
    _state = state;
    switch (state) {
        case HBRearCellStateSelect:
            [self.changeButton setTitle:NSLocalizedString(@"ButtonChange", nil) forState:UIControlStateNormal];
            break;
        case HBRearCellStateEdit:
            [self.changeButton setTitle:NSLocalizedString(@"ButtonDone", nil) forState:UIControlStateNormal];
        default:
            break;
    }
    self.changeButton.hidden = state == HBRearCellStateNormal || !self.isEditable;
}

- (void)setIsEditable:(BOOL)isEditable
{
    _isEditable = isEditable;
    self.changeButton.hidden = self.state == HBRearCellStateNormal || !isEditable;
}


@end
