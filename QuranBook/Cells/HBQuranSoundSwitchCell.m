//
//  HBQuranSoundSwitchCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranSoundSwitchCell.h"

@implementation HBQuranSoundSwitchCell

@synthesize checked = _checked;

+ (NSString *)identifierCell
{
    return @"quranSoundSwitchCell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.checkSwitch.on = NO;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.checkSwitch.on = NO;
}

- (BOOL)checked
{
    return self.checkSwitch.on;
}

- (void)setChecked:(BOOL)checked
{
    self.checkSwitch.on = checked;
}

#pragma mark - HBQuranSoundSwitchCellView

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)addSwitchTarget:(id)target action:(SEL)action
{
    [self.checkSwitch addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

@end
