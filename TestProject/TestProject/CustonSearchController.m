//
//  CustonSearchController.m
//  TestProject
//
//  Created by Radi on 8/21/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "CustonSearchController.h"

@interface CustonSearchController ()

@end

@implementation CustonSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setActive:(BOOL)active {
    [super setActive:active];
    self.searchBar.showsCancelButton = NO;
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
