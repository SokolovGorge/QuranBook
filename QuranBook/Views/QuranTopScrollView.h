//
//  QuranTopScrollView.h
//  Habar
//
//  Created by Соколов Георгий on 30.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuranTopScrollView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

+ (instancetype)instanceFromNibByOwner:(id)owner;

@end
