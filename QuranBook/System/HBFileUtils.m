//
//  HBFileUtils.m
//  Habar
//
//  Created by Георгий Соколов on 30.06.17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "HBFileUtils.h"

NSString* documentPathWithFileName(NSString *fileName) {
    static NSString *documentPath = nil;
    if (!documentPath) {
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [paths firstObject];
    }
    return [documentPath stringByAppendingPathComponent:fileName];
}

NSString* cacheFolder()
{
    static NSString *cacheFolder = nil;
    if (!cacheFolder) {
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cacheFolder = [paths firstObject];
    }
    return cacheFolder;
}
