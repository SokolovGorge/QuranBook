//
//  HBParentPresenterDelegate.h
//  QuranBook
//
//  Created by Соколов Георгий on 02/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBParentPresenterDelegate <NSObject>

- (void)onCommitActionFromChild:(NSObject *)childPresenter userInfo:(NSDictionary *)userInfo;

- (void)onCancelActionFromChild:(NSObject *)childPresenter;

@end
