//
//  HBQuranSoundOptCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 17/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBQuranSoundOptCellView <NSObject>

- (void)displayTitle:(NSString *)title;

- (void)displaySubtitle:(NSString *)subtitle;

@end
