//
//  NSMutableAttributedString+HTML.m
//  Habar
//
//  Created by Соколов Георгий on 27.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "NSMutableAttributedString+HTML.h"
#import "HBMacros.h"

@implementation NSMutableAttributedString (HTML)

- (instancetype)initWithHtmlString:(NSString *)htmlString withFont:(UIFont *)font withColor:(UIColor *)color
{
    NSError *error = nil;
    NSString *fullString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                                              font.fontName,
                                                              font.pointSize]];
    self = [super initWithData:[fullString dataUsingEncoding:NSUTF8StringEncoding]
                       options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
            documentAttributes:nil
                         error:&error];
    if (error) {
        DLog(@"Error convert HTML string: %@", error.localizedDescription);
    }
    if (self) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.string.length)];

    }
    return self;
}

@end
