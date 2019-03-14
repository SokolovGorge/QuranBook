//
//  HBQuranItemCell.h
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranItemCellView.h"

@interface HBQuranItemCell : UITableViewCell <HBQuranItemCellView>

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleVerticalConstraint;


+ (NSString *)identifierCell;

@end
