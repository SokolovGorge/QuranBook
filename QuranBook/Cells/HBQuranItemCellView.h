//
//  HBQuranItemCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 09/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBQuranItemState.h"

@protocol HBQuranItemCellView <NSObject>

- (void)displayTitle:(NSString *)title;

- (void)displaySubtitle:(NSString *)subtitle;

- (void)setImageByURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

- (void)setItemImage:(UIImage *)image;

- (void)addDeleteActionWithTarget:(id)target action:(SEL)sel;

@property (assign, nonatomic) HBQuranItemState state;

@end
