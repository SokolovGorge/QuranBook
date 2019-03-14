//
//  HBQuranSoundItemCell.h
//  QuranBook
//
//  Created by Соколов Георгий on 21/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranSoundItemCellView.h"

@class HBCircleProgressView;

@interface HBQuranSoundItemCell : UITableViewCell <HBQuranSoundItemCellView>

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkedImageView;

@property (weak, nonatomic) IBOutlet UIView *loadView;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *execButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stopWidthConstraint;

@property (weak, nonatomic) HBCircleProgressView *progressView;

+ (NSString *)identifierCell;


@end
