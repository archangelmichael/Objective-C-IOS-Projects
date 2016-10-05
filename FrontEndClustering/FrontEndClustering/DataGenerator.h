//
//  DataGenerator.h
//  FrontEndClustering
//
//  Created by Radi on 10/5/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@class DataGenerator;

@protocol DataGeneratorDelegate <NSObject>

- (void)dataGenerator:(DataGenerator *)dataGenerator
       addAnnotations:(NSArray<MyAnnotation *> *)annotations
             followed:(BOOL)followed;

@end


@interface DataGenerator : NSObject

@property (nonatomic, weak) id<DataGeneratorDelegate> delegate;

- (void)startGeneratingDataNear:(CLLocationCoordinate2D)location
                      withCount:(long)count;
- (void)stopGeneratingData;

@end
