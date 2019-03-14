//
//  HBMacros.h
//  QuranBook
//
//  Created by Соколов Георгий on 29/09/2018.
//  Copyright © 2018 Соколов Георгий. All rights reserved.
//

#ifndef HBMacros_h
#define HBMacros_h

#define TOPVIEWCONTROLLER()\
[(AppDelegate *)([UIApplication sharedApplication].delegate) topViewController]

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]

#endif /* HBMacros_h */
