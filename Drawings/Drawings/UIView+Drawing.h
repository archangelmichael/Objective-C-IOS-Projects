//
//  UIView+Drawing.h
//  Drawings
//
//  Created by Radi on 10/11/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Drawing)

- (void)drawLayerWithoutCircleAreasWithRadius:(float)radius
                                      centers:(NSArray *)centers;

- (void)drawLayerWithCircleOutlinesWithRadius:(float)radius
                                      centers:(NSArray *)centers;

- (void)drawCirclesOutlinesCenter:(CGPoint)center
                           radius:(float)radius;
@end
