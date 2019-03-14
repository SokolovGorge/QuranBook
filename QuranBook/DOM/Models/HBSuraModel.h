//
//  HBSuraModel.h
//  Habar
//
//  Created by Соколов Георгий on 26.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBSuraEntity;

typedef NS_ENUM(NSInteger, HBSuraState) {
    HBSuraStateNormal,
    HBSuraStateLastRead
};

@interface HBSuraModel : NSObject <NSCopying>

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) HBSuraState state;
@property (strong, nonatomic) NSString *arabicName;
@property (strong, nonatomic) NSString *translitName;
@property (strong, nonatomic) NSString *translationName;
@property (strong, nonatomic) UIImage *titleImage;
@property (assign, nonatomic) NSInteger countAyas;
@property (assign, nonatomic) NSInteger lastAya;

- (instancetype)initArabicEntity:(HBSuraEntity *)arabicEntity translitEntity:(HBSuraEntity *)translitEntity translationEntity:(HBSuraEntity *)translationEntity titleImage:(UIImage *)titleImage;


@end
