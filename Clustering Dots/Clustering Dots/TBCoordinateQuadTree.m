//
//  TBCoordinateQuadTree.m
//  TBAnnotationClustering
//
//  Created by Theodore Calmes on 9/27/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import "TBCoordinateQuadTree.h"
#import "TBClusterAnnotation.h"

typedef struct TBDotInfo {
    char * dotID;
    char * dotTitle;
    BOOL isFollowed;
} TBDotInfo;

TBQuadTreeNodeData TBDataFromDot(Dot * dot) {
    double latitude = dot.lat;
    double longitude = dot.lon;
    
    TBDotInfo * dotInfo = malloc(sizeof(TBDotInfo));
    NSString * dotTitle = [NSString stringWithFormat:@"%@", dot.title];
    dotInfo->dotTitle = malloc(sizeof(char) * dotTitle.length + 1);
    strncpy(dotInfo->dotTitle, [dotTitle UTF8String], dotTitle.length + 1);

    NSString * dotID = [NSString stringWithFormat:@"%i", dot.id];
    dotInfo->dotID = malloc(sizeof(char) * dotID.length + 1);
    strncpy(dotInfo->dotID, [dotID UTF8String], dotID.length + 1);
    
    // dotInfo->isFollowed = dot.isFollowed;

    return TBQuadTreeNodeDataMake(latitude, longitude, dotInfo);
}

TBBoundingBox TBBoundingBoxForMapRect(MKMapRect mapRect)
{
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));

    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;

    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;

    return TBBoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect TBMapRectForBoundingBox(TBBoundingBox boundingBox)
{
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));

    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

NSInteger TBZoomScaleToZoomLevel(MKZoomScale scale)
{
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));

    return zoomLevel;
}

float TBCellSizeForZoomScale(MKZoomScale zoomScale)
{
    NSInteger zoomLevel = TBZoomScaleToZoomLevel(zoomScale);

    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;

        default:
            return 88;
    }
}

@implementation TBCoordinateQuadTree

- (void)buildTreeWithDots:(NSArray *)dotsArr aroundCoordinate:(CLLocationCoordinate2D)coordinate {
    @autoreleasepool {
        NSInteger count = dotsArr.count;

        TBQuadTreeNodeData *dataArray = malloc(sizeof(TBQuadTreeNodeData) * count);
        for (NSInteger i = 0; i < count; i++) {
            dataArray[i] = TBDataFromDot(dotsArr[i]);
        }

        TBBoundingBox world = TBBoundingBoxMake(coordinate.latitude - 45, coordinate.longitude - 45,
                                                coordinate.latitude + 45, coordinate.longitude + 45);
        _root = TBQuadTreeBuildWithData(dataArray, count, world, 4);
    }
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale {
    double TBCellSize = TBCellSizeForZoomScale(zoomScale);
    double scaleFactor = zoomScale / TBCellSize;

    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);

    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int count = 0;

            NSMutableArray *titles = [[NSMutableArray alloc] init];
            NSMutableArray *ids = [[NSMutableArray alloc] init];
            NSMutableArray *follows = [[NSMutableArray alloc] init];

            TBQuadTreeGatherDataInRange(self.root, TBBoundingBoxForMapRect(mapRect), ^(TBQuadTreeNodeData data) {
                totalX += data.x;
                totalY += data.y;
                count++;

                TBDotInfo dotInfo = *(TBDotInfo *)data.data;
                [ids addObject:[NSString stringWithFormat:@"%s", dotInfo.dotID]];
                [titles addObject:[NSString stringWithFormat:@"%s", dotInfo.dotTitle]];
                [follows addObject:[NSString stringWithFormat:@"%i", dotInfo.isFollowed]];
            });

            if (count == 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                TBClusterAnnotation *annotation = [[TBClusterAnnotation alloc] initWithCoordinate:coordinate
                                                                                            count:count];
                annotation.title = [titles lastObject];
                annotation.subtitle = [ids lastObject];
                annotation.isFollowed = [[follows lastObject] boolValue];
                [clusteredAnnotations addObject:annotation];
            }

            if (count > 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                TBClusterAnnotation *annotation = [[TBClusterAnnotation alloc] initWithCoordinate:coordinate
                                                                                            count:count];
                [clusteredAnnotations addObject:annotation];
            }
        }
    }

    return [NSArray arrayWithArray:clusteredAnnotations];
}

@end
