//
//  SecondViewController.m
//  MultiMaps
//
//  Created by Radi on 5/9/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mv;
@property (weak, nonatomic) IBOutlet UISwitch * typeSwitch;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mv.showsUserLocation = true;
    [self onChangeType:nil];
    
    
    //[self.vBot addSubview:map];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //map.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidLayoutSubviews {
    //map.frame = CGRectMake(0, 0, self.vMap.bounds.size.width, self.vMap.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeType:(id)sender {
    self.mv.mapType = self.typeSwitch.on ? MKMapTypeHybrid : MKMapTypeStandard;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"second"]) {
        SecondChildViewController * cvc = (SecondChildViewController *) segue.destinationViewController;
        cvc.map = self.mv;
        cvc.mapCenter = self.mv.centerCoordinate;
    }
}

@end
