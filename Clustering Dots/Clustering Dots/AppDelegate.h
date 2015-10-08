//
//  AppDelegate.h
//  Clustering Dots
//
//  Created by Radi on 6/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AFNetworking.h>

#import "Dot.h"
#import "FilterData.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) NSString * loggedUsername, * loggedPassword;
@property(nonatomic,strong) NSString * iosXXL, * tokenGuest, * username, * tokenLogin;

@property (nonatomic, strong) NSMutableArray * arAllDots;
@property (nonatomic, strong) NSMutableArray * arCurrentDots;

@property (nonatomic, strong) FilterData * mapFilterData;
@property (nonatomic, assign) MKCoordinateRegion watchedRegion;

// USER
-(void)initGuest;
-(void)loginWithUsername:(NSString*)username
                password:(NSString*)password
                 success:(void (^)(AFHTTPRequestOperation *, id))success
                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
-(void)logoutWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                 failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
-(void)reloadSettingsForName:(NSString *)name
                     nameKey:(NSString *)nameKey
                       token:(NSString *)token
                    tokenKey:(NSString *)tokenKey;

// DOTS
-(void)getAllDotsWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
-(void)loadDotsData:(id)responseObject toArray:(NSMutableArray *)destinationArray;
-(void)loadDotsData:(id)responseObject toVC:(UIViewController *)vc;
@end

