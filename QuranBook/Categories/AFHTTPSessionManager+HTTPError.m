//
//  AFHTTPSessionManager+HTTPError.m
//  Habar
//
//  Created by DCH on 11/01/17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import "AFHTTPSessionManager+HTTPError.h"

@implementation AFHTTPSessionManager (HTTPError)
- (NSError *)errorFromError:(NSError *)error
             responseObject:(id)responseObject
                   response:(NSURLResponse *)response {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
    if (responseObject) {
        userInfo[kNetworkProviderResponseObjectKey] = responseObject;
    }
    
    NSInteger HTTPStatusCode = error.code;
    if (response) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *HTTPResponse = (id)response;
            HTTPStatusCode = HTTPResponse.statusCode;
        }
    } else {
        HTTPStatusCode = 408;
    }
    
    return [NSError errorWithDomain:error.domain code:HTTPStatusCode userInfo:userInfo];
}
@end
