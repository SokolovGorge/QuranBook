//
//  HBQuranAyaCell.h
//  QuranBook
//
//  Created by Соколов Георгий on 20/10/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBQuranAyaCellView.h"

@class QuranMenuView;

@interface HBQuranAyaCell : UITableViewCell <HBQuranAyaCellView>

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextView *arabicTextView;
@property (weak, nonatomic) IBOutlet UITextView *translitTextView;
@property (weak, nonatomic) IBOutlet UITextView *translationTextView;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView0;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView2;

@property (weak, nonatomic) QuranMenuView *parentMenuView;
@property (strong, nonatomic) UITapGestureRecognizer *arabicTapGesture;
@property (strong, nonatomic) UITapGestureRecognizer *translitTapGesture;
@property (strong, nonatomic) UITapGestureRecognizer *translationTapGesture;

+ (NSString *)identifierCell;

- (UIImageView *)stateImageViewByIndex:(NSInteger)index;

@end

