//
//  SecondChildViewController.h
//  MultiMaps
//
//  Created by Radi on 5/9/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SecondChildViewController : UIViewController


@property (weak, nonatomic) MKMapView *map;
@property (weak, nonatomic) IBOutlet MKMapView *mv;
@property (nonatomic) CLLocationCoordinate2D mapCenter;

@end
