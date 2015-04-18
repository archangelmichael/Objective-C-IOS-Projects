//
//  ViewController.m
//  BunnyClasses
//
//  Created by Radi on 4/18/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Bunny *bunny = [Bunny new];
    @try {
        bunny.jumpSize = -23;
    }
    @catch (NSException *exc) {
        NSLog(@"%@", [exc reason]);
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
