//
//  FirstViewController.m
//  SeguesActions
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(UIStoryboardSegue *)segue {
    
}

-(IBAction)goBackToFirstVC:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goSecond"]) {
        SecondViewController *toVC = (SecondViewController *)[segue destinationViewController];
        toVC.text = @"IT WORKS";

    }
        // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
