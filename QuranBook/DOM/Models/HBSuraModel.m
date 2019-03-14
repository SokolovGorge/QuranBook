//
//  HBSuraModel.m
//  Habar
//
//  Created by Соколов Георгий on 26.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBSuraModel.h"
#import "HBSuraEntity.h"

@implementation HBSuraModel

- (instancetype)initArabicEntity:(HBSuraEntity *)arabicEntity translitEntity:(HBSuraEntity *)translitEntity translationEntity:(HBSuraEntity *)translationEntity titleImage:(UIImage *)titleImage
{
    self = [super init];
    if (self) {
        self.state = HBSuraStateNormal;
        self.index = arabicEntity.index.integerValue;
        self.countAyas = arabicEntity.countAyas.integerValue;
        self.arabicName = arabicEntity.name;
        self.translitName = translitEntity.name;
        self.translationName = translationEntity.name;
        self.titleImage = titleImage;
    }
    return self;
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    HBSuraModel *suraCopy = [[HBSuraModel allocWithZone:zone] init];
    suraCopy.state = self.state;
    suraCopy.index = self.index;
    suraCopy.countAyas = self.countAyas;
    suraCopy.arabicName = [self.arabicName copyWithZone:zone];
    suraCopy.translitName = [self.translitName copyWithZone:zone];
    suraCopy.translationName = [self.translationName copyWithZone:zone];
    suraCopy.titleImage = [self.titleImage copy];
    suraCopy.lastAya = self.lastAya;
    
    return suraCopy;
}

@end
