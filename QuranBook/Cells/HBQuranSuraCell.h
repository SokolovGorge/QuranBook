//
//  HBQuranSuraCell.h
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSuraCellState.h"
#import "HBQuranSuraCellView.h"

@interface HBQuranSuraCell : UITableViewCell <HBQuranSuraCellView>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthConstraint;

@property (strong, nonatomic) UIImage *titleImage;
@property (assign, nonatomic) HBSuraCellState state;

+ (NSString *)identifierCell;

- (void)updateSizeByImageSize:(CGSize)imageSize;

@end
