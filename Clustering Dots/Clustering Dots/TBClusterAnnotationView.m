//
//  TBClusterAnnotationView.m
//  TBAnnotationClustering
//
//  Created by Theodore Calmes on 10/4/13.
//  Copyright (c) 2013 Theodore Calmes. All rights reserved.
//

#import "TBClusterAnnotationView.h"

CGPoint TBRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect TBCenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGFloat const TBScaleFactorAlpha = 0.3;
static CGFloat const TBScaleFactorBeta = 1.5;
static int const CLUSTER_SIZE_ULTIPLIER = 60;

CGFloat TBScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * TBScaleFactorAlpha * powf(value, TBScaleFactorBeta)));
}


@interface TBClusterAnnotationView ()

@property (strong, nonatomic) UILabel *countLabel;
@end

@implementation TBClusterAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
        [self setCount:1];
        self.isFollowed = ((TBClusterAnnotation *) annotation).isFollowed;
        self.title = ((TBClusterAnnotation *) annotation).title;
    }
    return self;
}

- (void)setupLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    _countLabel.shadowOffset = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count {
    _count = count;

    CGRect newBounds = CGRectMake(0, 0,
                                  roundf(CLUSTER_SIZE_ULTIPLIER * TBScaledValueForValue(count)),
                                  roundf(CLUSTER_SIZE_ULTIPLIER * TBScaledValueForValue(count)));
    self.frame = TBCenterRect(newBounds, self.center);

    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
    self.countLabel.frame = TBCenterRect(newLabelBounds, TBRectCenter(newBounds));
    self.countLabel.text = [@(_count) stringValue];
    
    if (count == 1) {
        self.countLabel.hidden = YES;
        return;
    }
    else {
        self.countLabel.hidden = NO;
    }

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetAllowsAntialiasing(context, true);

    UIColor *innerCircleStrokeColor = self.isFollowed ?
        [UIColor colorWithRed:(25 / 255.0) green:(170 / 255.0) blue:(184 / 255.0) alpha:1.0] :
        [UIColor colorWithRed:(213 / 255.0) green:(214 / 255.0) blue:(214 / 255.0) alpha:1.0];
    UIColor *innerCircleFillColor = self.isFollowed ?
    [UIColor colorWithRed:(117 / 255.0) green:(212 / 255.0) blue:(219 / 255.0) alpha:1.0] :
    [UIColor colorWithRed:(255 / 255.0) green:(255 / 255.0) blue:(255 / 255.0) alpha:1.0];;

    CGRect circleFrame = CGRectInset(rect, 4, 4);

    [innerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 6);
    CGContextStrokeEllipseInRect(context, circleFrame);

    [innerCircleFillColor setFill];
    CGContextFillEllipseInRect(context, circleFrame);
}

@end
