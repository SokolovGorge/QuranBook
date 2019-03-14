//
//  HBQuranRearCell.h
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBRearCellState.h"

@interface HBQuranRearCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (assign, nonatomic) HBRearCellState state;
@property (assign, nonatomic) BOOL isEditable;

+ (NSString *)identifierCell;

@end
