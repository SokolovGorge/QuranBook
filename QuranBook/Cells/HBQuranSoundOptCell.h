//
//  HBQuranSoundOptCell.h
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranSoundOptCellView.h"

@interface HBQuranSoundOptCell : UITableViewCell <HBQuranSoundOptCellView>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

+ (NSString *)identifierCell;

@end
