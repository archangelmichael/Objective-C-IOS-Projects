//
//  ViewController.m
//  RegistrationWithCustomView
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"
#import "RegistrationUIView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RegistrationUIView *registrationView = [[[NSBundle mainBundle] loadNibNamed:@"RegistrationView"
                                                             owner:self
                                                           options:nil]
                                objectAtIndex:0];
    [registrationView.saveButton addTarget:self
                                    action:@selector(registrationButtonTap)
                          forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:registrationView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)registrationButtonTap {
    int a = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
