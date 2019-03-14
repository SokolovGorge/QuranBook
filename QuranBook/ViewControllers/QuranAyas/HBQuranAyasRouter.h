//
//  HBQuranAyasRouter.h
//  QuranBook
//
//  Created by Соколов Георгий on 13/03/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"

@protocol HBQuranAyasRouter <HBBaseControllerView>

- (void)callNoticeControllerWithTitle:(NSString *)title noticeText:(NSString *)noticeText;

@end

