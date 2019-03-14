//
//  NSMutableAttributedString+HTML.h
//  Habar
//
//  Created by Соколов Георгий on 27.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (HTML)

- (instancetype)initWithHtmlString:(NSString *)htmlString withFont:(UIFont *)font withColor:(UIColor *)color;

@end
