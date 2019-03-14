//
//  QuranManuView.h
//  Habar
//
//  Created by Соколов Георгий on 07.11.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuranMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

+ (instancetype)instanceFromNibByOwner:(id)owner;

- (instancetype)cloneView;

- (void)prepareForSize:(CGSize)size;

- (void)openMenuWithAnimate:(BOOL)animate;

- (void)closeMenuOnCompletion:(void (^)(void))completion;

@end
