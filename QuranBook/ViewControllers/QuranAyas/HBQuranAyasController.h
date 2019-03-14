//
//  HBQuranAyasController.h
//  Habar
//
//  Created by Соколов Георгий on 26.10.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBRevealChildController.h"
#import "HBParentPresenterDelegate.h"
#import "HBQuranGateway.h"

@protocol HBParentControllerDelegate;
@class HBSuraModel;
@class HBAyaModel;
@class SWRevealViewController;

@interface HBQuranAyasController : HBRevealChildController <HBQuranAyaDelegate>

+ (instancetype)instanceFromStoryboard;

- (void)initBySuraModel:(HBSuraModel *)suraModel;

- (void)initByListAyas:(NSMutableArray<HBAyaModel *> *)listAyas;

- (void)setNeedLoadSuraModel:(HBSuraModel *)suraModel;

- (void)reloadDataBySuraModel:(HBSuraModel *)suraModel;

@end
