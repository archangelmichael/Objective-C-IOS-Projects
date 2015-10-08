//
//  AppDelegate.m
//  PushNotifications
//
//  Created by Radi on 10/2/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "AppDelegate.h"

#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set default VC as start point
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.defaultVC = [[DefaultVC alloc] initWithNibName:@"DefaultVC" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.defaultVC];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    // Set push notifications delegate
    [UAirship push].pushNotificationDelegate = self.defaultVC;
    
    // Set the sample view controller as the Inbox delegate
    [UAirship inbox].delegate = self.defaultVC;
    
    // Receive my channel ID
    NSString *channelId = [UAirship push].channelID;
    NSLog(@"My Application Channel ID: %@", channelId);
    
    // Set the notification types required for the app (optional). This value defaults
    // to badge, alert and sound, so it's only necessary to set it if you want
    // to add or remove types.
    [UAirship push].userNotificationTypes = (UIUserNotificationTypeAlert |
                                             UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound );
    
    // User notifications will not be enabled until userPushNotificationsEnabled is
    // set YES on UAPush. Once enabled, the setting will be persisted and the user
    // will be prompted to allow notifications. Normally, you should wait for a more appropriate
    // time to enable push to increase the likelihood that the user will accept
    // notifications.
    [UAirship push].userPushNotificationsEnabled = YES;
    
    [[UAirship push] setAutobadgeEnabled:YES];
    [[UAirship push] resetBadge];
    [[UAirship inAppMessaging] setAutoDisplayEnabled:YES];
    
    return YES;
}

- (void)updateUrbanAirshipTags {
    //Verify if alias and tags were set by MDM
    static NSString * const kConfigurationKey = @"com.apple.configuration.managed";
    static NSString * const kAliasKey = @"alias";
    static NSString * const kTagsKey = @"tags";
    NSDictionary *serverConfig = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kConfigurationKey];
    NSString *alias = serverConfig[kAliasKey];
    if ([alias length] > 0) {
        [UAirship push].alias = alias;
        [[UAirship push] updateRegistration];
    }
    @try {
        NSArray *tags = serverConfig[kTagsKey];
        if ([tags count] > 0) {
            [UAirship push].tags = tags;
            [[UAirship push] updateRegistration];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception : %@",exception);
    }
}

- (void)failIfSimulator {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound) {
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:@"You can see UAInbox in the simulator, but you will not be able to recieve push notifications."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [someError show];
    }
}

/**
 * Called when the app is started from a user notification action button with foreground activation mode.
 *
 * @param notification The notification dictionary.
 * @param identifier The user notification action identifier.
 * @param completionHandler Should be called as soon as possible.
 */
- (void)launchedFromNotification:(NSDictionary *)notification
                actionIdentifier:(NSString *)identifier
               completionHandler:(void (^)())completionHandler {
    NSLog(@"DID LAUNCH FROM NOTIFICATION");
}

/**
 * Called when the app is started from a user notification action button with background activation mode.
 *
 * @param notification The notification dictionary.
 * @param identifier The user notification action identifier.
 * @param completionHandler Should be called as soon as possible.
 */
- (void)receivedBackgroundNotification:(NSDictionary *)notification
                      actionIdentifier:(NSString *)identifier
                     completionHandler:(void (^)())completionHandle {
    NSLog(@"DID RECEIVE BACKGROUND NOTIFICATION");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UAirship push] resetBadge];//zero badge
    [self updateUrbanAirshipTags];
    NSLog(@" %ldli new messages", (long)[UAirship inbox].messageList.unreadCount);
    [self.defaultVC reloadWebView];
}

-(void)applicationWillResignActive:(UIApplication *)application {
    UAInbox *inbox = [UAirship inbox];
    if (inbox.messageList.unreadCount >= 0) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:inbox.messageList.unreadCount];
    }
}

-(void)setQuietTime {
    // Set the quiet time from 7:30pm - 7:30am
    [[UAirship push] setQuietTimeStartHour:19 startMinute:30 endHour:7 endMinute:30];
    
    // Enable quiet time
    [UAirship push].quietTimeEnabled = YES;
    
    // Update registration
    [[UAirship push] updateRegistration];
}

@end
