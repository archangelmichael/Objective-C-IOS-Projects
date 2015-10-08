//
//  ViewController.m
//  Clustering Dots
//
//  Created by Radi on 6/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    AppDelegate * app;
    BOOL isLoggingOperation; // When logging in or logging out
    BOOL isInitialLoading;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)onLoginButtonClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    isLoggingOperation = NO;
    self.mapView.showsPointsOfInterest = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            [locationManager requestWhenInUseAuthorization];
    }

    [locationManager startUpdatingLocation];
    isInitialLoading = YES;
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(50.85 , 4.34), MKCoordinateSpanMake(180, 180)) animated:YES];
    // [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(50.85 , 4.34) animated:YES];
    
    self.dataIsLoaded = NO;
    
    self.coordinateQuadTree = [[TBCoordinateQuadTree alloc] init];
    self.coordinateQuadTree.mapView = self.mapView;
    [self reloadMapDots];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
    }
}

/**
 Updates current location
 @param locations -> array with locations
 */
-(void)locationManager:(CLLocationManager*)manager
    didUpdateLocations:(NSArray*)locations {
    CLLocation *newLocation = (CLLocation*)[locations lastObject];
    NSLog(@"LOCATION UPDATED TO: %@", newLocation);
    [self locationManager:manager didUpdate2Location:newLocation fromLocation:nil];
}

/**
 Updates location to new location with check if currently in Bulgaria.
 If so modify location with London's location
 */
-(void)locationManager:(CLLocationManager*)manager
    didUpdate2Location:(CLLocation*)newLocation
          fromLocation:(CLLocation*)oldLocation{
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (isInitialLoading) {
        CLLocationCoordinate2D loc = [userLocation coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 10000, 10000);
        [self.mapView setRegion:region animated:YES];
        isInitialLoading = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addBounceAnnimationToView:(UIView *)view {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    bounceAnimation.duration = 0.6;
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++) {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    bounceAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations {
    NSMutableSet *before = [NSMutableSet setWithArray:self.mapView.annotations];
    [before removeObject:[self.mapView userLocation]];
    NSSet *after = [NSSet setWithArray:annotations];
    
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mapView addAnnotations:[toAdd allObjects]];
        [self.mapView removeAnnotations:[toRemove allObjects]];
    }];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (!self.dataIsLoaded) {
        return;
    }
    
    if (![self coordinate:self.mapView.region.center inRegion:app.watchedRegion]) {
        [self reloadMapDots];
        return;
    }
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:mapView.visibleMapRect
                                                                            withZoomScale:scale];
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    }];
}

- (BOOL)coordinate:(CLLocationCoordinate2D)coord inRegion:(MKCoordinateRegion)region {
    CLLocationCoordinate2D center = region.center;
    MKCoordinateSpan span = region.span;
    
    BOOL result = YES;
    result &= cos((center.latitude - coord.latitude)*M_PI/180.0) > cos(span.latitudeDelta/2.0*M_PI/180.0);
    result &= cos((center.longitude - coord.longitude)*M_PI/180.0) > cos(span.longitudeDelta/2.0*M_PI/180.0);
    return result;
}

-(void)reloadMapDots {
    [self.loadingIndicator startAnimating];
    [self fillSearchInfo];
    [app getAllDotsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [app loadDotsData:responseObject toVC:self];
         [self.loadingIndicator stopAnimating];
         // NSLog(@"All Dots Count: %lu", (unsigned long)app.arAllDots.count);
     }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.loadingIndicator stopAnimating];
         NSLog(@"ERROR GETTING ALL DOTS");
     }];
}

