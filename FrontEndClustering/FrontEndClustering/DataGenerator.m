//
//  DataGenerator.m
//  FrontEndClustering
//
//  Created by Radi on 10/5/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "DataGenerator.h"

#define BATCH_COUNT 500 // how many annotations have to be loaded before showing them on the map
#define DELAY_BETWEEN_BATCHES 0.3

#define SEPARATION_DEGREES 10
#define MAX_LATITUDE 90
#define MAX_LONGITUDE 180

@interface DataGenerator()

@property (nonatomic) NSOperationQueue *operationQueue;

@end

@implementation DataGenerator

- (instancetype)init {
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)startGeneratingDataNear:(CLLocationCoordinate2D)location
                      withCount:(long)count {
    // Parse on background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableArray<MyAnnotation *> *followedAnnotations = [NSMutableArray<MyAnnotation *> arrayWithCapacity:BATCH_COUNT];
        NSMutableArray<MyAnnotation *> *unfollowedAnnotations = [NSMutableArray<MyAnnotation *> arrayWithCapacity:BATCH_COUNT];
        long index = 0;
        while (index < count) {
            index += 1;
            MyAnnotation * newAnnotation = [self getRandomAnnotationNear:location];
            if (newAnnotation.followed) {
                [followedAnnotations addObject:newAnnotation];
            }
            else {
                [unfollowedAnnotations addObject:newAnnotation];
            }
           
            if (followedAnnotations.count == BATCH_COUNT) {
                // Dispatch batch of annotations
                [self dispatchAnnotations:followedAnnotations
                                 followed:true];
                [followedAnnotations removeAllObjects];
            }
            
            if (unfollowedAnnotations.count == BATCH_COUNT) {
                // Dispatch batch of annotations
                [self dispatchAnnotations:unfollowedAnnotations
                                 followed:false];
                [unfollowedAnnotations removeAllObjects];
            }
        }
        
        // Dispatch remaining annotations
        [self dispatchAnnotations:followedAnnotations
                         followed:true];
        [self dispatchAnnotations:unfollowedAnnotations
                         followed:false];
    });
}

- (MyAnnotation *)getRandomAnnotationNear:(CLLocationCoordinate2D)center {
    CLLocationCoordinate2D location = [self getCoordinateNear:center];
    MyAnnotation * annotation = [[MyAnnotation alloc] initWithCoordinate:location];
    annotation.title = [NSString stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
    annotation.followed = (int)roundf(location.latitude) % 2 == 0;
    return annotation;
}

- (CLLocationCoordinate2D)getCoordinateNear:(CLLocationCoordinate2D)center {
    double minLat = center.latitude - SEPARATION_DEGREES;
    minLat = minLat <= -MAX_LATITUDE ? -MAX_LATITUDE : minLat ;
    double maxLat = center.latitude + SEPARATION_DEGREES;
    maxLat = minLat >= MAX_LATITUDE ? MAX_LATITUDE : maxLat;
    
    double minLon = center.longitude - 2 * SEPARATION_DEGREES;
    minLon = minLon <= -MAX_LONGITUDE ? -MAX_LONGITUDE : minLon ;
    double maxLon = center.longitude + 2 * SEPARATION_DEGREES;
    maxLon = minLon >= MAX_LONGITUDE ? MAX_LONGITUDE : maxLon;
    
    double latitude = [self randomDoubleBetween:minLat and:maxLat];
    double longitude = [self randomDoubleBetween:minLon and:maxLon];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (double)randomDoubleBetween:(double)min
                          and:(double)max {
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(max - min) + min;
}

- (void)stopGeneratingData {
    [self.operationQueue cancelAllOperations];
}

- (void)dispatchAnnotations:(NSArray<MyAnnotation *> *)annotations
                   followed:(BOOL)followed {
    // Dispatch on main thread with some delay to simulate network requests
    NSArray *annotationsToDispatch = [annotations copy];
    [self.operationQueue addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate dataGenerator:self
                          addAnnotations:annotationsToDispatch
                                followed:followed];
        });
        [NSThread sleepForTimeInterval:DELAY_BETWEEN_BATCHES];
    }];
}

@end
