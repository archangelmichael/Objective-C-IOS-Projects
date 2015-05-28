//
//  TraktAPIClient.h
//  ShowTracker
//
//  Created by Radi on 5/28/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

extern NSString * const kTraktAPIKey;
extern NSString * const kTraktBaseURLString;

@interface TraktAPIClient : AFHTTPSessionManager

+ (TraktAPIClient *)sharedClient;

- (void)getAllShowsFromDate:(NSDate *)date
            forNumberOfDays:(int)numberOfDays
                    success:(void (^)(NSURLSessionDataTask *, id))success
                    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (void)getAllNewShowsFromDate:(NSDate *)date
               forNumberOfDays:(int)numberOfDays
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (void)getAllSeasonsPremieresFromDate:(NSDate *)date
                       forNumberOfDays:(int)numberOfDays
                               success:(void (^)(NSURLSessionDataTask *, id))success
                               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (void)getAllMoviesPremieresFromDate:(NSDate *)date
                      forNumberOfDays:(int)numberOfDays
                              success:(void (^)(NSURLSessionDataTask *, id))success
                              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
