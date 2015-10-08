//
//  ViewController.h
//  Clustering Dots
//
//  Created by Radi on 6/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

#import "Dot.h"
#import "TBCoordinateQuadTree.h"
#import "TBClusterAnnotation.h"
#import "TBClusterAnnotationView.h"


@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate >

@property (assign) BOOL dataIsLoaded;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) TBCoordinateQuadTree *coordinateQuadTree;

@end

