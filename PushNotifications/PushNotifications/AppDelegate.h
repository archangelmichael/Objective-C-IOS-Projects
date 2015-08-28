//
//  AppDelegate.h
//  PushNotifications
//
//  Created by Radi on 8/27/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#define DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)scheduleNotificationWithTitle:(NSString *)notificationText
                                date:(NSDate *)fireDate;

- (void)scheduleSimpleLocalNotificationWithTitle:(NSString *)notificationText
                                            date:(NSDate *)fireDate;

// NSUserDefaults methods
-(PFUser *)loadUserData;
-(void)setUserDefaultUsername:(NSString *)username
                     password:(NSString *)password;
@end

