//
//  HBQuranAyaCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 23/02/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBQuranAyaCellView <NSObject>

@property (assign, nonatomic, readonly) BOOL hasArabicGesture;
@property (assign, nonatomic, readonly) BOOL hasTranslitGesture;
@property (assign, nonatomic, readonly) BOOL hasTranslationGesture;

- (UIImageView *)stateImageViewByIndex:(NSInteger)index;

- (void)addArabicGesture:(UIGestureRecognizer*)gestureRecognizer;

- (void)addTranslitGesture:(UIGestureRecognizer*)gestureRecognizer;

- (void)addTranslationGesture:(UIGestureRecognizer*)gestureRecognizer;

- (void)modifyBackgroundClolor:(UIColor *)backgroundColor;

- (void)updateMenuView:(BOOL)visibleMenu;

- (void)displayNumber:(NSString *)numberText;

- (void)displayArabicText:(NSAttributedString *)arabicText;

- (void)displayTranslitText:(NSAttributedString *)translitText;

- (void)displayTranslationText:(NSAttributedString *)translationText;

@end
