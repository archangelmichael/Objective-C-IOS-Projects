//
//  ImageDataRequester.m
//  TestProject
//
//  Created by Radi on 8/30/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ImageDataRequester.h"

@implementation ImageDataRequester {
    NSURL * baseURL;
}

NSString * const BASE_URL_PATH = @"https://upload.uploadcare.com";
NSString * const BASE_API_URL_PATH = @"https://api.uploadcare.com";
NSString * const PUBLIC_KEY = @"56dfdcadcb2e597a4375";
NSString * const PRIVATE_KEY = @"5674572744cd8788a51e";

+ (id)sharedGCDManager {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (id)init {
    if (self = [super init]) {
        baseURL = [NSURL URLWithString:BASE_URL_PATH];
    }
    
    return self;
}

-(void)uploadImageData:(NSData *) imageData
           withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) success
               failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure {

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    NSDictionary * parameters = @{
                                  @"UPLOADCARE_PUB_KEY" : PUBLIC_KEY,
                                  @"UPLOADCARE_STORE"  : @"1"
                                  };
    AFHTTPRequestOperation *op = [manager POST:@"/base/"
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      //do not put image inside parameters dictionary as I did, but append it!
                                      [formData appendPartWithFileData:imageData
                                                                  name:@"file"
                                                              fileName:@"avatar.png"
                                                              mimeType:@"image/png"];
                                  }
                                       success:success
                                       failure:failure];
    [op start];
}

-(void)downloadImageForID:(NSString *)imageID
              withSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                  failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSString * relativeURLPath = [NSString stringWithFormat:@"/files/%@/", imageID];
    NSDictionary * headers = @{
                               @"Authorization" : [NSString stringWithFormat:@"Uploadcare.Simple %@:%@", PUBLIC_KEY, PRIVATE_KEY]
                               };
    NSDictionary * parameters = nil;
    
    NSMutableURLRequest * request = [self createURLRequestToAPIURL:relativeURLPath
                                                        withMethod:@"GET"
                                                       withHeaders:headers
                                                    withParameters:parameters];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:success failure:failure];
    [op start];
}

-(void)getImageFromURL:(NSString *)imageURL
           withSuccess:(void (^)(AFHTTPRequestOperation *, id))success
               failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSURL * completeURL = [NSURL URLWithString:imageURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:completeURL];
    [request setHTTPMethod:@"GET"];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:success failure:failure];
    [op start];
}

-(NSMutableURLRequest *)createURLRequestToAPIURL:(NSString *)relativeURL
                                   withMethod:(NSString *)method
                                  withHeaders:(NSDictionary *)headers
                               withParameters:(NSDictionary *)parameters {
    // Set complete URL
    NSURL * completeURL = [NSURL URLWithString:relativeURL relativeToURL:[NSURL URLWithString:BASE_API_URL_PATH]];
    // Set request to complete URL
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:completeURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    // Set request method
    [request setHTTPMethod:method];
    // Set request headers
    [request setAllHTTPHeaderFields:headers];
    // Set request parameteres
    request.HTTPBody = [self httpBodyForParamsDictionary:parameters];
    return request;
}

-(NSMutableURLRequest *)createURLRequestToURL:(NSString *)relativeURL
                                   withMethod:(NSString *)method
                                  withHeaders:(NSDictionary *)headers
                               withParameters:(NSDictionary *)parameters {
    // Set complete URL
    NSURL * completeURL = [NSURL URLWithString:relativeURL relativeToURL:baseURL];
    // Set request to complete URL
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:completeURL];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    // Set request method
    [request setHTTPMethod:method];
    // Set request headers
    [request setAllHTTPHeaderFields:headers];
    // Set request parameteres
    request.HTTPBody = [self httpBodyForParamsDictionary:parameters];
    return request;
}

- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary {
    NSMutableArray *parameterArray = [NSMutableArray array];
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)percentEscapeString:(NSString *)string {
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

@end
