//
//  DrawingCustomUIView.m
//  DrawingCustomView
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "DrawingCustomUIView.h"
#import <UIKit/UIKit.h>

@implementation DrawingCustomUIView

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //NSInteger cx = 30;
    //NSInteger cy = 30;
    CGFloat midWidth = rect.size.width/2;
    CGFloat midHeight = rect.size.height/2;
    CGFloat radius = midHeight<midWidth ? midHeight: midWidth;
    CGFloat cx = rect.origin.x + midWidth;
    CGFloat cy = rect.origin.y + midHeight;
    
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetLineWidth(context, 6);
    CGContextAddArc(context, cx, cy, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]);
    CGContextAddArc(context, cx, cy, radius, 0, 2*M_PI, YES);
    CGContextFillPath(context);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
