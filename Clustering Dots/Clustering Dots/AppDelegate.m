//
//  AppDelegate.m
//  Clustering Dots
//
//  Created by Radi on 6/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    NSURL * baseUrl;
    AppDelegate * app;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString * baseUrlAsString = @"http://api.dotisfun.com";
    baseUrl = [NSURL URLWithString:baseUrlAsString];
    app = self;
    self.arAllDots = [NSMutableArray arrayWithCapacity:10];
    self.arCurrentDots = [NSMutableArray arrayWithCapacity:10];
    self.mapFilterData = [[FilterData alloc] init];
    
    [self initGuest];
    
    
    // Override point for customization after application launch.
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

// USER
-(void)initGuest {
    NSString * loginAsGuestUrlAsStringFormat = @"/v0/user/guest";
    NSURL * requestUrl = [NSURL URLWithString:loginAsGuestUrlAsStringFormat relativeToURL:baseUrl];
    
    // Set complete URL
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestUrl];
    // Set method
    request.HTTPMethod = @"POST";
    // Set body from dictionary
    NSDictionary * dataDictionary = @{ @"platform" : @"ios" };
    request.HTTPBody = [self httpBodyForParamsDictionary:dataDictionary];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:0
                                                                    error:nil];
         self.iosXXL = [[jsonData allKeys] lastObject];
         self.tokenGuest = [[jsonData allValues] lastObject];
         [self reloadSettingsForName:self.iosXXL
                             nameKey:@"IOS_XXL"
                               token:self.tokenGuest
                            tokenKey:@"TOKEN_GUEST"];
         NSLog(@"GUEST LOGED IN");
     }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSLog(@"ERROR LOGING GUEST IN");
                              }];
    [op start];
}

-(void)loginWithUsername:(NSString*)username
                password:(NSString*)password
                 success:(void (^)(AFHTTPRequestOperation *, id))success
                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    self.loggedUsername = @"";
    self.loggedPassword = @"";
    self.tokenLogin = @"";
    
    NSString * loginUrlAsStringFormat = @"/v0/user/login";
    NSURL * requestUrl = [NSURL URLWithString:loginUrlAsStringFormat relativeToURL:baseUrl];
    
    // Set complete URL
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestUrl];
    // Set method
    [request setHTTPMethod:@"POST"];
    // Set Headers
    [request setAllHTTPHeaderFields:@{ @"X-DOT-Request" :  [NSString stringWithFormat:@"%@ %@", self.iosXXL, self.tokenGuest]}];
    // Set body from dictionary
    NSDictionary * dataDictionary = @{ @"username" : username, @"password" : password };
    request.HTTPBody = [self httpBodyForParamsDictionary:dataDictionary];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:success failure:failure];
    [op start];
}

-(void)logoutWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSString * logoutUrlAsStringFormat = @"/v0/user/logout";
    NSURL * requestUrl = [NSURL URLWithString:logoutUrlAsStringFormat relativeToURL:baseUrl];
    
    // Set complete URL
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestUrl];
    // Set method
    [request setHTTPMethod:@"GET"];
    // Set headers
    [request setAllHTTPHeaderFields:@{
                                      @"X-DOT-Request" : [NSString stringWithFormat:@"%@ %@", self.iosXXL, self.tokenGuest],
                                      @"Authorization" : [NSString stringWithFormat:@"%@ %@", self.loggedUsername, self.tokenLogin]
                                      }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:success failure:failure];
    [op start];
}

- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary {
    NSMutableArray *parameterArray = [NSMutableArray array];
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)percentEscapeString:(NSString *)string {
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

-(void)reloadSettingsForName:(NSString *)name
                     nameKey:(NSString *)nameKey
                       token:(NSString *)token
                    tokenKey:(NSString *)tokenKey {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:nameKey];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:tokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// DOTS
-(void)getAllDotsWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    int watchedDistance = 10000000;
    self.watchedRegion = MKCoordinateRegionMakeWithDistance(self.mapFilterData.region.center,
                                                            watchedDistance / 100,
                                                            watchedDistance / 100);
    
    NSLog(@"%f", self.mapFilterData.region.center.latitude);
    NSLog(@"%f", self.mapFilterData.region.center.longitude);
    
    NSString * getAllDotsUrlAsStringFormat = @"/v0/dot/around/%f,%f/%d/%d%@?%@u=%@&t=%@";
    NSString * getAllDotsUrlAsString =
        [NSString stringWithFormat:getAllDotsUrlAsStringFormat,
         self.mapFilterData.region.center.latitude,
         self.mapFilterData.region.center.longitude,
         self.mapFilterData.zoomLevel,
         watchedDistance, // [self getDistanceInMetersFromRegion:self.mapFilterData.region] * 3,
         ([self.mapFilterData.username length] > 0 ? [NSString stringWithFormat:@"/%@", self.mapFilterData.username] : @""),
         ([self.mapFilterData.hashtag length] > 0 ? [NSString stringWithFormat:@"tag=%@&", self.mapFilterData.hashtag] : @""),
         [self.username length] > 0 ? self.username : @"",
         self.tokenLogin];
    NSURL * requestUrl = [NSURL URLWithString:getAllDotsUrlAsString relativeToURL:baseUrl];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestUrl];
    [request setHTTPMethod:@"GET"];
    
    // Set body from dictionary
    // [request setHTTPBody:[NSKeyedArchiver archivedDataWithRootObject:nil]];
    
    // Set headers
    [request setAllHTTPHeaderFields:@{
                                      @"X-DOT-Request" : [NSString stringWithFormat:@"%@ %@", self.iosXXL, self.tokenGuest]
                                      }];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:success failure:failure];
    [op start];
}


