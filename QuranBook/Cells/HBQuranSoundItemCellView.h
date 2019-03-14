//
//  HBQuranSoundItemCellView.h
//  QuranBook
//
//  Created by Соколов Георгий on 16/12/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBQuranSoundItemCellView <NSObject>

@property (strong, nonatomic) UIColor *progressColor;
@property (assign, nonatomic) BOOL checked;

- (void)displayTitle:(NSString *)title;

- (void)displaySubtitle:(NSString *)subtitle;

- (void)displayStatus:(NSString *)status;

- (void)displayInfo:(NSString *)info;

- (void)setVisibleStop:(BOOL)visible;

- (void)setExecButtonImageNamed:(NSString *)imageNamed;

- (void)setStopButtonImageNamed:(NSString *)imageNamed;

- (void)setPercent:(float)percent withAnimate:(BOOL)animate;

- (void)setImageByUrl:(NSURL *)url withPlaceholderImage:(UIImage *)placeholder;

- (void)setImage:(UIImage *)image;

- (void)addStopTarget:(id)target action:(SEL)action;

- (void)addExecTarget:(id)target action:(SEL)action;



@end
