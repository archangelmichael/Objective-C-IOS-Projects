//
//  SocialUser.m
//  TWEETER
//
//  Created by Radi on 4/6/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

#import "SocialUser.h"

@implementation SocialUser

@synthesize userId, userName, userToken, userSecret, userEmail, userFriends;

+ (instancetype) userWithId: (NSString *)socialID
                       name: (NSString *)socialName
                      token: (NSString *)socialToken
                     secret: (NSString *)socialSecret
{
    SocialUser * user = [[SocialUser alloc] initWithId:socialID
                                                  name:socialName
                                                 token:socialToken
                                                secret:socialSecret];
    return user;
}

- (instancetype) initWithId: (NSString *)socialID
                       name: (NSString *)socialName
                      token: (NSString *)socialToken
                     secret: (NSString *)socialSecret
{
    self = [super init];
    if (self) {
        userId = socialID;
        userName = socialName;
        userToken = socialToken;
        userSecret = socialSecret;
        userEmail = NULL;
        userFriends = NULL;
    }
    
    return self;
}

- (void) setUserEmail: (NSString *)socialEmail
{
    userEmail = socialEmail;
}

- (void)setUserFriends:(NSArray *)socialFriends
{
    userFriends = socialFriends;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@" ID: %@, \n NAME: %@, \n EMAIL: %@, \n FRIENDS: %@, \n TOKEN: %@, \n SECRET: %@",
            userId,
            userName,
            userEmail,
            [userFriends componentsJoinedByString:@","],
            userToken,
            userSecret];
}

@end