-(void)loadDotsData:(id)responseObject  toVC:(ViewController *)vc {
    [self.arAllDots removeAllObjects];
    dispatch_queue_t myQueue = dispatch_queue_create("Fetch Dots Data Queue", nil);
    dispatch_async(myQueue, ^{
        NSString *s = [[NSString alloc] initWithData:responseObject
                                            encoding:NSUTF8StringEncoding];
        NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:0
                                                                    error:nil];
        NSArray *jFeatures = [jsonData objectForKey:@"features"];
        for(NSDictionary *jFeature in jFeatures) {
            NSDictionary *jGeometry = [jFeature objectForKey:@"geometry"];
            NSArray *jCoordinates = [jGeometry objectForKey:@"coordinates"];
            NSDictionary *jProperties = [jFeature objectForKey:@"properties"];
            
            int dotID = [[jProperties objectForKey:@"dot_id"] intValue];
            Dot * currentDot = [[Dot alloc] initDotWithId:dotID
                                                    title:[jProperties objectForKey:@"title"]
                                                 latitude:[jCoordinates[1] floatValue]
                                                longitude:[jCoordinates[0] floatValue]];
            int dotsCount = [[jProperties objectForKey:@"count_dots"] intValue];
            currentDot.isFollowed = [[jProperties objectForKey:@"followed"] boolValue];
            currentDot.dotsCount = dotsCount;
            [self.arAllDots addObject:currentDot];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"All Dots Count: %lu", (unsigned long)self.arAllDots.count);
            ViewController * senderVC = (ViewController *)vc;
            [senderVC.mapView removeAnnotations:senderVC.mapView.annotations];
            senderVC.coordinateQuadTree = [[TBCoordinateQuadTree alloc] init];
            senderVC.coordinateQuadTree.mapView = senderVC.mapView;
            [senderVC.coordinateQuadTree buildTreeWithDots:app.arAllDots aroundCoordinate:senderVC.mapView.centerCoordinate];
            senderVC.dataIsLoaded = YES;
            [senderVC mapView:senderVC.mapView regionDidChangeAnimated:YES];
        });
    });
}

/**
 Parses data from response objec to specified array
 */
-(void)loadDotsData:(id)responseObject toArray:(NSMutableArray *)destinationArray {
//    if (self.arAllDots.count > 300) { // Caching dots data
//        [self.arAllDots removeAllObjects];
//    }
    
    NSString *s = [[NSString alloc] initWithData:responseObject
                                        encoding:NSUTF8StringEncoding];
    NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0
                                                                error:nil];
    NSArray *jFeatures = [jsonData objectForKey:@"features"];
    [destinationArray removeAllObjects];
    for(NSDictionary *jFeature in jFeatures) {
        NSDictionary *jGeometry = [jFeature objectForKey:@"geometry"];
        NSArray *jCoordinates = [jGeometry objectForKey:@"coordinates"];
        NSDictionary *jProperties = [jFeature objectForKey:@"properties"];
        NSArray *jPopTags = [jProperties objectForKey:@"popular_tags"];
        int dotID = [[jProperties objectForKey:@"dot_id"] intValue];
        
        Dot * currentDot = [self getDotByID:dotID];
        // BOOL existed = (currentDot != nil);
        if (!currentDot)  {
            currentDot = [[Dot alloc] initDotWithId:dotID
                                              title:nil
                                           latitude:0
                                          longitude:0];
            [self.arAllDots addObject:currentDot];
            currentDot.id = dotID;
        }
        
        currentDot.dotsCount = [[jProperties objectForKey:@"count_dots"] intValue];
        if (currentDot.dotsCount == 1)  {
            [destinationArray insertObject:currentDot atIndex:0];
        } else {
            [destinationArray addObject:currentDot];
        }
        
        currentDot.title = [jProperties objectForKey:@"title"];
        currentDot.lat = [jCoordinates[1] floatValue];
        currentDot.lon = [jCoordinates[0] floatValue];
        id followed = [jProperties objectForKey:@"followed"];
        currentDot.isFollowed = [followed boolValue];
        
        if ([jPopTags isKindOfClass:[NSArray class]]){
            for(NSString *sTag in jPopTags){
                if ([[sTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
                    [currentDot.arTags addObject:sTag];
                }
            }
        }
    }
}

-(Dot*)getDotByID:(int)dotID {
    for(Dot *dK in self.arAllDots) {
        if (dK.id == dotID) {
            return dK;
        }
    }
    
    return nil;
}

-(int)getDistanceInMetersFromRegion:(MKCoordinateRegion)region {
    CLLocation *pO = [[CLLocation alloc] initWithLatitude:region.center.latitude
                                                longitude:region.center.longitude];
    float k = 0.5;
    CLLocation *pA = [[CLLocation alloc] initWithLatitude:region.center.latitude + region.span.latitudeDelta * k
                                                longitude:region.center.longitude + region.span.longitudeDelta * k];
    return [pO distanceFromLocation:pA];
}

@end