-(void)reloadMap {
    [self.coordinateQuadTree buildTreeWithDots:app.arAllDots aroundCoordinate:self.mapView.centerCoordinate];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:[TBClusterAnnotationView class]]) {
        if (((TBClusterAnnotationView *)view).count > 1) {
            [self.mapView setRegion:MKCoordinateRegionMake([view.annotation coordinate],
                                                           MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta / 2,
                                                                                self.mapView.region.span.longitudeDelta / 2))
                           animated:YES];
        }
        else if ([view.annotation isKindOfClass:[TBClusterAnnotation class]]) {
            if ([((TBClusterAnnotation *)view.annotation).title isEqualToString:@"#dotcluster#"]) {
                [self.mapView setRegion:MKCoordinateRegionMake([view.annotation coordinate],
                                                               MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta / 2,
                                                                                    self.mapView.region.span.longitudeDelta / 2))
                               animated:YES];
                [self reloadMapDots];
            }
            else {
                [self.mapView setCenterCoordinate:[view.annotation coordinate] animated:YES];
            }
        }
        else {
            [self.mapView setCenterCoordinate:[view.annotation coordinate] animated:YES];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const TBAnnotatioViewReuseID = @"TBAnnotatioViewReuseID";
    
    if (annotation == mapView.userLocation)
        return nil;
    
    TBClusterAnnotationView *annotationView;// = (TBClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TBAnnotatioViewReuseID];
    
    if (!annotationView) {
        annotationView = [[TBClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:TBAnnotatioViewReuseID];
    }
    
    annotationView.canShowCallout = NO;
    if (annotationView.count == 1 && ![annotationView.title isEqualToString:@"#dotcluster#"]) {
        annotationView.canShowCallout = YES;
    }
    //annotationView.canShowCallout = (annotationView.count > 1 || [annotationView.title isEqualToString:@"#dotcluster#"]) ? NO : YES;
    annotationView.count = [(TBClusterAnnotation *)annotation count];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (UIView *view in views) {
        [self addBounceAnnimationToView:view];
    }
}

-(void)fillSearchInfo {
    int zoom = [self getZoomLevel:self.mapView];
    app.mapFilterData.zoomLevel = zoom;
    app.mapFilterData.region = self.mapView.region;
    app.mapFilterData.username = @"";
    app.mapFilterData.hashtag = @"";
    app.mapFilterData.isMainMap = self.mapView;
}

-(int)getZoomLevel:(MKMapView*)mapView {
    float dLat = mapView.region.span.latitudeDelta,
    dLon = mapView.region.span.longitudeDelta,
    d = (dLat + dLon)/2;
    int zoom = (d <= 0.005 ? 30 :
                d <= 0.011 ? 16 :
                d <= 0.022 ? 15 :
                d <= 0.044 ? 14 :
                d <= 0.05 ? 13 :
                d <= 0.088 ? 12 :
                d <= 0.176 ? 11 :
                d <= 0.352 ? 10 :
                d <= 0.703 ? 9 :
                d <= 1.406 ? 8 :
                d <= 2.813 ? 7 :
                d <= 5.625 ? 6 :
                d <= 11.25 ? 5 :
                d <= 22.5 ? 4 :
                d <= 45 ? 3 :
                d <= 90 ? 2 :
                d <= 180 ?  1 : 0);
    return zoom;
}

- (IBAction)onLoginButtonClick:(id)sender {
    [self.loadingIndicator startAnimating];
    if ([self.loginButton.titleLabel.text isEqualToString:@"LOGIN"]) {
        NSString * username = @"radi";
        NSString * password = @"angel";
        [app loginWithUsername:username
                      password:password
                       success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSDictionary *jsonUser = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:0
                                                                        error:nil];
             if ([s isEqualToString:@""] || [jsonUser isEqualToDictionary:@{}]) {
                 NSLog(@"No such user found");
                 return;
             }
             
             app.loggedUsername = username;
             app.username = username;
             app.loggedPassword = password;
             
             app.tokenLogin = [jsonUser objectForKey:@"token"];
             [app reloadSettingsForName:username nameKey:@"USERNAME" token:app.tokenLogin tokenKey:@"TOKEN_LOGIN"];
             NSLog(@"LOGIN SUCCESSFUL");
             [self.loadingIndicator stopAnimating];
             self.loginButton.titleLabel.text = @"LOGOUT";
             
             isLoggingOperation = YES;
             [app.arAllDots removeAllObjects];
             [self reloadMapDots];
         }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"LOGIN FAILED");
            [self.loadingIndicator stopAnimating];
        }];
    }
    else {
        [app logoutWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             app.loggedUsername = @"";
             app.loggedPassword = @"";
             app.username = @"";
             app.tokenLogin = @"";
             [app reloadSettingsForName:app.username nameKey:@"USERNAME" token:app.tokenLogin tokenKey:@"TOKEN_LOGIN"];
             NSLog( @"LOGOUT SUCCESSFUL : %@", s);
             [self.loadingIndicator stopAnimating];
             self.loginButton.titleLabel.text = @"LOGIN";
             
             isLoggingOperation = YES;
             [app.arAllDots removeAllObjects];
             [self reloadMapDots];
         }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"LOGOUT FAILED");
             [self.loadingIndicator stopAnimating];
         }];

    }
}
@end
