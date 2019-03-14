//
//  HBTimeUtils.m
//  Habar
//
//  Created by Соколов Георгий on 11.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBTimeUtils.h"

NSString *timeInSecondsToString(NSTimeInterval seconds) {
    int hours = seconds / 3600;
    seconds -= hours * 3600;
    int min = seconds / 60;
    int sec = seconds - min * 60;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, min, sec];
    }
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}
