//
//  HBQuranSurasRouterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 08/02/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import "HBQuranSurasRouterImp.h"
#import "HBQuranMainSettingsController.h"
#import "HBQuranAyasController.h"
#import "HBQuranSurasController.h"
#import "HBQuranGateway.h"

@interface HBQuranSurasRouterImp()

@property (strong, nonatomic) HBQuranGateway *gateway;

@end

@implementation HBQuranSurasRouterImp

- (void)callSettings
{
    HBQuranMainSettingsController *vc = [HBQuranMainSettingsController instanceFromStoryboard];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.curController presentViewController:nc animated:YES completion:nil];
}


- (void)showAyaControllerByModel:(HBSuraModel *)suraModel
{
    //закрываем меню
    HBQuranSurasController *sc = (HBQuranSurasController *)self.curController;
    [sc closeSliderMenu];
    
    //проверяем поднят ли контролер
    UIViewController *vc = self.curController.navigationController.topViewController;
    if (vc && [vc isKindOfClass:[HBQuranAyasController class]]) {
        HBQuranAyasController *ayasController = (HBQuranAyasController *)vc;
        [ayasController reloadDataBySuraModel:suraModel];
    } else {
        HBQuranAyasController *ayasController = [self createAyasControllerWithSuraModel:nil];
        [ayasController setNeedLoadSuraModel:suraModel];
        //       self.navigationController.navigationBar.hidden = NO;
        //       [self.revealViewController.navigationController setNavigationBarHidden:YES];
        [self.curController.navigationController pushViewController:ayasController animated:YES];
    }
}

- (void)showAyaControllerByModel:(HBSuraModel *)suraModel preparedAyas:(NSMutableArray<HBAyaModel *> *)listAyas
{
    HBQuranAyasController *ayasController = [self createAyasControllerWithSuraModel:suraModel];
    ayasController.parentPresenterDelegate = self.curPresenter;
    [ayasController initByListAyas:listAyas];
    [self.curController.navigationController pushViewController:ayasController animated:YES];
}


- (HBQuranAyasController *)createAyasControllerWithSuraModel:(HBSuraModel *)suraModel
{
    HBQuranAyasController *vc = [HBQuranAyasController instanceFromStoryboard];
    vc.parentPresenterDelegate = self.curPresenter;
    HBQuranSurasController *sc = (HBQuranSurasController *)self.curController;
    vc.revealController = [sc revealViewController];
    //    vc.gateway = self.gateway; //передаем уже с закешированными сурами
    self.gateway.ayaDelegate = vc;
    [vc initBySuraModel:suraModel];
    return vc;
}


@end
