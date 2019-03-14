//
//  HBQuranSearchSuraCell.h
//  Habar
//
//  Created by Соколов Георгий on 02.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranSearchSuraCellView.h"

@interface HBQuranSearchSuraCell : UITableViewCell <HBQuranSearchSuraCellView>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthConstraint;

@property (strong, nonatomic) UIImage *titleImage;

+ (NSString *)identifierCell;

@end
