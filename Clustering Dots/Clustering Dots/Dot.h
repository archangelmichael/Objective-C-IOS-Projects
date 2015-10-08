//
//  Dot.h
//  Clustering Dots
//
//  Created by Radi on 6/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Dot : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property(nonatomic,assign) int id, userID, dotsCount, zoomLevel;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) float lat, lon;
@property(nonatomic,assign) BOOL isFollowed;
@property(nonatomic,strong) NSMutableArray *arTags;

-(id)initDotWithId :(int)dotId title:(NSString*)aTitle latitude:(float)fLat longitude:(float)fLon;

@end
