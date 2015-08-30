//
//  ImageDataRequester.h
//  TestProject
//
//  Created by Radi on 8/30/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ImageDataRequester : NSObject
+ (id)sharedGCDManager;

-(void)uploadImageData:(NSData *)imageData
           withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)downloadImageForID:(NSString *)imageID
              withSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void)getImageFromURL:(NSString *)imageURL
           withSuccess:(void (^)(AFHTTPRequestOperation *, id))success
               failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
@end
