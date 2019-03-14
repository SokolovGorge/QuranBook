//
//  HBQuranSearchSuraCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 08/02/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBQuranSearchSuraCellView <NSObject>

- (void)displayTitle:(NSString *)title;

- (void)displaySubtitle:(NSString *)subtitle;

- (void)setTitleImage:(UIImage *)titleImage;

@end
