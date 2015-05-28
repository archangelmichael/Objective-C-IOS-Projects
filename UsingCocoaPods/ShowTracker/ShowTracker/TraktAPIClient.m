//
//  TraktAPIClient.m
//  ShowTracker
//
//  Created by Radi on 5/28/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

#import "TraktAPIClient.h"

// Set this to your Trakt API Key
NSString * const kTraktAPIKey = @"ArchangelMichael";  // TRAKT API KEY IS YOUR USERNAME
NSString * const kTraktBaseURLString = @"https://api-v2launch.trakt.tv/calendars/";

NSString * const kClientId = @"98374767aa6df0508ed019497566d3e01dedd0911b91bdf2f37826c7653f3f31";
NSString * const kClientSecret = @"e198ee1086163ba13847bf202c758b2f2cc65ab7212725d75a339deb02596e77";

// REQUESTS WITH AUTHENTICATION
/** Headers
 Content-Type: application/json
 Authorization: Bearer [token]
 trakt-api-version: 2
 trakt-api-key: [client_id]
 */

// GET MY SHOWS
NSString * const kTraktMyShowsURL = @"my/shows/%@/%i";
// https://api-v2launch.trakt.tv/calendars/my/shows/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

// GET MY NEW SHOWS
NSString * const kTraktMyNewShowsURL = @"my/shows/new/%@/%i";
// https://api-v2launch.trakt.tv/calendars/my/shows/new/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

// GET MY SEASON PREMIERES
NSString * const kTraktMySeasonPremieresURL = @"my/shows/premieres/%@/%i";
// https://api-v2launch.trakt.tv/calendars/my/shows/premieres/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

// GET MY MOVIES PREMIERES
NSString * const kTraktMyMoviesPremieresURL = @"my/movies/%@/%i";
// https://api-v2launch.trakt.tv/calendars/my/movies/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

// REQUESTS WITHOUT AUTHENTICATION
/** Headers
 Content-Type: application/json
 trakt-api-version: 2
 trakt-api-key: [client_id]
 */
// GET ALL SHOWS
NSString * const kTraktAllShowsURL = @"all/shows/%@/%i";
// https://api-v2launch.trakt.tv/calendars/all/shows/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

// GET ALL NEW SHOWS
NSString * const kTraktAllNewShowsURL = @"all/shows/new/%@/%i";
// https://api-v2launch.trakt.tv/calendars/all/shows/new/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

// GET ALL SEASON PREMIERES
NSString * const kTraktAllSeasonPremieresURL = @"all/shows/premieres/%@/%i";
// https://api-v2launch.trakt.tv/calendars/all/shows/premieres/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

// GET ALL MOVIES PREMIERES
NSString * const kTraktAllMoviesPremieresURL = @"all/movies/%@/%i";
// https://api-v2launch.trakt.tv/calendars/all/movies/start_date/days
// Request => GET
// start_date => String in format: 2015-01-03
// days => Integer in format: 7

@implementation TraktAPIClient

+ (TraktAPIClient *)sharedClient {
    static TraktAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{ @"Content-Type" : @"application/json",
                                                 @"trakt-api-version" : @"2",
                                                 @"trakt-api-key" : kClientId };
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kTraktBaseURLString]
                                 sessionConfiguration:configuration];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getAllShowsFromDate:(NSDate *)date
            forNumberOfDays:(int)numberOfDays
                    success:(void (^)(NSURLSessionDataTask *, id))success
                    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [formatter stringFromDate:date];
    NSString* path = [NSString stringWithFormat:kTraktAllShowsURL, dateString, numberOfDays];
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)getAllNewShowsFromDate:(NSDate *)date
               forNumberOfDays:(int)numberOfDays
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [formatter stringFromDate:date];
    NSString* path = [NSString stringWithFormat:kTraktAllNewShowsURL, dateString, numberOfDays];
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (failure) {
              failure(task, error);
          }
      }];
}

- (void)getAllSeasonsPremieresFromDate:(NSDate *)date
                       forNumberOfDays:(int)numberOfDays
                               success:(void (^)(NSURLSessionDataTask *, id))success
                               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [formatter stringFromDate:date];
    NSString* path = [NSString stringWithFormat:kTraktAllSeasonPremieresURL, dateString, numberOfDays];
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (failure) {
              failure(task, error);
          }
      }];
}

- (void)getAllMoviesPremieresFromDate:(NSDate *)date
                      forNumberOfDays:(int)numberOfDays
                              success:(void (^)(NSURLSessionDataTask *, id))success
                              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [formatter stringFromDate:date];
    NSString* path = [NSString stringWithFormat:kTraktAllMoviesPremieresURL, dateString, numberOfDays];
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (failure) {
              failure(task, error);
          }
      }];
}
@end