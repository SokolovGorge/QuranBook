//
//  HBQuranSuraCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 08/02/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBQuranSuraCellView <NSObject>

- (void)modifyBackgroudColor:(UIColor *)color;

- (void)setHiddenNumber:(BOOL)hidden;

- (void)displayNumber:(NSString *)number;

- (void)displayIconImage:(UIImage *)image;

- (void)displayTitleImage:(UIImage *)image;

- (void)displayTitle:(NSString *)title;

- (void)displaySubtitle:(NSString *)subtitle;

- (void)updateSizeByImageSize:(CGSize)imageSize;

@end
