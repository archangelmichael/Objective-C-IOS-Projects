//
//  ViewController.m
//  FabricTwitterSample
//
//  Created by Radi on 6/8/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
    }];
    logInButton.center = self.view.center;
    [self.view addSubview:logInButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
