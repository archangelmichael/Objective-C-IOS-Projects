//
//  ViewController.m
//  MapKitTutorial
//
//  Created by Radi on 10/12/15.
//  Copyright © 2015 archangel. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager * locationManager;

@end

@implementation ViewController {
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

/**
 Updates current location
 @param locations -> array with locations
 */
-(void)locationManager:(CLLocationManager*)manager
    didUpdateLocations:(NSArray*)locations {
    CLLocation * newLocation = [locations lastObject];
    float myLat = newLocation.coordinate.latitude;
    float myLon = newLocation.coordinate.longitude;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(myLat, myLon)
                             animated:YES];
    //NSLog(@"LOCATION UPDATED TO: %@", newLocation);
}

- (IBAction)onZoom:(id)sender {
    MKUserLocation * userLocation = self.mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20000, 20000);
    [self.mapView setRegion:region animated:NO];
}

- (IBAction)onChangeType:(id)sender {
    if (self.mapView.mapType == MKMapTypeStandard) {
        self.mapView.mapType = MKMapTypeSatellite;
    }
    else {
        self.mapView.mapType = MKMapTypeStandard;
    }
}

- (IBAction)onUserLocation:(id)sender {
    MKUserLocation * userLocation = self.mapView.userLocation;
    float myLat = userLocation.coordinate.latitude;
    float myLon = userLocation.coordinate.longitude;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(myLat, myLon)
                             animated:YES];
}

- (void)showLoading {
    // Asynchronous call
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
//    [self doSomethingInBackgroundWithProgressCallback:^(float progress) {
//        hud.progress = progress;
//    } completionCallback:^{
//        [hud hide:YES];
//    }];
    
    // On Main Thread
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end
