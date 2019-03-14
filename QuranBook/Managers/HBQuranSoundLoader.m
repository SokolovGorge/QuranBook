//
//  HBQuranSoundLoader.m
//  Habar
//
//  Created by Соколов Георгий on 25.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBQuranSoundLoader.h"
#import "SSZipArchive.h"
#import "HBMacros.h"
#import "HBLoadContentManager.h"
#import "HBCoreDataManager.h"
#import "HBConstants.h"
#import "HBQuranBaseEntity.h"
#import "HBQuranItemEntity.h"
#import "HBQuranSoundEntity.h"
#import "HBSuraEntity.h"
#import "HBAyaSoundEntity.h"
#import "HBQuranService.h"


#define kSoundArchive  @"sounds.zip"

@interface HBQuranSoundLoader()<SSZipArchiveDelegate>

@property (strong, nonatomic) HBQuranSoundEntity *soundEntity;
@property (strong, nonatomic) NSArray<NSNumber *> *suraCounts;
@property (assign, nonatomic) NSInteger suraIndex;
@property (assign, nonatomic) NSInteger ayaIndex;
@property (assign, nonatomic) NSInteger totalCount;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *subname;
@property (strong, nonatomic) id<HBQuranService> quranService;

@end

@implementation HBQuranSoundLoader

- (instancetype)initLoadService:(id<HBLoadContentService>)loadContentService withQuranService:(id<HBQuranService>)quranService withId:(NSString *)itemId
{
    self = [super initLoadService:loadContentService withId:itemId];
    if (self) {
        self.quranService = quranService;
        self.totalCount = 0;
        NSNumber *numberId = @([self.itemId intValue]);
        self.soundEntity = (HBQuranSoundEntity *)[self.quranService quranEntityById:numberId];
        if (self.soundEntity) {
            self.name = self.soundEntity.name;
            self.subname = self.soundEntity.subname;
        } else  {
            self.error = [NSError errorWithDomain:kHabarErrorDomain code:5004 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"Don't load HBQuranSoundEntity id = %@ from BD.", self.itemId]}];
            self.loadState = HBLoadStateError;
        }
    }
    return self;
}

- (void)unpackWithFilePath:(NSString *)filePath
{
    NSError *error = nil;
    NSString *soundFolder = [self.quranService soundFolderByItemId:self.itemId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:soundFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:soundFolder withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            DLog(@"Create folder error: %@", error);
            [self updateStateWithError:error];
            return;
        }
    }
    [SSZipArchive unzipFileAtPath:filePath
                    toDestination:soundFolder
                        overwrite:YES
                         password:nil
                            error:&error
                         delegate:self];
    if (error) {
        DLog(@"Unzip error: %@", error);
        [self updateStateWithError:error];
        return;
    }
    self.loadState = HBLoadStateComplete;
    [self saveState];
}

- (void)innerClearData
{
    if (!self.soundEntity) {
        return;
    }
    NSString *soundFolder = [self.quranService soundFolderByItemId:self.itemId];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:soundFolder error:&error];
    if (error) {
        DLog(@"Quran delete error: %@", error);
    } else {
        DLog(@"Quran Sound cleared");
    }
}

+ (void)restoreLoadProcessWithLoadContentService:(id<HBLoadContentService>)loadContentService
{
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        NSArray<HBQuranSoundEntity *> *array = [HBQuranSoundEntity MR_findAllInContext:context];
        for (HBQuranSoundEntity *soundEntity in array) {
            NSString *itemId = [soundEntity.itemId stringValue];
            if (soundEntity.soundStateValue == HBLoadStateLoading) {
                 [loadContentService startLoadByType:HBLoadTypeQuranSound byId:itemId];
            } else if (soundEntity.soundStateValue ==  HBLoadStateUnpacking) {
                [loadContentService startLoadByType:HBLoadTypeQuranSound byId:itemId];
            } else if (soundEntity.soundStateValue == HBLoadStatePause) {
                //если была пауза - выставляем остановку, так как выставить состояние загрузчика весьма проблематично
                soundEntity.soundStateValue = HBLoadStateNone;
            }
        }
    }];
}

- (HBLoadType)loadType
{
    return HBLoadTypeQuranSound;
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subTitle
{
    return self.subname;
}

- (void)saveState
{
    [[HBCoreDataManager sharedInstance] performSyncAndSave:^(NSManagedObjectContext *context) {
        HBQuranSoundEntity *soundInContext = [self.soundEntity MR_inContext:context];
        soundInContext.soundStateValue = self.loadState;
    }];
}

- (NSURL *)urlData
{
    __block NSString *urlString;
    [[HBCoreDataManager sharedInstance] performSync:^(NSManagedObjectContext *context) {
        HBQuranSoundEntity *soundInContext = [self.soundEntity MR_inContext:context];
        urlString = soundInContext.url_data;
    }];
    urlString = [urlString stringByAppendingPathComponent:kSoundArchive];
    return [NSURL URLWithString:urlString];
}

- (NSString *)prefixTask
{
    return @"QuranSound";
}

#pragma mark - SSZipArchiveDelegate

- (void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total
{
    if (total != 0) {
        self.percent = (float)loaded / (float)total * 100.f;
    }
}

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo
{
    return self.loadState = HBLoadStateUnpacking;
}


@end
