//
//  UserVCViewController.m
//  ContainerView
//
//  Created by Radi on 6/8/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "UserVCViewController.h"

@interface UserVCViewController ()

@end

@implementation UserVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShowDot:(id)sender {
    if (self.parentViewController != nil) {
        [(ParentViewController *)self.parentViewController swapChildVC:NO];
    }
}

- (IBAction)onBack:(id)sender {
    if (self.parentViewController != nil) {
        [(ParentViewController *)self.parentViewController goBack];
    }
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
