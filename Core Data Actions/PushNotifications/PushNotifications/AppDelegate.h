//
//  AppDelegate.h
//  PushNotifications
//
//  Created by Radi on 10/2/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DefaultVC * defaultVC;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

