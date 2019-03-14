//
//  HBQuranArabicItemCell.h
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranArabicItemCellView.h"

@interface HBQuranArabicItemCell : UITableViewCell<HBQuranArabicItemCellView>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;

+ (NSString *)identifierCell;

- (void)setState:(HBQuranItemState)state;

@end

