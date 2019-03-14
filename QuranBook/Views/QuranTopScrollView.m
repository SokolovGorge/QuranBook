//
//  QuranTopScrollView.m
//  Habar
//
//  Created by Соколов Георгий on 30.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "QuranTopScrollView.h"

@implementation QuranTopScrollView

+ (instancetype)instanceFromNibByOwner:(id)owner
{
    return [[NSBundle mainBundle] loadNibNamed:@"QuranTopScrollView" owner:owner options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.text = NSLocalizedString(@"QuranPreviousSuraTitle", nil);
    self.subtitleLabel.text = NSLocalizedString(@"QuranPreviousSuraSubTitle", nil);
}

@end
