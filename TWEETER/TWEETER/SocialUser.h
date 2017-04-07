//
//  SocialUser.h
//  TWEETER
//
//  Created by Radi on 4/6/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialUser : NSObject

@property (nonatomic, strong, readonly) NSString * userId;
@property (nonatomic, strong, readonly) NSString * userName;
@property (nonatomic, strong, readonly) NSString * userToken;
@property (nonatomic, strong, readonly) NSString * userSecret;
@property (nonatomic, strong, readonly) NSString * userEmail;
@property (nonatomic, strong, readonly) NSArray * userFriends;

+ (instancetype) userWithId: (NSString *)socialID
                       name: (NSString *)socialName
                      token: (NSString *)socialToken
                     secret: (NSString *)socialSecret;

- (instancetype) initWithId: (NSString *)socialID
                       name: (NSString *)socialName
                      token: (NSString *)socialToken
                     secret: (NSString *)socialSecret;

- (void) setUserEmail: (NSString *)socialEmail;
- (void) setUserFriends: (NSArray *)socialFriends;
- (NSString *) description;
@end
