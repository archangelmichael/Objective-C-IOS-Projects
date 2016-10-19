//
//  AppDelegate.m
//  TestPush
//
//  Created by Radi on 10/19/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "AppDelegate.h"

#import <OneSignal/OneSignal.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Add this line. Replace '5eb5a37e-b458-11e3-ac11-000c2940e62c' with your OneSignal App ID.
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"985aaf68-b2e6-4bc7-9b6e-872f73096f17"];
    
    // Sync hashed email if you have a login system or collect it.
    //   Will be used to reach the user at the most optimal time of day.
    // [OneSignal syncHashedEmail:userEmail];
    
    [self registerForRemoteNotifications];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types == UIUserNotificationTypeNone) {
        [self registerForRemoteNotifications];
    }
}

- (void)registerForRemoteNotifications {
    UIUserNotificationType notificationTypes = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                                         UIUserNotificationTypeSound |
                                                                         UIUserNotificationTypeAlert);
    UIUserNotificationSettings * notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationTypes
                                                                                          categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * deviceTokenStr = [[[[deviceToken description]
                                    stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                    stringByReplacingOccurrencesOfString:@">" withString:@""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"REGISTERED DEVICE TOKEN : %@", deviceTokenStr);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"FAILED TO REGISTER : %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
