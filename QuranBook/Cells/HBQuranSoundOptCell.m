//
//  HBQuranSoundOptCell.m
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import "HBQuranSoundOptCell.h"

@implementation HBQuranSoundOptCell

+ (NSString *)identifierCell
{
    return @"quranSoundOptCell";
}

#pragma mark - HBQuranSoundOptCellView

- (void)displayTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)displaySubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}


@end
