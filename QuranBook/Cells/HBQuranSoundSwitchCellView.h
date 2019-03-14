//
//  HBQuranSoundSwitchCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 17/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBQuranSoundSwitchCellView <NSObject>

@property(assign, nonatomic) BOOL checked;

- (void)displayTitle:(NSString *)title;

- (void)addSwitchTarget:(id)target action:(SEL)action;

@end
