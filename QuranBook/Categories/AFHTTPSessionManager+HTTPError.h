//
//  AFHTTPSessionManager+HTTPError.h
//  Habar
//
//  Created by DCH on 11/01/17.
//  Copyright © 2017 Bezlimit. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
static NSString const* const kNetworkProviderResponseObjectKey = @"AFHTTPSessionManagerResponse";
@interface AFHTTPSessionManager (HTTPError)
- (NSError *)errorFromError:(NSError *)error
             responseObject:(id)responseObject
                   response:(NSURLResponse *)response;
@end
