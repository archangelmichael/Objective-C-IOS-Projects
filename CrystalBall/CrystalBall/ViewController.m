//
//  ViewController.m
//  CrystalBall
//
//  Created by ARCHANGEL on 4/14/15.
//  Copyright (c) 2015 ARCHANGEL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)tryYourLuck:(id)sender {
    self.luckLabel.text = [LuckGenerator getrandomPrediction];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    self.luckLabel.text = nil;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.luckLabel.text = [LuckGenerator getrandomPrediction];
    }
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
