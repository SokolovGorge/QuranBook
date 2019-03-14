//
//  HBFileUtils.h
//  Habar
//
//  Created by Георгий Соколов on 30.06.17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Возвращает пролный путь к каталогу документов с файлом

 @param fileName NSString имя файла
 @return NSString полный путь
 */
NSString* documentPathWithFileName(NSString *fileName);

/**
 Возвращает путь к временной папке

 @return NSString - папка
 */
NSString* cacheFolder(void);
