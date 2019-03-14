//
//  HBQuranArabicItemCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 08/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBQuranItemState.h"

@protocol HBQuranArabicItemCellView <NSObject>

- (void)displayTitle:(NSString *)title;

- (void)displaySubtitle:(NSString *)subtitle;

- (void)addDeleteActionWithTarget:(id)target action:(SEL)sel;

@property (assign, nonatomic) HBQuranItemState state;


@end

