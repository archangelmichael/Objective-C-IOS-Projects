//
//  ChildViewController.m
//  MultiMaps
//
//  Created by Radi on 5/9/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@property (weak, nonatomic) IBOutlet UIView *vMap;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.map.frame = CGRectMake(0, 0, self.vMap.bounds.size.width, self.vMap.bounds.size.height);
    [self.map setCenterCoordinate:self.mapCenter animated:true];
    [self.vMap addSubview:self.map];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.map removeFromSuperview];
    self.map = nil;
}

-(void)viewDidLayoutSubviews {
    self.map.frame = CGRectMake(0, 0, self.vMap.bounds.size.width, self.vMap.bounds.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
