//
//  MyAnnotation.h
//  FrontEndClustering
//
//  Created by Radi on 10/4/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign) BOOL followed;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
