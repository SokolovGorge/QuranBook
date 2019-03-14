//
//  HBBaseLoader.m
//  Habar
//
//  Created by Соколов Георгий on 25.12.2017.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBBaseLoader.h"
#import "HBMacros.h"
#import "HBLoadContentService.h"

@interface HBBaseLoader() <NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (assign, nonatomic) BOOL flagInProgress;

@end

@implementation HBBaseLoader

- (instancetype)initLoadService:(id<HBLoadContentService>)loadContentService withId:(NSString *)itemId;
{
    self = [super init];
    if (self) {
        self.loadContentService = loadContentService;
        self.loadState = HBLoadStateNone;
        self.itemId = itemId;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[self URLSessionIdentifier]];
        
        self.backgroundSession = [NSURLSession sessionWithConfiguration:configuration
                                                               delegate:self
                                                          delegateQueue:nil];
    }
    return self;
}

- (void)startLoad
{
    self.flagInProgress = NO;
    self.error = nil;
    self.loadState = HBLoadStateLoading;
    self.percent = 0.f;
    [self saveState];
    //делаем задержку и проверяем не запущен ли уже процесс загрузки
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.flagInProgress) {
            self.downloadTask = [self.backgroundSession downloadTaskWithURL:[self urlData]];
            [self.downloadTask resume];
            DLog(@"taskStarted");
        }
    });
}

- (void)pause
{
    if (self.loadState != HBLoadStateLoading) {
        return;
    }
    self.loadState = HBLoadStatePause;
    [self.downloadTask suspend];
}

- (void)resume
{
    if (self.loadState != HBLoadStatePause) {
        return;
    }
    self.error = nil;
    self.loadState = HBLoadStateLoading;
    [self.downloadTask resume];
}


- (void)stopLoad
{
    if (self.loadState != HBLoadStateLoading && self.loadState != HBLoadStateUnpacking && self.loadState != HBLoadStatePause) {
        return;
    }
    if (self.loadState == HBLoadStateLoading) {
        [self.downloadTask cancel];
    }
    self.loadState = HBLoadStateNone;
    [self saveState];
}

- (void)clearData
{
    self.loadState = HBLoadStateNone;
    [self saveState];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self innerClearData];
    });
}


- (void)setLoadState:(HBLoadState)loadState
{
    if (_loadState != loadState) {
        _loadState = loadState;
        [self.loadContentService sendStatus:loadState byType:[self loadType] byId:self.itemId];
    }
}

- (void)setPercent:(float)percent
{
    // запускаем только, когда статус загрузки или распаковки
    if (_percent != percent && (self.loadState == HBLoadStateLoading || self.loadState == HBLoadStateUnpacking)) {
        _percent = percent;
        [self.loadContentService sendPercent:percent byType:[self loadType] byId:self.itemId];
    }
}

- (NSString *)URLSessionIdentifier
{
    return [NSString stringWithFormat:@"com.habarlink.%@%@", [self prefixTask], self.itemId];
}

- (void)updateStateWithError:(NSError *)error
{
    self.error = error;
    self.loadState = HBLoadStateError;
    [self saveState];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSError *error = nil;
    NSString *fileName = [location.path lastPathComponent];
    NSString *tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpFilePath error:&error];
        if (error) {
            DLog(@"Delete file %@ error: %@", tmpFilePath, error);
            [self updateStateWithError:error];
            return;
        }
    }
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:tmpFilePath error:&error];
    if (error) {
        DLog(@"Move file error: %@", error);
        [self updateStateWithError:error];
        return;
    }

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        self.loadState = HBLoadStateUnpacking;
        self.percent = 0.f;
        [self saveState];
        [self unpackWithFilePath:tmpFilePath];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    _flagInProgress = YES;
    if (totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown) {
        self.percent = (double)totalBytesWritten/(double)totalBytesExpectedToWrite * 100.f;
    } else {
        self.percent = 0.f;
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // выбрасываем ошибку только, если процесс не остановлен
    if (error  && self.loadState != HBLoadStateNone) {
        self.error = error;
        self.loadState = HBLoadStateError;
        [self saveState];
    }
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error
{
    self.error = error;
    self.loadState = HBLoadStateError;
    [self saveState];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    // продолжение процесса после выхода из фона
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *identifier = [self URLSessionIdentifier];
        HBURLSessionHandler handler = [self.loadContentService URLSessionHandlerByIdentifier:identifier];
        if (handler) {
            [self.loadContentService removeURLSessionHandlerByIdentifier:identifier];
            handler();
        }
    });
}

#pragma mark - Abstact Methods

+ (void)restoreLoadProcessWithLoadContentService:(id<HBLoadContentService>)loadContentService
{
    mustOverride();
}

- (HBLoadType)loadType
{
    mustOverride();
}

- (NSString *)title
{
    mustOverride();
}

- (NSString *)subTitle
{
    mustOverride();
}

- (void)saveState
{
    mustOverride();
}

- (void)unpackWithFilePath:(NSString *)filePath
{
    mustOverride();
}

- (void)innerClearData
{
    mustOverride();
}

- (NSURL *)urlData
{
    mustOverride();
}

- (NSString *)prefixTask
{
    mustOverride();
}

@end
