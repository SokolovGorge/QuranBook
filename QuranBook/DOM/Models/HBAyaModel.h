//
//  HBAyaModel.h
//  Habar
//
//  Created by Соколов Георгий on 26.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBQuranItemType.h"

@protocol HBQuranService;
@class HBHighlightModel;

@interface HBAyaModel : NSObject


@property (assign, nonatomic, readonly) BOOL prepared;
@property (assign, nonatomic) NSInteger suraIndex;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *arabicText;
@property (strong, nonatomic) NSAttributedString *formatedArabicText;
@property (strong, nonatomic) NSString *translitText;
@property (strong, nonatomic) NSAttributedString *formatedTranslitText;
@property (strong, nonatomic) NSString *translationText;
@property (strong, nonatomic) NSAttributedString *formatedTranslationText;
@property (strong, nonatomic) NSString *noticeText;
@property (assign, nonatomic) BOOL flagView;
@property (assign, nonatomic) BOOL flagFavorite;
@property (strong, nonatomic) id<HBQuranService> quranService;

@property (strong, nonatomic) NSMutableArray<HBHighlightModel *> *arabicHighlights;
@property (strong, nonatomic) NSMutableArray<HBHighlightModel *> *translitHighlights;
@property (strong, nonatomic) NSMutableArray<HBHighlightModel *> *translationHighlights;

- (void)addHighlightModel:(HBHighlightModel *)highlightModel byType:(HBQuranItemType)type;

- (void)prepareData;

- (BOOL)isTouchRange:(NSRange)range byType:(HBQuranItemType)type;

- (NSArray<HBHighlightModel *> *)removeTouchItemsByRange:(NSRange)range byType:(HBQuranItemType)type;

@end
