//
//  ViewController.m
//  TWEETER
//
//  Created by Radi on 4/5/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

#import "ViewController.h"

#import <TwitterKit/TwitterKit.h>
#import <Crashlytics/Crashlytics.h>


#import "SocialUser.h"

@interface ViewController ()
@property (nonatomic, strong) SocialUser * socialUser;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.socialUser = NULL;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TWTRSession * twSession = [[Twitter sharedInstance] sessionStore].session;
    if (twSession != nil) {
        self.socialUser = [SocialUser userWithId:twSession.userID
                                            name:twSession.userName
                                           token:twSession.authToken
                                          secret:twSession.authTokenSecret];
        NSLog(@"USER LOGGED : %@", self.socialUser.description);
    }
}

- (IBAction)onLogin:(id)sender {
    // If using the log in methods on the Twitter instance
    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased
                                    completion:^(TWTRSession *session, NSError *error)
     {
         if (session) {
             self.socialUser = [SocialUser userWithId:session.userID
                                                 name:session.userName
                                                token:session.authToken
                                               secret:session.authTokenSecret];
             NSLog(@"signed in as %@", self.socialUser.description);
         }
         else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}

- (IBAction)onCheckSession:(id)sender {
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    
    TWTRSession *lastSession = store.session;
    NSArray *sessions = [store existingUserSessions];
    TWTRSession *specificSession = [store sessionForUserID:store.session.userID];
    
    NSLog(@"Current session : %@", lastSession);
    NSLog(@"Existing sessions : %@", sessions);
    NSLog(@"Session for current user id : %@", specificSession);
}

- (IBAction)onGetEmail:(id)sender {
    [self getEmailByRequest];
}

- (void) getEmailByClient {
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    [client requestEmailForCurrentUser:^(NSString * _Nullable email, NSError * _Nullable error) {
        if (error != NULL) {
            NSLog(@" Fetching email failed : %@ ", error.localizedDescription);
        }
        else {
            NSLog(@" Fetching email success : %@", email);
        }
    }];
}

- (void) getEmailByRequest {
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                     URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                              parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                   error:nil];
    [client sendTwitterRequest:request
                    completion:^(NSURLResponse *response,
                                 NSData *data,
                                 NSError *connectionError)
     {
         if (connectionError != NULL) {
             NSLog(@"Fetching email failed : %@", connectionError.localizedDescription);
         }
         else {
             // NSLog(@"Fetching email response : %@", response);
             NSError *jsonError;
             id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
             if(jsonError) {
                 // check the error description
                 NSLog(@"json error : %@", [jsonError localizedDescription]);
             }
             else {
                 if ([jsonData isKindOfClass:[NSString class]]) {
                     NSLog(@" STRING EMAIL : %@", (NSString *)jsonData);
                 }
                 if ([jsonData isKindOfClass:[NSDictionary class]]) {
                     NSLog(@" STRING EMAIL : %@", [(NSDictionary *)jsonData valueForKey:@"email"]);
                 }
                 else {
                     NSLog(@" UNKNOWN ANSWER TYPE ");
                 }
             }
         }
     }];
}

- (IBAction)onGetFriends:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self getTWFriendsWithSuccess:^(NSString *userIds)
    {
        NSLog(@"TW friends : %@", userIds);
        if (weakSelf != nil) {
            [weakSelf showAlertWithTitle:@"TW"
                                 message:@"GOT FRIENDS"];
        }
    }
                          failure:^(NSError * _Nullable error)
    {
        if (error != nil) {
            NSLog(@"TW get friends error : %@", [error localizedDescription]);
        }
        else {
            NSLog(@"TW get friends complete");
        }
        
        if (weakSelf != nil) {
            [weakSelf showAlertWithTitle:@"TW"
                                 message:@"GOT NO FRIENDS"];
        }
    }];
}

- (void) getTWFriendsWithSuccess: (void(^)(NSString * userIds)) success
                         failure: (void(^)(NSError * _Nullable error)) failure {
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/friends/ids.json";
    NSError *clientError;
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                     URL:statusesShowEndpoint
                                              parameters:NULL
                                                   error:&clientError];
    if (clientError != nil) {
        NSLog(@"Failed getting friends : %@", [clientError localizedDescription]);
        failure(clientError);
    }
    else {
        [client sendTwitterRequest:request
                        completion:^(NSURLResponse * _Nullable response,
                                     NSData * _Nullable data,
                                     NSError * _Nullable connectionError)
         {
             if (connectionError != nil) {
                 NSLog(@"Twitter get friends request failed : %@", [connectionError localizedDescription]);
                 failure(connectionError);
             }
             else {
                 NSError *jsonError;
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:&jsonError];
                 if (jsonError != nil) {
                     NSLog(@"TW parsing user ids error : %@", [jsonError localizedDescription]);
                     failure(jsonError);
                     return;
                 }
                 
                 NSMutableSet * twIDs = [[NSMutableSet alloc] init];
                 for (NSString * friendID in [json objectForKey:@"ids"]) {
                     [twIDs addObject:friendID];
                 }
                 
                 if (twIDs.count > 0) {
                     NSString * idsStr = [[twIDs allObjects] componentsJoinedByString:@","];
                     success(idsStr);
                 }
                 else {
                     NSLog(@"No twitter friends");
                     failure(nil);
                 }
             }
         }];
    }
}

- (IBAction)onTweet:(id)sender {
    [self silentTWShare];
}

- (void)silentTWShare {
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    NSError *clientError;
    NSURLRequest *request = [client URLRequestWithMethod:@"POST"
                                                     URL:@"URL"
                                              parameters:nil
                                                   error:&clientError];
    if (request) {
        [client sendTwitterRequest:request
                        completion:^(NSURLResponse *response,
                                     NSData *data,
                                     NSError *connectionError)
         {
             if (data) {
                 NSLog(@"TW share complete");
             }
             else {
                 NSLog(@"TW share error: %@", connectionError);
             }
         }];
    }
    else {
        NSLog(@"TW share error: %@", clientError);
    }
}

- (IBAction)onCrash:(id)sender {
     [[Crashlytics sharedInstance] crash];
}

- (IBAction)onLogout:(id)sender {
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    [store logOutUserID:userID];
    self.socialUser = NULL;
    NSLog(@"User logged out : %@", self.socialUser.description);
}

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:title
                                                                      message:message
                                                               preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                              handler:nil]];
    [self presentViewController:alertVC
                       animated:true
                     completion:nil];
}

@end
