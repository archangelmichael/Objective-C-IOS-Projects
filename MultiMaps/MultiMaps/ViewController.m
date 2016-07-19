//
//  ViewController.m
//  MultiMaps
//
//  Created by Radi on 5/9/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *vMap;

@property (weak, nonatomic) IBOutlet UISwitch * typeSwitch;

@end

@implementation ViewController {
    MKMapView * map;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = self.vMap.frame;
    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    map.showsUserLocation = true;
    
    [self onChangeType:nil];
    
    
    //[self.vBot addSubview:map];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BOOL initial = [[NSUserDefaults standardUserDefaults] boolForKey:@"createDotForTheFirstTime"];
    
    
    
//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"createDotForTheFirstTime"] != YES)
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"createDotForTheFirstTime"];
//    }
    
    
    NSLog(@"%@", map);
    
    CGRect frame = self.vMap.frame;
    map.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.vMap addSubview:map];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[map removeFromSuperview];
}

-(void)viewDidLayoutSubviews {
    map.frame = CGRectMake(0, 0, self.vMap.bounds.size.width, self.vMap.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChangeType:(id)sender {
    map.mapType = self.typeSwitch.on ? MKMapTypeHybrid : MKMapTypeStandard;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"first"]) {
        ChildViewController * cvc = (ChildViewController *) segue.destinationViewController;
        cvc.map = map;
        cvc.mapCenter = map.centerCoordinate;
    }
}

@end
