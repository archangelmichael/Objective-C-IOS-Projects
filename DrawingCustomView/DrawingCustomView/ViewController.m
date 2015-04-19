//
//  ViewController.m
//  DrawingCustomView
//
//  Created by Radi on 4/19/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"
#import "DrawingCustomUIView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(50, 50, 200, 100);
    UIView *subview = [[DrawingCustomUIView alloc] initWithFrame:rect];
    subview.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:subview];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
