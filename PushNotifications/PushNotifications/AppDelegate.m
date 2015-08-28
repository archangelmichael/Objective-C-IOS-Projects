//
//  AppDelegate.m
//  PushNotifications
//
//  Created by Radi on 8/27/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"nstaVV4aCXDWC7qt8ZszaPFduCpKXKqOhDM4bAs4"
                  clientKey:@"AhJP2MEScbe5QPqv7nlDJ54vKUxKubBSmq623jpK"];
    // Register for Push Notitications
    [self initWithNotifications];
    if (DEVICE_VERSION >= 8.0) {
        [self setupCustomNotifications];
    }
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        [self showAlert:locationNotification.alertBody];
        NSLog(@"Clear local notifications");
        application.applicationIconBadgeNumber = 0;
    }
    
    //Remote notification info
    NSDictionary *remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    //Accept push notification when app is not open
    if (remoteNotifiInfo) {
        NSLog(@"Clear remote notifications");
        //[self application:application didReceiveRemoteNotification:remoteNotifiInfo];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark UINotification Registration

/*
 In the background/foreground state, then application:didReceiveRemoteNotification:fetchCompletionHandler will get triggered.
 
 In the Suspended state, then -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions will get triggered.
 
 In the Not Running state (your case), application:didReceiveRemoteNotification:fetchCompletionHandler never gets triggered.
 */
#pragma mark Remote Notificiations handling
- (void)initWithNotifications {
    if (DEVICE_VERSION >= 8.0) {
        UIUserNotificationSettings * notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
                                                                                              categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device Token: %@", deviceToken);
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration failure: %@", error.userInfo);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"REMOTE NOTIFICATION %@", userInfo);

    UIApplicationState state = [application applicationState];
    // user tapped notification while app was in background
    NSString * alertMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (state == UIApplicationStateInactive || state == UIApplicationStateBackground) {
        // go to screen relevant to Notification content
        [self scheduleSimpleLocalNotificationWithTitle:alertMessage
                                                  date:[NSDate dateWithTimeIntervalSinceNow:2]];
    } else {
        [self showAlert:alertMessage];
        // App is in UIApplicationStateActive (running in foreground)
        // perhaps show an UIAlertView
    }
    
    // Handle psuh with parse
    // [PFPush handlePush:userInfo];
    
    // WORKS WHEN YOU ARE IN THE APP
    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
}

- (void) application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
     forRemoteNotification:(NSDictionary *)userInfo
         completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:NotificationActionReplyId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationActionReplyName
                                                            object:nil];
    }
    else if ([identifier isEqualToString:NotificationActionDeleteId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationActionDeleteName
                                                            object:nil];
    }
    
    if (completionHandler) {
        completionHandler();
    }
}

#pragma mark Local Notifications Handling
- (void)setupCustomNotifications {
    UIUserNotificationSettings * currentNotificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (currentNotificationSettings == UIUserNotificationTypeNone) {
        UIUserNotificationType newNotificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    
        UIMutableUserNotificationAction * okAction = [[UIMutableUserNotificationAction alloc] init];
        okAction.identifier = NotificationActionOkId;
        okAction.title = NotificationActionOkTitle;
        okAction.activationMode = UIUserNotificationActivationModeBackground;
        okAction.destructive = NO;
        okAction.authenticationRequired = NO;
        
        UIMutableUserNotificationAction * replyAction = [[UIMutableUserNotificationAction alloc] init];
        replyAction.identifier = NotificationActionReplyId;
        replyAction.title = NotificationActionReplyTitle;
        replyAction.activationMode = UIUserNotificationActivationModeBackground;
        replyAction.destructive = NO;
        replyAction.authenticationRequired = NO;
        
        UIMutableUserNotificationAction * deleteAction = [[UIMutableUserNotificationAction alloc] init];
        deleteAction.identifier = NotificationActionDeleteId;
        deleteAction.title = NotificationActionDeleteTitle;
        deleteAction.activationMode = UIUserNotificationActivationModeBackground;
        deleteAction.destructive = YES;
        deleteAction.authenticationRequired = NO;
        
        NSArray * bannerActions = [NSArray arrayWithObjects:okAction, nil];
        NSArray * fullActions = [NSArray arrayWithObjects:okAction, replyAction, deleteAction, nil];
        
        UIMutableUserNotificationCategory * messageNotificationCategory = [[UIMutableUserNotificationCategory alloc] init];
        messageNotificationCategory.identifier = NotificationCategoryId;
        [messageNotificationCategory setActions:bannerActions forContext:UIUserNotificationActionContextMinimal];
        [messageNotificationCategory setActions:fullActions forContext:UIUserNotificationActionContextDefault];
    
        NSSet * settingsCategories = [NSSet setWithObjects:messageNotificationCategory, nil];
        UIUserNotificationSettings * userSettings = [UIUserNotificationSettings settingsForTypes:newNotificationTypes
                                                                                      categories:settingsCategories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userSettings];
    }
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"User settings %@", notificationSettings);
}

- (void) application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
      forLocalNotification:(UILocalNotification *)notification
         completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:NotificationActionReplyId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationActionReplyName
                                                            object:nil];
    }
    else if ([identifier isEqualToString:NotificationActionDeleteId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationActionDeleteName
                                                            object:nil];
    }
    
    if (completionHandler) {
        completionHandler();
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"Local notification received : %@", notification.alertBody);
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        [self showAlert:notification.alertBody];
    }
    
    // Perform custom action
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)showAlert:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark Notification Generation Methods
-(void)scheduleNotificationWithTitle:(NSString *)notificationText
                                date:(NSDate *)fireDate {
    UILocalNotification * newLocalNotification = [[UILocalNotification alloc] init];
    newLocalNotification.fireDate = fireDate;
    newLocalNotification.alertBody = notificationText;
    newLocalNotification.alertAction = NotificationActionOkId;
    newLocalNotification.category = NotificationCategoryId;
    [[UIApplication sharedApplication] scheduleLocalNotification:newLocalNotification];
}

- (void)scheduleSimpleLocalNotificationWithTitle:(NSString *)notificationText
                                            date:(NSDate *)fireDate {
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = notificationText;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark NSUserDefaults methods
-(PFUser *)loadUserData {
    NSString * savedUsername = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTS_USERNAME];
    NSString * savedPassword = [[NSUserDefaults standardUserDefaults] valueForKey:DEFAULTS_PASSWORD];
    if (savedUsername && savedPassword && ![savedUsername isEqualToString:@""] && ![savedPassword isEqualToString:@""]) {
        PFUser *user = [PFUser user];
        user.username = savedUsername;
        user.password = savedPassword;
        return user;
    }
    
    return nil;
}

-(void)setUserDefaultUsername:(NSString *)username
                     password:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:DEFAULTS_USERNAME];
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:DEFAULTS_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
