//
//  FilterData.h
//  Clustering Dots
//
//  Created by Radi on 6/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FilterData : NSObject

@property (nonatomic, assign) int zoomLevel;
@property (nonatomic, assign) MKCoordinateRegion region;
@property (nonatomic, strong) NSString *hashtag;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL isMainMap;

@end