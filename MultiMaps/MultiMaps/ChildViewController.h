//
//  ChildViewController.h
//  MultiMaps
//
//  Created by Radi on 5/9/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ChildViewController : UIViewController

@property (nonatomic) CLLocationCoordinate2D mapCenter;
@property (strong, nonatomic) IBOutlet MKMapView * map;

@end
