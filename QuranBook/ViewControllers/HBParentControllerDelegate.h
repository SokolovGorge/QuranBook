//
//  HBParentControllerDelegate.h
//  Habar
//  Служит для отвязки дочернего контрола от родителя при реализации действий в родительском контроле при подтверждении/отказе процесса в дочернем контроле.
//  Created by Соколов Георгий on 10.08.17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBParentControllerDelegate <NSObject>

/**
 * Реализует действия в родительским контроле при подтверждении процесса в дочернем контроле.

 @param childController UIViewController - дочерний контроллер (источник события)
 @param userInfo NSDictionary - доп.информация
 */
- (void)onCommitActionFromChild:(UIViewController *)childController userInfo:(NSDictionary *)userInfo;

/**
 * Реализует действия в родительским контроле при отмене процесса в дочернем контроле.
 
 @param childController UIViewController - дочерний контроллер (источник события)
 */
- (void)onCancelActionFromChild:(UIViewController *)childController;

@end
