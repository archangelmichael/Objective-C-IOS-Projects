//
//  ViewController.m
//  Drawings
//
//  Created by Radi on 10/11/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGPoint mapCircleCenter = CGPointMake(self.view.center.x,
                                          120);
    CGPoint shareCircleCenter = CGPointMake(self.view.center.x + self.view.frame.size.width/7,
                                            500);
    NSArray * circlesCenters = @[[NSValue valueWithCGPoint:mapCircleCenter],
                                 [NSValue valueWithCGPoint:shareCircleCenter]];
    float circleRadius = self.view.bounds.size.width/7;
    [self.view drawLayerWithoutCircleAreasWithRadius:circleRadius
                                             centers:circlesCenters];
//    [self.view drawLayerWithCircleOutlinesWithRadius:circleRadius
//                                             centers:circlesCenters];
    
    [self.view drawCirclesOutlinesCenter:mapCircleCenter
                                  radius:circleRadius];
    [self.view drawCirclesOutlinesCenter:shareCircleCenter
                                  radius:circleRadius];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
