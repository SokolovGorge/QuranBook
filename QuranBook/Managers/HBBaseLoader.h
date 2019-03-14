//
//  HBBaseLoader.h
//  Habar
//
//  Created by Соколов Георгий on 25.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBLoadState.h"
#import "HBLoadType.h"

@protocol HBLoadContentService;
@class HBLoadContentManager;

@interface HBBaseLoader : NSObject

@property (strong, nonatomic) id<HBLoadContentService> loadContentService;
@property (strong, nonatomic) NSString *itemId;
@property (assign, nonatomic) HBLoadState loadState;
@property (assign, nonatomic) float percent;
@property (strong, nonatomic) NSError *error;

- (instancetype)initLoadService:(id<HBLoadContentService>)loadContentService withId:(NSString *)itemId;

+ (void)restoreLoadProcessWithLoadContentService:(id<HBLoadContentService>)loadContentService;

- (void)startLoad;

- (void)resume;

- (void)pause;

- (void)stopLoad;

- (HBLoadType)loadType;

- (NSString *)title;

- (NSString *)subTitle;

- (void)saveState;

- (void)updateStateWithError:(NSError *)error;

- (void)unpackWithFilePath:(NSString *)filePath;

- (void)clearData;

- (NSURL *)urlData;

- (NSString *)prefixTask;

@end
