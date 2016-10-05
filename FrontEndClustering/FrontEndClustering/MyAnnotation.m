//
//  MyAnnotation.m
//  FrontEndClustering
//
//  Created by Radi on 10/4/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if ( (self = [super init]) ) {
        self.title = @"";
        self.subtitle = @"";
        self.coordinate = coordinate;
        self.followed = false;
    }
    
    return self;
}

@end
