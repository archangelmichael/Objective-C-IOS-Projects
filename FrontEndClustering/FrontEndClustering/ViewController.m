//
//  ViewController.m
//  FrontEndClustering
//
//  Created by Radi on 10/4/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"
#import "MKMapView+ZoomLevel.h"

#import <MapKit/MapKit.h>

#import "DataGenerator.h"
#import "ClusterAnnotationView.h"

#import "CCHMapClusterAnnotation.h"
#import "CCHMapClusterController.h"
#import "CCHMapClusterControllerDelegate.h"
#import "CCHCenterOfMassMapClusterer.h"
#import "CCHNearCenterMapClusterer.h"
#import "CCHFadeInOutMapAnimator.h"

@interface ViewController () <DataGeneratorDelegate, CCHMapClusterControllerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) DataGenerator *dataGenerator;
@property (nonatomic) CCHMapClusterController *mapClusterControllerFollowed;
@property (nonatomic) CCHMapClusterController *mapClusterControllerNotFollowed;

@property (nonatomic) NSUInteger count;
@property (nonatomic) id<CCHMapClusterer> mapClusterer;
@property (nonatomic) id<CCHMapAnimator> mapAnimator;

@end

@implementation ViewController

static const long INITIAL_ANNOTATION_COUNT = 64533;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup clusterization
    [self setupClusterVCs];
    self.mapView.delegate = self;
    
    // Read annotations
    self.dataGenerator = [[DataGenerator alloc] init];
    self.dataGenerator.delegate = self;
}

- (void)setupClusterVCs {
    // Setting clustarization controller
    self.mapClusterer = [[CCHCenterOfMassMapClusterer alloc] init];
    // self.mapClusterer = [[CCHNearCenterMapClusterer alloc] init];
    self.mapAnimator = [[CCHFadeInOutMapAnimator alloc] init];
    
    self.count = 0;
    
    // Set up followed map clustering
    self.mapClusterControllerFollowed = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    self.mapClusterControllerFollowed.delegate = self;
    
    self.mapClusterControllerFollowed.debuggingEnabled = false;
    self.mapClusterControllerFollowed.cellSize = 60;
    self.mapClusterControllerFollowed.marginFactor = 0.5;
    self.mapClusterControllerFollowed.clusterer = self.mapClusterer;
    self.mapClusterControllerFollowed.maxZoomLevelForClustering = 16;
    self.mapClusterControllerFollowed.minUniqueLocationsForClustering = 3;
    self.mapClusterControllerFollowed.animator = self.mapAnimator;
    
    
    self.mapClusterControllerNotFollowed = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    self.mapClusterControllerNotFollowed.delegate = self;
    
    self.mapClusterControllerNotFollowed.debuggingEnabled = false;
    self.mapClusterControllerNotFollowed.cellSize = 60 + 20;
    self.mapClusterControllerNotFollowed.marginFactor = 0.5;
    self.mapClusterControllerNotFollowed.clusterer = self.mapClusterer;
    self.mapClusterControllerNotFollowed.maxZoomLevelForClustering = 16;
    self.mapClusterControllerNotFollowed.minUniqueLocationsForClustering = 3;
    self.mapClusterControllerNotFollowed.animator = self.mapAnimator;
}

- (IBAction)onReloadAtCurrentLocation:(id)sender {
    // Restart data reader
    self.count = 0;
    [self.dataGenerator stopGeneratingData];
    [self.dataGenerator startGeneratingDataNear:self.mapView.centerCoordinate
                                      withCount:INITIAL_ANNOTATION_COUNT];
    
    // Remove all current items from the map
    [self.mapClusterControllerFollowed removeAnnotations:self.mapClusterControllerFollowed.annotations.allObjects
                                   withCompletionHandler:nil];
    [self.mapClusterControllerNotFollowed removeAnnotations:self.mapClusterControllerNotFollowed.annotations.allObjects
                                   withCompletionHandler:nil];
   
    for (id<MKOverlay> overlay in self.mapView.overlays) {
        [self.mapView removeOverlay:overlay];
    }
}

- (void)dataGenerator:(DataGenerator *)dataGenerator
       addAnnotations:(NSArray <MyAnnotation *>*)annotations
             followed:(BOOL)followed {
    if (followed) {
        [self.mapClusterControllerFollowed addAnnotations:annotations
                                    withCompletionHandler:nil];
    }
    else {
        [self.mapClusterControllerNotFollowed addAnnotations:annotations
                                       withCompletionHandler:nil];
    }
}


- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController
      titleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation {
    
    NSUInteger numAnnotations = mapClusterAnnotation.annotations.count;
    NSString *unit = numAnnotations > 1 ? @"annotations" : @"annotation";
    return [NSString stringWithFormat:@"%tu %@", numAnnotations, unit];
}


- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController
   subtitleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation {
    
    NSUInteger numAnnotations = MIN(mapClusterAnnotation.annotations.count, 5);
    NSArray *annotations = [mapClusterAnnotation.annotations.allObjects subarrayWithRange:NSMakeRange(0, numAnnotations)];
    NSArray *titles = [annotations valueForKey:@"title"];
    return [titles componentsJoinedByString:@", "];
}


- (void)mapClusterController:(CCHMapClusterController *)mapClusterController
willReuseMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation {
    MKAnnotationView *annotationView = [self.mapView viewForAnnotation:mapClusterAnnotation];
    if ([annotationView isKindOfClass:[ClusterAnnotationView class]]) {
        ((ClusterAnnotationView *)annotationView).count = mapClusterAnnotation.annotations.count;
        ((ClusterAnnotationView *)annotationView).unique = mapClusterAnnotation.isUniqueLocation;
    }
}

- (ClusterAnnotationView *)mapView:(MKMapView *)mapView
                 viewForAnnotation:(MyAnnotation *)annotation {
    ClusterAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:CCHMapClusterAnnotation.class]) {
        static NSString *identifier = @"clusterAnnotation";
        
        ClusterAnnotationView *clusterAnnotationView = (ClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (clusterAnnotationView) {
            clusterAnnotationView.annotation = annotation;
        }
        else {
            clusterAnnotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation
                                                                      reuseIdentifier:identifier];
            clusterAnnotationView.canShowCallout = true;
        }
        
        CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)annotation;
        clusterAnnotationView.count = clusterAnnotation.annotations.count;
        clusterAnnotationView.unique = clusterAnnotation.isUniqueLocation;
        clusterAnnotationView.followed = (clusterAnnotation.mapClusterController == self.mapClusterControllerFollowed);
        annotationView = clusterAnnotationView;
    }
    
    return annotationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
