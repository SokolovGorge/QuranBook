//
//  HBJuzModel.h
//  Habar
//
//  Created by Соколов Георгий on 14.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBSuraModel;

@interface HBJuzModel : NSObject

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *arabicName;
@property (strong, nonatomic) HBSuraModel *suraModel;

@end
