//
//  SecondViewController.m
//  LongPressSwipe
//
//  Created by Radi on 3/14/16.
//  Copyright © 2016 archangel. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    
    BOOL rightLongPressSwipe;
    BOOL getTime;
    CGPoint startPoint;
    CGPoint endPoint;
    NSDate *startTime;
    UILongPressGestureRecognizer *longPress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rightLongPressSwipe = NO;
    getTime = NO;
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.2;
    longPress.delegate = self;
    // lpgr.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:longPress];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        startPoint = [gestureRecognizer locationInView:self.view];
        startTime = [NSDate date];
        //NSLog(@"Long Press Start");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (getTime) {
            startTime = [NSDate date];
            getTime = NO;
        }
        
        //NSLog(@"Long Press Changed");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled
             || gestureRecognizer.state == UIGestureRecognizerStateFailed
             || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        endPoint = [gestureRecognizer locationInView:self.view];
        int dy = fabs(endPoint.y - startPoint.y);
        CGFloat dx = rightLongPressSwipe ? endPoint.x - startPoint.x : startPoint.x - endPoint.x ;
        NSDate * now = [NSDate date];
        NSTimeInterval timeDifference =  [now timeIntervalSinceDate:startTime];
        
        if (dy < 100 && dx > 0 && timeDifference < 1) {
            NSLog(@"Long press drag right");
            [self goBack];
        }
        
        getTime = YES;
    }
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
