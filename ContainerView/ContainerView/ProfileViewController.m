//
//  ProfileViewController.m
//  ContainerView
//
//  Created by Radi on 6/8/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController * destinationVC = segue.destinationViewController;
    if ([destinationVC isKindOfClass:[ParentViewController class]]) {
        BOOL goToUser = [segue.identifier isEqualToString:@"showUser"];
        ((ParentViewController *) destinationVC).loadUser = goToUser;
    }
    
    
    
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
