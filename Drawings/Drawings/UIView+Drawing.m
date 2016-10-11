//
//  UIView+Drawing.m
//  Drawings
//
//  Created by Radi on 10/11/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "UIView+Drawing.h"

@implementation UIView (Drawing)

- (void)drawLayerWithoutCircleAreasWithRadius:(float)radius
                                      centers:(NSArray *)centers {
    CAShapeLayer *shape = [CAShapeLayer layer];
    // set outline window frame
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,
                                                                            self.bounds.size.width,
                                                                            self.bounds.size.height) cornerRadius:0];
    // set circles frames
    for (id center in centers) {
        CGPoint circleCenter = [center CGPointValue];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(circleCenter.x - radius,
                                                                                      circleCenter.y - radius,
                                                                                      2.0 * radius,
                                                                                      2.0 * radius)
                                                              cornerRadius:radius];
        [path appendPath:circlePath];
    }
    
    [path setUsesEvenOddFillRule:true];
    shape.path = path.CGPath;
    shape.fillRule = kCAFillRuleEvenOdd;
    shape.fillColor = [UIColor blackColor].CGColor;
    shape.opacity = 0.6;
    [self.layer addSublayer:shape];
}

-(void)drawLayerWithCircleOutlinesWithRadius:(float)radius
                                     centers:(NSArray *)centers {
    CAShapeLayer *shape = [CAShapeLayer layer];
    // set outline window frame
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,
                                                                            self.bounds.size.width,
                                                                            self.bounds.size.height) cornerRadius:0];
    // set circles frames
    for (id center in centers) {
        CGPoint circleCenter = [center CGPointValue];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(circleCenter.x - radius,
                                                                                      circleCenter.y - radius,
                                                                                      2.0 * radius,
                                                                                      2.0 * radius)
                                                              cornerRadius:radius];
        [path appendPath:circlePath];
    }
    
    [path setUsesEvenOddFillRule:true];
    shape.path = path.CGPath;
    
    [shape setStrokeColor:[[UIColor whiteColor] CGColor]];
    [shape setFillColor:[[UIColor clearColor] CGColor]];
        // Set the stroke line width
    [shape setLineWidth:6.0f];
    
    
    //shape.fillRule = kCAFillRuleEvenOdd;
    //shape.fillColor = [UIColor blackColor].CGColor;
    //shape.opacity = 0.6;
    [self.layer addSublayer:shape];
}

- (void)drawCirclesOutlinesCenter:(CGPoint)center
                           radius:(float)radius {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x - radius, center.y - radius,
                                                                            radius * 2, radius * 2)];
    circleLayer.path = path.CGPath;
    circleLayer.strokeColor = [[UIColor whiteColor] CGColor];
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.lineWidth = 10.0;
    // Add the sublayer to the image view's layer tree
    [self.layer addSublayer:circleLayer];
}
@end
