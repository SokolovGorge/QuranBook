//
//  HBQuranAyasRouterImp.m
//  QuranBook
//
//  Created by Соколов Георгий on 13/03/2019.
//  Copyright © 2019 Соколов Георгий. All rights reserved.
//

#import "HBQuranAyasRouterImp.h"
#import "HBQuranNoticeController.h"

@implementation HBQuranAyasRouterImp

- (void)callNoticeControllerWithTitle:(NSString *)title noticeText:(NSString *)noticeText
{
    HBQuranNoticeController *vc = [HBQuranNoticeController instanceFromStoryboard];
    vc.parentController = (id<HBParentControllerDelegate>)self.curController;
    vc.navigationItem.title = title;
    vc.noticeText = noticeText;
    [self.curController.navigationController pushViewController:vc animated:YES];
    [self.curController.navigationController setNavigationBarHidden:NO animated:NO];

}

@end
