//
//  DefaultVC.m
//  PushNotifications
//
//  Created by Radi on 10/5/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "DefaultVC.h"

@interface DefaultVC ()

@property (nonatomic, strong) UAInboxMessageListController *messageListController;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DefaultVC {
    NSString *targetURLString;
    NSString *targetURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.title = @"Inbox Sample";
    [self logTechInfo];
    [self reloadWebView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(defaultsChanged)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Inbox"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(inboxButtonPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)logTechInfo {
    NSString * currentIOSVersion = [[NSString alloc] initWithString:[[UIDevice currentDevice] systemVersion]];
    NSString * currentDeviceModel = [[NSString alloc] initWithString:[[UIDevice currentDevice] model]];
    NSString * currentUrbanAirshipVersion = [UAirshipVersion get];
    
    NSLog(@"Current IOS Version : %@", currentIOSVersion);
    NSLog(@"Current Model : %@", currentDeviceModel);
    NSLog(@"UAInbox Version: %@", currentUrbanAirshipVersion);
    
    NSString *plistFilePath = [NSString stringWithString:[[NSBundle mainBundle] pathForResource:@"Parameters"
                                                                                         ofType:@"plist"]];
    NSDictionary * paramDict = [[NSDictionary alloc] initWithContentsOfFile:plistFilePath];
    NSArray * parameters = [NSArray arrayWithArray:[paramDict objectForKey:@"Root"]];
    NSLog(@"Parameters : %@", parameters);
    NSString * currentAppLocation = [[NSString alloc] initWithFormat:@"%@", [paramDict objectForKey:@"app_region"]];
    
    targetURL = [[NSString alloc] initWithFormat:@"%@?l=%@&i=%@&m=%@",
                 [paramDict objectForKey:@"ios_check_url"],
                 currentAppLocation,
                 currentIOSVersion,
                 currentDeviceModel];
}

- (void)defaultsChanged {
    [self reloadWebView];
}

- (void)reloadWebView {
    //Verify if targetURL was set by MDM
    targetURLString = @"";
    targetURL = @"http://www.ucb.com/";
    
    static NSString * const kConfigurationKey = @"com.apple.configuration.managed";
    NSDictionary *serverConfig = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kConfigurationKey];
    static NSString * const kConfigurationTargetURLKey = @"targetURL";
    targetURLString = serverConfig[kConfigurationTargetURLKey];
    if ([targetURLString length] > 0) {
        targetURL = [[NSString alloc] initWithFormat:@"%@", targetURLString];
        NSLog(@"Target URL : %@",targetURL);
    }
    
    NSURL *url = [NSURL URLWithString:targetURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

#pragma mark -
#pragma mark - UIInboxMessageListController methods
-(void)showInbox {
    [self inboxButtonPressed:nil];
}

- (UAInboxMessageListController *)buildMessageListController {
    UAInboxMessageListController *mlc = [[UAInboxMessageListController alloc] initWithNibName:@"UAInboxMessageListController"
                                                                                       bundle:nil];
    mlc.title = @"Inbox";
    mlc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                         target:self
                                                                                         action:@selector(inboxDone:)];
    
    return mlc;
}

- (void)inboxDone:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)inboxButtonPressed:(id)sender {
    if (!self.messageListController) {
        self.messageListController = [self buildMessageListController];
    }
    
    if (self.messageListController) {
        [self.navigationController pushViewController:self.messageListController
                                             animated:YES];
    }
    
        //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.messageListController];
    
    //[self presentViewController:nav animated:YES completion:nil];
}

/*
#pragma mark - 
#pragma mark - Receiving notifications delegate
- (void)receivedForegroundNotification:(NSDictionary *)notification
                fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //UA_LDEBUG(@"Received a notification while the app was already in the foreground");
    NSLog(@"Received a notification while the app was already in the foreground");
    // Do something with your customData JSON, then entire notification is also available
    
    // Be sure to call the completion handler with a UIBackgroundFetchResult
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)launchedFromNotification:(NSDictionary *)notification
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    //UA_LDEBUG(@"The application was launched or resumed from a notification");
    NSLog(@"The application was launched or resumed from a notification");
    // Do something when launched via a notification
    
    // Be sure to call the completion handler with a UIBackgroundFetchResult
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)receivedBackgroundNotification:(NSDictionary *)notification
                fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Received Background Notification");
    // Do something with the notification in the background
    
    // Be sure to call the completion handler with a UIBackgroundFetchResult
    completionHandler(UIBackgroundFetchResultNoData);
}
*/
 
@end
