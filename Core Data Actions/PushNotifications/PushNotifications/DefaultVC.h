//
//  DefaultVC.h
//  PushNotifications
//
//  Created by Radi on 10/5/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airship/AirshipLib.h"
#import "UAInboxMessageListController.h"

@interface DefaultVC : UIViewController <UAPushNotificationDelegate, UAInboxDelegate>
- (void)reloadWebView;
@end
