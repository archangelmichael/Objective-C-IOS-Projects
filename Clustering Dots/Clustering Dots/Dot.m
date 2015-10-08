//
//  Dot.m
//  Clustering Dots
//
//  Created by Radi on 6/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "Dot.h"

@implementation Dot

-(id)initDotWithId :(int)dotId
              title:(NSString*)aTitle
           latitude:(float)fLat
          longitude:(float)fLon {
    if ( self = [super init] ) {
        self.id = dotId;
        self.lat = fLat;
        self.lon = fLon;
        self.location = CLLocationCoordinate2DMake(fLat, fLon);
        self.title = aTitle;
        self.arTags = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}


@end
