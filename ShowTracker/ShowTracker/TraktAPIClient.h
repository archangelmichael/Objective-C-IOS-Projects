//
//  TraktAPIClient.h
//  ShowTracker
//
//  Created by Radi on 5/5/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

extern NSString * const kTraktAPIKey;
extern NSString * const kTraktBaseURLString;

@interface TraktAPIClient : AFHTTPSessionManager

+ (TraktAPIClient *)sharedClient;

- (void)getShowsForDate:(NSDate *)date
               username:(NSString *)username
           numberOfDays:(int)numberOfDays
                success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
