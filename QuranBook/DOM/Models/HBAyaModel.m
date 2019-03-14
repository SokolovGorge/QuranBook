//
//  HBAyaModel.m
//  Habar
//
//  Created by Соколов Георгий on 26.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBAyaModel.h"
#import "NSMutableAttributedString+HTML.h"
#import "HBQuranService.h"
#import "HBHighlightModel.h"

@implementation HBAyaModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _prepared = NO;
    }
    return self;
}

- (void)addHighlightModel:(HBHighlightModel *)highlightModel byType:(HBQuranItemType)type;
{
     switch (type) {
        case HBQuranItemTypeArabic:
             [self addArabicHighlightModel:highlightModel];
            break;
         case HBQuranItemTypeTranslit:
             [self addTranslitHighlightModel:highlightModel];
             break;
         case HBQuranItemTypeTranslation:
             [self addTranslationHighlightModel:highlightModel];
             break;
        default:
            break;
    }
}

- (void)addArabicHighlightModel:(HBHighlightModel *)highlightModel
{
    if (!self.arabicHighlights) {
        self.arabicHighlights = [NSMutableArray arrayWithObject:highlightModel];
    } else {
        [self.arabicHighlights addObject:highlightModel];
    }
}

- (void)addTranslitHighlightModel:(HBHighlightModel *)highlightModel
{
    if (!self.translitHighlights) {
        self.translitHighlights = [NSMutableArray arrayWithObject:highlightModel];
    } else {
        [self.translitHighlights addObject:highlightModel];
    }
}

- (void)addTranslationHighlightModel:(HBHighlightModel *)highlightModel
{
    if (!self.translationHighlights) {
        self.translationHighlights = [NSMutableArray arrayWithObject:highlightModel];
    } else {
        [self.translationHighlights addObject:highlightModel];
    }
}

- (void)prepareData
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self.quranService arabicFont], NSFontAttributeName,
                                                                          [self.quranService arabicColor], NSForegroundColorAttributeName,
                                                                          paragraphStyle, NSParagraphStyleAttributeName,
                                                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.arabicText attributes:attributes];
    if (self.arabicHighlights) {
        for (HBHighlightModel *model in self.arabicHighlights) {
            [self setBackgroundColorOnString:string inRange:model.range];
        }
    }
    self.formatedArabicText = string;
    
    string = [[NSMutableAttributedString alloc] initWithHtmlString:self.translitText withFont:[self.quranService translitFont] withColor:[self.quranService translitColor]];
    if (self.translitHighlights) {
        for (HBHighlightModel *model in self.translitHighlights) {
            [self setBackgroundColorOnString:string inRange:model.range];
        }
    }
    self.formatedTranslitText = string;
    
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self.quranService translationFont], NSFontAttributeName,
                                [self.quranService translationColor], NSForegroundColorAttributeName,
                                nil];
    string = [[NSMutableAttributedString alloc] initWithString:self.translationText attributes:attributes];
    if (self.translationHighlights) {
        for (HBHighlightModel *model in self.translationHighlights) {
            [self setBackgroundColorOnString:string inRange:model.range];
        }
    }
    self.formatedTranslationText = string;
    
    _prepared = YES;
}

- (void)setBackgroundColorOnString:(NSMutableAttributedString *)string inRange:(NSRange)range
{
    [string addAttribute:NSBackgroundColorAttributeName value:[self.quranService highlightColor] range:range];
}

- (BOOL)isTouchRange:(NSRange)range byType:(HBQuranItemType)type
{
    NSArray<HBHighlightModel *> *rangeArray = [self highlihgtArrayByType:type];
    if (rangeArray) {
        for (HBHighlightModel *model in rangeArray) {
            if ([self range:range touchRange:model.range]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSArray<HBHighlightModel *> *)removeTouchItemsByRange:(NSRange)range byType:(HBQuranItemType)type;
{
    NSMutableArray<HBHighlightModel *> *rangeArray = [self highlihgtArrayByType:type];
    if (!rangeArray) {
        return nil;
    }
    NSMutableArray<HBHighlightModel *> *touchArray = [NSMutableArray arrayWithCapacity:rangeArray.count];
    for (NSInteger i = rangeArray.count - 1; i >= 0; i--) {
        HBHighlightModel *model = rangeArray[i];
        if ([self range:range touchRange:model.range]) {
            [touchArray addObject:model];
            [rangeArray removeObjectAtIndex:i];
        }
    }
    return touchArray;
}

- (NSMutableArray<HBHighlightModel *> *)highlihgtArrayByType:(HBQuranItemType)type
{
    switch (type) {
        case HBQuranItemTypeArabic:
            return self.arabicHighlights;
        case HBQuranItemTypeTranslit:
            return self.translitHighlights;
        case HBQuranItemTypeTranslation:
            return self.translationHighlights;
        default:
            break;
    }
    return nil;
}

- (BOOL)range:(NSRange)range1 touchRange:(NSRange)range2
{
    NSUInteger startLocation = range2.location;
    NSUInteger endLocation = range2.location + range2.length - 1;
    return NSLocationInRange(startLocation, range1) || NSLocationInRange(endLocation, range1);
}

@end
