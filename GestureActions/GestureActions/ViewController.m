//
//  ViewController.m
//  GestureActions
//
//  Created by Radi on 4/20/15.
//  Copyright (c) 2015 archangel. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController ()
@property (nonatomic, strong) UIView * subview;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subview = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    [self.subview setBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:self.subview];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pich:(UIPinchGestureRecognizer *)sender {
        CGFloat zoom = sender.scale;
        NSLog(@"%f", zoom);
        
        self.subview.transform = CGAffineTransformMakeScale(zoom, zoom);
        NSLog(@"pinch");
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.subview];
    CGRect rect = self.subview.frame;
    
    CGRect newLoc = CGRectMake(location.x - rect.size.width/2,
                               location.y - rect.size.height/2,
                               rect.size.width,
                               rect.size.height);
    self.subview.frame = newLoc;
}

@end
