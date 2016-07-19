//
//  SecondChildViewController.m
//  MultiMaps
//
//  Created by Radi on 5/9/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "SecondChildViewController.h"

@interface SecondChildViewController ()

@end

@implementation SecondChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mv = self.map;
//    self.map.frame = CGRectMake(0, 0, self.vMap.bounds.size.width, self.vMap.bounds.size.height);
//    [self.map setCenterCoordinate:self.mapCenter animated:true];
//    [self.vMap addSubview:self.map];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.map removeFromSuperview];
    // self.map = nil;
}

-(void)viewDidLayoutSubviews {
    //self.map.frame = CGRectMake(0, 0, self.vMap.bounds.size.width, self.vMap.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
