//
//  HBQuranSurasRouter.h
//  QuranBook
//
//  Created by Соколов Георгий on 08/02/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBaseControllerView.h"

@class HBSuraModel;
@class HBAyaModel;

@protocol HBQuranSurasRouter <HBBaseControllerView>

- (void)callSettings;

- (void)showAyaControllerByModel:(HBSuraModel *)suraModel;

- (void)showAyaControllerByModel:(HBSuraModel *)suraModel preparedAyas:(NSMutableArray<HBAyaModel *> *)listAyas;

@end
