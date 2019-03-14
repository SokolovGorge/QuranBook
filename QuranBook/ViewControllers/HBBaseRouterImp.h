//
//  HBBaseRouterImp.h
//  QuranBook
//
//  Created by Соколов Георгий on 15/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBParentPresenterDelegate.h"

@interface HBBaseRouterImp : NSObject

@property (weak, nonatomic) UIViewController *curController;

@property (weak, nonatomic) id<HBParentPresenterDelegate> curPresenter;


@end
